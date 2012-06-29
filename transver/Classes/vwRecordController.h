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
#import "AudioRecorder.h"
#import "Util.h"
#include "dovocode.h"

@interface vwRecordController : UIViewController
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
	double increaseSound;                      //to hold the value of the slider
 	NSTimer *timer;	
    
    //Ray added for AudioRecorder
    
    //uipickerview
    IBOutlet UIPickerView *uipkVocodeOpt;
    NSArray* arrVocCarrierOpts;
    NSInteger carrierOptIndex;
    NSInteger done_vocode;
	//============================    
}
@property (nonatomic, retain) UILabel *uilbTimeTotal;
@property (nonatomic, retain) UISlider *uisliderTime;
@property (nonatomic, retain) UISwitch *uiswEncrypt;
@property (nonatomic, retain) UISwitch *uiswPassLock;
@property (nonatomic, retain) UISwitch *uiswAutoDel;
@property (nonatomic, retain) UISegmentedControl *switchView;
@property(retain,nonatomic)AVAudioPlayer *player;
@property (nonatomic, retain) UIPickerView *uipkVocodeOpt;
@property (nonatomic, retain) NSArray* arrVocCarrierOpts;
@property NSInteger carrierOptIndex;

-(IBAction)playPlayer:(id)sender;
-(IBAction)pausePlayer:(id)sender;
-(IBAction)stopPlayer:(id)sender;
-(IBAction)sliderValueChanged:(id)sender;
//-(IBAction)sound:(id)sender;


-(IBAction) updateSliderValue:(id)sender;
-(IBAction) recordButtonTapped :(id)sender;
-(IBAction) recordButtonTouchUp:(id)sender;
-(void) initRecorderSetup;
-(void) playerSetup;
-(IBAction) showPicker;
-(IBAction) hidePicker;
@end
