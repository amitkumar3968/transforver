//
//  NavTabAppDelegate.h
//  NavTab
//
//  Created by Robert Conn on 31/03/2009.
//  Copyright WiredBob Consulting 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
    static NSDictionary *globalSettings;

@interface NavTabAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
    UINavigationController *navController;
    UITabBarController *tabController;
}
@property (nonatomic, retain) NSDictionary *globalSettings;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UITabBarController *tabController;
@end

