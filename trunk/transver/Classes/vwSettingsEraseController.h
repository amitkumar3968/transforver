//
//  vwSettingsEraseHist.h
//  VEMsg
//
//  Created by sir 余 on 12/6/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

// TODO load this integer value when application build.
#define ERASE_HISTORY_OPTION @"vwSettingsEraseController.eraseHistoryOption"

@interface vwSettingsEraseController : UIViewController
{
    int currentSelectOption;
}

@property (nonatomic, retain) IBOutlet UIButton* uibtCancel;
@property (nonatomic, retain) IBOutlet UIButton* uibtSave;
@property (nonatomic, retain) IBOutlet UIButton* uibtOpt1;
@property (nonatomic, retain) IBOutlet UIButton* uibtOpt2;
@property (nonatomic, retain) IBOutlet UIButton* uibtOpt3;
@property (nonatomic, retain) IBOutlet UIButton* uibtOpt4;
@property (nonatomic, retain) IBOutlet UIButton* uibtOpt5;
@property (nonatomic, retain) IBOutlet UIButton* uibtOpt6;
@property (nonatomic, retain) IBOutlet UIButton* uibtOpt7;
@property (nonatomic, retain) IBOutlet UIButton* uibtOpt8;
@property (nonatomic, retain) IBOutlet UIImageView* uiivChk1;
@property (nonatomic, retain) IBOutlet UIImageView* uiivChk2;
@property (nonatomic, retain) IBOutlet UIImageView* uiivChk3;
@property (nonatomic, retain) IBOutlet UIImageView* uiivChk4;
@property (nonatomic, retain) IBOutlet UIImageView* uiivChk5;
@property (nonatomic, retain) IBOutlet UIImageView* uiivChk6;
@property (nonatomic, retain) IBOutlet UIImageView* uiivChk7;
@property (nonatomic, retain) IBOutlet UIImageView* uiivChk8; 
- (IBAction)cancelSetting:(id)sender;
- (IBAction)saveSetting:(id)sender;
- (IBAction)changeSelection:(id)sender;
@end
