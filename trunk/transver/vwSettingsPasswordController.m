//
//  vwSettingsPasswordController.m
//  NavTab
//
//  Created by sir 余 on 12/7/1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "vwSettingsPasswordController.h"
#import "Localization.h"
#import "Util.h"

@interface vwSettingsPasswordController ()

@end

@implementation vwSettingsPasswordController
@synthesize uiswProgramPassword;
@synthesize uitxPassword;
@synthesize uilbPassword;
@synthesize uilbProgramAuth;
@synthesize uibtCancel, uibtSave;

- (IBAction)cancelSetting:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}

- (IBAction)saveSetting:(id)sender
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:uiswProgramPassword.on forKey:PROGRAM_PASSWORD];
    [defaults setObject:uitxPassword.text forKey:PASSWORD];
    [defaults synchronize];
    
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}

- (IBAction)resignTextField:(id)sender
{
//    [uitxPassword setText:@"**********"];
//    [self resignFirstResponder];
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
    
	// Load setting and set on view.
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [uiswProgramPassword setOn:[defaults boolForKey:PROGRAM_PASSWORD]];
    [uitxPassword setText:[defaults objectForKey:PASSWORD]];
}

- (void)viewWillAppear:(BOOL)animated
{
    //localize appearance
    uibtCancel.titleLabel.text = LOC_TXT_BUTTON_CANCEL;
    uibtSave.titleLabel.text = LOC_TXT_BUTTON_SAVE;
    uilbProgramAuth.text = LOC_TXT_SETTING_AUTH_PASS_SWITCH; // uilbProgramAuth;
    uilbPassword.text = LOC_TXT_SETTING_AUTH_PASS; //uilbPassword;
    [super viewWillAppear:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

-(void)presentKB:(id)sender
{
    if (uiswProgramPassword.on)
    {
        [uitxPassword becomeFirstResponder];
    }else
    {
        //do nothing
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
