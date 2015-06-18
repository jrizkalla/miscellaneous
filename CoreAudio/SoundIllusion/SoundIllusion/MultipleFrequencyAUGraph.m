//
//  MultipleFrequencyAUGraph.m
//
//  Created by John Rizkalla on 2014-10-08.
//  Copyright (c) 2014 John Rizkalla. All rights reserved.
//

#import "MultipleFrequencyAUGraph.h"
#import "CheckError.h"
#import "MultipleFrequencyAUGraphCallback.h"

@implementation MultipleFrequencyAUGraph

- (id) init{
    double arr [0];
    return [self initWithFrequncies:arr ofSize:0];
}

- (id) initWithFrequncies:(double *) frequencies ofSize:(unsigned int)size{
    if (self = [super init]){
        _numFrequencies = size;
        
        //create the AUGraph
        checkErrorAndExit(NewAUGraph(&_graph), "Creating AUGraph for MultipleFrequencyAUGraph");
        
        //create the mixer unit
        AudioComponentDescription unitDesc = {0};
        unitDesc.componentType = kAudioUnitType_Mixer;
        unitDesc.componentSubType = kAudioUnitSubType_StereoMixer;
        unitDesc.componentManufacturer = kAudioUnitManufacturer_Apple;
        
        AUNode mixerNode;
        checkErrorAndExit(AUGraphAddNode(_graph, &unitDesc, &mixerNode), "Creating mixer node for MultipleFrequencyAUGraph");
        
        //create the output unit
        unitDesc.componentType = kAudioUnitType_Output;
        unitDesc.componentSubType = kAudioUnitSubType_DefaultOutput;
        unitDesc.componentManufacturer = kAudioUnitManufacturer_Apple;
        
        AUNode outputNode;
        checkErrorAndExit(AUGraphAddNode(_graph, &unitDesc, &outputNode), "Creating output node for MultipleFrequencyAUGraph");
        
        //open the graph
        checkErrorAndExit(AUGraphOpen(_graph), "Openening graph for MultipleFrequencyAUGraph");
        
        //get the AudioUnits from the graph
        checkErrorAndExit(AUGraphNodeInfo(_graph, mixerNode, NULL, &_mixerUnit), "Getting the mixer unit for MultipleFrequencyAUGraph");
        checkErrorAndExit(AUGraphNodeInfo(_graph, outputNode, NULL, &_outputUnit), "Getting the output unit for MultipleFrequencyAUGraph");
        
        //Get the AudioStreamBasicDescription to make the frequencyGenerators
        UInt32 dataSize = sizeof(AudioStreamBasicDescription);
        checkErrorAndExit(AudioUnitGetProperty(self.outputUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Global, 0, &_streamFormat, &dataSize), "Getting audio description from the output unit");
        
        
        //set input callback for the mixer unit for bus
        //0 - numFrequences. The mixer is supposed to mix all the frequencies in self.frequencies
        _mixerInfoArr = [[NSMutableArray alloc] initWithCapacity:self.numFrequencies];
        for (int i = 0; i < self.numFrequencies; i++){
            AURenderCallbackStruct callbackStruct;
            callbackStruct.inputProc = MultipleFrequencyAUGraphCallback;
            AUGraphMixerInfo *mixerInfo = [[AUGraphMixerInfo alloc] initWithIndex:i andSampleRate:_streamFormat.mSampleRate andFreq:frequencies[i] andLoudness:1];
            [_mixerInfoArr addObject:mixerInfo];
            
            callbackStruct.inputProcRefCon = (__bridge void *) mixerInfo;
            
            checkErrorAndExit(AudioUnitSetProperty(self.mixerUnit, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Global, i, &callbackStruct, sizeof(callbackStruct)), "setting render callback on mixer unit");
        }
        
        
        
        //set up the output node
        //connect mixer node to the output node
        checkErrorAndExit(AUGraphConnectNodeInput(self.graph, mixerNode, 0, outputNode, 0), "Connecting the mixer node to the outputNode for MultipleFrequencyAUGraph");
        
        checkErrorAndExit(AUGraphInitialize(_graph), "Initializing graph for MultipleFrequencyAUGraph");
        
    }
    return self;
}

- (void) setFrequencies:(double *)frequencies ofSize:(unsigned int)size{
    for (int i = 0; (i < size) && (i < self.numFrequencies); i++){
        AUGraphMixerInfo *mixerInfo = [self.mixerInfoArr objectAtIndex:i];
        mixerInfo.freq = frequencies[i];
    }
}

- (void) setFrequencies:(double *)frequencies andLoudness:(double *)loudness ofSize:(unsigned int)size{
    for (int i = 0; (i < size) && (i < self.numFrequencies); i++){
        AUGraphMixerInfo *mixerInfo = [self.mixerInfoArr objectAtIndex:i];
        mixerInfo.freq = frequencies[i];
        mixerInfo.loudness = loudness[i];
    }
}

- (void) play{
    //start the graph
    checkErrorAndExit(AUGraphStart(self.graph), "starting the graph for [MultipleFrequencyAUGraph play]");
}

- (void) pause{
    checkErrorAndExit(AUGraphStop(self.graph), "stopping the grpah for [MultipleFrequencyAUGraph pause]");
}

- (void) dealloc{
    //uninitialize and close the graph
    AUGraphStop(self.graph);
    AUGraphUninitialize(self.graph);
    AUGraphClose(self.graph);
}
@end
