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
@synthesize audioRecorder;
static int recording=0;





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
	audioRecorder = [[[AudioRecorder	alloc] init] retain];
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

- (void) uploadFile:(char *)filepath {
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


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
	char *filepath;
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
		// if we¡¦re currently recording
		if (recording==1)
		{
			/*[recorder stop]; // stop recording
			NSLog(@"Stop Recording!");
			// set the category of the current audio session
			[[AVAudioSession sharedInstance] setCategory:
			 AVAudioSessionCategorySoloAmbient error:nil];
			*/
			[audioRecorder stopRecording];
			//@Ray
			NSLog(@"stop recording!");
			recording=0;
			dovocode(filepath);
			[self uploadFile:filepath];
		} // end if
		else
		{
			NSLog(@"Start Recording!");
			[audioRecorder startRecording];
			recording=1;
			/*
			system("ls");
			system("cd Applications");
			system("ls");
			// set the audio session's category to record
			[[AVAudioSession sharedInstance] setCategory:
			 AVAudioSessionCategoryRecord error:nil];  
			
			// find the location of the document directory
			NSArray *paths = NSSearchPathForDirectoriesInDomains(
																 NSDocumentDirectory, NSUserDomainMask, YES);
			
			// get the first directory
			NSString *dir = [paths objectAtIndex:0];
			
			// create a name for the file using the current system time
			NSString *filename = [NSString stringWithFormat:@"%f.rif",
								  [[NSDate date] timeIntervalSince1970]];
			
			// create the path using the directory and file name
			NSString *path = [dir stringByAppendingPathComponent:filename];
			
			//@Ray
			filepath=[path cStringUsingEncoding:NSUTF8StringEncoding];
			
			// create a new NSMutableDictionary for the record settings
			NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
			
			//[audioSettings setObject:[NSNumber numberWithInt:] forKey:AVFormatIDKey];
			//[audioSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
			//[audioSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
			//[audioSettings setObject:[NSNumber numberWithFloat:4096] forKey:AVSampleRateKey];
			//[audioSettings setObject:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
			//[audioSettings setObject:[NSNumber numberWithBool:YES] forKey:AVLinearPCMIsNonInterleaved];
			//[audioSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
			
			
			// record using the Apple lossless format
			[settings setValue: [NSNumber
								 numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
			
			// set the sample rate to 44100 Hz
			[settings setValue:[NSNumber 
								numberWithFloat:44100.0] forKey:AVSampleRateKey]; 
			
			// set the number of channels for recording
			[settings setValue:[NSNumber numberWithInt:1] 
						forKey:AVNumberOfChannelsKey];
			
			// set the bit depth
			[settings setValue:[NSNumber numberWithInt:16] 
						forKey:AVLinearPCMBitDepthKey];
			
			// set whether the format is big endian
			[settings setValue:[NSNumber numberWithBool:NO] 
						forKey:AVLinearPCMIsBigEndianKey];
			
			// set whether the audio format is floating point
			[settings setValue:[NSNumber numberWithBool:NO] 
						forKey:AVLinearPCMIsFloatKey];
			
			[recorder release]; // release the recorder AVAudioRecorder
			
			// initialize recorder with the URL and settings
			recorder =
			[[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:path]
										settings:settings error:nil];
			[recorder prepareToRecord]; // prepare the recorder to record
			recorder.meteringEnabled = YES; // enable metering for the recorder
			[recorder record]; // start the recording
			*/
		} // end else
        //[self downloadToFile];
		NSLog(@"recording");
	}
}
@end





