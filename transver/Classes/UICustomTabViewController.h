//
//  UICustomTabViewController.h
//  NavTab
//
//  Created by Robert Conn on 31/03/2009.
//  Copyright 2009 WiredBob Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICustomTabViewController : UIViewController <UITabBarDelegate> {
	NSArray *viewControllers;
	IBOutlet UITabBar *tabBar;
	IBOutlet UITabBarItem *favouritesTabBarItem;
	IBOutlet UITabBarItem *moreTabBarItem;
	IBOutlet UITabBarItem *recordingTabBarItem;
	UIViewController *selectedViewController;
    NSString* localFilePath;
    NSFileHandle* audioFile;
}

- (void) downloadToFile;

@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, retain) NSString *localFilePath;
@property (nonatomic, retain) NSFileHandle *audioFile;
@property (nonatomic, retain) IBOutlet UITabBar *tabBar;
@property (nonatomic, retain) IBOutlet UITabBarItem *favouritesTabBarItem;
@property (nonatomic, retain) IBOutlet UITabBarItem *moreTabBarItem;
@property (nonatomic, retain) IBOutlet UITabBarItem *recordingTabBarItem;
@property (nonatomic, retain) UIViewController *selectedViewController;

@end
