//
//  Util.m
//  NavTab
//
//  Created by hank chen on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Util.h"
//#import "Reachability.h"

@implementation Util


+ (void) initSetting {
    g_PhoneNumber = [[NSString alloc] init];
    g_AccountID = [[NSMutableArray alloc] init];
    g_AccountName = [[NSMutableArray alloc] init];
}

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

+ (void) copyFileWithFilename:(NSString *) fileName{
    NSString *documentsPath = [Util getDocumentPath];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:[documentsPath stringByAppendingPathComponent:fileName]]) {
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
		[fileManager copyItemAtPath:defaultDBPath 
							 toPath:[documentsPath stringByAppendingPathComponent:fileName] 
							  error:nil];
		//firstStart = YES;//only check UserData.sqlite
	}
	
	
}

+ (bool) checkNetConn {
	
	//Reachability *reachAbility = [Reachability reachabilityWithHostName: @"www.apple.com"];
    
    //Ray To be fixed
	bool reach;// = [reachAbility currentReachabilityStatus];
	
	NSLog(@"checkNetConn, status:%d", reach);
	
	return reach;
}

+ (void) addRelationships:(int) uid phonenumber:(NSString *) phone{
    NSString *urlString = [NSString stringWithFormat:@"http://www.entalkie.url.tw/addRelationships.php?srcID=%d&dstPhone=%@", uid, phone];
    
    NSData *data = [DBHandler sendReqToUrl:urlString postString:nil];
	NSArray *array = nil;
    //NSMutableArray *ret = [[NSMutableArray alloc] init ];
	
	if(data)
	{
		NSString *responseString = [[NSString alloc] initWithData:data
                                                         encoding:NSUTF8StringEncoding];
		array = [responseString JSONValue];
		[responseString release];
	}
    
}

+ (NSArray*) fetchRelationships:(int) uid {
    NSString *urlString = [NSString stringWithFormat:@"http://www.entalkie.url.tw/getRelationships.php?masterID=%d", uid];
    //NSString *urlString = @"http://www.entalkie.url.tw/getRelationships.php?masterID=1";
    NSData *data = [DBHandler sendReqToUrl:urlString postString:nil];
	NSArray *array = nil;
    NSMutableArray *ret = [[NSMutableArray alloc] init ];
	
	if(data)
	{
		NSString *responseString = [[NSString alloc] initWithData:data
                                                         encoding:NSUTF8StringEncoding];
		array = [responseString JSONValue];
		[responseString release];
	}
    //[ret addObject:@"get friends"];
    for (NSDictionary *dic in array) {
        if( [dic objectForKey:@"USER_NAME"] == [NSNull null])
            [ret addObject: @"NO NAME"];
        else
            [ret addObject: [dic objectForKey:@"USER_NAME"]];
        NSLog(@"slave id:%@",[dic objectForKey:@"RELATION_SLAVEID"]);
        if( g_AccountID == nil)
            g_AccountID = [[NSMutableArray alloc] init];
        [g_AccountID addObject: [dic objectForKey:@"RELATION_SLAVEID"]];
    }
    //[ret addObject:nil];
    NSArray *retArr = [[NSArray alloc ]initWithArray:ret];
    [ret release];
    //NSLog(@"1:%d",[retArr retainCount]);
    [retArr autorelease];
    //NSLog(@"2:%d",[retArr retainCount]);
	return retArr;
}

+ (NSArray*) fetchHistory:(int) uid {
    NSString *urlString = [NSString stringWithFormat:@"http://www.entalkie.url.tw/getHistory.php?masterID=%d", uid];
    NSData *data = [DBHandler sendReqToUrl:urlString postString:nil];
	NSArray *array = nil;
    NSMutableArray *ret = [[NSMutableArray alloc] init ];
	
	if(data)
	{
		NSString *responseString = [[NSString alloc] initWithData:data
                                                         encoding:NSUTF8StringEncoding];
		array = [responseString JSONValue];
		[responseString release];
	}
    return array;
    //[ret addObject:@"get friends"];
    for (NSDictionary *dic in array) {
        if( [dic objectForKey:@"USER_NAME"] == [NSNull null])
            [ret addObject: @"NO NAME"];
        else
            [ret addObject: [dic objectForKey:@"USER_NAME"]];
        NSLog(@"DEST id:%@",[dic objectForKey:@"DIALOG_DESTINATIONID"]);
    }
    //[ret addObject:nil];
    NSArray *retArr = [[NSArray alloc ]initWithArray:ret];
    [ret release];
    //NSLog(@"1:%d",[retArr retainCount]);
    [retArr autorelease];
    //NSLog(@"2:%d",[retArr retainCount]);
	return retArr;
}

