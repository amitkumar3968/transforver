//
//  ChatViewController.m
//  ChatMe
//
//  Created by Emerson Malca on 6/24/11.
//  Copyright 2011 OneZeroWare. All rights reserved.
//

#import "ChatViewController.h"
#import "MessageTableViewCell.h"
#import "Message.h"
#import "Contact.h"
/*
#import "Contact.h"
#import "ChatMeUser.h"
#import "Message.h"
#import "ChatMeService.h"
#import "MessageTableViewCell.h"
#import "Common.h"
*/
@interface ChatViewController (Private) 
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
    
    //self.title = [self.contact.contactUser fullName];

    //Position the bubbleView on the bottom
    [self.view addSubview:self.bubbleView];
    CGRect bubbleFrame = self.bubbleView.frame;
    bubbleFrame.origin.y = CGRectGetHeight(self.view.frame) - CGRectGetHeight(bubbleFrame);
    [self.bubbleView setFrame:bubbleFrame];
    [self.bubbleView setDelegate:self];
    
    //Scroll to the bottom
    
    //NSArray *messages = [self.fetchedResultsController fetchedObjects];
    //Initialize the array.
    _listOfItems = [[NSMutableArray alloc] init];
    
    NSMutableArray *countriesToLiveInArray = [NSMutableArray arrayWithObjects:@"Iceland", @"Greenland", @"Switzerland", @"Norway", @"New Zealand", @"Greece", @"Rome", @"Ireland", nil];
    NSDictionary *countriesToLiveInDict = [NSDictionary dictionaryWithObject:countriesToLiveInArray forKey:@"Countries"];
    
    
    NSMutableArray *countriesLivedInArray = [NSMutableArray arrayWithObjects:@"India", @"U.S.A", nil];
    NSDictionary *countriesLivedInDict = [NSDictionary dictionaryWithObject:countriesLivedInArray forKey:@"Countries"];
    
    [_listOfItems addObject:countriesToLiveInDict];
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
    
    //First get the dictionary object
    NSDictionary *dictionary = [_listOfItems objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"Countries"];
    NSString *cellValue = [array objectAtIndex:indexPath.row];
    [cell.textLabel setText:cellValue];
    
    return cell;
}

- (void)configureCell:(MessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    /*
    ChatMeUser *currentUser = [[ChatMeService sharedChatMeService] currentUser];
    Message *message = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell setText:message.text];
    
    //We only set the image if the previous message was from a different user
    BOOL showImage = (indexPath.row == 0);
    if (indexPath.row != 0) {
        Message *prev = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section]];
        if (prev.fromUser != message.fromUser) {
            showImage = YES;
        }
    }
    
    if (showImage) {
        [cell setImage:message.fromUser.image];
    } else {
        [cell setImage:nil];
    }
    
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
        [self.tableView beginUpdates];
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

@end
