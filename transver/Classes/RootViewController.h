//
//  RootViewController.h
//  NavTab
//
//  Created by Robert Conn on 31/03/2009.
//  Copyright WiredBob Consulting 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddUserViewController.h"
#import "UICustomTabViewController.h"
#import "ChatBubbleView.h"
#import "AudioRecorder.h"
#import "Util.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

@interface RootViewController : UITableViewController <AddUserViewDelegate>{
	NSArray *accounts;
    NSString *m_PhoneNumber;
    NSString *m_UserName;
	UICustomTabViewController *tabViewController;
	AudioRecorder *audioRecorder;
    NSMutableArray *m_AccountID;
    int m_userid;
	int m_ShowMenu;
}

- (void) showMenu:(id) sender;
- (void) buttonPushed:(id)sender;
- (int) loginServer;
- (void) playSound;
- (void) uploadFile;
- (NSArray*) fetchRelationships:(int) m_userid;
- (void)MenuSetting:(id)sender;

- (void) getParameter;
- (void) saveParameter;
- (bool) checkUserInfoExist;
- (void) delUserInfo;
- (void) AddUserMenu:(id) sender;
- (void
   ) addRelationships:(int) uid phonenumber:(NSString *) phone;

@property (nonatomic, retain) NSMutableArray *m_AccountID;
@property (nonatomic, retain) NSArray *accounts;
@property (nonatomic, retain) NSString *m_PhoneNumber;
@property (nonatomic, retain) NSString *m_UserName;
@property (nonatomic, retain) UICustomTabViewController *tabViewController;
@property (nonatomic, retain) AudioRecorder *audioRecorder;
@property (nonatomic, assign) int m_userid;
@property (nonatomic, assign) int m_ShowMenu;


@end

@interface NSURLRequest (DummyInterface)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
@end
