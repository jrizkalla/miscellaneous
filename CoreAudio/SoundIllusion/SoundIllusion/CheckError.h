//
//  CheckError.h
//
//  Created by John Rizkalla on 2014-09-05.
//  Copyright (c) 2014 John Rizkalla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

/**
 @function   checkError
 @abstract   Checks and prints an OSStatus error
 @discussion
    If the error is a 4 char code, the the function prints message followed by the code,
    if it is an int then it prints the message followed by the int.
 @param      retRes
 The error
 @param      message
 What the function that returned the error was doing
 @param      exitApp
 if TRUE then the function exits after it prints, if FALSE then it does not
 @return
 Returnes TRUE if there is an error and FALSE if there is no error
*/
BOOL checkError (OSStatus retRes, char *message, BOOL exitApp);


/**
 @function checkErrorAndExit
 @abstract Checks and prints an OSStatus error then exits that application
 @param retRes
 The Error
 @param message
 What the function that returned the error was doing
 */
void checkErrorAndExit (OSStatus retRes, char *message);