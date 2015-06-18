//
//  AUGraphMixerInfo.h
//
//  Created by John Rizkalla on 2014-10-10.
//  Copyright (c) 2014 John Rizkalla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MultipleFrequencyAUGraph.h"
#import "FrequencyGenerator.h"

/**
 * An AUGraphMixerInfo object tells the callback function what frequency to generate and
 * the loudness of the frequency
 */
@interface AUGraphMixerInfo : NSObject

/**
 * The object that generates a sine wave (in a buffer)
 */
@property (nonatomic, readonly) FrequencyGenerator *freqGen;
/**
 * The frequency to generate
 */
@property (nonatomic) double freq;

/**
 * The loudness of the resultant values
 * Should have range of 0 to 1
 */
@property (nonatomic) double loudness;

/**
 * The index (or 'id') of this callback
 */
@property (nonatomic, readonly) int index;

/**
 * Does nothing
 * @returns nil
 */
- (id) init;

/**
 * initializes with index, freq = 0, and loudness = 0
 * @param index the index of the callback
 * @param sampleRate the sample rate of the generated frequency (used in FrequencyGenerator)
 * @returns the new object
 */
- (id) initWithIndex: (int) index andSampleRate: (double) sampleRate;

/**
 * initializes with index, freq, and loudness
 * @param index the index of the callback
 * @param sampleRate the sample rate of the generated frequency (used in FrequencyGenerator)
 * @param freq the frequency of the generated sound
 * @param loudness the loudness of the generated sound (0-1)
 * @returns the new object
 */
- (id) initWithIndex:(int)index andSampleRate: (double) sampleRate andFreq: (double) freq andLoudness: (double) loudness;

@end
