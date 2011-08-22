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

@interface RootViewController : UITableViewController {
	NSArray *accounts;
	UICustomTabViewController *tabViewController;
}

- (void) showMenu:(id) sender;
- (void) buttonPushed:(id)sender;
- (void) loginServer;
- (void) playSound;
- (void) uploadFile;
- (NSArray*) fetchRelationships;

@property (nonatomic, retain) NSArray *accounts;
@property (nonatomic, retain) UICustomTabViewController *tabViewController;

@end
