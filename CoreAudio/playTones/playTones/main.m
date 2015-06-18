//
//  main.m
//  playTones
//
//  Created by John Rizkalla on 2014-10-09.
//  Copyright (c) 2014 John Rizkalla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MultipleFrequencyAUGraph.h"

void printErrorAndExit (int returnValue){
    printf("\nUsage [OPTIONS] [FREQUENCY]\n");
    printf("Options:\n");
    printf("\t-d <int> or --duration <int>: play frequencies with a predetermined duration no text output or input\n");
    printf("\t-s or --silent: suppress all text output\n");
    printf("\t-h or --help: print this message and exit\n\n");
    printf("Frequency: any number of doubles representing frequencies to combine or\n");
    printf("           -fl <double> <double> where -fl is followed by the frequency and its loudness (eg. -fl 300 0.3)\n\n");
    exit (returnValue);
}


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //get the list of frequencies from the input
        double frequencies [argc - 1];
        double loudness [argc - 1];
        int indexOfFreq = 0;
        
        int duration = -1;
        bool loud = true;
        for (int i = 1; i < argc; i++){
            if (strcmp(argv[i], "-d") == 0 || strcmp(argv[i], "--duration") == 0){
                if (i == argc-1)
                    printErrorAndExit(1);
                duration = atoi(argv[i+1]);
                i++;
            } else if (strcmp(argv[i], "-s") == 0 || strcmp(argv[i], "--silent") == 0){
                loud = false;
            } else if (strcmp(argv[i], "-h") == 0 || strcmp(argv[i], "--help") == 0){
                printErrorAndExit(0);
            } else if (strcmp(argv[i], "-fl") == 0){
                if ((i + 2) > argc){
                    //missing input
                    printErrorAndExit(2);
                }
                double freq = atof(argv[i+1]);
                double loudn = -1;
                loudn = atof (argv[i+2]);
                if (freq > 0 && loudn >= 0){
                    frequencies[indexOfFreq] = freq;
                    loudness[indexOfFreq] = loudn;
                    indexOfFreq++;
                    i+=2;
                }
            }
            else{
                double res = atof(argv[i]);
                if (res > 0){
                    frequencies [indexOfFreq] = res;
                    loudness [indexOfFreq] = 1;
                    indexOfFreq++;
                }
            }
        }
        
        MultipleFrequencyAUGraph *graphObj = [[MultipleFrequencyAUGraph alloc] initWithFrequncies:frequencies ofSize:indexOfFreq];
        [graphObj setFrequencies:frequencies andLoudness:loudness ofSize:indexOfFreq];
        
        if (duration >= 0){
            [graphObj play];
            usleep(duration*1000*1000);
            [graphObj pause];
            return 0;
        }
        
        
        [graphObj play];
        if (loud) printf("Press <return> to pause. Press <cntl-c> to end process");
        getchar();
        [graphObj pause];
        while (1){
            if (loud) printf("Press <return> to play");
            getchar();
            [graphObj play];
            if (loud) printf("Press <return> to pause");
            getchar();
            [graphObj pause];
        }
    }
    return 0;
}
