//
//  ChatViewController.m
//  ChatMe
//
//  Created by Emerson Malca on 6/24/11.
//  Copyright 2011 OneZeroWare. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "ChatViewController.h"
#import "MessageTableViewCell.h"
#import "Message.h"
#import "Contact.h"
#import "Play.h"
#import "Quotation.h"
#import "Common.h"
#import "Dialog.h"
#import "OrderedDictionary.h"

/*
#import "Contact.h"
#import "ChatMeUser.h"
#import "Message.h"
#import "ChatMeService.h"
#import "MessageTableViewCell.h"
#import "Common.h"
*/


@interface ChatViewController (Private) 

#define DEFAULT_ROW_HEIGHT 78
#define HEADER_HEIGHT 20
//- (void)configureCell:(MessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)dismissKeyboardIfNeeded;
- (void)registerForKeyboardNotifications;

@end

@implementation ChatViewController

//@synthesize fetchedResultsController=__fetchedResultsController;
@synthesize tableView=_tableView;
@synthesize bubbleView=_bubbleView;
@synthesize contact=_contact;
@synthesize listOfItems=_listOfItems;
@synthesize sectionInfoArray;
@synthesize openSectionIndex;
@synthesize m_Messages;
@synthesize m_dstid;
@synthesize m_srcid;
@synthesize m_DstName;
@synthesize m_DicMessages;
@synthesize m_Quest;
@synthesize audioRecorder;


NSString *downloadfilename;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"History", @"History");
        self.tabBarItem.image = [UIImage imageNamed:@"search"];
    }
    return self;
}

