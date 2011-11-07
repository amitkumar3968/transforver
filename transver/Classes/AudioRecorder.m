//
//  audioRecorder.m
//  iMove
//
//  Created by Hasnat on 1/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AudioRecorder.h"


@implementation AudioRecorder

- init{
	if (self = [super init]) {
		// Your initialization code here
		
	// Get audio file page
    char path[512];
    [self getFilename:path maxLenth:sizeof path];
    fileURL = CFURLCreateFromFileSystemRepresentation(NULL, (UInt8*)path, strlen(path), false);

    // Init state variables
    playState.playing = false;
    recordState.recording = false;
	}
	return self;

}
void AudioInputCallback(
						void *inUserData, 
						AudioQueueRef inAQ, 
						AudioQueueBufferRef inBuffer, 
						const AudioTimeStamp *inStartTime, 
						UInt32 inNumberPacketDescriptions, 
						const AudioStreamPacketDescription *inPacketDescs)
{
	RecordState* recordState = (RecordState*)inUserData;
    if(!recordState->recording)
    {
        printf("Not recording, returning\n");
    }
	
    //if(inNumberPacketDescriptions == 0 && recordState->format->mBytesPerPacket != 0)
    //{
    //    inNumberPacketDescriptions = inBuffer->mAudioDataByteSize / recordState->format->mBytesPerPacket;
    //}
	
    printf("Writing buffer %d\n", recordState->currentPacket);
    OSStatus status = AudioFileWritePackets(recordState->audioFile,
											false,
											inBuffer->mAudioDataByteSize,
											inPacketDescs,
											recordState->currentPacket,
											&inNumberPacketDescriptions,
											inBuffer->mAudioData);
    if(status == 0)
    {
        recordState->currentPacket += inNumberPacketDescriptions;
    }
	
	
    AudioQueueEnqueueBuffer(recordState->queue, inBuffer, 0, NULL);
}




void AudioOutputCallback(
						 void* inUserData,
						 AudioQueueRef outAQ,
						 AudioQueueBufferRef outBuffer)
{
	PlayState* playState = (PlayState*)inUserData;	
    if(!playState->playing)
    {
        printf("Not playing, returning\n");
        return;
    }
	
	printf("Queuing buffer %d for playback\n", playState->currentPacket);
    
    AudioStreamPacketDescription* packetDescs;
    
    UInt32 bytesRead;
    UInt32 numPackets = 8000;
    OSStatus status;
    status = AudioFileReadPackets(
								  playState->audioFile,
								  false,
								  &bytesRead,
								  packetDescs,
								  playState->currentPacket,
								  &numPackets,
								  outBuffer->mAudioData);
	
    if(numPackets)
    {
        outBuffer->mAudioDataByteSize = bytesRead;
        status = AudioQueueEnqueueBuffer(
										 playState->queue,
										 outBuffer,
										 0,
										 packetDescs);
		
        playState->currentPacket += numPackets;
    }
    else
    {
        if(playState->playing)
        {
            AudioQueueStop(playState->queue, false);
            AudioFileClose(playState->audioFile);
            playState->playing = false;
        }
        
		AudioQueueFreeBuffer(playState->queue, outBuffer);
    }
	
}

- (void)setupAudioFormat:(AudioStreamBasicDescription*)format 
{
	format->mSampleRate = 19200;    
	format->mFormatID = kAudioFormatLinearPCM;
	format->mFormatFlags = kLinearPCMFormatFlagIsBigEndian |
	kLinearPCMFormatFlagIsSignedInteger |
	kLinearPCMFormatFlagIsPacked;
	format->mBytesPerPacket = 2;
	format->mFramesPerPacket = 1;
	format->mBytesPerFrame = 2;
	format->mChannelsPerFrame = 1;
	format->mBitsPerChannel = 16;
	/*
	format->mSampleRate = 8000.0;
	
	format->mFormatID = kAudioFormatLinearPCM;
	format->mFramesPerPacket = 1;
	format->mChannelsPerFrame = 1;
	format->mBytesPerFrame = 2;//sizeof(Float32);
	format->mBytesPerPacket = 2;
	format->mBitsPerChannel = 16;//16;
	format->mReserved = 0;
	format->mFormatFlags = kLinearPCMFormatFlagIsBigEndian |
	kLinearPCMFormatFlagIsSignedInteger |
	kLinearPCMFormatFlagIsPacked;
	 */
}

- (void)recordPressed:(id)sender
{
    if(!playState.playing)
    {
        if(!recordState.recording)
        {
            printf("Starting recording\n");
            [self startRecording];
        }
        else
        {
            printf("Stopping recording\n");
            [self stopRecording];
        }
    }
    else
    {
        printf("Can't start recording, currently playing\n");
    }
}

- (void)playPressed:(id)sender
{
    if(!recordState.recording)
    {
        if(!playState.playing)
        {
            printf("Starting playback\n");
            [self startPlayback];
        }
        else
        {
            printf("Stopping playback\n");
            [self stopPlayback];
        }
    }
}

