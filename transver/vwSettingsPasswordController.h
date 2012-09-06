//
//  vwSettingsPasswordController.h
//  NavTab
//
//  Created by sir 余 on 12/7/1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PROGRAM_PASSWORD @"vwSettingsPasswordController.programPassword"
#define PASSWORD @"vwSettingsPasswordController.password"

@interface vwSettingsPasswordController : UIViewController
@property (atomic, retain) IBOutlet UISwitch* uiswProgramPassword;
@property (atomic, retain) IBOutlet UITextField *uitxPassword;

- (IBAction)resignTextField:(id)sender;
- (IBAction)cancelSetting:(id)sender;
- (IBAction)saveSetting:(id)sender;
@end
