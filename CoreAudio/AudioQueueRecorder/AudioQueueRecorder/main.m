//
//  main.m
//  AudioQueueRecorder
//
//  Created by John Rizkalla on 2014-08-30.
//  Copyright (c) 2014 John Rizkalla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "CheckError.h"
#define TRACEAPP 1

typedef struct Recorder{
    AudioFileID recFile;
    SInt64 recordPacket;
    Boolean isRunning;
} Recorder;


double getDefaultInputDeviceSampleRate();

static void AQInputCallback (void *inUserData, AudioQueueRef inQueue, AudioQueueBufferRef inBuffer, const AudioTimeStamp *inStartTime, UInt32 inNumPackets, const AudioStreamPacketDescription *inPacketDesc);

void copyMagicCookieFromQueueToFile(AudioQueueRef queue, AudioFileID file);

int getComputerRecordBufferSize (AudioStreamBasicDescription *recordFormat, AudioQueueRef queue, float sec);


int main (int argc, char *argv[]){
@autoreleasepool {
    //figure out the format...
    AudioStreamBasicDescription recordFormat = {0};
    recordFormat.mFormatID = kAudioFormatMPEG4AAC;
    recordFormat.mSampleRate = getDefaultInputDeviceSampleRate();
    if (TRACEAPP) printf("TRACE: getDefaultInputDeviceSampleRate: %f\n", recordFormat.mSampleRate);

    //get the rest of recordFormat...
    UInt32 propSize = sizeof(recordFormat);
    checkErrorAndExit(AudioFormatGetProperty(kAudioFormatProperty_FormatInfo, 0, NULL, &propSize, &recordFormat), "getting the format from core audio");

    //create a recorder
    Recorder recorder = {0};
    recorder.recordPacket = 0;
    recorder.isRunning = FALSE;

    //Now create a queue
    AudioQueueRef queue;
    checkErrorAndExit(AudioQueueNewInput(&recordFormat, AQInputCallback, &recorder, NULL, NULL, 0, &queue), "Creating a new queue");
    //get the record format from the queue
    propSize = sizeof(recordFormat);
    checkErrorAndExit(AudioQueueGetProperty(queue, kAudioConverterCurrentOutputStreamDescription, &recordFormat, &propSize), "Getting recordFormat from the new queue");

    //create the file.
    //Note: the file is created after the queue becasue the queue provices a more accurate ASBD for the file
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"output.caf"];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    checkErrorAndExit(AudioFileCreateWithURL((__bridge CFURLRef)fileURL, kAudioFileCAFType, &recordFormat, kAudioFileFlags_EraseFile, &(recorder.recFile)), "creating output file");

    copyMagicCookieFromQueueToFile(queue, recorder.recFile);

    int bufferByteSize = getComputerRecordBufferSize(&recordFormat, queue, 0.5);
    //create the buffers
    const Byte NUM_BUFFERS = 3;
    for (int i = 0; i < NUM_BUFFERS; i++){
        AudioQueueBufferRef buffer;
        checkErrorAndExit(AudioQueueAllocateBuffer(queue, bufferByteSize, &buffer), "allocating buffer");
        //now enqueue the buffer
        checkErrorAndExit(AudioQueueEnqueueBuffer(queue, buffer, 0, NULL), "enqueueing buffer");
    }

    printf("Press <return> to start recording\n");
    getchar();

    recorder.isRunning = TRUE;
    checkErrorAndExit(AudioQueueStart(queue, NULL), "starting queue");

    printf("Press <return> to stop recording\n");
    getchar();
    recorder.isRunning = FALSE;
    checkErrorAndExit(AudioQueueStop(queue, TRUE), "stopping queue");
    printf("Stopped\n");

    copyMagicCookieFromQueueToFile(queue, recorder.recFile);

    //now clean up
    AudioQueueDispose(queue, TRUE);
    AudioFileClose(recorder.recFile);
}
return 0;
}