- (void)startRecording
{
    [self setupAudioFormat:&recordState.dataFormat];
    
    recordState.currentPacket = 0;
	
    OSStatus status;
    status = AudioQueueNewInput(&recordState.dataFormat,
								AudioInputCallback,
								&recordState,
								CFRunLoopGetCurrent(),
								kCFRunLoopCommonModes,
								0,
								&recordState.queue);
    
    if(status == 0)
    {
        for(int i = 0; i < NUM_BUFFERS; i++)
        {
            AudioQueueAllocateBuffer(recordState.queue,
									 16000, &recordState.buffers[i]);
            AudioQueueEnqueueBuffer(recordState.queue,
									recordState.buffers[i], 0, NULL);
        }
        
        status = AudioFileCreateWithURL(fileURL,
										kAudioFileAIFFType,
										&recordState.dataFormat,
										kAudioFileFlags_EraseFile,
										&recordState.audioFile);
        if(status == 0)
        {
            recordState.recording = true;        
            status = AudioQueueStart(recordState.queue, NULL);
            if(status == 0)
            {
				NSLog(@"Vocoder Finished !!");
                //labelStatus.text = @"Recording";
            }
        }
    }
    
    if(status != 0)
    {
        [self stopRecording];
		NSLog(@"Recording failed.");
        //labelStatus.text = @"Record Failed";
    }
}

- (void)stopRecording
{
    recordState.recording = false;
    
    AudioQueueStop(recordState.queue, true);
    for(int i = 0; i < NUM_BUFFERS; i++)
    {
        AudioQueueFreeBuffer(recordState.queue,
							 recordState.buffers[i]);
    }
    
    AudioQueueDispose(recordState.queue, true);
    AudioFileClose(recordState.audioFile);
	NSLog([self getFileLocation]);
	NSLog([NSString stringWithFormat:@"Click to play file %@",[self getFileLocation ]]);
    //labelStatus.text = @"Idle";
}
-(NSString *)getFileLocation{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
														 NSUserDomainMask, YES); 
    NSString* docDir = [paths objectAtIndex:0];
    NSString* file = [docDir stringByAppendingString:@"/out.aif"];
	return file;
}
- (void)startPlayback
{
    playState.currentPacket = 0;
    
    [self setupAudioFormat:&playState.dataFormat];
    
    OSStatus status;
	//NSLog([fileURL description]);
    status = AudioFileOpenURL(fileURL, 0x01, kAudioFileAIFFType, &playState.audioFile);
    if(status == 0)
    {
        status = AudioQueueNewOutput(
									 &playState.dataFormat,
									 AudioOutputCallback,
									 &playState,
									 CFRunLoopGetCurrent(),
									 kCFRunLoopCommonModes,
									 0,
									 &playState.queue);
        
        if(status == 0)
        {
            playState.playing = true;
            for(int i = 0; i < NUM_BUFFERS && playState.playing; i++)
            {
                if(playState.playing)
                {
                    AudioQueueAllocateBuffer(playState.queue, 16000, &playState.buffers[i]);
                    AudioOutputCallback(&playState, playState.queue, playState.buffers[i]);
                }
            }
			
            if(playState.playing)
            {
                status = AudioQueueStart(playState.queue, NULL);
                if(status == 0)
                {
					NSLog(@"Playing..");
                    //labelStatus.text = @"Playing";
                }
            }
        }        
    }
    
    if(status != 0)
    {
        [self stopPlayback];
		NSLog(@"Play Failed.");
        //labelStatus.text = @"Play failed";
    }
}

- (void)startPlaybackWithFilepath:(NSString *)filePath
{
    playState.currentPacket = 0;
    
    [self setupAudioFormat:&playState.dataFormat];
	const char *path_buffer=[filePath UTF8String];
	const char *path=[filePath UTF8String];
    fileURL = CFURLCreateFromFileSystemRepresentation(NULL, (UInt8*)path_buffer, strlen(path_buffer), false); 
    OSStatus status;
	//NSLog([fileURL description]);
    status = AudioFileOpenURL(fileURL, 0x01, kAudioFileAIFFType, &playState.audioFile);
    if(status == 0)
    {
        status = AudioQueueNewOutput(
									 &playState.dataFormat,
									 AudioOutputCallback,
									 &playState,
									 CFRunLoopGetCurrent(),
									 kCFRunLoopCommonModes,
									 0,
									 &playState.queue);
        
        if(status == 0)
        {
            playState.playing = true;
            for(int i = 0; i < NUM_BUFFERS && playState.playing; i++)
            {
                if(playState.playing)
                {
                    AudioQueueAllocateBuffer(playState.queue, 16000, &playState.buffers[i]);
                    AudioOutputCallback(&playState, playState.queue, playState.buffers[i]);
                }
            }
			
            if(playState.playing)
            {
                status = AudioQueueStart(playState.queue, NULL);
                if(status == 0)
                {
					NSLog(@"Playing..");
                    //labelStatus.text = @"Playing";
                }
            }
        }        
    }
    
    if(status != 0)
    {
        [self stopPlayback];
		NSLog(@"Play Failed.");
        //labelStatus.text = @"Play failed";
    }
}

- (void)stopPlayback
{
    playState.playing = false;
    
    for(int i = 0; i < NUM_BUFFERS; i++)
    {
        AudioQueueFreeBuffer(playState.queue, playState.buffers[i]);
    }
	
    AudioQueueDispose(playState.queue, true);
    AudioFileClose(playState.audioFile);
}
- (void)dealloc
{
    CFRelease(fileURL);
    //[labelStatus release];
    //[buttonRecord release];
    //[buttonPlay release];
    //	[window release];
    [super dealloc];
}

- (BOOL)getFilename:(char*)buffer maxLenth:(int)maxBufferLength
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
														 NSUserDomainMask, YES); 
    NSString* docDir = [paths objectAtIndex:0];
    NSString* file = [docDir stringByAppendingString:@"/recording.aif"];
    return [file getCString:buffer maxLength:maxBufferLength encoding:NSUTF8StringEncoding];
}
@end