//
//  vwSettingsController.h
//  VEMsg
//
//  Created by sir 余 on 12/5/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SAVE_VEM_PASSWORD @"vwSettingsController.saveVEMPassword"

@interface vwSettingsController : UIViewController
@property (nonatomic, retain) IBOutlet UILabel* uilbAuthentication;
@property (nonatomic, retain) IBOutlet UISwitch*uiswSaveVEMPassword;
@property (nonatomic, retain) IBOutlet UILabel* uilbEveryXMins;
@property (nonatomic, retain) IBOutlet UILabel* uilbFreeStorageSize;
@property (nonatomic, retain) IBOutlet UILabel* uilbLanguage;

- (IBAction)setEraseHistPeriod:(id)sender;
- (IBAction)changeVEMPasswordState:(id)sender;
@end
