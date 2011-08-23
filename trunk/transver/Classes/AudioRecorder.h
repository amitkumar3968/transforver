//
//  audioRecorder.h
//  iMove
//
//  Created by Hasnat on 1/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioQueue.h>
#import <AudioToolbox/AudioFile.h>
#define NUM_BUFFERS 3
#define SECONDS_TO_RECORD 10

typedef struct
{
    AudioStreamBasicDescription  dataFormat;
    AudioQueueRef                queue;
    AudioQueueBufferRef          buffers[NUM_BUFFERS];
    AudioFileID                  audioFile;
    SInt64                       currentPacket;
    bool                         recording;
} RecordState;

typedef struct
{
    AudioStreamBasicDescription  dataFormat;
    AudioQueueRef                queue;
    AudioQueueBufferRef          buffers[NUM_BUFFERS];
    AudioFileID                  audioFile;
    SInt64                       currentPacket;
    bool                         playing;
} PlayState;

@interface AudioRecorder : NSObject {
	RecordState recordState;
    PlayState playState;
    CFURLRef fileURL;
}
- (BOOL)getFilename:(char*)buffer maxLenth:(int)maxBufferLength;
- (void)setupAudioFormat:(AudioStreamBasicDescription*)format;
- (void)recordPressed:(id)sender;
- (void)playPressed:(id)sender;
- (void)startRecording;
- (void)stopRecording;
- (void)startPlayback;
- (void)stopPlayback;
@end