- (IBAction)startRecording:(id)sender
{
    [audioRecorder startRecording];
}
- (IBAction)stopRecording:(id)sender
{
    [audioRecorder stopRecording];
	[audioRecorder release];
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
}
- (void)dealloc
{
    //[__fetchedResultsController release];
    self.contact = nil;
    [_listOfItems release];
    [sectionInfoArray release];
    [m_DicMessages release];
    [m_Messages release];
    [m_Quest release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if( m_DicMessages == nil)
        m_DicMessages = [[NSMutableDictionary alloc] init];
    if( m_Quest == nil)
    {
        m_Quest = [[RKRequestQueue alloc] init];
        m_Quest.delegate = self;
        m_Quest.concurrentRequestsLimit = 1;
        m_Quest.showsNetworkActivityIndicatorWhenBusy = YES;
    }
    m_Messages = [[NSMutableArray alloc] init];
    
    self.title = m_DstName;
    //self.tableView.allowsSelection = NO;
    //Position the bubbleView on the bottom
    [self.view addSubview:self.bubbleView];
    CGRect bubbleFrame = self.bubbleView.frame;
    bubbleFrame.origin.y = CGRectGetHeight(self.view.frame) - CGRectGetHeight(bubbleFrame);
    [self.bubbleView setFrame:bubbleFrame];
    self.bubbleView.view = self.view;
    [self.bubbleView setDelegate:self];
    //[self fetchMessages:1 ];
    //[self sendMessages:1 ];
    //Scroll to the bottom
    
    //NSArray *messages = [self.fetchedResultsController fetchedObjects];
    //Initialize the array.
    _listOfItems = [[NSMutableArray alloc] init];
    
    //NSMutableArray *countriesToLiveInArray = [NSMutableArray arrayWithObjects:@"Iceland", @"Greenland", @"Switzerland", @"Norway", @"New Zealand", @"Greece", @"Rome", @"Ireland", nil];
    //NSDictionary *countriesToLiveInDict = [NSDictionary dictionaryWithObject:countriesToLiveInArray forKey:@"Countries"];
    
    
    //NSMutableArray *countriesLivedInArray = m_Messages;
    //NSDictionary *countriesLivedInDict = [NSDictionary dictionaryWithObject:countriesLivedInArray forKey:@"Messages"];
    
    sectionInfoArray = [[NSMutableArray alloc] init];
    NSArray *keys = [m_DicMessages allKeys];
    int count = [keys count];
    for (int i = 0; i < count; i++)
    {
        id key = [keys objectAtIndex: i];
        SectionInfo *sectionInfo = [[SectionInfo alloc] init];			
        sectionInfo.open = NO;
        sectionInfo.header = key;
        [self.sectionInfoArray addObject:sectionInfo];
        [sectionInfo release];
        //[_listOfItems addObject:countriesLivedInDict];
    }
    //[_listOfItems addObject:countriesToLiveInDict];
    //NSDate *today = [NSDate date];
    //NSDateFormatter *format = [[NSDateFormatter alloc] init];
    //[format setDateFormat:@"yyyy-MM-dd"];
    //NSString *todayString = [format stringFromDate:today];
    
    
    // Ask RestKit to spin the network activity indicator for us
    //client.requestQueue.delegate = self;
    //client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    
    //self.navigationController.navigationBar.delegate = self;
    //Set the title
    //self.navigationItem.title = @"Countries";
    //NSArray *messages = [[NSArray alloc] initWithObjects:@"find friends",@"Jerry", @"Raymond", @"John", nil];
    /* 
    if ([messages count] > 1) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-2 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }*/
    
    audioRecorder = [[[AudioRecorder	alloc] init] retain];
}

- (id) initWithRelation: (int) srcid DstID:(int) dstid {
    //[self initWithNibName:@"vwChatViewController" bundle:nil];
    [super initWithNibName:@"vwChatViewController" bundle:Nil];
    if (self) {
        self.title = NSLocalizedString(@"Contacts", @"Contacts");
        self.tabBarItem.image = [UIImage imageNamed:@"search"];
    }
    return self;
    NSLog(@"initWithDstName");
    //m_DicMessages = [[NSMutableDictionary alloc] init ];
    if( m_DicMessages == nil)
        m_DicMessages = [[NSMutableDictionary alloc] init];
    if( m_Quest == nil)
    {
        m_Quest = [[RKRequestQueue alloc] init];
        m_Quest.delegate = self;
        m_Quest.concurrentRequestsLimit = 1;
        m_Quest.showsNetworkActivityIndicatorWhenBusy = YES;
    }
    RKClient* client = [RKClient clientWithBaseURL:@"http://www.entalkie.url.tw"];
    [RKClient setSharedClient:client];
    m_srcid = srcid;
    m_dstid = dstid;
    [self fetchMessages:srcid DstID:dstid Messages:m_DicMessages];
    return self;
    
}

- (void) ScanMessages {
    NSLog(@"Scan Messages!!");
    [self fetchMessages:m_srcid DstID:m_dstid Messages:m_DicMessages];
    //NSMutableArray *countriesLivedInArray = m_Messages;
    //NSDictionary *countriesLivedInDict = [NSDictionary dictionaryWithObject:countriesLivedInArray forKey:@"Messages"];
    //[_listOfItems replaceObjectAtIndex:0 withObject:countriesLivedInDict];
    //[_listOfItems addObject:countriesLivedInDict];
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    //[[RKClient sharedClient].requestQueue cancelRequestsWithDelegate:self];
    //[_queue cancelAllRequests];
    //[_queue release];
    self.bubbleView = nil;
    self.tableView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"Contacts", @"Contacts");
    myTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(ScanMessages) userInfo:nil repeats:YES];
    
    /*
     Check whether the section info array has been created, and if so whether the section count still matches the current section count. In general, you need to keep the section info synchronized with the rows and section. If you support editing in the table view, you need to appropriately update the section info during editing operations.
     */
    /*
	if ((self.sectionInfoArray == nil) || ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:self.tableView])) {
		
        // For each play, set up a corresponding SectionInfo object to contain the default height for each row.
		NSMutableArray *infoArray = [[NSMutableArray alloc] init];
		
		for (Play *play in self.plays) {
			
			SectionInfo *sectionInfo = [[SectionInfo alloc] init];			
			sectionInfo.play = play;
			sectionInfo.open = NO;
			
            NSNumber *defaultRowHeight = [NSNumber numberWithInteger:DEFAULT_ROW_HEIGHT];
			NSInteger countOfQuotations = [[sectionInfo.play quotations] count];
			for (NSInteger i = 0; i < countOfQuotations; i++) {
				[sectionInfo insertObject:defaultRowHeight inRowHeightsAtIndex:i];
			}
			
			[infoArray addObject:sectionInfo];
			[sectionInfo release];
		}
		
		self.sectionInfoArray = infoArray;
		[infoArray release];
	}
     */
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    
    /*
     Create the section header views lazily.
     */
	SectionInfo *sectionInfo = [sectionInfoArray objectAtIndex:section];
    if (!sectionInfo.headerView) {
		//NSString *playName = sectionInfo.play.name;
        sectionInfo.headerView = [[[SectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, HEADER_HEIGHT) title:sectionInfo.header section:section delegate:self] autorelease];
    }
    
    return sectionInfo.headerView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //Set all unseen messages to seen (if any)
    /*
    ChatMeUser *currentUser = [[ChatMeService sharedChatMeService] currentUser];
    for (Message *message in currentUser.receivedMessages) {
        if ([message.seenByRecepient boolValue] == NO && message.fromUser == self.contact.contactUser) {
            [message setSeenByRecepient:[NSNumber numberWithBool:YES]];
        }
    }
    */
    //[currentUser.managedObjectContext save:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [myTimer invalidate];
    self.sectionInfoArray = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [m_DicMessages count];//[_listOfItems count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //Number of rows it should expect should be based on the section
    //[m_DicMessages ob
    //NSDictionary *dictionary = [_listOfItems objectAtIndex:section];
    SectionInfo *tmpSect = [sectionInfoArray objectAtIndex:section];
    NSDictionary *dic = [m_DicMessages objectForKey:tmpSect.header];
    
    NSLog(@"%d %d %@",[dic count], tmpSect.open, tmpSect.header);
    return tmpSect.open?[dic count]:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    MessageTableViewCell *cell = (MessageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    for (NSInteger ko=0; ko<[[cell subviews] count]; ko++){
        //This code never gets hit
        UIView *l=[[cell subviews] objectAtIndex:0];
        [l removeFromSuperview];
        l=nil;
    }
    // Set up the cell...
    
	//NSString *imagefile = [[NSBundle mainBundle] pathForResource:@"userWaldo" ofType:@"png"];
	//UIImage *ui= [[UIImage alloc] initWithContentsOfFile:imagefile];
    //First get the dictionary object
    //NSDictionary *dictionary = [_listOfItems objectAtIndex:indexPath.section];
    //NSArray *array = [dictionary objectForKey:@"Messages"];
    //NSArray *elementArr = [array objectAtIndex:indexPath.row];
    //NSString *cellValue = [elementArr objectAtIndex:0];
    //[cell.textLabel setText:cellValue];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    
    return cell;
}
- (void) fetchMessages:(int) srcid DstID:(int)dstid Messages:(NSMutableDictionary *)srcMessages{
    NSDate *today = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    
    NSString *todayString = [format stringFromDate:today];
    
    NSDateComponents *dayComponent = [[[NSDateComponents alloc] init] autorelease];
    dayComponent.day = 1;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *dateToBeIncremented = [theCalendar dateByAddingComponents:dayComponent toDate:today options:0];
    NSString *tomorrowString = [format stringFromDate:dateToBeIncremented];
    NSString *urlString = [NSString stringWithFormat:@"http://www.entalkie.url.tw/getMessages.php"];
    NSString *postString = [NSString stringWithFormat:@"srcID=%d&dstID=%d&fromdate=%@&todate=%@",srcid,dstid,todayString,tomorrowString];
    //NSString *urlString = @"http://www.entalkie.url.tw/getRelationships.php?masterID=1";
    NSData *data = [DBHandler sendReqToUrl:urlString postString:postString];
    NSArray *array = nil;
    
    NSMutableArray *ret = [[NSMutableArray alloc] init ];
    
    if(data)
    {
        NSString *responseString = [[NSString alloc] initWithData:data
                                                         encoding:NSUTF8StringEncoding];
        array = [responseString JSONValue];
        [responseString release];
    }
    //[ret addObject:todayString];
    for (NSDictionary *dic in array) {
        NSMutableArray *element = [[NSMutableArray alloc] init ];
        NSString *tmpDate = [dic objectForKey:@"DIALOG_CREATEDTIME"];
        NSDateFormatter *tmpformat = [[NSDateFormatter alloc] init];
        [tmpformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        //NSDate *tmp = [tmpformat dateFromString:tmpDate];
        
        tmpDate = [format stringFromDate:[tmpformat dateFromString:tmpDate]];
        [tmpformat release];
        if( [srcMessages objectForKey:tmpDate] != nil )
        {
            OrderedDictionary *tmpDic = [srcMessages objectForKey:tmpDate];
            if([tmpDic objectForKey:[dic objectForKey:@"DIALOG_ID"]] != nil)
            {
                
            }else
            {
                Dialog *element = [[Dialog alloc] init];
                element.m_Dialog_ID = [[dic objectForKey:@"DIALOG_ID"] intValue];
                element.m_Dialog_Type = [[dic objectForKey:@"DIALOG_TYPE"] intValue];
                element.m_Dialog_Voice = [dic objectForKey:@"DIALOG_VOICE"];
                element.m_Dialog_Encrypt  = [dic objectForKey:@"DIALOG_VOICE_ENCRYPT"];
                element.m_Dialog_Message = [dic objectForKey:@"DIALOG_MESSAGE"];
                element.m_Created_Time = [dic objectForKey:@"DIALOG_CREATEDTIME"];
                element.m_Dialog_SourceID = [[dic objectForKey:@"DIALOG_SOURCEID"] intValue];
                element.m_Dialog_DstID = [[dic objectForKey:@"DIALOG_DESTINATIONID"] intValue];
                if( element.m_Dialog_Type == 1)
                    [self queueRequests:element.m_Dialog_Voice];
                else
                    [self queueRequests:element.m_Dialog_Encrypt];

                [tmpDic setObject:element forKey:[dic objectForKey:@"DIALOG_ID"]];
                [element release];
            }
        }else
        {
            OrderedDictionary *tmpDic = [[OrderedDictionary alloc] init];
            Dialog *element = [[Dialog alloc] init];
            element.m_Dialog_ID = [[dic objectForKey:@"DIALOG_ID"] intValue];
            element.m_Dialog_Type = [[dic objectForKey:@"DIALOG_TYPE"] intValue];
            element.m_Dialog_Voice = [dic objectForKey:@"DIALOG_VOICE"];
            element.m_Dialog_Encrypt  = [dic objectForKey:@"DIALOG_VOICE_ENCRYPT"];
            element.m_Dialog_Message = [dic objectForKey:@"DIALOG_MESSAGE"];
            element.m_Created_Time = [dic objectForKey:@"DIALOG_CREATEDTIME"];
            element.m_Dialog_SourceID = [[dic objectForKey:@"DIALOG_SOURCEID"] intValue];
            element.m_Dialog_DstID = [[dic objectForKey:@"DIALOG_DESTINATIONID"] intValue];
                
            if( element.m_Dialog_Type == 1)
                [self queueRequests:element.m_Dialog_Voice];
            else
                [self queueRequests:element.m_Dialog_Encrypt];
            [tmpDic setObject:element forKey:[dic objectForKey:@"DIALOG_ID"]];
            [element release];
            [srcMessages setObject:tmpDic forKey:tmpDate];
            [tmpDic release];
        }
        if( [[dic objectForKey:@"DIALOG_TYPE"] integerValue] == 0)
        {
            [element addObject: [dic objectForKey:@"DIALOG_MESSAGE"]];
        }
        else
        {
            //to download the voice file
            NSLog(@"encrypt %@", [dic objectForKey:@"DIALOG_VOICE_ENCRYPT"]);
            if( ![(NSString *)[dic objectForKey:@"DIALOG_VOICE_ENCRYPT"] isEqualToString:@""])
            {
                //downloadfilename = [dic objectForKey:@"DIALOG_VOICE_ENCRYPT"];
                //[self downloadToFile:[dic objectForKey:@"DIALOG_VOICE_ENCRYPT"]];
                
                [element addObject: [dic objectForKey:@"DIALOG_VOICE_ENCRYPT"]];
            }else
            {
                //downloadfilename = [dic objectForKey:@"DIALOG_VOICE"];
                //[self downloadToFile:[dic objectForKey:@"DIALOG_VOICE"]];
                
                [element addObject: [dic objectForKey:@"DIALOG_VOICE"]];
            }
        }
        [element addObject: [dic objectForKey:@"DIALOG_CREATEDTIME"]];
        [element addObject: [dic objectForKey:@"DIALOG_SOURCEID"]];
        [element addObject: [dic objectForKey:@"DIALOG_DESTINATIONID"]];
        [ret addObject:element];
        [element release];
    }
    [m_Quest start];
    //[ret addObject:nil];
    //NSMutableArray *retArr = [[NSMutableArray alloc ]initWithArray:ret];
    //[ret release];
    
    //return retArr;
}
- (void)configureCell:(MessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    //ChatMeUser *currentUser = [[ChatMeService sharedChatMeService] currentUser];
    //NSDictionary *dictionary = [_listOfItems objectAtIndex:indexPath.section];
    SectionInfo *sect =[sectionInfoArray objectAtIndex:indexPath.section];
    NSDictionary *dictionary = [m_DicMessages objectForKey:sect.header];
    NSEnumerator *enumerator = [dictionary keyEnumerator];
    id key;
    int index = 0;
    Dialog *tmpDialog, *prevDialog;
    while ((key = [enumerator nextObject])) {
        tmpDialog = [dictionary objectForKey:key];
        if( index == indexPath.row)
            break;
        index++;
        prevDialog = [dictionary objectForKey:key];
    }
    //NSArray *array = [dictionary objectForKey:@"Messages"];
    //NSArray *elementArr = [array objectAtIndex:indexPath.row];
    NSString *cellValue;
    if( tmpDialog.m_Dialog_Type == 1)
    {
        if( [tmpDialog.m_Dialog_Encrypt length]!= 0)
            cellValue = tmpDialog.m_Dialog_Encrypt;
        else
            cellValue = tmpDialog.m_Dialog_Voice;
    }else
        cellValue = tmpDialog.m_Dialog_Message;
    Message *message = [[Message alloc] init];
    
    message.text = cellValue;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [dateFormat dateFromString:tmpDialog.m_Created_Time];
    [dateFormat setDateFormat:@"a h:mm "];
    NSString *str = [dateFormat stringFromDate:date]; 
    [dateFormat release];
    
    message.sentDate = date;
    message.srcUser = tmpDialog.m_Dialog_SourceID;
    message.dstUser = tmpDialog.m_Dialog_DstID;
    NSLog(@"cellvalue: %@", cellValue);
    [cell setText:cellValue];
    cell.m_date = str;
    //We only set the image if the previous message was from a different user
    BOOL showImage = (indexPath.row == 0);
    if (indexPath.row != 0) {
        //NSDictionary *dictionary = [_listOfItems objectAtIndex:indexPath.section];
        //NSArray *array = [dictionary objectForKey:@"Messages"];
        //NSArray *elementArr = [array objectAtIndex:indexPath.row-1];
        if (prevDialog.m_Dialog_SourceID != message.srcUser) {
            showImage = YES;
        }
        /*
        Message *prev = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section]];
        if (prev.fromUser != message.fromUser) {
            showImage = YES;
        }*/
    }
    //NSString *myImagePath =  [[NSBundle mainBundle] pathForResource:@"userWaldo" ofType:@"png"];
    UIImage *userImg = [UIImage imageNamed:@"userWaldo.png"];
    if (showImage) {
        //[cell setImage:userImg];
    } else {
        [cell setImage:nil];
    }
    userImg = nil;
    //[cell setMessageAlignment:kMessageAlignmentLeft];
    
    //Also, if fromUser is us (currentUser) we align it to the left, right otherwise
    CGRect frame;
    NSLog(@"srcUser: %d", message.srcUser);
    if (message.srcUser == m_srcid) {
        [cell setMessageAlignment:kMessageAlignmentLeft];
        frame = CGRectMake(85.0, 15.0, 150.0, 5.0);
    } else {
        [cell setMessageAlignment:kMessageAlignmentRight];
        frame = CGRectMake(85.0, 15.0, 150.0, 5.0);
    }
    [message release];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setNeedsDisplay];
    
    NSRange aRange = [cellValue rangeOfString:@"aif"];
    if (aRange.location ==NSNotFound  ) {
    } else {
        NSLog(@" %@ %d ",cellValue, aRange.location);
        CGRect btnViewFrame = CGRectMake(55.0, 25.0,16.0,16.0);
        UIButton *settingBtn = [[UIButton alloc] initWithFrame:btnViewFrame];
        UIImage *snap_picture = [UIImage imageNamed:@"arrow-right.png"];
        [settingBtn setBackgroundImage:snap_picture forState:UIControlStateNormal];
        //[settingBtn addTarget:self action:@selector(playVoice:) forControlEvents:UIControlEventTouchUpInside];
        settingBtn.tag = 2;
        [settingBtn setEnabled:NO];
        [cell addSubview:settingBtn];
        [settingBtn release];
        
        
        UISlider *slider = [[UISlider alloc] initWithFrame:frame];
        //[slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        [slider setBackgroundColor:[UIColor clearColor]];
        slider.minimumValue = 0.0;
        slider.maximumValue = 50.0;
        slider.continuous = YES;
        slider.value = 0.0;
        slider.enabled = NO;
        [cell addSubview:slider];
        [slider release];
    }
    
}



