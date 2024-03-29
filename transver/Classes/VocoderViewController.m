//
//  ChatViewController.m
//  ChatMe
//
//  Created by Emerson Malca on 6/24/11.
//  Copyright 2011 OneZeroWare. All rights reserved.
//

#import "VocoderViewController.h"
#import "MessageTableViewCell.h"
#import "Message.h"
#import "Contact.h"
#import "Play.h"
#import "Quotation.h"
#import "Common.h"
//Ray@11012011
#import <AudioToolbox/AudioServices.h>
#import "Util.h"
#import "ChatBubbleView.h"
//==========================================

/*
#import "Contact.h"
#import "ChatMeUser.h"
#import "Message.h"
#import "ChatMeService.h"
#import "MessageTableViewCell.h"
#import "Common.h"
*/


@interface VocoderViewController (Private) 

#define DEFAULT_ROW_HEIGHT 78
#define HEADER_HEIGHT 45
//- (void)configureCell:(MessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)dismissKeyboardIfNeeded;
- (void)registerForKeyboardNotifications;


@end

@implementation VocoderViewController

//@synthesize fetchedResultsController=__fetchedResultsController;
@synthesize tableView=_tableView;
@synthesize bubbleView=_bubbleView;
@synthesize contact=_contact;
@synthesize listOfItems=_listOfItems;
@synthesize sectionInfoArray;
@synthesize openSectionIndex;
@synthesize m_Messages;

//Ray@ 11012011
@synthesize mybutton;
@synthesize localFilePath;
@synthesize audioFile;
@synthesize audioRecorder;
//=======================================

- (void)dealloc
{
    //[__fetchedResultsController release];
    self.contact = nil;
    [_listOfItems release];
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
    NSLog(@"viewDidLoad %@", m_Messages);
    
    //self.title = [self.contact.contactUser fullName];

    //Position the bubbleView on the bottom
    [self.view addSubview:self.bubbleView];
    CGRect bubbleFrame = self.bubbleView.frame;
    bubbleFrame.origin.y = CGRectGetHeight(self.view.frame) - CGRectGetHeight(bubbleFrame);
    [self.bubbleView setFrame:bubbleFrame];
    [self.bubbleView setDelegate:self];
    //[self fetchMessages:1 ];
    [self sendMessages:1 ];
    //Scroll to the bottom
    
    //NSArray *messages = [self.fetchedResultsController fetchedObjects];
    //Initialize the array.
    _listOfItems = [[NSMutableArray alloc] init];
    
    NSMutableArray *countriesToLiveInArray = [NSMutableArray arrayWithObjects:@"Iceland", @"Greenland", @"Switzerland", @"Norway", @"New Zealand", @"Greece", @"Rome", @"Ireland", nil];
    NSDictionary *countriesToLiveInDict = [NSDictionary dictionaryWithObject:countriesToLiveInArray forKey:@"Countries"];
    
    
    NSMutableArray *countriesLivedInArray = m_Messages;
    NSDictionary *countriesLivedInDict = [NSDictionary dictionaryWithObject:countriesLivedInArray forKey:@"Countries"];
    
    //[_listOfItems addObject:countriesToLiveInDict];
    [_listOfItems addObject:countriesLivedInDict];
    myTimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(moveACar) userInfo:nil repeats:YES];
    
    //self.navigationController.navigationBar.delegate = self;
    //Set the title
    //self.navigationItem.title = @"Countries";
    //NSArray *messages = [[NSArray alloc] initWithObjects:@"find friends",@"Jerry", @"Raymond", @"John", nil];
    /* 
    if ([messages count] > 1) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-2 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }*/
}

- (id) initWithRelation: (int) srcid DstID:(int) dstid {
    NSLog(@"initWithDstName");
    m_Messages = [self fetchMessages:srcid DstID:dstid];
    return self;
    
}

- (void) moveACar {
    //NSLog(@"move!!");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.bubbleView = nil;
    self.tableView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
		NSString *playName = sectionInfo.play.name;
        sectionInfo.headerView = [[[SectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, HEADER_HEIGHT) title:playName section:section delegate:self] autorelease];
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
    return [_listOfItems count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //Number of rows it should expect should be based on the section
    NSDictionary *dictionary = [_listOfItems objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"Countries"];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    MessageTableViewCell *cell = (MessageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
    
    //First get the dictionary object
    NSDictionary *dictionary = [_listOfItems objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"Countries"];
    NSString *cellValue = [array objectAtIndex:indexPath.row];
    //[cell.textLabel setText:cellValue];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(MessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    //ChatMeUser *currentUser = [[ChatMeService sharedChatMeService] currentUser];
    NSDictionary *dictionary = [_listOfItems objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"Countries"];
    NSString *cellValue = [array objectAtIndex:indexPath.row];
    Message *message = [[Message alloc] init];
    
    message.text = cellValue;
    
    [cell setText:message.text];
    //We only set the image if the previous message was from a different user
    BOOL showImage = (indexPath.row == 0);
    if (indexPath.row != 0) {
        /*
        Message *prev = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section]];
        if (prev.fromUser != message.fromUser) {
            showImage = YES;
        }*/
    }
    NSString *myImagePath =  [[NSBundle mainBundle] pathForResource:@"userWaldo" ofType:@"png"];
    UIImage *userImg = [UIImage imageWithContentsOfFile:myImagePath];
    if (showImage) {
        [cell setImage:userImg];
    } else {
        [cell setImage:nil];
    }
    [cell setMessageAlignment:kMessageAlignmentLeft];
    /*
    //Also, if fromUser is us (currentUser) we align it to the left, right otherwise
    if (message.fromUser == currentUser) {
        [cell setMessageAlignment:kMessageAlignmentLeft];
    } else {
        [cell setMessageAlignment:kMessageAlignmentRight];
    }
    */
    [cell setNeedsDisplay];
}



#pragma mark - Table view delegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	if(section == 0)
		return @"Countries to visit";
	else
		return @"Countries visited";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //return 20;
    NSDictionary *dictionary = [_listOfItems objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"Countries"];
    NSString *cellValue = [array objectAtIndex:indexPath.row];
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
- (NSArray*) fetchMessages:(int) srcid DstID:(int)dstid {
    NSString *urlString = [NSString stringWithFormat:@"http://www.entalkie.url.tw/getMessages.php"];
    NSString *postString = [NSString stringWithFormat:@"srcID=%d&dstID=%d",srcid,dstid];
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
        [ret addObject: [dic objectForKey:@"DIALOG_MESSAGE"]];
    }
    //[ret addObject:nil];
    NSArray *retArr = [[NSArray alloc ]initWithArray:ret];
    [ret release];

    return retArr;
}
- (NSArray*) sendMessages:(int) uid {
    NSString *urlString = [NSString stringWithFormat:@"http://www.entalkie.url.tw/sendMessages.php"];
    //NSString *urlString = @"http://www.entalkie.url.tw/getRelationships.php?masterID=1";
    NSData *data = [DBHandler sendReqToUrl:urlString postString:@"srcID=2&dstID=3"];
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
        
        //Update the contact's last message
        [self.contact setLastCommunicationText:message];
        NSDictionary *oldDic = [_listOfItems objectAtIndex:1];
        NSMutableArray *oldArray = [oldDic objectForKey:@"Countries"];
        [oldArray addObject:message];
        [self.tableView reloadData];
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
    
    /*
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     */
    NSInteger countOfRowsToInsert = [sectionInfo.play.quotations count];
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    /*
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     */
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {
		
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

@end
