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
#import "DBHandler.h"
#import "JSON.h"
#import <AudioToolbox/AudioServices.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#define USE_CUSTOM_DRAWING 1

@implementation RootViewController

@synthesize accounts;
@synthesize tabViewController;
@synthesize audioRecorder;

- (void)viewDidLoad {
	
	
	UICustomTabViewController *tvController = [[UICustomTabViewController alloc] initWithNibName:@"TabViewController" bundle:nil];
	self.tabViewController = tvController;
    
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	//self.tableView.rowHeight = 100;
	//self.tableView.backgroundColor = [UIColor clearColor];
    [self loginServer];

    
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
	
	NSArray *array = [self fetchRelationships];//[[NSArray alloc] initWithObjects:@"find friends",@"Jerry", @"Raymond", @"John", nil];
	self.accounts = array;
	[array release];
	
	[super viewDidLoad];

}

- (NSArray*) fetchRelationships {
    NSString *urlString = @"http://www.entalkie.url.tw/getRelationships.php?masterID=1";
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
    [ret addObject:@"get friends"];
    for (NSDictionary *dic in array) {
        [ret addObject: [dic objectForKey:@"USER_NAME"]];
    }
    //[ret addObject:nil];
    NSArray *retArr = [[NSArray alloc ]initWithArray:ret];
    [ret release];
    
	return retArr;
}

