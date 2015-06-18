//
//  MultipleFrequencyAUGraphCallback.mi
//
//  Created by John Rizkalla on 2014-10-09.
//  Copyright (c) 2014 John Rizkalla. All rights reserved.
//

#import "MultipleFrequencyAUGraphCallback.h"
#import "MultipleFrequencyAUGraph.h"
#import "FrequencyGenerator.h"
#import "AUGraphMixerInfo.h"

OSStatus MultipleFrequencyAUGraphCallback (void *inRefCon, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames, AudioBufferList *ioData){
    AUGraphMixerInfo *mixerInfo = (__bridge AUGraphMixerInfo *) inRefCon;
    
    //fill the buffer with the frequency in graphObj
    
    [mixerInfo.freqGen fillFrames:inNumberFrames forBuffers:ioData withFreq:mixerInfo.freq andLoudness:mixerInfo.loudness];
    return noErr;
}

