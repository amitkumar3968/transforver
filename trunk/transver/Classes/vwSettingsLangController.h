//
//  vwSettingsEraseHist.h
//  VEMsg
//
//  Created by sir 余 on 12/6/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SELECTED_LANGUAGE @"vwSettingsLangController.selectedLanguage"

@interface vwSettingsLangController : UIViewController

@property (nonatomic, retain) IBOutlet UIButton* uibtCancel;
@property (nonatomic, retain) IBOutlet UIButton* uibtSave;

@property (nonatomic, retain) IBOutlet UIButton* uibtChineseS;
@property (nonatomic, retain) IBOutlet UIButton* uibtChineseT;
@property (nonatomic, retain) IBOutlet UIButton* uibtEnglish;
@property (nonatomic, retain) IBOutlet UIButton* uibtItalian;
@property (nonatomic, retain) IBOutlet UIButton* uibtFrench;
@property (nonatomic, retain) IBOutlet UIButton* uibtJapanese;
@property (nonatomic, retain) IBOutlet UIButton* uibtKorean;
@property (nonatomic, retain) IBOutlet UIButton* uibtGerman;
@property (nonatomic, retain) IBOutlet UIImageView* uiivChineseS;
@property (nonatomic, retain) IBOutlet UIImageView* uiivChineseT;
@property (nonatomic, retain) IBOutlet UIImageView* uiivEnglish;
@property (nonatomic, retain) IBOutlet UIImageView* uiivItalian;
@property (nonatomic, retain) IBOutlet UIImageView* uiivFrench;
@property (nonatomic, retain) IBOutlet UIImageView* uiivJapanese;
@property (nonatomic, retain) IBOutlet UIImageView* uiivKorean;
@property (nonatomic, retain) IBOutlet UIImageView* uiivGerman;
- (IBAction)cancelSetting:(id)sender;
- (IBAction)saveSetting:(id)sender;
- (IBAction)changeSelection:(id)sender;
@end
