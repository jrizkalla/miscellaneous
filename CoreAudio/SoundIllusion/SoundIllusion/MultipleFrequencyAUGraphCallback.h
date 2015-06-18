//
//  MultipleFrequencyAUGraphCallback.h
//
//  Created by John Rizkalla on 2014-10-09.
//  Copyright (c) 2014 John Rizkalla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioUnit/AudioUnit.h>

/**
 * Callback function used by MultipleFrequencyAUGraph
 */
OSStatus MultipleFrequencyAUGraphCallback (void *inRefCon, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames, AudioBufferList *ioData);