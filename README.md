# miscellaneous

## Episoder
Episoder is a program that keeps track of episodes you watch in a series (pre Netflix era).
I made it in the summer before my 12th grade in high school as a way to learn Java so I wasn't entirely sure what I was doing :)

The GUI is created using `java.awt` and it's completely static (does not allow resizing at all). I only tested it on a Windows Vista machine so it might not look the same on all devices.

A few notes about the program:
- The interface does not actually spend any time loading, I just thought a loading screen looked cool
- The program saves information in a text file called `ASD150.txt`. This name does not represent anything, I just thought that a weird name will prevent the user from opening and modifying the file

##Core Audio
Various projects I made while learning Core Audio.
Some (mostly `CheckError.c` and `CheckError.h`) are taken from *Learning Core Audio: A Hands-On Guide to Audio Programming for Mac and iOS by Chris Adamson and Kevin Avila*
### AudioQueuePlayback
Plays an audio file. Run AudioQueuePlayback with an audio file name as a command line argument

### AudioQueueRecorder
Records audio and saves it in a `output.caf` in the home directory

### playTones
Plays a bunch of frequencies together. Run it with `-h` in the command line to get a help message

### SoundIllusion
Creates a funny (and annoying if heard for more than a second) sound by combining different frequences at different times

### ToneFileGenerator
Creates a wave of a specific frequency and saves it in a file. Pass `help` in the command line to get a help message
