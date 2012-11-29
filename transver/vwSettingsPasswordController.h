//
//  vwSettingsPasswordController.h
//  NavTab
//
//  Created by sir 余 on 12/7/1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface vwSettingsPasswordController : UIViewController
@property (atomic, retain) IBOutlet UISwitch* uiswProgramPassword;
@property (atomic, retain) IBOutlet UITextField *uitxPassword;
@property (nonatomic, retain) IBOutlet UILabel *uilbProgramAuth;
@property (nonatomic, retain) IBOutlet UILabel *uilbPassword;
@property (nonatomic, retain) IBOutlet UIButton *uibtCancel;
@property (nonatomic, retain) IBOutlet UIButton *uibtSave;

- (IBAction)resignTextField:(id)sender;
- (IBAction)cancelSetting:(id)sender;
- (IBAction)saveSetting:(id)sender;
- (IBAction)presentKB:(id)sender;
@end