#pragma mark - Table view delegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
    SectionInfo *sect = [self.sectionInfoArray objectAtIndex:section];
    return sect.header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //return 20;
    //NSDictionary *dictionary = [_listOfItems objectAtIndex:indexPath.section];
    //NSArray *array = [dictionary objectForKey:@"Messages"];
    //NSArray *elementArr = [array objectAtIndex:indexPath.row];
    SectionInfo *sect =[sectionInfoArray objectAtIndex:indexPath.section];
    NSDictionary *dictionary = [m_DicMessages objectForKey:sect.header];
    NSEnumerator *enumerator = [dictionary keyEnumerator];
    id key;
    int index = 0;
    Dialog *tmpDialog;
    while ((key = [enumerator nextObject])) {
        tmpDialog = [dictionary objectForKey:key];
        if( index == indexPath.row)
            break;
        index++;
    }

    NSLog(@"index path %d",indexPath.row);
    NSString *cellValue = tmpDialog.m_Dialog_Message;
    //Message *message = [_listOfItems objectAtIndex:indexPath.section];
    
    CGRect textRect = CGRectMake(0.0, 0.0, tableView.frame.size.width - kMessageSideSeparation*2 - kMessageImageWidth - kMessageBigSeparation, kMaxHeight);
    UIFont *font = [UIFont systemFontOfSize:16.0];
    CGSize textSize = [cellValue sizeWithFont:font constrainedToSize:textRect.size lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat effectiveHeight = textSize.height + kMessageTopSeparation*2;
    //Check the minimum
    if (effectiveHeight < tableView.rowHeight) {
        effectiveHeight = tableView.rowHeight;
    }
    
    return effectiveHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected row:%d",indexPath.row);
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //NSDictionary *dictionary = [_listOfItems objectAtIndex:indexPath.section];
    //NSArray *array = [dictionary objectForKey:@"Messages"];
    //NSArray *elementArr = [array objectAtIndex:indexPath.row];
    SectionInfo *sect =[sectionInfoArray objectAtIndex:indexPath.section];
    NSDictionary *dictionary = [m_DicMessages objectForKey:sect.header];
    NSEnumerator *enumerator = [dictionary keyEnumerator];
    id key;
    int index = 0;
    Dialog *tmpDialog;
    while ((key = [enumerator nextObject])) {
        tmpDialog = [dictionary objectForKey:key];
        if( index == indexPath.row)
            break;
        index++;
    }
    NSString *cellValue;
    if( tmpDialog.m_Dialog_Type == 1)
    {
        if( [tmpDialog.m_Dialog_Encrypt length]!= 0)
            cellValue = [NSString stringWithFormat:@"%@", tmpDialog.m_Dialog_Encrypt];
        else
            cellValue = [NSString stringWithFormat:@"%@", tmpDialog.m_Dialog_Voice];
    }else
        return;
    //NSString *cellValue = [NSString stringWithFormat:@"%@/%@", [Util getDocumentPath], tmpDialog.m_Dialog_Message];
    NSLog(@"play selected value:%@",cellValue);
    NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@", [Util getDocumentPath], cellValue]] ) 
    {
        downloadfilename = cellValue;
        [downloadfilename retain];
        [self downloadToFile:cellValue];
    }else
    {
        [self playSound:cellValue];
    }
    //[self playSound:[elementArr objectAtIndex:0]];
}

