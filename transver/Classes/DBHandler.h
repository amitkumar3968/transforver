//
//  SBHandler.h
//  NavTab
//
//  Created by hank chen on 8/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SBHandler : NSObject {
    
}

+(UIImage*)downloadImageFromUrl:(NSString*)urlString;
+(NSData*)sendReqForUrl:(NSString*)urlString body:(NSData*)body;
+(NSData*)uploadImageToUrl:(NSString*)urlString body:(NSData*)body 
				  boundary:(NSString*)boundary;
+(void)loadUrl:(NSString*)urlStr webView:(UIWebView*)webView;
+(NSData*)sendReqForUrl:(NSString*)urlString postString:(NSString*)postString;

@end
