//
//  VocViewController.h
//  NavTab
//
//  Created by easystudio on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h> //right click on framework and add AVFoundation
#import <AudioToolbox/AudioToolbox.h> //right click on framework and add AudioToolbox
#import "AudioRecorder.h"
#import "Util.h"

@protocol VocSendVoiceDelegate;

@interface VocViewController : UIViewController 
<UIPickerViewDelegate, UIPickerViewDataSource, AVAudioPlayerDelegate>{
	IBOutlet UITextField *password;
	IBOutlet UIPickerView *voice_opt;
	IBOutlet UISwitch *encrypt;
	NSArray *vocodeCarrierOptions;
	NSString* localFilePath;
	AudioRecorder *audioRecorder;
	int done_vocode;
	int vocode_carrier_index;
	// elements for random string generator	
	
	//Ray add for AudioPlayer UI
	AVAudioPlayer *player ;//
	IBOutlet UISlider *slider,*timeSlider;    //slider to increase sound as required
	IBOutlet UIButton *playButton;           //Play button to start song
	IBOutlet UIButton *pauseButton;        //Pause button to pause song 
	IBOutlet UIButton *stopButton;          //stop button to start song from starting 
	double increaseSound;                      //to hold the value of the slider
 	NSTimer *timer;	
	//============================
    id <VocSendVoiceDelegate> delegate;
}

@property (nonatomic,retain)  AudioRecorder *audioRecorder;
//@property (nonatomic, retain) NSFileHandle *audioFile;
@property (nonatomic, retain) NSString *localFilePath;
@property (nonatomic, retain) UITextField *password;
@property (nonatomic, retain) UIPickerView *voice_opt;
@property (nonatomic, retain) UISwitch *encrypt;
@property (nonatomic, retain) NSArray *vocodeCarrierOptions;

- (IBAction) playorig_playback:(id)sender;
- (IBAction) playtrans_playback:(id)sender;
- (IBAction) sendexit_playback:(id)sender;
- (IBAction) quit_playback:(id)sender;
- (IBAction) vocodeTapped :(id)sender;
- (void) uploadFile:(char*)filepath;
+ (NSString*) genRandStringLength:(int)len;

//@Ray add for AudioPlayer UI
@property(retain,nonatomic)AVAudioPlayer *player;//
@property(retain,nonatomic)IBOutlet UISlider *slider ,*timeSlider;
@property(nonatomic,readwrite)double increaseSound;
@property(nonatomic,retain)NSTimer *timer;
@property (nonatomic, assign) id <VocSendVoiceDelegate> delegate;

-(IBAction)playPlayer:(id)sender;//
-(IBAction)pausePlayer:(id)sender;//
-(IBAction)stopPlayer:(id)sender;//
-(IBAction)sound:(id)sender;

-(void)timeLoader;                                         //to slide the song slider as the song slides
-(IBAction)timerPosition:(id)sender; 
- (IBAction)textFieldFinished:(id)sender;
//============================


@end

@protocol VocSendVoiceDelegate <NSObject>
@optional

- (void) sendVoice:(NSString *)origfilename vocode:(NSString *)vocodefilename pass:(NSString *)password;

@end