#pragma mark -
#pragma mark Keyboard notifications

- (void)dismissKeyboardIfNeeded {
    if ([self.bubbleView.messageTextView canResignFirstResponder]) {
        [self.bubbleView.messageTextView resignFirstResponder];
    }
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications {
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification*)aNotification {
    CGRect tableFrame  = self.tableView.frame, keyboardFrame;
	CGRect normalizedTableFrame = [self.view convertRect:tableFrame toView:[UIApplication sharedApplication].keyWindow];
	
    [[aNotification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardFrame];
	
	CGRect intersection = CGRectIntersection(normalizedTableFrame, keyboardFrame);
	
	tableFrame.size.height -= intersection.size.height;
    
    //Take the bubble view into consideration
    tableFrame.size.height -= self.bubbleView.frame.size.height;
    
    CGRect bubbleFrame = self.bubbleView.frame;
    bubbleFrame.origin.y = CGRectGetMaxY(tableFrame);
    
    [UIView animateWithDuration:0.3 
                     animations:^ {
                         self.tableView.frame = tableFrame;
                         self.bubbleView.frame = bubbleFrame;
                     }
                     completion:^(BOOL finished){
                         //Scroll to the bottom
                         NSUInteger num = [self.tableView numberOfRowsInSection:0];
                         if (num>0) {
                             [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:num-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                         }
                     }];
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
    
    CGRect tableFrame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height - self.bubbleView.frame.size.height);
    
    CGRect bubbleFrame = self.bubbleView.frame;
    bubbleFrame.origin.y = CGRectGetMaxY(tableFrame);
    
    [UIView animateWithDuration:0.3 
                     animations:^ {
                         self.tableView.frame = tableFrame;
                         self.bubbleView.frame = bubbleFrame;
                     }];
}

- (NSArray*) sendMessages:(NSString *) message {
    NSString *urlString = [NSString stringWithFormat:@"http://www.entalkie.url.tw/sendMessages.php"];
    NSString *postString = [NSString stringWithFormat:@"srcID=%d&dstID=%d&type=0&message=%@",m_srcid,m_dstid,message];
    //NSString *urlString = @"http://www.entalkie.url.tw/getRelationships.php?masterID=1";
    NSData *data = [DBHandler sendReqToUrl:urlString postString:postString];
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

#pragma mark -
#pragma mark NSURLConnection methods
NSMutableData *tempData;    //下載時暫存用的記憶體
long expectedLength;        //檔案大小
NSURLConnection* connection;


- (void)downloadToFile:(NSString *)filename
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
    NSString* filePath = [NSString stringWithFormat:@"http://www.entalkie.url.tw/download.php?filename=%@", filename];
    NSLog(@"%@",filename);
    [request setURL:[NSURL URLWithString:filePath]];
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
    
    //double ex = expectedLength;
    //downloadProgress.progress = [tempData length] / ex;;
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{   //檔案下載完成
    //取得可讀寫的路徑
	//NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	//NSString *path = [pathList objectAtIndex:0];
    NSString *documentsPath = [Util getDocumentPath];
	//加上檔名
	documentsPath = [documentsPath stringByAppendingPathComponent: downloadfilename];
    NSLog(@"儲存路徑：%@", documentsPath);
	
	//寫入檔案
    [tempData writeToFile:documentsPath atomically:NO];
    [tempData release];
    tempData = nil;
    [self playSound:downloadfilename];
    [downloadfilename autorelease];
    //img.image = [UIImage imageWithContentsOfFile:path]; //顯示圖片在畫面中
}

- (void) playSound:(NSString *) filename {
	/*NSLog(@"Playing Sound!");
     [audioRecorder startPlayback];*/
	//system("ls");
    

	SystemSoundID soundID = 0;
	//NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	//NSString *documentsPath = [Util getDocumentPath];
	//NSString *audioPath = [documentsPath stringByAppendingPathComponent:filename];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", [Util getDocumentPath],filename];
    NSLog(@"play %@",filePath);
	//NSString *filePath = [[NSBundle mainBundle] resourcePath];// stringByAppendingPathComponent:@"123.wav"];

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


#pragma mark ChatBubbleViewDelegate methods

- (void)chatBubbleView:(ChatBubbleView *)bubbleView willResizeToHeight:(CGFloat)newHeight {
    
    //Resize the table accordingly
    CGFloat tableHeight = CGRectGetMaxY(self.bubbleView.frame) - newHeight;
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height = tableHeight;
    
    [UIView animateWithDuration:0.3 
                     animations:^ {
                         self.tableView.frame = tableFrame;
                     }];
}

- (void)chatBubbleView:(ChatBubbleView *)bubbleView willSendText:(NSString *)message {
    
    if (message && [message length] > 0) {
        [self sendMessages:message];
        /*
        //Update the contact's last message
        [self.contact setLastCommunicationText:message];
        NSDictionary *oldDic = [_listOfItems objectAtIndex:1];
        NSMutableArray *oldArray = [oldDic objectForKey:@"Messages"];
        [oldArray addObject:message];
         */
        [self ScanMessages];
        //Send to server
        //ChatMeUser *currentUser = [[ChatMeService sharedChatMeService] currentUser];
        //[[ChatMeService sharedChatMeService] sendMessage:message fromUser:currentUser toUser:self.contact.contactUser];
    }
}

#pragma mark - Fetched results controller
#if 0
- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil)
    {
        return __fetchedResultsController;
    }
    
    /*
     Set up the fetched results controller.
     */
    //NSManagedObjectContext *context = self.contact.managedObjectContext;
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    //NSEntityDescription *entity = [NSEntityDescription entityForName:@"Message" inManagedObjectContext:context];
    //[fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:10];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sentDate" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    //Set the predicate
    //ChatMeUser *currentUser = [[ChatMeService sharedChatMeService] currentUser];
    //ChatMeUser *contactUser = self.contact.contactUser;
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(fromUser == %@ && toUser == %@) || (fromUser == %@ && toUser == %@)", currentUser, contactUser, contactUser, currentUser];
    //[fetchRequest setPredicate:predicate];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    //NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    //aFetchedResultsController.delegate = self;
    //self.fetchedResultsController = aFetchedResultsController;
    
    //[aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error])
    {
	    /*
	     Replace this implementation with code to handle the error appropriately.
         
	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}    
#endif
#pragma mark - Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    switch(type)
    {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(MessageTableViewCell*)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
    
    //Scroll to the bottom
    NSUInteger num = [self.tableView numberOfRowsInSection:0];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:num-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}


-(void)textFieldDidEndEditing:(UITextField *)textField {
	NSLog(@"prepare to hide keyboard");
	//scrollView.frame = CGRectMake(0,44,320,416); //original setup
}

#pragma mark Section header delegate

-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)sectionOpened {
	
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionOpened];
	
	sectionInfo.open = YES;
    
    //[self.sectionInfoArray replaceObjectAtIndex:sectionOpened withObject:sectionInfo];
    
    /*
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     */
    //NSDictionary *dictionary = [_listOfItems objectAtIndex:sectionOpened];
    //NSArray *array = [dictionary objectForKey:@"Messages"];
    NSLog(@"%@", [sectionInfoArray objectAtIndex:sectionOpened]);
    NSDictionary *dictionary = [m_DicMessages objectForKey:sectionInfo.header ];
    NSEnumerator *enumerator = [m_DicMessages keyEnumerator];
    id key;
    int index = 0;
    Dialog *tmpDialog;
    while ((key = [enumerator nextObject])) {
        tmpDialog = [dictionary objectForKey:key];
    }

    NSInteger countOfRowsToInsert = [dictionary count];
    //NSString *cellValue = [elementArr objectAtIndex:0];

    //NSInteger countOfRowsToInsert = [sectionInfo.play.quotations count];
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    /*
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     */
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound && previousOpenSectionIndex != sectionOpened) {
		
		SectionInfo *previousOpenSection = [self.sectionInfoArray objectAtIndex:previousOpenSectionIndex];
        previousOpenSection.open = NO;
        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = [previousOpenSection.play.quotations count];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    
    // Style the animation so that there's a smooth flow in either direction.
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // Apply the updates.
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.tableView endUpdates];
    self.openSectionIndex = sectionOpened;
    
    [indexPathsToInsert release];
    [indexPathsToDelete release];
}


-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)sectionClosed {
    
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionClosed];
	
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [self.tableView numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
        [indexPathsToDelete release];
    }
    self.openSectionIndex = NSNotFound;
}

