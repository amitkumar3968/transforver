//
//  UICustomTabViewController.m
//  NavTab
//
//  Created by Robert Conn on 31/03/2009.
//  Copyright 2009 WiredBob Consulting. All rights reserved.
//

#import "UICustomTabViewController.h"
#import "FavoritesTabViewController.h"
#import "MoreTabViewController.h"

#define TEMP_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"]

@implementation UICustomTabViewController

@synthesize viewControllers;
@synthesize tabBar;
@synthesize	favouritesTabBarItem;
@synthesize moreTabBarItem;
@synthesize recordingTabBarItem;
@synthesize selectedViewController;
@synthesize localFilePath;
@synthesize audioFile;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {

        // Custom initialization
		FavoritesTabViewController *favTabViewController = [[FavoritesTabViewController alloc] initWithNibName:@"FavoritesTabView" bundle:nil];
		MoreTabViewController *moreTabViewController = [[MoreTabViewController alloc] initWithNibName:@"MoreTabView" bundle:nil];
		
		NSArray *array = [[NSArray alloc] initWithObjects:favTabViewController, moreTabViewController, nil];
		self.viewControllers = array;
		
		[self.view addSubview:favTabViewController.view];
		self.selectedViewController = favTabViewController;
		
		[array release];
		[favTabViewController release];
		[moreTabViewController release];
		
    }
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	tabBar.selectedItem = favouritesTabBarItem;	
	[super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[tabBar release];
	[favouritesTabBarItem release];
	[moreTabBarItem release];
	[recordingTabBarItem release];
	[viewControllers release];
	[selectedViewController release];
    [super dealloc];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
	if (item == favouritesTabBarItem) {

		UIViewController *fabViewController = [viewControllers objectAtIndex:0];
		[self.selectedViewController.view removeFromSuperview];
		[self.view addSubview:fabViewController.view];
		self.selectedViewController = fabViewController;

	} else if (item == moreTabBarItem) {
		UIViewController *moreViewController = [viewControllers objectAtIndex:1];
		[self.selectedViewController.view removeFromSuperview];
		[self.view addSubview:moreViewController.view];
		self.selectedViewController = moreViewController;
		
	} else if (item == recordingTabBarItem) {
        //[self downloadToFile];
		NSLog(@"recording");
	}
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
    
    [super viewDidLoad];
    
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
	path = [path stringByAppendingPathComponent: @"00.wav"];
    NSLog(@"儲存路徑：%@", path);
	
	//寫入檔案
    [tempData writeToFile:path atomically:NO];
    [tempData release];
    tempData = nil;
    
    //img.image = [UIImage imageWithContentsOfFile:path]; //顯示圖片在畫面中
}

@end
