//
//  UICustomTabViewController.h
//  NavTab
//
//  Created by Robert Conn on 31/03/2009.
//  Copyright 2009 WiredBob Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h> 
#import "AudioRecorder.h"
#import "ChatBubbleView.h"
#import "Util.h"

@interface UICustomTabViewController : UIViewController <UITabBarDelegate, ChatBubbleViewDelegate> {
	NSArray *viewControllers;
	IBOutlet UITabBar *tabBar;
	IBOutlet UITabBarItem *favouritesTabBarItem;
	IBOutlet UITabBarItem *moreTabBarItem;
	IBOutlet UITabBarItem *recordingTabBarItem;
    
	UIViewController *selectedViewController;
    NSString* localFilePath;
    NSFileHandle* audioFile;
    AudioRecorder *audioRecorder;
}

- (void) uploadFile:(char*)filepath;

@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, retain) NSString *localFilePath;
@property (nonatomic, retain) NSFileHandle *audioFile;
@property (nonatomic, retain) IBOutlet ChatBubbleView *bubbleView;
@property (nonatomic, retain) IBOutlet UITabBar *tabBar;
@property (nonatomic, retain) IBOutlet UITabBarItem *favouritesTabBarItem;
@property (nonatomic, retain) IBOutlet UITabBarItem *moreTabBarItem;
@property (nonatomic, retain) IBOutlet UITabBarItem *recordingTabBarItem;
@property (nonatomic, retain) UIViewController *selectedViewController;
@property (nonatomic,retain)  AudioRecorder *audioRecorder;
@end
