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


#define PROGRAM_PASSWORD @"vwSettingsPasswordController.programPassword"
#define PASSWORD @"vwSettingsPasswordController.password"


NSString *g_UserNumber;
NSString *g_UserName;
NSMutableArray *g_AccountPhone;
NSMutableArray *g_AccountID;
NSMutableArray *g_AccountName;
NSMutableDictionary *g_CountryCodeMap;

int g_UserID;
int destID;
UITabBarController *g_tabController;
UIViewController *g_RootController;
NSUserDefaults *g_Settings;


@interface Util : NSObject {
    
}
+ (void)showAlertView:(NSString *) msg;
+ (void)dissmissAlertView;
+ (NSString*) getDocumentPath;
+ (void) copyFile;
+ (void) copyFileWithFilename:(NSString *) fileName;
+ (void) removeFile:(NSString*)filename;

#pragma mark server utilitydelUserInfo
+ (int)  loginServer;
+ (void) uploadFile;
+ (NSArray*) fetchRelationships:(int) m_userid;
+ (NSArray*) fetchHistory:(int) m_userid;

+ (NSString*) getCountryCode;
+ (void) getParameter;
+ (void) saveParameter;
+ (bool) checkUserInfoExist;
+ (void) delUserInfo;
+ (void) addRelationships:(int) uid phonenumber:(NSString *) phone;
+ (void) getRelationships:(int) uid;
+ (void) delMessages:(int) dialod_id;
+ (void) getSetting;
+ (void) eraseHistory;
+ (void) clearHistory:(int)delete_mode;
+ (void) checkEraseHistory;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
@end

@interface NSURLRequest (DummyInterface)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
@end
