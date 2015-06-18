//
//  AUGraphMixerInfo.m
//
//  Created by John Rizkalla on 2014-10-10.
//  Copyright (c) 2014 John Rizkalla. All rights reserved.
//

#import "AUGraphMixerInfo.h"

@implementation AUGraphMixerInfo

- (id) init{
    return nil;
}

- (id) initWithIndex:(int)index andSampleRate: (double) sampleRate andFreq:(double)freq andLoudness:(double)loudness{
    if (self = [super init]){
        _index = index;
        _freq = freq;
        self.loudness = loudness;
        _freqGen = [[FrequencyGenerator alloc] initWithSampleRate:sampleRate];
    }
    return self;
}

- (id) initWithIndex:(int)index andSampleRate:(double)sampleRate{
    return [self initWithIndex:index andSampleRate:sampleRate andFreq:0 andLoudness:0];
}

- (void) setLoudness:(double)loudness{
    if (loudness > 1 || loudness < 0)
        _loudness = 0;
    else
        _loudness = loudness;
}

@end