+ (void) delUserInfo {
	[Util removeFile:@"user.status"];
}

+ (bool) checkUserInfoExist {
	NSString *documentPath = [Util getDocumentPath];
    NSLog(@"%@", documentPath);
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:[documentPath stringByAppendingPathComponent:@"user.status"]] ) {
		return YES;
	} else {
		[self delUserInfo];
		return NO;
	}
}

+ (void) saveParameter {
    NSString *documentPath = [Util getDocumentPath];
    
	//[self delEventInfo];
	
	
	NSArray *plumberArr = [[NSArray alloc] initWithObjects: [NSString stringWithFormat:@"%@",  g_PhoneNumber ],
						   [NSString stringWithFormat:@"%@",  g_UserName ],
                           nil];
	
	NSLog(@"###saveParameter, lives:%@, level:%@", [plumberArr objectAtIndex:0], [plumberArr objectAtIndex:1] );
	
	[plumberArr writeToFile:[documentPath stringByAppendingPathComponent:@"user.status"] atomically:YES];
	[plumberArr release];
    
	
}

+ (void) getParameter {
    NSString *documentPath = [Util getDocumentPath];
    
    NSArray *plumberArr = [[NSArray alloc] initWithContentsOfFile:[documentPath stringByAppendingPathComponent:@"user.status"]];
    
    g_PhoneNumber = [plumberArr objectAtIndex:0];
    g_UserName = [plumberArr objectAtIndex:1];
}

+ (void) uploadFile {
	/*
	 turning the image into a NSData object
	 getting the image back out of the UIImageView
	 setting the quality to 90
	 */
	UIImageView *image = [[UIImageView alloc] initWithFrame:
                          CGRectMake(100.0, 100.0, 57.0, 57.0)];
	image.image = 
	[UIImage imageNamed:@"phone.png"];
	//NSData *imageData = UIImageJPEGRepresentation(image.image, 90);
	//NSString* str =  [[NSBundle mainBundle] pathForResource:@"mysoundcompressed" ofType:@"caf"];
	NSString *audioFile = [NSString stringWithFormat:@"%@/%@.caf", [[NSBundle mainBundle] resourcePath], @"111"]; 
	NSData *wavData = [NSData dataWithContentsOfFile:audioFile];
	// setting up the URL to post to
	NSString *urlString = @"http://www.entalkie.url.tw/upload.php";
	
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	/*
	 add some header info now
	 we always need a boundary when we post a file
	 also we need to set the content type
	 
	 You might want to generate a random boundary.. this is just the same
	 as my output from wireshark on a valid html post
	 */
	NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	/*
	 now lets create the body of the post
	 */
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"star.caf\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:wavData]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
	// now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"%@",returnString);
}

+ (int) loginServer {
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [myDevice uniqueIdentifier];
	//NSString *post =[[NSString alloc] initWithFormat:@"userName=%@&userPhone=%@&deviceID=",@"hank",[[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"]];
	NSString *post =[[NSString alloc] initWithFormat:@"userPhone=%@&userName=%@&deviceID=",g_PhoneNumber,[[UIDevice currentDevice] name ]];
	post = [post stringByAppendingFormat:@"%@",deviceUDID];
    //post = [post stringByAppendingFormat:[[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"],deviceUDID];
	NSURL *url=[NSURL URLWithString:@"http://www.entalkie.url.tw/login.php"];
	
	NSLog(@"%@",post);
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:url];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
	
	/* when we user https, we need to allow any HTTPS cerificates, so add the one line code,to tell teh NSURLRequest to accept any https certificate, i'm not sure about the security aspects
	 */
	
	[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
	
	NSError *error;
	NSURLResponse *response;
	NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	NSString *data=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
	//NSLog(@"data:%@ error:%@",data, error);
    return [data intValue];
}

@end
