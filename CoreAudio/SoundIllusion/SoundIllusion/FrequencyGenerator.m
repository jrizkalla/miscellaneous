//
//  FrequencyGenerator.m
//
//  Created by John Rizkalla on 2014-10-08.
//  Copyright (c) 2014 John Rizkalla. All rights reserved.
//

#import "FrequencyGenerator.h"

@implementation FrequencyGenerator

- (id) init{
    return [self initWithSampleRate:44100];
}

- (id) initWithSampleRate:(double)sampleRate{
    if (self = [super init]){
        if (sampleRate < 0) sampleRate = 44100;
        
        _startingFrameCount = 0;
        _sampleRate = sampleRate;
    }
    return self;
}

- (void) fillFrames:(UInt32)numFrames forBuffers:(AudioBufferList *)oData withFreq:(double)freq andLoudness:(double)loudness{
    double cycleLength = self.sampleRate / freq;
    //fprintf(stderr, "cyclelength: %f", cycleLength);
    unsigned int j = self.startingFrameCount;
    
    for (int frame = 0; frame < numFrames; frame++){
        //fprintf(stderr, "%i ", j);
        float value = (float) sin (2 * M_PI * ((double)j / cycleLength)); //2*pi* position in cycle
        value   *= loudness;
        float *data = oData->mBuffers[0].mData; //the left buffer (float array)
        data[frame] = value;
        data = oData->mBuffers[1].mData; //the right buffer
        data[frame] = value;
        
        j++;
        if (j > cycleLength)
            j = 0; // at the end of the wave, return j to the beggining
    }
    
    _startingFrameCount = j;
}

- (void) fillFrames:(UInt32)numFrames forBuffers:(AudioBufferList *)oData withFreq:(double)freq{
    [self fillFrames:numFrames forBuffers:oData withFreq:freq andLoudness:1];
}

@end
