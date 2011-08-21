//
//  DBHandler.m
//  NavTab
//
//  Created by hank chen on 8/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DBHandler.h"
#import "JSON.h"


@implementation DBHandler


+(void)loadUrl:(NSString*)urlStr webView:(UIWebView*)webView
{
    NSURL *url = [[NSURL alloc] initWithString:urlStr];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    [url release];
    [webView loadRequest:req];
    [req release];
}

+(UIImage*)downloadImageFromUrl:(NSString*)urlString
{
	NSURL *url = [NSURL URLWithString:urlString];
	NSData *data = [[NSData alloc]
					initWithContentsOfURL:url];
	UIImage *image = [UIImage imageWithData:data];
	[data release];
	return image;
}

+(NSData*)uploadImageToUrl:(NSString*)urlString body:(NSData*)body 
				  boundary:(NSString*)boundary
{
	NSURL *url = [NSURL URLWithString:urlString];
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url  
															  cachePolicy:NSURLRequestReturnCacheDataElseLoad
														  timeoutInterval:30];
	if(body == nil)
    {
		[urlRequest setHTTPMethod: @"GET" ];
    }
	else
    {
		[urlRequest setHTTPMethod: @"POST" ];
		[urlRequest setHTTPBody:body];
		
		
    }
	
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",
							 boundary];
	[urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	NSURLResponse *urlResponse = nil;
	NSError *error = nil;
	NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest
												 returningResponse:&urlResponse
															 error:&error];
	NSLog(@"%s", [responseData bytes]);
	//NSLog(@"%p", error);
	//NSString *responseString = [[NSString alloc] initWithData:responseData
	//										encoding:NSUTF8StringEncoding];
	//NSLog(@"%@", responseString);
	return [responseData copy];
}

+(NSData*)sendReqForUrl:(NSString*)urlString postString:(NSString*)postString
{	
	NSURL *url = [NSURL URLWithString:urlString];
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url  
															  cachePolicy:NSURLRequestReloadIgnoringCacheData
														  timeoutInterval:30];
	if(postString == nil)
    {
		[urlRequest setHTTPMethod: @"GET" ];
    }
	else
    {
		NSData *body = [postString dataUsingEncoding:NSUTF8StringEncoding];
		[urlRequest setHTTPMethod: @"POST" ];
		[urlRequest setHTTPBody:body];
		
		
    }
	
	NSURLResponse *urlResponse = nil;
	NSError *error = nil;
	NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest
												 returningResponse:&urlResponse
															 error:&error];
	//NSLog(@"%s", [responseData bytes]);
    
	return responseData;
}

+(NSData*)sendReqForUrl:(NSString*)urlString body:(NSData*)body
{	
	NSURL *url = [NSURL URLWithString:urlString];
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url  
															  cachePolicy:NSURLRequestReturnCacheDataElseLoad
														  timeoutInterval:30];
	if(body == nil)
    {
		[urlRequest setHTTPMethod: @"GET" ];
    }
	else
    {
		[urlRequest setHTTPMethod: @"POST" ];
		[urlRequest setHTTPBody:body];
		
		
    }
	
	NSURLResponse *urlResponse = nil;
	NSError *error = nil;
	NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest
												 returningResponse:&urlResponse
															 error:&error];
	//NSLog(@"%s", [responseData bytes]);
	//NSLog(@"%p", error);
	//NSString *responseString = [[NSString alloc] initWithData:responseData
	//										encoding:NSUTF8StringEncoding];
	//NSLog(@"%@", responseString);
	//return [responseData copy];
	return responseData;
}

@end
