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

@implementation vwSettingsController
@synthesize uibtEraseHist;

- (IBAction)setEraseHistPeriod:(id)sender
{
    CGRect rectEraseRect = CGRectMake(0, 0, 200,180);
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
    CGRect rectEraseRect = CGRectMake(0, 0, 200,180);
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
        self.tabBarItem.image = [UIImage imageNamed:@"settings.jpg"];
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
    // Do any additional setup after loading the view from its nib.
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

@end
