//
//  vwSettingsController.m
//  VEMsg
//
//  Created by sir 余 on 12/5/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "vwSettingsController.h"
#import "vwSettingsEraseController.h"
#import "vwSettingsLangController.h"
#import "vwSettingsPasswordController.h"

@implementation vwSettingsController;
@synthesize uilbAuthentication;
@synthesize uiswSaveVEMPassword;
@synthesize uilbEveryXMins;
@synthesize uilbLanguage;

- (IBAction)setEraseHistPeriod:(id)sender
{
//    CGRect rectEraseRect = CGRectMake(0, 0, 200,180);
    vwSettingsEraseController *eraseView = [[vwSettingsEraseController alloc] initWithNibName:@"vwSettingsEraseController" bundle:[NSBundle mainBundle]];
    [self presentModalViewController:eraseView animated:NO];
    /*eraseView.uitvEraseHistPeriod.delegate=self;
     eraseView.view.frame=rectEraseRect;
     [eraseView.view setBackgroundColor:[UIColor clearColor]];
     eraseView.view.autoresizingMask=UIViewAutoresizingFlexibleHeight;
     [self.view.window addSubview:eraseView.view];*/
}

- (IBAction)setLang:(id)sender
{
//    CGRect rectEraseRect = CGRectMake(0, 0, 200,180);
    vwSettingsLangController *langView = [[vwSettingsLangController alloc] initWithNibName:@"vwSettingsLangController" bundle:[NSBundle mainBundle]];
    [self presentModalViewController:langView animated:NO];
    /*eraseView.uitvEraseHistPeriod.delegate=self;
     eraseView.view.frame=rectEraseRect;
     [eraseView.view setBackgroundColor:[UIColor clearColor]];
     eraseView.view.autoresizingMask=UIViewAutoresizingFlexibleHeight;
     [self.view.window addSubview:eraseView.view];*/
}

- (IBAction)setPassword:(id)sender
{
    //CGRect rectPasswordRect = CGRectMake(0, 0, 200,180);
    vwSettingsPasswordController *passwordView = [[vwSettingsPasswordController alloc] initWithNibName:@"vwSettingsPasswordController" bundle:[NSBundle mainBundle]];
    [self presentModalViewController:passwordView animated:NO];
    /*eraseView.uitvEraseHistPeriod.delegate=self;
     eraseView.view.frame=rectEraseRect;
     [eraseView.view setBackgroundColor:[UIColor clearColor]];
     eraseView.view.autoresizingMask=UIViewAutoresizingFlexibleHeight;
     [self.view.window addSubview:eraseView.view];*/
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Settings", @"Settings");
        self.tabBarItem.image = [UIImage imageNamed:@"common_icon_set_rest.png"];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view exchangeSubviewAtIndex:1 withSubviewAtIndex:0];  //make the title label on top of the head bar
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) viewWillAppear:(BOOL)animated
{
    // Do any additional setup after loading the view from its nib.
    
    // Load Setting and Show in View
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    // Load Authentication Setting
    [uilbAuthentication setText:[userDefaults boolForKey:PROGRAM_PASSWORD]? @"Enable"
                         : @"Disable"];
    
    // Load Save VEM Password
    [uiswSaveVEMPassword setOn:[userDefaults boolForKey:SAVE_VEM_PASSWORD]];
    
    // Load Erase Setting
    int option = [userDefaults integerForKey:ERASE_HISTORY_OPTION];
    NSString* everyXMinsString;
    switch (option) {
        case 0:// use default value
            everyXMinsString = @"Every 5 mins";
            break;
        case 1:
            everyXMinsString = @"Never";
            break;
        case 2:
            everyXMinsString = @"Every 3 months";
            break;
        case 3:
            everyXMinsString = @"Every month";
            break;
        case 4:
            everyXMinsString = @"Every week";
            break;
        case 5:
            everyXMinsString = @"Every day";
            break;
        case 6:
            everyXMinsString = @"Every hour";
            break;
        case 7:
            everyXMinsString = @"Every 5 mins";
            break;
        case 8:
            everyXMinsString = @"Every time";
            break;
    }
    [uilbEveryXMins setText:everyXMinsString];
    
    // Load Language Setting
    NSString* language_temp = [userDefaults objectForKey:SELECTED_LANGUAGE];
    if ( language_temp == nil ) { // default value
        language_temp = @"English";
    } else if ( [language_temp isEqualToString:@"ChineseTraditional"] ) { // fix text to show
        language_temp = @"Chinsese Trad";
    } else if ( [language_temp isEqualToString:@"ChineseSimple"] ) { // fix text to show
        language_temp = @"Chinese Simp";
    }
    [uilbLanguage setText:language_temp];
}

- (IBAction)changeVEMPasswordState:(id)sender
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL ifSaveVEMPassword = uiswSaveVEMPassword.isOn;
    
    if ( ifSaveVEMPassword ) {
        // TODO do something when save VEM Password be click
    } else {
        // TODO do something when save VEM Password be cancel
    }
    
    [userDefaults setBool:ifSaveVEMPassword forKey:SAVE_VEM_PASSWORD];
    
    [userDefaults synchronize];
}

@end
