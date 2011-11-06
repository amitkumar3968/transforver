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

@interface VocViewController : UIViewController {
	IBOutlet UITextField *passwd;
	IBOutlet UIButton *playorig;
	IBOutlet UIButton *playtrans;
	IBOutlet UIButton *record;
	IBOutlet UIButton *sendexit;
	IBOutlet UIButton *quit;
	IBOutlet UIPickerView *voice_opt;
	IBOutlet UISwitch *encrypt;
	NSString* localFilePath;
}

@property (nonatomic,retain)  AudioRecorder *audioRecorder;
@property (nonatomic, retain) NSFileHandle *audioFile;
@property (nonatomic, retain) NSString *localFilePath;

- (IBAction) playorig_playback;
- (IBAction) playtrans_playback;
- (IBAction) dovocode_playback;
- (IBAction) sendexit_playback;
- (IBAction) quit_playback;
- (IBAction) vocodeTapped :(id)sender;
- (void) uploadFile:(char*)filepath;



@end


