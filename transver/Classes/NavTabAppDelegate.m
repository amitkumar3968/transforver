//
//  NavTabAppDelegate.m
//  NavTab
//
//  Created by Robert Conn on 31/03/2009.
//  Copyright WiredBob Consulting 2009. All rights reserved.
//

#import "NavTabAppDelegate.h"
//#import "RootViewController.h"
#import "ChatViewController.h"
#import "vwRecordController.h"
#import "NavContactsViewController.h"
#import "vwSettingsController.h"
#import "vwAboutController.h"
#import "vwHistoryController.h"

@implementation NavTabAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize tabController;
@synthesize globalSettings, accounts;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	//navController = [[UINavigationController alloc] init];
	//TableViewController *tabView = [[TableViewController alloc] init];
	g_UserID = -1;
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	//self.tableView.rowHeight = 100;
	//self.tableView.backgroundColor = [UIColor clearColor];
    
    if([Util checkUserInfoExist])
    {
        [Util getParameter];
        g_UserID = [Util loginServer];
        NSArray *array = [Util fetchRelationships:g_UserID];
        g_AccountName = [array mutableCopy];
    }
    //g_UserID = 20;
    [Util getRelationships:g_UserID];
    
    //[navController pushViewController:tabController animated:FALSE];
    [globalSettings initWithObjects:[NSArray arrayWithObjects:@"language", nil] forKeys:[NSArray arrayWithObjects:@"1", nil]];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UIViewController *vcRecord, *vcContact, *vcHistory, *vcSettings, *vcAbout;
    
    vcContact = [[NavContactsViewController alloc] initWithNibName:@"NavContactsViewController" bundle:nil];
    vcRecord = [[vwRecordController alloc] initWithNibName:@"vwRecordController" bundle:nil]; 
    vcHistory = [[vwHistoryController alloc] initWithNibName:@"vwHistoryController" bundle:nil];    
    vcSettings = [[vwSettingsController alloc] initWithNibName:@"vwSettingsController" bundle:nil];
    vcAbout = [[vwAboutController alloc] initWithNibName:@"vwAboutController" bundle:nil];
    UINavigationController *hisNavCtlr = [[UINavigationController alloc] initWithRootViewController:vcHistory];
    self.tabController = [[UITabBarController alloc] init];
    //self.tabController.tabBar.selectedImageTintColor = [UIColor yellowColor];
    self.tabController.viewControllers = [NSArray arrayWithObjects:vcRecord, vcContact, hisNavCtlr, vcSettings, vcAbout, nil];
    self.window.rootViewController = self.tabController;
    g_tabController = self.tabController;
    [self.window makeKeyAndVisible];
    g_RootController = self.window.rootViewController;
    
    if([Util checkUserInfoExist]){
        tabController.selectedIndex = 0;
        [window addSubview:[tabController view]];
    }
    else {
        AddUserViewController *addUserView = [[AddUserViewController alloc] initWithNibName:@"AddUserViewController" bundle:nil];
        addUserView.title = @"Add Phone Number";
        addUserView.delegate = self;
        [self.window.rootViewController presentModalViewController:addUserView animated:NO];
    } 
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}
#pragma mark AddUserViewDelegate methods

- (void) savePhoneNumber:(NSString *)phonenumber nickName:(NSString *)name{
    NSLog(@"save phone: %@", phonenumber);
    if( g_UserID == -1)
    {
        g_UserName=name;
        g_UserNumber = phonenumber;
        [Util saveParameter];
        g_UserID = [Util loginServer];
        NSArray *array = [Util fetchRelationships:g_UserID];//[[NSArray alloc] initWithObjects:@"find friends",@"Jerry", @"Raymond", @"John", nil];
        g_AccountID = [array mutableCopy];
        //[array release];
    }else
    {
        //add user for contact list
        //[self addRelationships:m_userid phonenumber:phonenumber];
        //[self fetchRelationships:m_userid];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
