//
//  CheckError.m
//  AudioQueueRecorder
//
//  Created by John Rizkalla on 2014-09-05.
//  Copyright (c) 2014 John Rizkalla. All rights reserved.
//

#include <stdio.h>
#include "CheckError.h"

BOOL checkError (OSStatus retRes, char *message, BOOL exitApp){
    if (retRes == noErr) return FALSE;

    //check if the retRes is a 4 char code...
    char errorMessage[20];
    *(UInt32 *)(errorMessage + 1) = CFSwapInt32HostToBig(retRes);
    if (isprint(errorMessage[1]) && isprint(errorMessage[2]) && isprint(errorMessage[3]) && isprint(errorMessage[4])){
        errorMessage[0] = errorMessage [5] = '\'';
        errorMessage[6] = '\0';
    }else
        sprintf(errorMessage, "%d", (int) retRes);

    fprintf(stderr, "Error in %s (%s)\n", message, errorMessage);

    if (exitApp) exit(1);
    return TRUE;
}

void checkErrorAndExit (OSStatus retRes, char *message){
    checkError(retRes, message, TRUE);
}
