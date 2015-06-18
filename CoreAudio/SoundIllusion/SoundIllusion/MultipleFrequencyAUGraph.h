//
//  MultipleFrequencyAUGraph.h
//
//  Created by John Rizkalla on 2014-10-08.
//  Copyright (c) 2014 John Rizkalla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioUnit/AudioUnit.h>
#import "FrequencyGenerator.h"
#import "AUGraphMixerInfo.h"

/**
 * Contains and manages an audio graph that generates a number of
 * sine wave (with different frequencies), mixes them, then sends them to the
 * standard output
 * @author John Rizkalla
 */
@interface MultipleFrequencyAUGraph : NSObject

/**
 * The number of frequenciesMixedTogether (size of self.mixerInfoArr)
 * numFrequencies is set at the beginning and is not changed throughout
 * the life of the object
 * @see MultipleFrequencyAUGraph#mixerInfoArr
 */
@property (nonatomic, readonly) unsigned int numFrequencies;

/**
 * An array of size self.numFrequencies that has information about each
 * frequency generated (used for the callback function)
 * Change the frequencies by accessing objects in this array
 */
@property (nonatomic, readonly) NSMutableArray *mixerInfoArr;

/**
 * The Audio Graph that manages the audio units
 */
@property (nonatomic, readonly) AUGraph graph;

/**
 * The Audio Unit that mixes all the frequencies and generates one audio stream
 * kAudioUnitType_Mixer, kAudioUnitSubType_StereoMixer
 */
@property (nonatomic, readonly) AudioUnit mixerUnit;

/**
 * The Audio Unit that sends data to the default output device
 * kAudioUnitType_Output, kAudioUnitSubType_DefaultOutput
 */
@property (nonatomic, readonly) AudioUnit outputUnit;

/**
 * The format of the stream
 */
@property (nonatomic, readonly) AudioStreamBasicDescription streamFormat;


/**
 * initializes with no frequncies mixed together
 * An object initalized with this only plays silence
 * @returns the new object
 */
- (id) init;

/**
 * initializes with frequencies
 * @param an array of double that represent all the frequencies to be played. frequencies is copyied
 * @param the size of frequencies. This is also the new size of self.frequencies
 * @returns the new object
 */
- (id) initWithFrequncies: (double *) frequencies ofSize: (unsigned int) size;

/**
 * Changes the frequencies in mixerInfoArr. This method does not change the value of frequencies (parameter), if the passed array is less than the expected size, it copies only the new parts and does not change the values out of range in mixerInfoArr. If the passed array is too big, then it ignores all extra stuff
 * @param frequencies an array of double that represent all the frequencies to be played. frequencies is copied
 * @param size size of frequencies
 */
- (void) setFrequencies:(double *) frequencies ofSize: (unsigned int) size;

/**
 * Changes the frquencies and loudness in mixerInfoArr. This method does not change the value of freqncies (paramter) or loudness. If the passed array is less than the expected size, it copies only the new parts and does not change the values out of range in mixerInfoArr. If the passed array is too big, then it ignores all the extra stuff
 * @param frequencies an array of double that represents all the frequencies to be played. frequencies is copied
 * @param loudness an array of double that represents the loudness of frequencies. loudness is copied
 * @param size size of frequencies
 */
- (void) setFrequencies:(double *)frequencies andLoudness: (double *) loudness ofSize:(unsigned int)size;

/**
 * pauses the graph
 */
- (void) pause;

/**
 * restarts the graph
 */
- (void) play;

@end
