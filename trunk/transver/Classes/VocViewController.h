//
//  VocViewController.h
//  NavTab
//
//  Created by easystudio on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioRecorder.h"


@interface VocViewController : UIViewController {
	IBOutlet UITextField *passwd;
	IBOutlet UIButton *dovocode;
	IBOutlet UIButton *playorig;
	IBOutlet UIButton *playtrans;
	IBOutlet UIButton *record;
	IBOutlet UIButton *sendexit;
	IBOutlet UIButton *quit;
	IBOutlet UIPickerView *voice_opt;
	IBOutlet UISwitch *encrypt;
}

@property (nonatomic,retain)  AudioRecorder *audioRecorder;
@property (nonatomic, retain) NSFileHandle *audioFile;

- (IBAction) playorig_playback;
- (IBAction) playtrans_playback;
- (IBAction) dovocode_playback;
- (IBAction) recordButtonTapped;
- (IBAction) recordButtonTouchUp;
- (IBAction) sendexit_playback;
- (IBAction) quit_playback;
- (IBAction) vocodeTapped :(id)sender;



@end
