//
//  vwSettingsEraseHist.m
//  VEMsg
//
//  Created by sir 余 on 12/6/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "vwSettingsEraseController.h"

@implementation vwSettingsEraseController

@synthesize uibtCancel;
@synthesize uibtSave;
@synthesize uibtOpt1;
@synthesize uibtOpt2;
@synthesize uibtOpt3;
@synthesize uibtOpt4;
@synthesize uibtOpt5;
@synthesize uibtOpt6;
@synthesize uibtOpt7;
@synthesize uibtOpt8;
@synthesize uiivChk1;
@synthesize uiivChk2;
@synthesize uiivChk3;
@synthesize uiivChk4;
@synthesize uiivChk5;
@synthesize uiivChk6;
@synthesize uiivChk7;
@synthesize uiivChk8;

- (void)disableAllChks
{
    uiivChk1.hidden=YES;
    uiivChk2.hidden=YES;
    uiivChk3.hidden=YES;
    uiivChk4.hidden=YES;
    uiivChk5.hidden=YES;
    uiivChk6.hidden=YES;
    uiivChk7.hidden=YES;
    uiivChk8.hidden=YES;
}

- (IBAction)cancelSetting:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)saveSetting:(id)sender
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:currentSelectOption forKey:ERASE_HISTORY_OPTION];
    [defaults synchronize];

    [self dismissViewControllerAnimated:YES completion:^(void){}];
}

- (IBAction)changeSelection:(id)sender
{
    UIImageView* uiivSender=(UIImageView*)sender;
    int selectedOpt = uiivSender.tag;
    currentSelectOption = selectedOpt;
    [self disableAllChks];
    NSLog(@"%d", selectedOpt);
    switch (selectedOpt) {
        case 1:
            uiivChk1.hidden=NO;
            break;
        case 2:
            uiivChk2.hidden=NO;
            break;
        case 3:
            uiivChk3.hidden=NO;
            break;
        case 4:
            uiivChk4.hidden=NO;
            break;
        case 5:
            uiivChk5.hidden=NO;
            break;
        case 6:
            uiivChk6.hidden=NO;
            break;
        case 7:
            uiivChk7.hidden=NO;
            break;
        case 8:
            uiivChk8.hidden=NO;
            break;
        default:
            break;
    }
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
    // 全cancel
    [self disableAllChks];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    currentSelectOption = [defaults integerForKey:ERASE_HISTORY_OPTION];

    if ( currentSelectOption == 0) { // do not save in standardUserDefaults
        currentSelectOption = 7; // default setting.
    }
    
    NSLog(@"Now Option: %d", currentSelectOption);

    switch (currentSelectOption) {
        case 1:
            uiivChk1.hidden=NO;
            break;
        case 2:
            uiivChk2.hidden=NO;
            break;
        case 3:
            uiivChk3.hidden=NO;
            break;
        case 4:
            uiivChk4.hidden=NO;
            break;
        case 5:
            uiivChk5.hidden=NO;
            break;
        case 6:
            uiivChk6.hidden=NO;
            break;
        case 7:
            uiivChk7.hidden=NO;
            break;
        case 8:
            uiivChk8.hidden=NO;
            break;
        default:
            break;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

@end
