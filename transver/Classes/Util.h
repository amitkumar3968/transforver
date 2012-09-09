//
//  Util.h
//  NavTab
//
//  Created by hank chen on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBHandler.h"
#import "JSON.h"

NSString *g_PhoneNumber;
NSString *g_UserName;
NSMutableArray *g_AccountID;
NSMutableArray *g_AccountName;
int g_UserID;
int destID;
UITabBarController *g_tabController;
UIViewController *g_RootController;
@interface Util : NSObject {
    
}

+ (NSString*) getDocumentPath;
+ (void) copyFile;
+ (void) copyFileWithFilename:(NSString *) fileName;
+ (void) removeFile:(NSString*)filename;

#pragma mark server utilitydelUserInfo
+ (int)  loginServer;
+ (void) uploadFile;
+ (NSArray*) fetchRelationships:(int) m_userid;
+ (NSArray*) fetchHistory:(int) m_userid;

+ (void) getParameter;
+ (void) saveParameter;
+ (bool) checkUserInfoExist;
+ (void) delUserInfo;
+ (void) addRelationships:(int) uid phonenumber:(NSString *) phone;
+ (void) getRelationships:(int) uid;
+ (void) delMessages:(int) dialod_id;
@end

@interface NSURLRequest (DummyInterface)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
@end
