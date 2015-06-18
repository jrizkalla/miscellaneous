//
//  main.m
//  SoundIllusion
//
//  Created by John Rizkalla on 2014-10-17.
//  Copyright (c) 2014 John Rizkalla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MultipleFrequencyAUGraph.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        const double maxFreq = 1000;
        const double minFreq = 200;
        
        double frequences[] = {minFreq, (maxFreq-minFreq)/2, maxFreq};
        double frequencies1[] = {frequences[0]};
        double frequencies2[] = {frequences[1]};
        double frequencies3[] = {frequences[2]};
        MultipleFrequencyAUGraph *graph1 = [[MultipleFrequencyAUGraph alloc] initWithFrequncies:frequencies1 ofSize:1];
        MultipleFrequencyAUGraph *graph2 = [[MultipleFrequencyAUGraph alloc] initWithFrequncies:frequencies2 ofSize:1];
        MultipleFrequencyAUGraph *graph3 = [[MultipleFrequencyAUGraph alloc] initWithFrequncies:frequencies3 ofSize:1];
        [graph1 play];
        [graph2 play];
        [graph3 play];
        
        double diff1 =1;
        double diff2 =1;
        double diff3 =1;
        
        while (true){
            for (int i= 0; i < 3; i++){
                usleep(1000);
                MultipleFrequencyAUGraph *graph = i==0? graph1 : (i==1? graph2 : graph3);
                double *freq = i==0? frequencies1 : (i==1? frequencies2 : frequencies3);
                double *diff = i==0? &diff1: (i==1? &diff2 : &diff3);
                double res = freq[0]-((maxFreq-minFreq)/2)-minFreq;
                res = res<0? -res: res;
                res = res / ((maxFreq-minFreq)/2);
                res = 1-res;
                double loudness[] = {res};
                
                //[graph pause];
                freq[0]+= *diff;
                if (freq[0] >= maxFreq)
                    *diff = -1;
                else if (freq[0] <= minFreq)
                    *diff = 1;
                [graph setFrequencies:freq andLoudness:loudness ofSize:1];
                [graph play];
            }
        }
    }
    return 0;
}
