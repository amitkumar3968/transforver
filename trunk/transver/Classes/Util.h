//
//  Util.h
//  NavTab
//
//  Created by hank chen on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Util : NSObject {
    
}

+ (NSString*) getDocumentPath;
+ (void) copyFile;
+ (void) copyFileWithFilename:(NSString *) fileName;
+ (void) removeFile:(NSString*)filename;
@end
