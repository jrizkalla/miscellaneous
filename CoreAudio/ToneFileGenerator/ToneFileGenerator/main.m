//
//  main.m
//  ToneFileGenerator
//
//  Created by John Rizkalla on 2014-08-28.
//  Copyright (c) 2014 John Rizkalla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define SAMPLE_RATE 44100 //CD quality
#define DEFAULT_FREQ 261.626 //c on a piano
#define DEFAULT_DURATION 5
#define FILENAME_FORMAT @"%0.3f-%@.aif"
#define TRACE 0

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        int duration = DEFAULT_DURATION; //5 seconds
        double freq = DEFAULT_FREQ;
        char *waveType = "square";
        for (int i = 1; i < argc; i++){
            if (strcmp(argv[i], "duration") == 0){
                if (i == (argc - 1))
                    break;
                duration = atof(argv[i+1]);
                if (duration <= 0)
                    duration = DEFAULT_DURATION;
            }
            if (strcmp(argv[i], "waveType") == 0){
                if (i == (argc - 1))
                    break;
                waveType = (char *) argv[i+1];
                assert(strcmp(waveType, "square") == 0 || strcmp(waveType, "sawtooth") == 0 || strcmp(waveType, "sine") == 0);
            }
            if (strcmp(argv[i], "frequency") == 0){
                if (i == (argc - 1))
                    break;
                freq = atof (argv[i + 1]);
                if (freq < 0)
                    freq = DEFAULT_FREQ;
            }
            if (strcmp(argv[i], "help") == 0){
                printf("\nParameters:\n");
                printf("duration (int): duration in seconds\n");
                printf("waveType (square, sawtooth, sine): the wave type\n");
                printf("frequency (double): frequency of the wave\n\n");
            }
        }

        printf ("Wave type: %s wave\n", waveType);
        printf ("Duration: %i s\n", duration);
        printf ("Frequency: %f Hz\n", freq);

        NSLog(@"Starting to write");
        NSString *fileName = [NSString stringWithFormat:FILENAME_FORMAT, freq, [NSString stringWithUTF8String:waveType]];
        NSString *fileDir = [NSHomeDirectory() stringByAppendingPathComponent:fileName];
        NSURL *fileURL = [NSURL fileURLWithPath:fileDir];

        AudioStreamBasicDescription asbd;
        memset (&asbd, 0, sizeof(asbd)); //set everything to 0
        asbd.mSampleRate = SAMPLE_RATE;
        asbd.mFormatID = kAudioFormatLinearPCM;
        asbd.mFormatFlags = kAudioFormatFlagIsBigEndian | kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
        //kAudioFormatFlagIsPacked indecates that each sample uses all the bits
        asbd.mBitsPerChannel = 16; //2 bytes per channel (and only 1 channel)
        asbd.mChannelsPerFrame = 1;
        asbd.mFramesPerPacket = 1; //because there is no compressed stuff
        asbd.mBytesPerFrame = 2;
        asbd.mBytesPerPacket = 2;

        AudioFileID audioFile;
        OSStatus retErr = noErr;
        retErr = AudioFileCreateWithURL((__bridge CFURLRef) fileURL, kAudioFileAIFFType, &asbd, kAudioFileFlags_EraseFile, &audioFile);
        assert(retErr == noErr);

        long maxSamples = SAMPLE_RATE * duration;
        long count = 0;
        long waveLengthInSamples = SAMPLE_RATE / freq;
        UInt32 bytesToWrite = 2*(UInt32)waveLengthInSamples;

        if (TRACE) printf("waveLengthInSamples: %li\n", waveLengthInSamples);

        while (count < maxSamples){

            SInt16 waveBuffer[waveLengthInSamples];
            long writePos = count*2;
            for (int i = 0; i < waveLengthInSamples; i++){
                SInt16 sample;

                if (strcmp(waveType, "square") == 0){ //square wave...
                    if (i < waveLengthInSamples/2)//the first half of the wave
                        sample = CFSwapInt16HostToBig(SHRT_MAX);
                    else
                        sample = CFSwapInt16HostToBig(SHRT_MIN);
                }

                else if (strcmp(waveType, "sawtooth") == 0){
                    sample = CFSwapInt16HostToBig(((i/(double)waveLengthInSamples) * (2*SHRT_MAX)) - SHRT_MAX);
                }

                else if (strcmp(waveType, "sine") == 0){
                    sample = CFSwapInt16HostToBig((SInt16) (SHRT_MAX * sin(2*M_PI*(i/(double)waveLengthInSamples))));
                }

                //add the sample to the buffer
                waveBuffer[i] = sample;

                //retErr = AudioFileWriteBytes(audioFile, false, count*2, &bytesToWrite, &sample);
                //assert(retErr == noErr);

                count++;
            }

            if (TRACE) printf("BytesToWrite: %i\n", bytesToWrite);

            retErr = AudioFileWriteBytes(audioFile, false, writePos, &bytesToWrite, waveBuffer);
            assert(retErr == noErr);
        }

        retErr = AudioFileClose(audioFile);
        assert(retErr == noErr);
        NSLog(@"Done");
        NSLog(@"File name and loc: %@", fileDir);

    }
    return 0;
}
