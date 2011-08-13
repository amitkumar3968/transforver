//
//  RootViewController.m
//  NavTab
//
//  Created by Robert Conn on 31/03/2009.
//  Copyright WiredBob Consulting 2009. All rights reserved.
//

#import "RootViewController.h"
//#import "NavTabAppDelegate.h"
#import "UICustomTabViewController.h"
#import <AudioToolbox/AudioServices.h>
#import <AddressBook/AddressBook.h>

@implementation RootViewController

@synthesize accounts;
@synthesize tabViewController;

- (void)viewDidLoad {
	
	
	UICustomTabViewController *tvController = [[UICustomTabViewController alloc] initWithNibName:@"TabViewController" bundle:nil];
	self.tabViewController = tvController;
	[tvController release];
	self.title = @"Accounts";
	
	UIBarButtonItem *leftButton = 
	[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(compose:)];
	
	self.navigationItem.leftBarButtonItem = leftButton;
	[leftButton release];
	
	UIImage *image = [UIImage imageNamed:@"phone.png"];
	CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
	UIButton* button = [[UIButton alloc] initWithFrame:frame];
	[button setBackgroundImage:image forState:UIControlStateNormal];
	[button addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
	[button setShowsTouchWhenHighlighted:YES];
	
	
	
	UIBarButtonItem *rightButton = 
	[[UIBarButtonItem alloc] initWithCustomView:button];
	
	self.navigationItem.rightBarButtonItem = rightButton;
	[rightButton release];
	[button release];
	
	//accessing the address book
	ABAddressBookRef addressBook = ABAddressBookCreate();
	CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
	CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(
															   kCFAllocatorDefault,
															   CFArrayGetCount(people),
																   people
															   );
	
	
	CFArraySortValues(
					  peopleMutable,
					  CFRangeMake(0, CFArrayGetCount(peopleMutable)),
					  (CFComparatorFunction) ABPersonComparePeopleByName,
					  (void*) ABPersonGetSortOrdering()
					  );
	
	CFRelease(addressBook);
	CFRelease(people);
	CFRelease(peopleMutable);
	
	NSArray *array = [[NSArray alloc] initWithObjects:@"find friends",@"Raymond", @"Raymond", @"John", nil];
	self.accounts = array;
	[array release];
	
	[super viewDidLoad];

}

- (void) playSound {
	SystemSoundID soundID = 0;
	NSString* str =  [[NSBundle mainBundle] pathForResource:@"123" ofType:@"wav"];
	NSURL* tmpUrl = [[NSURL alloc] initFileURLWithPath:str ];
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

- (void) showMenu:(id) sender {
	NSLog(@"showMenu");
	[self loginServer];
	[self playSound];
	[self uploadFile];
	return ;
	/*
	UIActionSheet *myMenu = [[UIActionSheet alloc]
                             initWithTitle: @"Menu"
                             delegate:self
                             cancelButtonTitle:@"Cancel"
                             destructiveButtonTitle:@"Etwas unwiderrufliches"
                             otherButtonTitles:@"Eins", @"Zwei", nil];
	 */
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:
							  CGRectMake(100.0, 100.0, 57.0, 57.0)];
	imageView.image = [UIImage imageNamed:@"star.jpg"];
	//[self.view addSubview:imageView];
	[imageView release];
	UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    imageButton.frame = CGRectMake(100.0, 100.0, 57.0, 57.0);
	[imageButton addTarget:self action:@selector(buttonPushed:)
		  forControlEvents:UIControlEventTouchUpInside];
    [imageButton setImage:[UIImage imageNamed:@"phone.png"] forState:UIControlStateNormal];
    [self.view addSubview:imageButton];
	
	UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
	
	CGRect newSize = CGRectMake(200, 200, 200, 200);
	myButton.frame = newSize;
	[myButton setImage:[UIImage imageNamed:@"phone.png"] forState:UIControlStateNormal];
	[myButton addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:myButton];
    //[myMenu showInView:self.view];
	//[myMenu release];
}

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

- (void) loginServer {
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [myDevice uniqueIdentifier];
	NSString *post =[[NSString alloc] initWithFormat:@"userName=%@&deviceID=",@"hank"];
	post = [post stringByAppendingFormat:deviceUDID];
	NSURL *url=[NSURL URLWithString:@"http://www.entalkie.url.tw/login.php"];
	
	NSLog(post);
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
	NSLog(@"%@",data);
}

- (void) downloadFile {
}

- (void) buttonPushed:(id)sender
{
	[self uploadFile];
	NSLog(@"It works!");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [accounts count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	NSUInteger row = indexPath.row;
	cell.text = [accounts objectAtIndex:row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.tabViewController setTitle:[accounts objectAtIndex:indexPath.row]];
	[self.navigationController pushViewController:self.tabViewController animated:YES];

}

- (void)dealloc {
	[tabViewController release];
	[accounts release];
    [super dealloc];
}


@end

