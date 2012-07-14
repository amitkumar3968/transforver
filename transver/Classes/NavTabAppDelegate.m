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


@implementation NavTabAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize tabController;
@synthesize globalSettings;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	//navController = [[UINavigationController alloc] init];
	//TableViewController *tabView = [[TableViewController alloc] init];
	
	//[navController pushViewController:tabController animated:FALSE];
    [globalSettings initWithObjects:@"language" forKeys:1];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UIViewController *vcRecord, *vcContact, *vcHistory, *vcSettings, *vcAbout;
    
    vcContact = [[NavContactsViewController alloc] initWithNibName:@"NavContactsViewController" bundle:nil];
    vcRecord = [[vwRecordController alloc] initWithNibName:@"vwRecordController" bundle:nil]; 
    vcHistory = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];    
    vcSettings = [[vwSettingsController alloc] initWithNibName:@"vwSettingsController" bundle:nil];
    vcAbout = [[vwAboutController alloc] initWithNibName:@"vwAboutController" bundle:nil];
    
    self.tabController = [[UITabBarController alloc] init];
    self.tabController.viewControllers = [NSArray arrayWithObjects:   vcRecord, vcContact, vcHistory, vcSettings, vcAbout, nil];
    self.window.rootViewController = self.tabController;
    [self.window makeKeyAndVisible];
    return YES;
    tabController.selectedIndex = 0;
	[window addSubview:[tabController view]];

	// Configure and show the window
	//[window addSubview:[tabController view]];
	[window makeKeyAndVisible];
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

@end
