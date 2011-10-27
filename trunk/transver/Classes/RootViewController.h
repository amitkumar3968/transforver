//
//  RootViewController.h
//  NavTab
//
//  Created by Robert Conn on 31/03/2009.
//  Copyright WiredBob Consulting 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICustomTabViewController.h"
#import "ChatBubbleView.h"
#import "AudioRecorder.h"
#import "Util.h"

@interface RootViewController : UITableViewController {
	NSArray *accounts;
	UICustomTabViewController *tabViewController;
	AudioRecorder *audioRecorder;
    int m_userid;
	
}

- (void) showMenu:(id) sender;
- (void) buttonPushed:(id)sender;
- (int) loginServer;
- (void) playSound;
- (void) uploadFile;
- (NSArray*) fetchRelationships:(int) m_userid;

@property (nonatomic, retain) NSArray *accounts;
@property (nonatomic, retain) UICustomTabViewController *tabViewController;
@property (nonatomic, retain) AudioRecorder *audioRecorder;
@property (nonatomic, assign) int m_userid;



@end
