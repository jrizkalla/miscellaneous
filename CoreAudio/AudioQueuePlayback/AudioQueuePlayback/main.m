//
//  main.m
//  AudioQueuePlayback
//
//  Created by John Rizkalla on 2014-09-08.
//  Copyright (c) 2014 John Rizkalla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "CheckError.h"

typedef struct Player{
    AudioFileID file;
    SInt64 packetPos;
    UInt32 numPacketsToRead;
    AudioStreamPacketDescription *packetDesc;
    Boolean isDone;
} Player;

static void AQOutputCallback (void *inUserData, AudioQueueRef inQueue, AudioQueueBufferRef inBuffer);

UInt32 calculateBytesForTime (AudioFileID file, AudioStreamBasicDescription dataFormat, double seconds, UInt32 *oNumPacketsToRead);
void copyEncoderCookieToQueue (AudioFileID file, AudioQueueRef queue);

//--------------------------------------------------------------------------------------------

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString *filePath = nil;
        
        if (argc > 1){
            filePath = [NSString stringWithUTF8String: argv[1]];
            filePath = [filePath stringByExpandingTildeInPath];

            if (![[NSFileManager defaultManager] fileExistsAtPath: filePath]){
                fprintf(stderr, "Please provide a valid file\n");
                return 1; //error
            }
        }
        else{
            fprintf(stderr, "Please provide a file to play\n");
            return 1;
        }

        NSLog(@"File path: %@", filePath);
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];

        Player player = {0};
        if (checkError(AudioFileOpenURL((__bridge CFURLRef)fileURL, kAudioFileReadPermission, 0, &(player.file)), "opening file", NO)){
            fprintf(stderr, "Supported file formats are: mp3, aac, m4a, wav, and aif\n");
            return 1;
        }

        AudioStreamBasicDescription dataFormat = {0};
        UInt32 propSize = sizeof(dataFormat);
        checkErrorAndExit(AudioFileGetProperty(player.file, kAudioFilePropertyDataFormat, &propSize, &dataFormat), "getting the data format from the file");


        //create the queue
        AudioQueueRef queue;
        checkErrorAndExit(AudioQueueNewOutput(&dataFormat, AQOutputCallback, &player, NULL, NULL, 0, &queue), "creating output queue");

        UInt32 bufferByteSize = calculateBytesForTime(player.file, dataFormat, 0.5, &(player.numPacketsToRead));

        //if its a variable format rate
        if (dataFormat.mBytesPerPacket == 0 || dataFormat.mFramesPerPacket == 0)
            player.packetDesc = malloc(sizeof(AudioStreamPacketDescription) * player.numPacketsToRead);
        else
            player.packetDesc = NULL;

        copyEncoderCookieToQueue(player.file, queue);

        //create the buffers
        const int NUM_BUFFERS = 3;
        AudioQueueBufferRef buffers[NUM_BUFFERS];
        player.isDone = false;
        player.packetPos = 0;
        //fill the buffers
        for (int i = 0; i < NUM_BUFFERS; i++){
            checkErrorAndExit(AudioQueueAllocateBuffer(queue, bufferByteSize, &(buffers[i])), "allocating buffer");
            AQOutputCallback(&player, queue, buffers[i]); //the buffers are enqueued by AQOutputCallback
            //if there is no more data in the file
            if (player.isDone)
                break;
        }

        printf("Press <return> to start playing\n");
        getchar();
        checkErrorAndExit(AudioQueueStart(queue, NULL), "starting queue");
        printf("Playing...\n");

        //keep the main waiting for the end of the file...
        do{
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.25, false);
        }while (!player.isDone);

        //now make sure everything is done playing
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 2, false);

        player.isDone = true;
        checkErrorAndExit(AudioQueueStop(queue, TRUE), "stopping queue");
        AudioQueueDispose(queue, TRUE);
        AudioFileClose(player.file);

    }
    return 0;
}

void copyEncoderCookieToQueue (AudioFileID file, AudioQueueRef queue){
    UInt32 propSize = 0;
    OSStatus retRes = AudioFileGetPropertyInfo(file, kAudioFilePropertyMagicCookieData, &propSize, NULL);
    if (retRes == noErr && propSize > 0){
        //there is a cookie
        Byte *magicCookie = (UInt8 *)malloc(sizeof(UInt8) * propSize);
        checkErrorAndExit(AudioFileGetProperty(file, kAudioFilePropertyMagicCookieData, &propSize, magicCookie), "getting the cookie from the file");
        checkErrorAndExit(AudioQueueSetProperty(queue, kAudioQueueProperty_MagicCookie, magicCookie, propSize), "setting the magic cookie in the queue");
        free(magicCookie);
    }
}

UInt32 calculateBytesForTime (AudioFileID file, AudioStreamBasicDescription dataFormat, double seconds, UInt32 *oNumPacketsToRead){
    UInt32 bufferSize = 0;

    UInt32 maxPacketSize;
    UInt32 propSize = sizeof(maxPacketSize);
    checkErrorAndExit(AudioFileGetProperty(file, kAudioFilePropertyPacketSizeUpperBound, &propSize, &maxPacketSize), "getting the packet size from file");

    const int maxBufferSize = 0x10000; //max 0f 64 KB
    const int minBufferSize = 0x4000; //min of 16 KB

    if (dataFormat.mFramesPerPacket){
        double numPacketsForTime = dataFormat.mSampleRate / dataFormat.mFramesPerPacket * seconds;
        bufferSize = numPacketsForTime * maxPacketSize;
    } else{ //pick a buffer big enough to hold at least 1 packet
        bufferSize = (maxBufferSize > maxPacketSize)? maxBufferSize : maxPacketSize;
    }

    if ((bufferSize > maxBufferSize) && (bufferSize > maxPacketSize))
        bufferSize = maxBufferSize;
    else if (bufferSize < minBufferSize)
        bufferSize = minBufferSize;

    *oNumPacketsToRead = bufferSize / maxPacketSize;
    return bufferSize;
}

static void AQOutputCallback (void *inUserData, AudioQueueRef inQueue, AudioQueueBufferRef inBuffer){
    Player *player = (Player *) inUserData;
    if (player->isDone) return;

    //read packets from the audio file
    UInt32 numBytes = 0;
    UInt32 numPackets = player->numPacketsToRead;
    checkErrorAndExit(AudioFileReadPackets(player->file, false, &numBytes, player->packetDesc, player->packetPos, &numPackets, inBuffer->mAudioData), "reading packet data from file");

    //enqueue the packets
    if (numPackets > 0){
        inBuffer->mAudioDataByteSize = numBytes;
        AudioQueueEnqueueBuffer(inQueue, inBuffer, (player->packetDesc? numPackets : 0), player->packetDesc);
        player->packetPos += numPackets;
    } else{ //end of file
        checkErrorAndExit(AudioQueueStop(inQueue, false), "stopping the queue");
        player->isDone = true;
    }
    
}