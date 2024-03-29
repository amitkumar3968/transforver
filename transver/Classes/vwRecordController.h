//
//  FirstViewController.h
//  VEMsg
//
//  Created by sir 余 on 12/5/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h> //right click on framework and add AVFoundation
#import <AudioToolbox/AudioToolbox.h> //right click on framework and add AudioToolbox
#import <MediaPlayer/MediaPlayer.h>
#import "AudioRecorder.h"
#import "Util.h"
#import "VocViewController.h"
#import "MyContactsView.h"
#import "VoiceConverterModel.h"

#include "dovocode.h"

#define MAX_RECORD_SECONDS 60
#define MAX_PASSWORD_LENGTH 5
#define RECORDING_FILE_AIF @"recording.aif"
#define RECORDING_FILE_M4A @"recording.caf"
#define VOCODE_FILE_AIF @"out.aif"
#define VOCODE_FILE_M4A @"out.caf"

@protocol RecorderSendDelegate;


@interface vwRecordController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
{
    IBOutlet UILabel *uilbTimeElapse;
    IBOutlet UILabel *uilbTimeTotal;
    IBOutlet UISlider *uisliderTime;
    IBOutlet UISwitch *uiswEncrypt;
    IBOutlet UISwitch *uiswPassLock;
    IBOutlet UISwitch *uiswAutoDel;    
    UISegmentedControl* switchView;
	//Ray add for AudioPlayer UI
	AVAudioPlayer *player ;
	IBOutlet UISlider *slider,*timeSlider;    //slider to increase sound as required
	IBOutlet UIButton *playButton;           //Play button to start song
	IBOutlet UIButton *pauseButton;        //Pause button to pause song 
	IBOutlet UIButton *stopButton;          //stop button to start song from starting 
    IBOutlet UIButton *btnSend;
    IBOutlet UIButton *btnDelete;
    UIView *confirmView;
	double increaseSound;                      //to hold the value of the slider
 	NSTimer *timer;	
    BOOL playerPlaying;
    float recSeconds;
    
    //Ray added for AudioRecorder
    
    //uipickerview
    IBOutlet UIPickerView *uipkVocodeOpt;
    NSArray* arrVocCarrierOpts;
    NSInteger carrierOptIndex;
    NSInteger done_vocode;
    
	//============================   
    id <RecorderSendDelegate> delegate;
    NSString *destName;
    //============================
}
@property (nonatomic, retain) UILabel *uilbTimeTotal;
@property (nonatomic, retain) UISlider *uisliderTime;
@property (nonatomic, retain) UISwitch *uiswEncrypt;
@property (nonatomic, retain) UISwitch *uiswPassLock;
@property (nonatomic, retain) UISwitch *uiswAutoDel;
@property (nonatomic, retain) UISegmentedControl *switchView;
@property (nonatomic, retain) IBOutlet UIButton *btnSend;
@property (nonatomic, retain) IBOutlet UIButton *btnDelete;
@property (nonatomic, retain) UIView *confirmView;
@property(retain,nonatomic)AVAudioPlayer *player;
@property (nonatomic, retain) UIPickerView *uipkVocodeOpt;
@property (nonatomic, retain) NSArray* arrVocCarrierOpts;
@property NSInteger carrierOptIndex;
@property (nonatomic, assign) id<RecorderSendDelegate> delegate;
@property (nonatomic, retain) NSString *destName;

@property (nonatomic, retain) IBOutlet UIButton* uibtSendToWho;
@property (nonatomic, retain) IBOutlet UIButton* vocodeOptionReady;
@property (nonatomic, strong) UIPickerView* selecteTargetPicker;

@property (nonatomic, retain) NSTimer *recTimer;
@property (nonatomic, retain) IBOutlet UIButton *uibtRecord;
@property (nonatomic, retain) AudioRecorder *recorder;
@property (nonatomic, retain) IBOutlet  UIActivityIndicatorView *progressView;
@property (nonatomic, retain) UIView *recordingBar;
@property (nonatomic, retain) UILabel *uilbRecSec;
@property (nonatomic, retain) UIView *coverView, *coverView2;

@property (nonatomic, retain) NSString *vocodedFilepath;
@property (nonatomic, retain) NSString *originalFilepath;

@property (nonatomic, retain) IBOutlet  UITextField *txfPass;

@property (nonatomic, retain) IBOutlet UILabel *uilbSelectEncryType;
@property (nonatomic, retain) IBOutlet UILabel *uilbPassLock;
@property (nonatomic, retain) IBOutlet UILabel *uilbPassword;
@property (nonatomic, retain) IBOutlet UILabel *uilbAutoDel;
@property (nonatomic, retain) UITextField *passInput;
@property (nonatomic, retain) UIAlertView* authAlert;

-(IBAction)playPlayer:(id)sender;
-(IBAction)pausePlayer:(id)sender;
-(IBAction)stopPlayer:(id)sender;
-(IBAction)sliderValueChanged:(id)sender;
//-(IBAction)sound:(id)sender;
-(IBAction) passwordCheck :(id)sender;

-(void) updateSliderValue:(id)sender;
-(IBAction) recordButtonTapped :(id)sender;
-(void) initRecorderSetup;
-(void) updateRecordingState:(NSTimer *)recTimer;

-(void) playerSetup;
-(IBAction) showPicker;
-(IBAction) hidePicker;

-(IBAction) showSendToWhoPicker:(id)sender;
-(IBAction) deletePressed;


@end


@protocol RecorderSendDelegate <NSObject>
@optional
- (void)sendVoice:(NSString *)origfilename vocode:(NSString *)vocodefilename pass:(NSString *)password;

@end

