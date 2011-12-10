//
//  NavTabAppDelegate.m
//  NavTab
//
//  Created by Robert Conn on 31/03/2009.
//  Copyright WiredBob Consulting 2009. All rights reserved.
//

#import "NavTabAppDelegate.h"
//#import "RootViewController.h"


@implementation NavTabAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize tabController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	//navController = [[UINavigationController alloc] init];
	//TableViewController *tabView = [[TableViewController alloc] init];
	
	//[navController pushViewController:tabController animated:FALSE];
	
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