- (void) audioFdPlay:(NSString *)filePath{
	//NSString *audioFile = [NSString stringWithFormat:@"%@/%@.aif", [Util getDocumentPath], @"recording"];
	//[audioRecorder startPlaybackWithFilepath:audioFile];
	
	//@ Ray added for audio player UI
	
	//int a=0;
	//initialize string to the path of the song in the resource folder
	//NSString *myMusic = [NSString stringWithFormat:@"%@", filePath];
	NSString *stringEscapedMyMusic = [filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	AVAudioPlayer *cellPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:stringEscapedMyMusic] error:NULL];
	cellPlayer.numberOfLoops = 0;
	cellPlayer.volume = .5;
	//timeSlider.maximumValue = player.duration;
	//timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeLoader) userInfo:nil repeats:YES];
	[cellPlayer play];
	[cellPlayer dealloc];
	//==========================
};

#pragma mark VocSendVoiceDelegate methods

- (void) sendVoice:(NSString *)origfilename vocode:(NSString *)vocodefilename pass:(NSString *)password{
    NSString *urlString = [NSString stringWithFormat:@"http://www.entalkie.url.tw/sendMessages.php"];
    NSString *postString = [NSString stringWithFormat:@"srcID=%d&dstID=%d&type=1&orig=%@&vocode=%@",m_srcid,m_dstid,origfilename,vocodefilename];
    //NSString *urlString = @"http://www.entalkie.url.tw/getRelationships.php?masterID=1";
    NSData *data = [DBHandler sendReqToUrl:urlString postString:postString];
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

- (void)queueRequests:(NSString *)filename {
    //NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    NSString* filePath = [NSString stringWithFormat:@"/download.php?filename=%@", filename];
    NSLog(@"%@",filename);
    /*
    [request setURL:[NSURL URLWithString:filePath]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"Mobile Safari 1.1.3 (iPhone; U; CPU like Mac OS X; en)" forHTTPHeaderField:@"User-Agent"];
    tempData = [NSMutableData alloc];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    RKRequestQueue* queue = [[RKRequestQueue alloc] init];
    queue.delegate = self;
    queue.concurrentRequestsLimit = 1;
    queue.showsNetworkActivityIndicatorWhenBusy = YES;
    */
    // Queue up 4 requests
    RKRequest *quest = [[RKClient sharedClient] requestWithResourcePath:filePath delegate:self];
    [m_Quest addRequest:quest];
    //[queue addRequest:[[RKClient sharedClient] requestWithResourcePath:filePath delegate:self]];
    //[queue addRequest:[[RKClient sharedClient] requestWithResourcePath:filePath delegate:self]];
    //[queue addRequest:[[RKClient sharedClient] requestWithResourcePath:filePath delegate:self]];
    
    // Start processing!
    //[queue start];
}

- (void)requestQueue:(RKRequestQueue *)queue didSendRequest:(RKRequest *)request {
    NSLog(@"%@", [NSString stringWithFormat:@"RKRequestQueue %@ is current loading %d of %d requests", 
                         queue, [queue loadingCount], [queue count]]);
}

- (void)requestQueueDidBeginLoading:(RKRequestQueue *)queue {
    NSLog(@"%@",[NSString stringWithFormat:@"Queue %@ Began Loading...", queue]);
}

- (void)requestQueueDidFinishLoading:(RKRequestQueue *)queue {
    NSLog(@"%@", [NSString stringWithFormat:@"Queue %@ Finished Loading...", queue]);
}

- (void)request:(RKRequest *)request didReceivedData:(NSInteger)bytesReceived totalBytesReceived:(NSInteger)totalBytesReceived totalBytesExectedToReceive:(NSInteger)totalBytesExpectedToReceive{
    NSLog(@"%@", [NSString stringWithFormat:@"didReceivedData %d Finished Loading...", bytesReceived]);
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    if ([response isStream]) {
        NSString *documentsPath = [Util getDocumentPath];
        //加上檔名
        NSLog(@"儲存路徑：%@", response.request.URL);
        NSString *tmpurl = [response.request.URL absoluteString];
        NSRange range = [tmpurl rangeOfString:@"=" options:NSBackwardsSearch];
        NSString* fileName = [tmpurl substringFromIndex:range.location + 1];
        documentsPath = [documentsPath stringByAppendingPathComponent: fileName];
    
	
        //寫入檔案
    
        [response.body writeToFile:documentsPath atomically:NO];
        //[tempData release];
        //tempData = nil;
        //[self playSound:downloadfilename];
        //[downloadfilename autorelease];
    }
    if ([response isJSON]) {
        NSLog(@"Got a JSON response back!");
    }
}
@end
