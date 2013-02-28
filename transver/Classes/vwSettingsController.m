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
#import "Util.h"
#import "Localization.h"

@implementation vwSettingsController;
@synthesize uilbUsersNumber;
@synthesize uibtAuthentication;
@synthesize uiswSaveVEMPassword;
@synthesize uibtEveryXMins;
@synthesize uilbFreeStorageSize;
@synthesize uibtLanguage;
@synthesize uibtClearAllHistory, uilbLocTxtSettingAuch, uilbLocTxtSettingEraseHist, uilbLocTxtSettingLanguage, uilbLocTxtSettingSavePass, uilbLocTxtSettingStorage, uilbLocTxtSettingSyncContacts, uilbLocTxtSettingTitle;

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
    NSLog(@" %d VEM Users.", [g_AccountName count]);
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
    
    //localization appearance
    uilbLocTxtSettingSyncContacts.text = LOC_TXT_SETTING_SYNC_CONTACTS;
    uilbLocTxtSettingTitle.text =  LOC_TXT_SETTING_TITLE;
    uilbLocTxtSettingAuch.text =  LOC_TXT_SETTING_AUTH;
    uilbLocTxtSettingSavePass.text = LOC_TXT_SETTING_SAVE_PASS;
    uilbLocTxtSettingEraseHist.text = LOC_TXT_SETTING_ERASE_HIST;
    uilbLocTxtSettingStorage.text = LOC_TXT_SETTING_STORAGE;
    uilbLocTxtSettingLanguage.text = LOC_TXT_SETTING_LANG;
    uibtClearAllHistory.titleLabel.text = LOC_TXT_SETTING_CLEAR_ALL_HIST;
    
    // Load User Number of Contact
    [uilbUsersNumber setText:[NSString stringWithFormat:@"%d Users",[g_AccountID count]]];
    
    // Load Setting and Show in View
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    // Load Authentication Setting
    [uibtAuthentication setTitle:[userDefaults boolForKey:PROGRAM_PASSWORD]? @"Enable":@"Disable" forState:UIControlStateNormal];
    
    // Load Save VEM Password
    [uiswSaveVEMPassword setOn:[userDefaults boolForKey:SAVE_VEM_PASSWORD]];
    
    // Load Erase Setting
    int option = [userDefaults integerForKey:ERASE_HISTORY_OPTION];
    NSString* everyXMinsString;
    switch (option) {
        case 0: // Never set, set to default
            everyXMinsString = @"Never";
            break;
        case 1: // Default
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
    [uibtEveryXMins setTitle:everyXMinsString forState:UIControlStateNormal];
    
    // Load(get) space used
    [uilbFreeStorageSize setText: [self getMPSize:[self folderSize]]];
//    NSError* error = [[NSError alloc] init];
//    NSDictionary* dic = [NSFileManager attributesOfItemAtPath:@"/" error:error];
//    NSString* size = [dic objectForKey:@"fileSize"];
//    [uilbFreeStorageSize setText:size];
    
    
    // Load Language Setting
    NSString* language_temp = [userDefaults objectForKey:SELECTED_LANGUAGE];
    if ( language_temp == nil ) { // default value
        language_temp = @"English";
    } else if ( [language_temp isEqualToString:@"ChineseTraditional"] ) { // fix text to show
        language_temp = @"Chinsese Trad";
    } else if ( [language_temp isEqualToString:@"ChineseSimple"] ) { // fix text to show
        language_temp = @"Chinese Simp";
    }
    [uibtLanguage setTitle:language_temp forState:UIControlStateNormal];
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

-(uint64_t)getFreeDiskspace {
    uint64_t totalSpace = 0.0f;
    uint64_t totalFreeSpace = 0.0f;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes floatValue];
        totalFreeSpace = [freeFileSystemSizeInBytes floatValue];
        NSLog(@"Memory Capacity of %llu MiB with %llu MiB Free memory available.", ((totalSpace/1024ll)/1024ll), ((totalFreeSpace/1024ll)/1024ll));
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %d", [error domain], [error code]);
    }  
    
    return totalFreeSpace;
}

- (unsigned long long int)folderSize {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *folderPath = [paths objectAtIndex:0];
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    unsigned long long int fileSize = 0;
    
    while (fileName = [filesEnumerator nextObject]) {
        NSDictionary *fileDictionary = [[NSFileManager defaultManager] fileAttributesAtPath:[folderPath stringByAppendingPathComponent:fileName] traverseLink:YES];
        fileSize += [fileDictionary fileSize];
    }
    
    return fileSize;
}

-(NSString *)getMPSize:(int) size_t
{
    double d_size = size_t;
    if ( d_size < 1024 ) {
        return [NSString stringWithFormat:@"0 KB"];
    }
    
    d_size /= 1024;
    if ( d_size <1024 ) {
        return [NSString stringWithFormat:@"%.2f KB", d_size];
    }
    
    d_size /= 1024;
    if ( d_size <1024 ) {
        return [NSString stringWithFormat:@"%.2f MB", d_size];
    }
    
    d_size /= 1024;
    if ( d_size < 1024 ) {
        return [NSString stringWithFormat:@"%.2f GB", d_size];
    }
    
    d_size /= 1024;
    if ( d_size < 1024 ) {
        return [NSString stringWithFormat:@"%.2f TB", d_size];
    }
    
    return [NSString stringWithFormat:@"Error"];
}

- (IBAction)cleaAllHistory:(id)sender {
    // TODO clean all voice recorder history
    UIAlertView *cleanAllHistAlert = [[UIAlertView alloc] initWithTitle:@"Clean All Messages" message:@"Clean All Message?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    
    // Remove all audio file in document folder
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileMgr = [[[NSFileManager alloc] init] autorelease];
    NSError *error = nil;
    NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (error == nil) {
        for (NSString *path in directoryContents) {
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:path];
            
            // Delete caf files only
            NSRange range = [fullPath rangeOfString:@"caf"];
            if (range.location != NSNotFound)
            {
                BOOL removeSuccess = [fileMgr removeItemAtPath:fullPath error:&error];
                if (!removeSuccess) {
                    // Error handling
                    NSLog(@"file %@ was not deleted!", fullPath);
                }
            }
        }
    } else {
        // Error handling
        NSLog(@"Error when retrieving list of files in document folder!");
    }
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        //do nothing
    }
    [Util eraseHistory];
}
@end
