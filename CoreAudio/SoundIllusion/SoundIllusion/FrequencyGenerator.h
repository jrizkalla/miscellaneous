//
//  FrequencyGenerator.h
//
//  Created by John Rizkalla on 2014-10-08.
//  Copyright (c) 2014 John Rizkalla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

/**
 * Filles AudioBuffers with a sine wave of the specified frequency
 * @author John Rizkalla
 */
@interface FrequencyGenerator : NSObject

/**
 * Marks the position in the wave cycle to start from.
 * It starts from 0 all the way to cycle length (which is freq/sampleRate)
 */
@property (nonatomic, readonly) unsigned int startingFrameCount;

/**
 * The sample rate. Used for calculating the cycle length
 */
@property (nonatomic) double sampleRate;

/**
 * initializes with default sampleRate of 44100 Hz
 * @returns a newly initialized object
 */
- (id) init;

/**
 * initializes with sampleRate
 * @param a valid sample rate used to calcluate the cycle length
 * @returns a newly initialized object
 */
- (id) initWithSampleRate: (double) sampleRate;


/**
 * Fills numFrames of 2 buffers of noninterleaved audio with a sine wave
 * @param the number of frames to fill
 * @param 2 buffers to be filled. buffer [0] is the left channel and buffer [1] is the right channel
 * @param the frequency of the sine wave
 */
- (void) fillFrames: (UInt32) numFrames forBuffers: (AudioBufferList *) oData withFreq: (double) freq;

/**
 * Fills numFrames of 2 buffers of noninterleaved audio with a sine wave
 * @param the number of frames to fill
 * @param 2 buffers to be filled. buffer [0] is the left channel and buffer [1] is the right channel
 * @param the frequency of the sine wave
 * @param the loudness of the sine wave
 */
- (void) fillFrames: (UInt32) numFrames forBuffers: (AudioBufferList *) oData withFreq: (double) freq andLoudness: (double) loudness;

@end
