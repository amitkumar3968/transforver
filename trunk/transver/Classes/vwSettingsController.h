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
@property (nonatomic, retain) IBOutlet UILabel* uilbUsersNumber;
@property (nonatomic, retain) IBOutlet UIButton* uibtAuthentication;
@property (nonatomic, retain) IBOutlet UISwitch*uiswSaveVEMPassword;
@property (nonatomic, retain) IBOutlet UIButton* uibtEveryXMins;
@property (nonatomic, retain) IBOutlet UILabel* uilbFreeStorageSize;
@property (nonatomic, retain) IBOutlet UIButton* uibtLanguage;
@property (nonatomic, retain) IBOutlet UILabel* uilbLocTxtSettingTitle;
@property (nonatomic, retain) IBOutlet UILabel* uilbLocTxtSettingSyncContacts;
@property (nonatomic, retain) IBOutlet UILabel* uilbLocTxtSettingAuch;
@property (nonatomic, retain) IBOutlet UILabel* uilbLocTxtSettingSavePass;
@property (nonatomic, retain) IBOutlet UILabel* uilbLocTxtSettingEraseHist;
@property (nonatomic, retain) IBOutlet UILabel* uilbLocTxtSettingStorage;
@property (nonatomic, retain) IBOutlet UILabel* uilbLocTxtSettingLanguage;
@property (nonatomic, retain) IBOutlet UIButton* uibtClearAllHistory;

- (IBAction)cleaAllHistory:(id)sender;
- (IBAction)setEraseHistPeriod:(id)sender;
- (IBAction)changeVEMPasswordState:(id)sender;
@end
