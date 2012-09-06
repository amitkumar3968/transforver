//
//  vwSettingsPasswordController.m
//  NavTab
//
//  Created by sir 余 on 12/7/1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "vwSettingsPasswordController.h"

@interface vwSettingsPasswordController ()

@end

@implementation vwSettingsPasswordController
@synthesize uiswProgramPassword;
@synthesize uitxPassword;

- (IBAction)cancelSetting:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)saveSetting:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    
    // save setting.
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:uiswProgramPassword.isOn forKey:PROGRAM_PASSWORD];
    [defaults setObject:uitxPassword.text forKey:PASSWORD];
    [defaults synchronize];
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
