//
//  Util.m
//  NavTab
//
//  Created by hank chen on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Util.h"
#import "Reachability.h"

@implementation Util


+ (NSString*) getDocumentPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [paths objectAtIndex:0];
	return documentsPath;
}

+ (void) removeFile:(NSString*)filename {
	NSString *documentPath = [Util getDocumentPath];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:[documentPath stringByAppendingPathComponent:filename]]) {
		[fileManager removeItemAtPath:[documentPath stringByAppendingPathComponent:filename] error:nil];
	}
}

+ (void) copyFile{
    NSString *documentsPath = [Util getDocumentPath];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:[documentsPath stringByAppendingPathComponent:@"Lion.aif"]]) {
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Lion.aif"];
		[fileManager copyItemAtPath:defaultDBPath 
							 toPath:[documentsPath stringByAppendingPathComponent:@"Lion.aif"] 
							  error:nil];
		//firstStart = YES;//only check UserData.sqlite
	}


}

+ (bool) checkNetConn {
	
	Reachability *reachAbility = [Reachability reachabilityWithHostName: @"www.apple.com"];
	bool reach = [reachAbility currentReachabilityStatus];
	
	NSLog(@"checkNetConn, status:%d", reach);
	
	return reach;
}

@end
