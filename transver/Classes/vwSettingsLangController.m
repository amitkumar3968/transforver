//
//  vwSettingsEraseHist.m
//  VEMsg
//
//  Created by sir 余 on 12/6/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "vwSettingsLangController.h"
#import "Localization.h"

@implementation vwSettingsLangController {
    NSString* selectedLanguage_temp;
}

@synthesize uibtCancel;
@synthesize uibtSave;
@synthesize uibtChineseS;
@synthesize uibtChineseT;
@synthesize uibtEnglish;
@synthesize uibtItalian;
@synthesize uibtFrench;
@synthesize uibtJapanese;
@synthesize uibtKorean;
@synthesize uibtGerman;
@synthesize uiivChineseS;
@synthesize uiivChineseT;
@synthesize uiivEnglish;
@synthesize uiivItalian;
@synthesize uiivFrench;
@synthesize uiivJapanese;
@synthesize uiivKorean;
@synthesize uiivGerman;
@synthesize uibtLangCancel, uibtLangSave, uilbLangChSimp, uilbLangChTrad, uilbLangEng,uilbLangFrech, uilbLangGerman, uilbLangItalian, uilbLangJapansed, uilbLangKorean;

- (void)disableAllChks
{
    uiivChineseS.hidden=YES;
    uiivChineseT.hidden=YES;
    uiivEnglish.hidden=YES;
    uiivItalian.hidden=YES;
    uiivFrench.hidden=YES;
    uiivJapanese.hidden=YES;
    uiivKorean.hidden=YES;
    uiivGerman.hidden=YES;
}

- (IBAction)cancelSetting:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}

- (IBAction)saveSetting:(id)sender
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:selectedLanguage_temp forKey:SELECTED_LANGUAGE];
    [userDefault synchronize];
    
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}

- (void)activateCheckAtIdx:(int)index
{
    switch (index) {
        case 1:
            uiivChineseS.hidden=NO;
            selectedLanguage_temp = @"ChineseSimple";
            break;
        case 2:
            uiivChineseT.hidden=NO;
            selectedLanguage_temp = @"ChineseTraditional";
            break;
        case 3:
            uiivEnglish.hidden=NO;
            selectedLanguage_temp = @"English";
            break;
        case 4:
            uiivItalian.hidden=NO;
            selectedLanguage_temp = @"Italian";
            break;
        case 5:
            uiivFrench.hidden=NO;
            selectedLanguage_temp = @"French";
            break;
        case 6:
            uiivJapanese.hidden=NO;
            selectedLanguage_temp = @"Japanese";
            break;
        case 7:
            uiivKorean.hidden=NO;
            selectedLanguage_temp = @"Korean";
            break;
        case 8:
            uiivGerman.hidden=NO;
            selectedLanguage_temp = @"German";
            break;
        default:
            break;
    }
    
}
- (IBAction)changeSelection:(id)sender
{
    UIImageView* uiivSender=(UIImageView*)sender;
    [self disableAllChks];
    NSLog(@"%d", uiivSender.tag);
    [self activateCheckAtIdx:uiivSender.tag];    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self disableAllChks];
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    selectedLanguage_temp = [userDefaults stringForKey:SELECTED_LANGUAGE];
    if ( selectedLanguage_temp == nil) { // default value
        selectedLanguage_temp = @"English";
    }
    
    if ( [selectedLanguage_temp isEqualToString:@"ChineseSimple"]) {
        [self activateCheckAtIdx:1];
    } else if ( [selectedLanguage_temp isEqualToString:@"ChineseTraditional"] ) {
        [self activateCheckAtIdx:2];
    } else if ( [selectedLanguage_temp isEqualToString:@"English"] ) {
        [self activateCheckAtIdx:3];
    } else if ( [selectedLanguage_temp isEqualToString:@"Italian"] ) {
        [self activateCheckAtIdx:4];
    } else if ( [selectedLanguage_temp isEqualToString:@"French"] ) {
        [self activateCheckAtIdx:5];
    } else if ( [selectedLanguage_temp isEqualToString:@"Japanese"] ) {
        [self activateCheckAtIdx:6];
    } else if ( [selectedLanguage_temp isEqualToString:@"Korean"] ) {
        [self activateCheckAtIdx:7];
    } else if ( [selectedLanguage_temp isEqualToString:@"German"] ) {
        [self activateCheckAtIdx:8];
    } else { // default value
        [self activateCheckAtIdx:3];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    //localization appearance
    uibtLangCancel.titleLabel.text = LOC_TXT_BUTTON_CANCEL;
    uibtLangSave.titleLabel.text = LOC_TXT_BUTTON_SAVE;
    uilbLangChSimp.text = LOC_TXT_SETTING_LANG_CH_SIMP;
    uilbLangChTrad.text = LOC_TXT_SETTING_LANG_CH_TRAD;
    uilbLangEng.text = LOC_TXT_SETTING_LANG_ENG;
    uilbLangFrech.text = LOC_TXT_SETTING_LANG_FRENCH;
    uilbLangGerman.text = LOC_TXT_SETTING_LANG_GERMAN;
    uilbLangItalian.text = LOC_TXT_SETTING_LANG_ITALIAN;
    uilbLangJapansed.text = LOC_TXT_SETTING_LANG_JAPANESE;
    uilbLangKorean.text = LOC_TXT_SETTING_LANG_KOREA;
    
    [super viewWillAppear:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [selectedLanguage_temp release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
