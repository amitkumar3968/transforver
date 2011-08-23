//
//  FavoritesTabViewController.m
//  NavTab
//
//  Created by Robert Conn on 04/04/2009.
//  Copyright 2009 WiredBob Consulting. All rights reserved.
//

#import "FavoritesTabViewController.h"
#import <AudioToolbox/AudioServices.h>
#import "Util.h"


@implementation FavoritesTabViewController

@synthesize mybutton;
@synthesize localFilePath;
@synthesize audioFile;
@synthesize audioRecorder;

- (void) uploadFile {
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
	NSString *audioFile = [NSString stringWithFormat:@"%@/%@.aif", [Util getDocumentPath], @"recording"]; 
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
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"star.aif\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
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


- (IBAction)downloadingButtonClick:(id)sender {
	[self downloadToFile];
}

- (IBAction)uploadButtonClick:(id)sender {
	[self uploadFile];
}

- (IBAction)recordingButtonClick:(id)sender {
	NSLog(@"recording");
    // if we're currently recording
    [audioRecorder startRecording];
}

- (IBAction)recordingButtonRelease:(id)sender {
    NSLog(@"release");
    [audioRecorder stopRecording];
    //@Ray
    NSLog(@"stop recording!");
    NSLog(@"playing...");
    [Util copyFile];
    dovocode();
    //[self uploadFile:filepath];

}

- (IBAction)playButtonClick:(id)sender {
	NSLog(@"playing");
    // if we're currently recording
    [self playSound];
}


- (void) playSound {
	/*NSLog(@"Playing Sound!");
     [audioRecorder startPlayback];*/
	system("ls");
	SystemSoundID soundID = 0;
	//NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [Util getDocumentPath];
	NSString *audioPath = [documentsPath stringByAppendingPathComponent:@"out.aif"];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.aif", [Util getDocumentPath], @"star"];
	//NSString *filePath = [[NSBundle mainBundle] resourcePath];// stringByAppendingPathComponent:@"123.wav"];
	NSLog(documentsPath);
	NSLog(filePath);
	NSURL* tmpUrl = [[NSURL alloc] initFileURLWithPath:filePath ];
	CFURLRef soundFileURL = (CFURLRef)tmpUrl;
	OSStatus errorCode = AudioServicesCreateSystemSoundID(soundFileURL, &soundID);
	if (errorCode != 0) {
		// Handle failure here
	}
	else
	{
		AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
		AudioServicesPlaySystemSound(soundID);
	}
    
	[tmpUrl release];
}


#pragma mark -
#pragma mark NSURLConnection methods
NSMutableData *tempData;    //下載時暫存用的記憶體
long expectedLength;        //檔案大小
NSURLConnection* connection;


- (void)downloadToFile
{
    /*
     NSString* filePath = [[NSString stringWithFormat:@"%@/%@.wav", TEMP_FOLDER, name] retain];
     self.localFilePath = filePath;
     
     // set up FileHandle
     self.audioFile = [[NSFileHandle fileHandleForWritingAtPath:localFilePath] retain];
     [filePath release];
     
     
     NSURL *webURL=[NSURL URLWithString:@"http://www.entalkie.url.tw/download.php"];
     // Open the connection
     NSURLRequest* request = [NSURLRequest 
     requestWithURL:webURL
     cachePolicy:NSURLRequestUseProtocolCachePolicy
     timeoutInterval:60.0];
     NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
     */
    //downloadProgress.progress = 0.0;
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:@"http://www.entalkie.url.tw/download.php"]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"Mobile Safari 1.1.3 (iPhone; U; CPU like Mac OS X; en)" forHTTPHeaderField:@"User-Agent"];
    tempData = [NSMutableData alloc];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    //[super viewDidLoad];
    
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{   //發生錯誤
    [connection release];
	NSLog(@"發生錯誤");
}
- (void)connection: (NSURLConnection *)connection didReceiveResponse: (NSURLResponse *)aResponse {  //連線建立成功
    //取得狀態
    NSInteger status = (NSInteger)[(NSHTTPURLResponse *)aResponse statusCode];
    NSLog(@"%d", status);
    
	expectedLength = [aResponse expectedContentLength]; //儲存檔案長度
}
-(void) connection:(NSURLConnection *)connection didReceiveData: (NSData *) incomingData
{   //收到封包，將收到的資料塞進緩衝中並修改進度條
	[tempData appendData:incomingData];
    
    double ex = expectedLength;
    //downloadProgress.progress = [tempData length] / ex;;
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{   //檔案下載完成
    //取得可讀寫的路徑
	NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = [pathList objectAtIndex:0];
    
	//加上檔名
	path = [path stringByAppendingPathComponent: @"star.aif"];
    NSLog(@"儲存路徑：%@", path);
	
	//寫入檔案
    [tempData writeToFile:path atomically:NO];
    [tempData release];
    tempData = nil;
    
    //img.image = [UIImage imageWithContentsOfFile:path]; //顯示圖片在畫面中
}




/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {

}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	
    [super viewDidLoad];
    audioRecorder = [[[AudioRecorder	alloc] init] retain];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [audioRecorder release];
    [super dealloc];
}


@end
