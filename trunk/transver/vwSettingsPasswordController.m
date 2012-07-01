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

@synthesize uitxPassword;
- (IBAction)cancelSetting:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)saveSetting:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)resignTextField:(id)sender
{
    [uitxPassword setText:@"**********"];
    [self resignFirstResponder];
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
	// Do any additional setup after loading the view.
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