- (void) playSound {
	/*NSLog(@"Playing Sound!");
	[audioRecorder startPlayback];*/
	system("ls");
	SystemSoundID soundID = 0;
	//NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [Util getDocumentPath];
	NSString *audioPath = [documentsPath stringByAppendingPathComponent:@"out.aif"];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.caf", [Util getDocumentPath], @"recording"];
	//NSString *filePath = [[NSBundle mainBundle] resourcePath];// stringByAppendingPathComponent:@"123.wav"];
	NSLog(documentsPath);
	NSLog(filePath);
	NSURL* tmpUrl = [[NSURL alloc] initFileURLWithPath:audioPath ];
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
    [imageButton setImage:[UIImage imageNamed:@"images/phone.png"] forState:UIControlStateNormal];
    [self.view addSubview:imageButton];
	
	UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
	
	CGRect newSize = CGRectMake(200, 200, 200, 200);
	myButton.frame = newSize;
	[myButton setImage:[UIImage imageNamed:@"images/phone.png"] forState:UIControlStateNormal];
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
	//NSString *post =[[NSString alloc] initWithFormat:@"userName=%@&userPhone=%@&deviceID=",@"hank",[[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"]];
	NSString *post =[[NSString alloc] initWithFormat:@"userName=%@&deviceID=",@"hank"];
	post = [post stringByAppendingFormat:deviceUDID];
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
	NSLog(@"data:%@ error:%@",data, error);
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

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
{
    [self dismissModalViewControllerAnimated:YES];
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
#if USE_CUSTOM_DRAWING
	const NSInteger TOP_LABEL_TAG = 1001;
	const NSInteger BOTTOM_LABEL_TAG = 1002;
	UILabel *topLabel;
	UILabel *bottomLabel;
#endif
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
        //cell.opaque = NO; 
#if USE_CUSTOM_DRAWING
        
		
		
		//const CGFloat LABEL_HEIGHT = 20;
		//UIImage *image = [UIImage imageNamed:@"imageA.png"];
        /*
		//
		// Create the label for the top row of text
		//
		topLabel =
        [[[UILabel alloc]
          initWithFrame:
          CGRectMake(
                     image.size.width + 2.0 * cell.indentationWidth,
                     0.5 * (tableView.rowHeight - 2 * LABEL_HEIGHT),
                     tableView.bounds.size.width -
                     image.size.width - 4.0 * cell.indentationWidth
                     - indicatorImage.size.width,
                     LABEL_HEIGHT)]
         autorelease];
		[cell.contentView addSubview:topLabel];
        
		//
		// Configure the properties for the text that are the same on every row
		//
		topLabel.tag = TOP_LABEL_TAG;
		topLabel.backgroundColor = [UIColor clearColor];
		topLabel.textColor = [UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
		topLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
		topLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
        
		//
		// Create the label for the top row of text
		//
		bottomLabel =
        [[[UILabel alloc]
          initWithFrame:
          CGRectMake(
                     image.size.width + 2.0 * cell.indentationWidth,
                     0.5 * (tableView.rowHeight - 2 * LABEL_HEIGHT) + LABEL_HEIGHT,
                     tableView.bounds.size.width -
                     image.size.width - 4.0 * cell.indentationWidth
                     - indicatorImage.size.width,
                     LABEL_HEIGHT)]
         autorelease];
		[cell.contentView addSubview:bottomLabel];
        
		//
		// Configure the properties for the text that are the same on every row
		//
		bottomLabel.tag = BOTTOM_LABEL_TAG;
		bottomLabel.backgroundColor = [UIColor clearColor];
		bottomLabel.textColor = [UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
		bottomLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
		bottomLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize] - 2];
        */
		//
		// Create a background image view.
		//
		cell.backgroundView =
        [[[UIImageView alloc] init] autorelease];
		cell.selectedBackgroundView =
        [[[UIImageView alloc] init] autorelease];
#endif
        //cell.textColor = [UIColor whiteColor];
    }
#if USE_CUSTOM_DRAWING
    else
    {
        topLabel = (UILabel *)[cell viewWithTag:TOP_LABEL_TAG];
        bottomLabel = (UILabel *)[cell viewWithTag:BOTTOM_LABEL_TAG];
    }
	
	//topLabel.text = [NSString stringWithFormat:@"Cell at row %ld.", [indexPath row]];
	//bottomLabel.text = [NSString stringWithFormat:@"Some other information.", [indexPath row]];
	
	//
	// Set the background and selected background images for the text.
	// Since we will round the corners at the top and bottom of sections, we
	// need to conditionally choose the images based on the row index and the
	// number of rows in the section.
	//
    /*
	UIImage *rowBackground;
	UIImage *selectionBackground;
	NSInteger sectionRows = [tableView numberOfRowsInSection:[indexPath section]];
	NSInteger row = [indexPath row];
	if (row == 0 && row == sectionRows - 1)
	{
		rowBackground = [UIImage imageNamed:@"topAndBottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"topAndBottomRowSelected.png"];
	}
	else if (row == 0)
	{
		rowBackground = [UIImage imageNamed:@"topRow.png"];
		selectionBackground = [UIImage imageNamed:@"topRowSelected.png"];
	}
	else if (row == sectionRows - 1)
	{
		rowBackground = [UIImage imageNamed:@"bottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"bottomRowSelected.png"];
	}
	else
	{
		rowBackground = [UIImage imageNamed:@"middleRow.png"];
		selectionBackground = [UIImage imageNamed:@"middleRowSelected.png"];
	}
	((UIImageView *)cell.backgroundView).image = rowBackground;
	((UIImageView *)cell.selectedBackgroundView).image = selectionBackground;
	*/
	//
	// Here I set an image based on the row. This is just to have something
	// colorful to show on each row.
	//
    /*
	if ((row % 3) == 0)
	{
		cell.image = [UIImage imageNamed:@"imageA.png"];
	}
	else if ((row % 3) == 1)
	{
		cell.image = [UIImage imageNamed:@"imageB.png"];
	}
	else
	{
		cell.image = [UIImage imageNamed:@"imageC.png"];
	}
     */
#else
	cell.text = [NSString stringWithFormat:@"Cell at row %ld.", [indexPath row]];
#endif
    
    //
    //cell.backgroundColor = [UIColor colorWithRed:.1 green:.1 blue:.1 alpha:.4];
    
    NSInteger row = [indexPath row];
    
    
    if( row == 0 )
    {
        UIImage *indicatorImage = [UIImage imageNamed:@"indicator.png"];
        cell.userInteractionEnabled = YES;
		cell.accessoryView =
        [[[UIImageView alloc]
          initWithImage:indicatorImage]
         autorelease];
                //[cell contentView].backgroundColor = [UIColor clearColor];
        //[cell contentView].backgroundColor = [UIColor colorWithRed:.1 green:.1 blue:.1 alpha:1];
        UIImage *rowBackground;
        rowBackground = [UIImage imageNamed:@"topRow.png"];
        ((UIImageView *)cell.backgroundView).image = rowBackground;
        cell.textLabel.backgroundColor = [UIColor colorWithRed:.0 green:.2 blue:.2 alpha:.1];
        cell.textLabel.backgroundColor = [UIColor colorWithRed:.1 green:.1 blue:.1 alpha:.01];
        //cell.textLabel.backgroundColor = [UIColor colorWithRed:.1 green:.1 blue:.1 alpha:.9];
        //cell.contentView.backgroundColor = [UIColor colorWithRed:.1 green:.1 blue:.1 alpha:.9];
        //UIView *backView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        //backView.backgroundColor = [UIColor clearColor];
        //cell.contentView.backgroundColor = [UIColor clearColor];
    }
    else
    {
        NSInteger row = [indexPath row];
        UIImage *rowBackground;
        rowBackground = [UIImage imageNamed:@"gradientBackground.png"];
        ((UIImageView *)cell.backgroundView).image = rowBackground;
        cell.textLabel.backgroundColor = [UIColor colorWithRed:.0 green:.2 blue:.2 alpha:.1];

    }
    cell.text = [accounts objectAtIndex:row];
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    if ( row == 0 )
    {//to add the contact list
        ABPeoplePickerNavigationController *myPicker = [[ABPeoplePickerNavigationController alloc] init];
        [myPicker setPeoplePickerDelegate:self];
        //myPicker.peoplePickerDelegate = self;   
        // 只show e-mail
        //myPicker.displayedProperties = [NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonEmailProperty]]; 
        //ABPersonViewController* ppnc = [[ABPersonViewController alloc] init];
        [self.navigationController presentModalViewController:myPicker animated:YES];   
        //[myPicker release];
        [myPicker release];

        //[self.tabViewController setTitle:[accounts objectAtIndex:indexPath.row]];
        //[self.navigationController pushViewController:self.tabViewController animated:YES];
    }else
    {
        [self.tabViewController setTitle:[accounts objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:self.tabViewController animated:YES];
    }

}

- (void)dealloc {
	[tabViewController release];
	[accounts release];
    [super dealloc];
}


@end

