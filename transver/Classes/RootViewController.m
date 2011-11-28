//
//  RootViewController.m
//  NavTab
//
//  Created by Robert Conn on 31/03/2009.
//  Copyright WiredBob Consulting 2009. All rights reserved.
//

#import "RootViewController.h"
//#import "NavTabAppDelegate.h"
#import "ChatViewController.h"
#import "UICustomTabViewController.h"
#import "DBHandler.h"
#import "JSON.h"
#import "AddUserViewController.h"
#import <AudioToolbox/AudioServices.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

#define USE_CUSTOM_DRAWING 1

@implementation RootViewController

@synthesize accounts;
@synthesize tabViewController;
@synthesize audioRecorder;
//@synthesize m_userid;
@synthesize m_ShowMenu;
@synthesize m_PhoneNumber;
@synthesize m_UserName;
@synthesize m_AccountID;
//@synthesize firstName;
//@synthesize lastName;


- (void)viewDidLoad {
	//[[UIApplication sharedApplication] setApplicationIconBadgeNumber:100];
	m_ShowMenu = 0;
	UICustomTabViewController *tvController = [[UICustomTabViewController alloc] initWithNibName:@"TabViewController" bundle:nil];
	self.tabViewController = tvController;
    [tvController release];
    //[self.view addSubview:tabViewController.view];
    m_userid = -1;
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	//self.tableView.rowHeight = 100;
	//self.tableView.backgroundColor = [UIColor clearColor];
    if( ![self checkUserInfoExist])
    {
        AddUserViewController *addUserView = [[AddUserViewController alloc] initWithNibName:@"AddUserViewController" bundle:nil];
        addUserView.title = @"Add Phone Number";
        addUserView.delegate = self;
        [self.navigationController pushViewController:addUserView animated:YES];
        //[self saveParameter];
    }else
    {
        [self getParameter];
        m_userid = [self loginServer];
    }
    

    
	
    NSLog(@"USER_ID:%d", m_userid);
	//self.title = @"Accounts";
	
	UIBarButtonItem *leftButton = 
	[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(AddUserMenu:)];
	
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
    /*
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
	CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
	for (int i=0;i < nPeople;i++) { 
		ABRecordRef ref = CFArrayGetValueAtIndex(peopleMutable,i);
		//NSLog((NSString *)ABRecordCopyValue(ref));
	}
	
	CFRelease(addressBook);
	CFRelease(people);
	CFRelease(peopleMutable);
	*/
    m_AccountID = [[NSMutableArray alloc] init];
    if( m_userid != -1)
    {
        

        NSArray *array = [self fetchRelationships:m_userid];//[[NSArray alloc] initWithObjects:@"find friends",@"Jerry", @"Raymond", @"John", nil];
        self.accounts = array;
        //[array release];
        NSLog(@"%d", [array retainCount]);
    }
	[super viewDidLoad];

}

