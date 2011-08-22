//
//  Util.m
//  NavTab
//
//  Created by hank chen on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Util.h"


@implementation Util


+ (NSString*) getDocumentPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [paths objectAtIndex:0];
	return documentsPath;
}

+ (void) copyFile{
    NSString *documentsPath = [Util getDocumentPath];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:[documentsPath stringByAppendingPathComponent:@"Lion.caf"]]) {
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Lion.caf"];
		[fileManager copyItemAtPath:defaultDBPath 
							 toPath:[documentsPath stringByAppendingPathComponent:@"Lion.caf"] 
							  error:nil];
		//firstStart = YES;//only check UserData.sqlite
	}


}

@end
