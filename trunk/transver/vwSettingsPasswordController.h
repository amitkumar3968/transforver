//
//  vwSettingsPasswordController.h
//  NavTab
//
//  Created by sir 余 on 12/7/1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface vwSettingsPasswordController : UIViewController
{
    IBOutlet UITextField *uitxPassword;
}
@property (atomic, retain) UITextField *uitxPassword;

- (IBAction)resignTextField:(id)sender;
- (IBAction)cancelSetting:(id)sender;
- (IBAction)saveSetting:(id)sender;
@end