double getDefaultInputDeviceSampleRate(){
    const float DEFAULT_RATE = 44000;

    //get the default recorind device...
    AudioObjectPropertyAddress propertyAddress = {0};
    propertyAddress.mSelector = kAudioHardwarePropertyDefaultInputDevice;
    propertyAddress.mScope = kAudioObjectPropertyScopeGlobal;
    propertyAddress.mElement = 0;
    AudioDeviceID deviceID = 0;
    UInt32 dataSize = sizeof(AudioDeviceID);
    if (checkError(AudioHardwareServiceGetPropertyData(kAudioObjectSystemObject, &propertyAddress, 0, NULL, &dataSize, &deviceID), "getting the default input device", FALSE)) //if there is an error
        return DEFAULT_RATE; //return 44000 as a sample rate...

    propertyAddress.mSelector = kAudioDevicePropertyNominalSampleRate;
    propertyAddress.mScope = kAudioObjectPropertyScopeGlobal;
    propertyAddress.mElement = 0;
    double output = DEFAULT_RATE;
    dataSize = sizeof(double);
    checkError(AudioHardwareServiceGetPropertyData(deviceID, &propertyAddress, 0, NULL, &dataSize, &output), "getting the nominal sample rate", FALSE);
    if (output == 0)
        output = DEFAULT_RATE;

    return output;
}

static void AQInputCallback (void *inUserData, AudioQueueRef inQueue, AudioQueueBufferRef inBuffer, const AudioTimeStamp *inStartTime, UInt32 inNumPackets, const AudioStreamPacketDescription *inPacketDesc){
    //save the data in the buffer
    Recorder *recorder = (Recorder *) inUserData;

    if (inNumPackets > 0){
        checkErrorAndExit(AudioFileWritePackets(recorder->recFile, FALSE, inBuffer->mAudioDataByteSize, inPacketDesc, recorder->recordPacket, &inNumPackets, inBuffer->mAudioData), "writing packets to file");
        recorder->recordPacket += inNumPackets;
    }

    if (recorder->isRunning){ //re-enqueue the buffer
        checkErrorAndExit(AudioQueueEnqueueBuffer(inQueue, inBuffer, 0, NULL), "re-enqueuing buffer");
    }
}

void copyMagicCookieFromQueueToFile(AudioQueueRef queue, AudioFileID file){
    //see if there is a cookie
    UInt32 propSize = 0;
    checkErrorAndExit(AudioQueueGetPropertySize(queue, kAudioQueueProperty_MagicCookie, &propSize), "Getting the size of the cookie");

    if (propSize == 0) // no cookie
        return;

    Byte *magicCookie = (Byte *) malloc(propSize);
    checkErrorAndExit(AudioQueueGetProperty(queue, kAudioQueueProperty_MagicCookie, magicCookie, &propSize), "Getting the magic cookie");

    //and send it to the file
    checkErrorAndExit(AudioFileSetProperty(file, kAudioFilePropertyMagicCookieData, propSize, magicCookie), "Setting the magic cookie on the file");
    free(magicCookie);
}

int getComputerRecordBufferSize (AudioStreamBasicDescription *recordFormat, AudioQueueRef queue, float sec){
    int frames = (int)ceil(sec * recordFormat->mSampleRate);

    if (recordFormat->mBytesPerFrame > 0){
        return frames * recordFormat->mBytesPerFrame;
    }

    //work at the packet level...
    //get the max packet size
    UInt32 maxPacketSize;
    if (recordFormat->mBytesPerPacket > 0)
        maxPacketSize = recordFormat->mBytesPerPacket;
    else{
        UInt32 propSize = sizeof(maxPacketSize);
        checkErrorAndExit(AudioQueueGetProperty(queue, kAudioConverterPropertyMaximumOutputPacketSize, &maxPacketSize, &propSize), "Getting the maximum property size");
    }

    int packets = (recordFormat->mFramesPerPacket > 0)? (frames/recordFormat->mFramesPerPacket) : frames; //frames is the worst case scenario

    if (packets == 0)
        packets = 1;
    return packets * maxPacketSize;

}