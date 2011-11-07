//
//  VocViewController.h
//  NavTab
//
//  Created by easystudio on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioRecorder.h"
#import "Util.h"

@interface VocViewController : UIViewController 
<UIPickerViewDelegate, UIPickerViewDataSource>{
	IBOutlet UITextField *password;
	IBOutlet UIPickerView *voice_opt;
	IBOutlet UISwitch *encrypt;
	NSArray *vocodeCarrierOptions;
	NSString* localFilePath;
	AudioRecorder *audioRecorder;
	int done_vocode;
	int vocode_carrier_index;
}

@property (nonatomic,retain)  AudioRecorder *audioRecorder;
//@property (nonatomic, retain) NSFileHandle *audioFile;
@property (nonatomic, retain) NSString *localFilePath;
@property (nonatomic, retain) UITextField *password;
@property (nonatomic, retain) UIPickerView *voice_opt;
@property (nonatomic, retain) UISwitch *encrypt;
@property (nonatomic, retain) NSArray *vocodeCarrierOptions;

- (IBAction) playorig_playback:(id)sender;
- (IBAction) playtrans_playback;
- (IBAction) sendexit_playback:(id)sender;
- (IBAction) quit_playback:(id)sender;
- (IBAction) vocodeTapped :(id)sender;
- (void) uploadFile:(char*)filepath;


@end


