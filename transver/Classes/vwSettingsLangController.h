//
//  vwSettingsEraseHist.h
//  VEMsg
//
//  Created by sir 余 on 12/6/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface vwSettingsLangController : UIViewController
{
    NSDictionary* dicEraseHistChkions;
    IBOutlet UIButton* uibtCancel;
    IBOutlet UIButton* uibtSave;
    IBOutlet UIButton* uibtOpt1;
    IBOutlet UIButton* uibtOpt2;
    IBOutlet UIButton* uibtOpt3;
    IBOutlet UIButton* uibtOpt4;
    IBOutlet UIButton* uibtOpt5;
    IBOutlet UIButton* uibtOpt6;
    IBOutlet UIButton* uibtOpt7;
    IBOutlet UIButton* uibtOpt8;
    IBOutlet UIImageView* uiivChk1;
    IBOutlet UIImageView* uiivChk2;
    IBOutlet UIImageView* uiivChk3;
    IBOutlet UIImageView* uiivChk4;
    IBOutlet UIImageView* uiivChk5;
    IBOutlet UIImageView* uiivChk6;
    IBOutlet UIImageView* uiivChk7;
    IBOutlet UIImageView* uiivChk8;     
}
@property (nonatomic, retain) NSDictionary* dicEraseHistOptions;
@property (nonatomic, retain) UIButton* uibtCancel;
@property (nonatomic, retain) UIButton* uibtSave;
@property (nonatomic, retain) UIButton* uibtOpt1;
@property (nonatomic, retain) UIButton* uibtOpt2;
@property (nonatomic, retain) UIButton* uibtOpt3;
@property (nonatomic, retain) UIButton* uibtOpt4;
@property (nonatomic, retain) UIButton* uibtOpt5;
@property (nonatomic, retain) UIButton* uibtOpt6;
@property (nonatomic, retain) UIButton* uibtOpt7;
@property (nonatomic, retain) UIButton* uibtOpt8;
@property (nonatomic, retain) UIImageView* uiivChk1;
@property (nonatomic, retain) UIImageView* uiivChk2;
@property (nonatomic, retain) UIImageView* uiivChk3;
@property (nonatomic, retain) UIImageView* uiivChk4;
@property (nonatomic, retain) UIImageView* uiivChk5;
@property (nonatomic, retain) UIImageView* uiivChk6;
@property (nonatomic, retain) UIImageView* uiivChk7;
@property (nonatomic, retain) UIImageView* uiivChk8; 
- (IBAction)cancelSetting:(id)sender;
- (IBAction)saveSetting:(id)sender;
- (IBAction)changeSelection:(id)sender;
@end