- (void) addRelationships:(int) uid phonenumber:(NSString *) phone{
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

- (NSArray*) fetchRelationships:(int) uid {
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
    [ret addObject:@"get friends"];
    for (NSDictionary *dic in array) {
        if( [dic objectForKey:@"USER_NAME"] == [NSNull null])
            [ret addObject: @"NO NAME"];
        else
            [ret addObject: [dic objectForKey:@"USER_NAME"]];
        NSLog(@"%@",[dic objectForKey:@"RELATION_SLAVEID"]);
        [m_AccountID addObject: [dic objectForKey:@"RELATION_SLAVEID"]];
    }
    //[ret addObject:nil];
    NSArray *retArr = [[NSArray alloc ]initWithArray:ret];
    [ret release];
    //NSLog(@"1:%d",[retArr retainCount]);
    [retArr autorelease];
    //NSLog(@"2:%d",[retArr retainCount]);
	return retArr;
}

- (void) playSound {
	/*NSLog(@"Playing Sound!");
	[audioRecorder startPlayback];*/
	system("ls");
	SystemSoundID soundID = 0;
	//NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	//NSString *documentsPath = [Util getDocumentPath];
	//NSString *audioPath = [documentsPath stringByAppendingPathComponent:@"out.aif"];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.aif", [Util getDocumentPath], @"recording"];

	//NSString *filePath = [[NSBundle mainBundle] resourcePath];// stringByAppendingPathComponent:@"123.wav"];
	NSLog(@"%@",filePath);
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

-(void)MenuSetting:(id)sender{
    NSLog(@"MenuSetting");
}

- (void) AddUserMenu:(id) sender {
    NSLog(@"AddUserMenu");
    AddUserViewController *addUserView = [[AddUserViewController alloc] initWithNibName:@"AddUserViewController" bundle:nil];
    addUserView.title = @"Add Phone Number";
    addUserView.delegate = self;
    [self.navigationController pushViewController:addUserView animated:YES];
}
- (void) showMenu:(id) sender {
	NSLog(@"showMenu");
	//[self loginServer];
	//[self playSound];
	//[self uploadFile];
	//return ;
    if( m_ShowMenu == 0)
    {
        CGRect transparentViewFrame = CGRectMake(0.0, 0.0,360.0,480.0);
        UIView *transparentView = [[UIView alloc] initWithFrame:transparentViewFrame];
            transparentView.backgroundColor = [UIColor lightGrayColor];
            transparentView.alpha = 1;
        transparentView.tag = 1;
    
    
            CGRect menuViewFrame = CGRectMake(120.0, 20.0,180.0,240.0);
            UIView *menuView = [[UIView alloc] initWithFrame:menuViewFrame];
            menuView.backgroundColor = [UIColor lightGrayColor];
            menuView.alpha = 1;
            [transparentView addSubview:menuView];
        [self.view addSubview:transparentView];
        CGRect btnViewFrame = CGRectMake(120.0, 20.0,64.0,64.0);
        UIButton *settingBtn = [[UIButton alloc] initWithFrame:btnViewFrame];
        //[settingBtn setTitle:@"Ok" forState:UIControlStateNormal];
        //settingBtn.backgroundColor = [UIColor blackColor];
        UIImage *snap_picture = [UIImage imageNamed:@"project-open-3.png"];
        [settingBtn setBackgroundImage:snap_picture forState:UIControlStateNormal];
        [settingBtn addTarget:self action:@selector(MenuSetting:) forControlEvents:UIControlEventTouchUpInside];
        settingBtn.tag = 2;
        [self.view addSubview:settingBtn];
        [settingBtn release];
        
        btnViewFrame = CGRectMake(220.0, 20.0,64.0,64.0);
        settingBtn = [[UIButton alloc] initWithFrame:btnViewFrame];
        snap_picture = [UIImage imageNamed:@"view-media-artist.png"];
        [settingBtn setBackgroundImage:snap_picture forState:UIControlStateNormal];
        [settingBtn addTarget:self action:@selector(MenuSetting:) forControlEvents:UIControlEventTouchUpInside];
        settingBtn.tag = 3;
        [self.view addSubview:settingBtn];
        [settingBtn release];
        
        btnViewFrame = CGRectMake(120.0, 100.0,64.0,64.0);
        settingBtn = [[UIButton alloc] initWithFrame:btnViewFrame];
        snap_picture = [UIImage imageNamed:@"quickopen-file.png"];
        [settingBtn setBackgroundImage:snap_picture forState:UIControlStateNormal];
        [settingBtn addTarget:self action:@selector(MenuSetting:) forControlEvents:UIControlEventTouchUpInside];
        settingBtn.tag = 4;
        [self.view addSubview:settingBtn];
        [settingBtn release];
        
        btnViewFrame = CGRectMake(220.0, 100,64.0,64.0);
        settingBtn = [[UIButton alloc] initWithFrame:btnViewFrame];
        snap_picture = [UIImage imageNamed:@"media-skip-forward-10.png"];
        [settingBtn setBackgroundImage:snap_picture forState:UIControlStateNormal];
        [settingBtn addTarget:self action:@selector(MenuSetting:) forControlEvents:UIControlEventTouchUpInside];
        settingBtn.tag = 5;
        [self.view addSubview:settingBtn];
        [settingBtn release];
        
        
    
        
        
        [menuView release];
        [transparentView release];
            m_ShowMenu = 1;
    }else
    {
        m_ShowMenu = 0;
        UIView *transparentView = [self.view viewWithTag:1];
        [transparentView removeFromSuperview];
        transparentView = [self.view viewWithTag:2];
        [transparentView removeFromSuperview];
        transparentView = [self.view viewWithTag:3];
        [transparentView removeFromSuperview];
        transparentView = [self.view viewWithTag:4];
        [transparentView removeFromSuperview];
        transparentView = [self.view viewWithTag:5];
        [transparentView removeFromSuperview];
        
    }
    
    
    return;
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

- (int) loginServer {
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [myDevice uniqueIdentifier];
	//NSString *post =[[NSString alloc] initWithFormat:@"userName=%@&userPhone=%@&deviceID=",@"hank",[[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"]];
	NSString *post =[[NSString alloc] initWithFormat:@"userPhone=%@&userName=%@&deviceID=",m_PhoneNumber,[[UIDevice currentDevice] name ]];
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

//@Ray Define actions (add relationship in DB) when specific contact is selected
- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
	
	
	ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
	
	const NSString *phone      = ABMultiValueCopyValueAtIndex(phoneMulti, 0);
	NSString *stringWithoutSeperates = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];	
	[self savePhoneNumber:stringWithoutSeperates];
    [phone release];    
	
    [self dismissModalViewControllerAnimated:YES];
	
    return NO;
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
        //NSInteger row = [indexPath row];
        UIImage *rowBackground;
        rowBackground = [UIImage imageNamed:@"gradientBackground.png"];
        ((UIImageView *)cell.backgroundView).image = rowBackground;
        cell.textLabel.backgroundColor = [UIColor colorWithRed:.0 green:.2 blue:.2 alpha:.1];

    }
    cell.textLabel.text = [accounts objectAtIndex:row];
    //UIImageView *MyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100.0, 33.0, 10.0, 10.0)]; //put your size and coordinates here
    
    //MyImageView.image = [UIImage imageNamed:@"carat-open.png"];
    //[cell.contentView addSubview: MyImageView];
    //[MyImageView release];
    UILabel *MyLabel = [[UILabel alloc] initWithFrame:CGRectMake(290.0, 23.0, 19.0, 15.0)];
    MyLabel.text = @"2";
    MyLabel.layer.cornerRadius = 5;
    cell.layer.cornerRadius = 8;
    cell.layer.masksToBounds = YES;
    //[cell.contentView addSubview: MyLabel];
    [MyLabel release];

    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    if ( row == 0 )
    {//to add the contact list
        ABPeoplePickerNavigationController *myPicker = [[ABPeoplePickerNavigationController alloc] init];
        [myPicker setPeoplePickerDelegate:(id<ABPeoplePickerNavigationControllerDelegate>)self];
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
        //[self.tabViewController setTitle:[accounts objectAtIndex:indexPath.row]];
        //[self.navigationController pushViewController:self.tabViewController animated:YES];
        //Show the message chat view
        //ChatViewController *chat = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
        ChatViewController *chat = [[ChatViewController alloc] initWithRelation:m_userid DstID:[[m_AccountID objectAtIndex:indexPath.row-1] integerValue]];
        chat.m_DstName = [accounts objectAtIndex:indexPath.row];
        //ChatViewController *chat = [[ChatViewController alloc] initWithRelation:1 DstID:2];
                                    
        //[chat setContact:contact];
        
        [self.navigationController pushViewController:chat animated:YES];
        //self.navigationController.navigationBar.delegate = self;
        
        [chat release];

    }

}


- (void) delUserInfo {
	[Util removeFile:@"user.status"];
}

- (bool) checkUserInfoExist {
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

- (void) saveParameter {
    NSString *documentPath = [Util getDocumentPath];
    
	//[self delEventInfo];
	
	
	NSArray *plumberArr = [[NSArray alloc] initWithObjects: [NSString stringWithFormat:@"%@",  m_PhoneNumber ],
						   [NSString stringWithFormat:@"%@",  m_UserName ],
                           nil];
	
	NSLog(@"###saveParameter, lives:%@, level:%@", [plumberArr objectAtIndex:0], [plumberArr objectAtIndex:1] );
	
	[plumberArr writeToFile:[documentPath stringByAppendingPathComponent:@"user.status"] atomically:YES];
	[plumberArr release];
    
	
}

- (void) getParameter {
    NSString *documentPath = [Util getDocumentPath];
    
    NSArray *plumberArr = [[NSArray alloc] initWithContentsOfFile:[documentPath stringByAppendingPathComponent:@"user.status"]];
    
    m_PhoneNumber = [plumberArr objectAtIndex:0];
    m_UserName = [plumberArr objectAtIndex:1];
}


- (void)dealloc {
	[tabViewController release];
	[accounts release];
    [m_AccountID release];
    [super dealloc];
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar
        shouldPopItem:(UINavigationItem *)item{
    return FALSE;
}

#pragma mark AddUserViewDelegate methods

- (void) savePhoneNumber:(NSString *)phonenumber{
    NSLog(@"save phone: %@", phonenumber);
    if( m_userid == -1)
    {
        m_PhoneNumber = phonenumber;
        [self saveParameter];
        m_userid = [self loginServer];
        NSArray *array = [self fetchRelationships:m_userid];//[[NSArray alloc] initWithObjects:@"find friends",@"Jerry", @"Raymond", @"John", nil];
        self.accounts = array;
        //[array release];
    }else
    {
        //add user for contact list
        [self addRelationships:m_userid phonenumber:phonenumber];
        [self fetchRelationships:m_userid];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
//
//  LocalPushAppDelegate.m
//  LocalPush
//
/*
@interface ToDoItem : NSObject  {
    NSInteger year;
    NSInteger month;
    NSInteger day;
    NSInteger hour;
    NSInteger minute;
    NSInteger second;
    NSString *eventName;
}

@property (nonatomic, readwrite) NSInteger year;
@property (nonatomic, readwrite) NSInteger month;
@property (nonatomic, readwrite) NSInteger day;
@property (nonatomic, readwrite) NSInteger hour;
@property (nonatomic, readwrite) NSInteger minute;
@property (nonatomic, readwrite) NSInteger second;
@property (nonatomic, copy) NSString *eventName;

@end

@implementation ToDoItem

@synthesize year, month, day, hour, minute, second, eventName;

@end

#import "LocalPushAppDelegate.h"

@implementation LocalPushAppDelegate

@synthesize window;

#define ToDoItemKey @"EVENTKEY1"
#define MessageTitleKey @"MSGKEY1"


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    NSLog(@"application: didFinishLaunchingWithOptions:");
    // Override point for customization after application launch
    
    UILocalNotification *localNotif = [launchOptions
                                       objectForKey:UIApplicationLaunchOptionsLocalNotificationKey]; 
    
    if (localNotif) {
        NSString *itemName = [localNotif.userInfo objectForKey:ToDoItemKey]; 
        //  [viewController displayItem:itemName]; // custom method 
        application.applicationIconBadgeNumber = localNotif.applicationIconBadgeNumber-1; 
        NSLog(@"has localNotif %@",itemName);
    }
    else {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        NSDate *now = [NSDate date];
        NSLog(@"now is %@",now);
        NSDate *scheduled = [now dateByAddingTimeInterval:120] ; //get x minute after
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        unsigned int unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit;
        NSDateComponents *comp = [calendar components:unitFlags fromDate:scheduled];
        
        NSLog(@"scheduled is %@",scheduled);
        
        ToDoItem *todoitem = [[ToDoItem alloc] init];
        
        todoitem.day = [comp day];
        todoitem.month = [comp month];
        todoitem.year = [comp year];
        todoitem.hour = [comp hour];
        todoitem.minute = [comp minute];
        todoitem.eventName = @"Testing Event";
        
        [self scheduleNotificationWithItem:todoitem interval:1];
        NSLog(@"scheduleNotificationWithItem");
    }
    [window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notif {
    NSLog(@"application: didReceiveLocalNotification:");
    NSString *itemName = [notif.userInfo objectForKey:ToDoItemKey];
    NSString *messageTitle = [notif.userInfo objectForKey:MessageTitleKey];
    // [viewController displayItem:itemName]; // custom method 
    [self _showAlert:itemName withTitle:messageTitle];
    NSLog(@"Receive Local Notification while the app is still running...");
    NSLog(@"current notification is %@",notif);
    application.applicationIconBadgeNumber = notif.applicationIconBadgeNumber-1; 
    
}

- (void) _showAlert:(NSString*)pushmessage withTitle:(NSString*)title
{
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:pushmessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    if (alertView) { 
        [alertView release]; 
    }
}


- (void)scheduleNotificationWithItem:(ToDoItem *)item interval:(int)minutesBefore {
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setDay:item.day];
    [dateComps setMonth:item.month];
    [dateComps setYear:item.year];
    [dateComps setHour:item.hour];
    [dateComps setMinute:item.minute];
    NSDate *itemDate = [calendar dateFromComponents:dateComps];
    [dateComps release];
    
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    localNotif.fireDate = [itemDate dateByAddingTimeInterval:-(minutesBefore*60)];
    NSLog(@"fireDate is %@",localNotif.fireDate);
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotif.alertBody = [NSString stringWithFormat:NSLocalizedString(@"%@ in %i minutes.", nil),
                            item.eventName, minutesBefore];
    localNotif.alertAction = NSLocalizedString(@"View Details", nil);
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    //  NSDictionary *infoDict = [NSDictionary dictionaryWithObject:item.eventName forKey:ToDoItemKey];
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:item.eventName,ToDoItemKey, @"Local Push received while running", MessageTitleKey, nil];
    localNotif.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    NSLog(@"scheduledLocalNotifications are %@", [[UIApplication sharedApplication] scheduledLocalNotifications]);
    [localNotif release];
}

- (NSString *) checkForIncomingChat {
    return @"javacom";
};

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"Application entered background state.");
    // UIBackgroundTaskIdentifier bgTask is instance variable
    // UIInvalidBackgroundTask has been renamed to UIBackgroundTaskInvalid
    NSAssert(self->bgTask == UIBackgroundTaskInvalid, nil);
    
    bgTask = [application beginBackgroundTaskWithExpirationHandler: ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [application endBackgroundTask:self->bgTask];
            self->bgTask = UIBackgroundTaskInvalid;
        });
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        while ([application backgroundTimeRemaining] > 1.0) {
            NSString *friend = [self checkForIncomingChat];
            if (friend) {
                UILocalNotification *localNotif = [[UILocalNotification alloc] init];
                if (localNotif) {
                    localNotif.alertBody = [NSString stringWithFormat:
                                            NSLocalizedString(@"%@ has a message for you.", nil), friend];
                    localNotif.alertAction = NSLocalizedString(@"Read Msg", nil);
                    localNotif.soundName = @"alarmsound.caf";
                    localNotif.applicationIconBadgeNumber = 1;
                    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Your Background Task works",ToDoItemKey, @"Message from javacom", MessageTitleKey, nil];
                    localNotif.userInfo = infoDict;
                    [application presentLocalNotificationNow:localNotif];
                    [localNotif release];
                    friend = nil;
                    break;
                }
            }
        }
        [application endBackgroundTask:self->bgTask];
        self->bgTask = UIBackgroundTaskInvalid;
    });
}


- (void)dealloc {
    [window release];
    [super dealloc];
}
*/

@end

