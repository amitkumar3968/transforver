//
//  MyContactsView.m
//  NavTab
//
//  Created by hank chen on 11/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <AddressBookUI/AddressBookUI.h>
#import "MyContactsView.h"
#import "OverlayViewController.h"
#import "ChatViewController.h"
#import "ContactTableViewCell.h"
#import "AddUserViewController.h"
#import "Util.h"
#import "Localization.h"

@implementation MyContactsView

NSMutableArray *imageList;

@synthesize tableViewNavigationBar;
@synthesize listOfItems, filteredListContent, savedSearchTerm, savedScopeButtonIndex, searchWasActive, searchBar, listOfPhones, m_view;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        //retrieve VEM contact list
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) addContactToAddressBook:(ABAddressBookRef)addressesBookRef
{
    NSArray *addresses = (NSArray *) ABAddressBookCopyArrayOfAllPeople(addressesBookRef);
    NSInteger addressesCount = [addresses count];
    
    for (int i = 0; i < addressesCount; i++) {
        ABRecordRef record = [addresses objectAtIndex:i];
        NSString *firstName = (NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty);
        NSString *lastName = (NSString *)ABRecordCopyValue(record, kABPersonLastNameProperty);
        if (firstName==nil)
            firstName=@"";
        if (lastName==nil) {
            lastName=@"";
        }
        UIImageView *contactImage = (UIImageView *)ABPersonCopyImageData(record);
        NSString *contactFirstLast = [NSString stringWithFormat: @"%@ %@", firstName, lastName];
        ABMultiValueRef phoneNumbers = (NSString *)ABRecordCopyValue(record, kABPersonPhoneProperty);
        NSString* mobileNumber=nil;
        NSString* mobileLabel;
        for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
            mobileLabel = ABMultiValueCopyLabelAtIndex(phoneNumbers, i);
            if ([mobileLabel isEqualToString:@"_$!<Mobile>!$_"]) {
                mobileNumber = (NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
                break;
            }
            if ([mobileLabel isEqualToString:@"iPhone"]) {
                mobileNumber = (NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers,i);
                break;
            }
        }
        
        if (mobileNumber!=nil)
        {
            [listOfPhones addObject:mobileNumber];
            [listOfItems addObject:contactFirstLast];
        }
        
#if 1
        else
        {
            [listOfPhones addObject:@"0933333333"];
            [listOfItems addObject:@"0933333333"];
        }
#endif
        
        // Comment this line so always use build-in imgage; Here I think something goes wrong, but I don't know what
        // If I comment out this line, the application works, but now pictures is showing.
        /*
         if (contactImage==nil)
         [imageList addObject:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_con_rest@2x.png"]]];
         else {
         [imageList addObject:contactImage];
         }*/
        
        [firstName release];
        [lastName release];
    }
    NSLog(@"End of fetching contacts.");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    listOfItems = [[NSMutableArray alloc] init];
    listOfPhones = [[NSMutableArray alloc] init];
    
    //Setup Contacts and VEM Buttons on top
    allButton = [UIButton buttonWithType:UIButtonTypeCustom];
    allButton.frame = CGRectMake(21.0, 0.0, 138.0, 44.0);
    [allButton setTitle:@"ALL" forState:UIControlStateNormal];
    [allButton setBackgroundImage:[UIImage imageNamed:@"contacts_btn_header_unslected.png"] forState:UIControlStateNormal];
    [allButton setBackgroundImage:[UIImage imageNamed:@"contacts_btn_header_unslected.png"] forState:UIControlStateHighlighted];
    [allButton setBackgroundImage:[UIImage imageNamed:@"contacts_btn_header_slected.png"] forState:UIControlStateSelected];
    [allButton setSelected:NO];
	[allButton addTarget:self action:@selector(allbuttonPushed:)
        forControlEvents:UIControlEventTouchUpInside];
    filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filterButton.frame = CGRectMake(161.0, 0.0, 138.0, 44.0);
    [filterButton setTitle:@"Messenger" forState:UIControlStateNormal];
    [filterButton setBackgroundImage:[UIImage imageNamed:@"contacts_btn_header_unslected.png"] forState:UIControlStateNormal];
    [filterButton setBackgroundImage:[UIImage imageNamed:@"contacts_btn_header_slected.png"] forState:UIControlStateSelected];
    [filterButton setBackgroundImage:[UIImage imageNamed:@"contacts_btn_header_slected.png"] forState:UIControlStateSelected];
	[filterButton addTarget:self action:@selector(filterbuttonPushed:)
           forControlEvents:UIControlEventTouchUpInside];
    [filterButton setSelected:YES];
    //[imageButton setImage:[UIImage imageNamed:@"phone.png"] forState:UIControlStateNormal];
    CGRect transparentViewFrame = CGRectMake(0.0, 0.0f, 320.0f, 44.0f);
    
    m_view = [[UIView alloc] initWithFrame:transparentViewFrame];
    m_view.backgroundColor = [UIColor blackColor];
    m_view.alpha = 1;
    m_view.tag = 1;
    
    [m_view addSubview:allButton];
    [m_view addSubview:filterButton];
    
    CGRect leftsidebar = CGRectMake(1.0, 0.0f, 19.0f, 44.0f);
    UIImageView *m_leftsideview = [[UIImageView alloc] initWithFrame:leftsidebar];
    [m_leftsideview setImage:[UIImage imageNamed:@"contacts_bg_sideheader.png"]];
    CGRect rightsidebar = CGRectMake(300.0, 0.0f, 19.0f, 44.0f);
    UIImageView *m_rightsideview = [[UIImageView alloc] initWithFrame:rightsidebar];
    [m_rightsideview setImage:[UIImage imageNamed:@"contacts_bg_sideheader.png"]];
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    [self.navigationController.navigationBar addSubview:m_leftsideview];
    [self.navigationController.navigationBar addSubview:m_rightsideview];
    [self.navigationController.navigationBar addSubview:m_view];
    [m_view release];
    
    
    searchBar.delegate = self;
    
    //self.tableView.tableHeaderView = searchBar;
    //searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    


    
	// create a filtered list that will contain products for the search results table.
	//self.filteredListContent = [NSMutableArray arrayWithCapacity:[self.listOfItems count]];
	
	// restore search settings if they were saved in didReceiveMemoryWarning.
    /*
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
     */
	
	//[self.tableView reloadData];
    //[self.tableView reloadData];
    //NSArray ImageArray = [[NSArray arrayWithArray:imageList] retain];
    //NSArray ContentArray = [[NSArray arrayWithArray:list] retain];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    searchBar = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    //localize appearance
    initTable = YES;
    [Util showAlertView:@"Loading"];
    allButton.titleLabel.text = LOC_TXT_CONTACT_ALLBUTTON; // allButton.titleText;
    filterButton.titleLabel.text = LOC_TXT_CONTACT_VEMBUTTON; //filterButton.titleText;
    [super viewWillAppear:NO];
    [self performSelectorInBackground:@selector(updateContact) withObject:NULL];
}

-(void)viewDidAppear:(BOOL)animated
{
    // reload table and prepare data here

}


- (void) allbuttonPushed: (id) sender{
    UIButton *imageButton = (UIButton *)sender;
    [Util showAlertView:@"Loading"];
    if( imageButton == allButton) {
        [imageButton setSelected:YES];
        [filterButton setSelected:NO];
    }
    else {
        [imageButton setSelected:YES];
        [allButton setSelected:NO];
    }
    [self performSelectorInBackground:@selector(updateContact) withObject:NULL];

}
- (void) filterbuttonPushed: (id) sender{
    UIButton *imageButton = (UIButton *)sender;
    [Util showAlertView:@"Loading"];
    if( imageButton == allButton) {
        [imageButton setSelected:YES];
        [filterButton setSelected:NO];
    }
    else {
        [imageButton setSelected:YES];
        [allButton setSelected:NO];
        [self getRelationships:g_UserID ];
    }
    [self performSelectorInBackground:@selector(updateContact) withObject:NULL];
}

- (void)updateContact
{
    [self getRelationships:g_UserID ];
    
    if (initTable) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        imageList = [[NSMutableArray alloc] init];
        
        ABAddressBookRef addressBookRef = ABAddressBookCreate();
        NSArray *addresses;
        if (ABAddressBookRequestAccessWithCompletion != NULL) //check authentication only in ios6
        {
            if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
                ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
                    // First time access has been granted, add the contact
                    [self addContactToAddressBook: addressBookRef];
                });
            }
            else if(ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
                // The user has previously given access, add the contact
                [self addContactToAddressBook: addressBookRef];
            }
            else{
                //do nothging
            }
        }
        else
        {
            [self addContactToAddressBook: addressBookRef];
        }
    }
    initTable=NO;
    [self.tableView reloadData];
    [Util dissmissAlertView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (initTable)
        return 0;
    else
    {
        if ([filterButton isSelected]) {
            return [g_AccountName count];
        }
        else {
            return [listOfItems count];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    //create cell from address book or from VEM server contacts, based on whether filter button is pressed
        //set button appearance
    [cell.uibtContactAdd setBackgroundImage:[UIImage imageNamed:@"history_btn_setncel_pressed@2x.png"] forState:UIControlStateNormal];
    [cell.uibtContactAdd setBackgroundImage:[UIImage imageNamed:@"history_btn_setncel_rest@2x.png"] forState:UIControlStateSelected];
    [cell.uibtContactDel setBackgroundImage:[UIImage imageNamed:@"history_btn_setncel_pressed@2x.png"] forState:UIControlStateNormal];
    [cell.uibtContactDel setBackgroundImage:[UIImage imageNamed:@"history_btn_setncel_rest@2x.png"] forState:UIControlStateSelected];
    
    if ([filterButton isSelected]) {
        cell.lastNameLabel.text = [g_AccountName objectAtIndex:([indexPath row])];
        cell.thumbnailView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_con_rest@2x.png"]];
        cell.uibtContactDel.tag = [indexPath row];
        [cell.uibtContactDel addTarget:self action:@selector(delPerson:) forControlEvents:UIControlEventTouchUpInside];   
        cell.thumbnailView.contentMode = UIViewContentModeScaleAspectFit;
        cell.uibtContactAdd.hidden=TRUE;
        cell.uibtContactDel.hidden=FALSE;
        [cell.thumbnailView setFrame:CGRectMake(5, 10, 30, 30)];
        [cell.contentView addSubview:cell.thumbnailView];
    }
    else {
        cell.firstNameLabel.hidden=TRUE;
        cell.lastNameLabel.text = [listOfItems objectAtIndex:([indexPath row])];
        cell.thumbnailView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_con_rest@2x.png"]];
        cell.thumbnailView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.thumbnailView setFrame:CGRectMake(5, 10, 30, 30)];
        cell.uibtContactAdd.tag = [indexPath row];
        [cell.uibtContactAdd addTarget:self action:@selector(addPerson:) forControlEvents:UIControlEventTouchUpInside];

        //check condition for add button
        NSString *strPhone = [listOfPhones objectAtIndex:[indexPath row]];
        strPhone = [strPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        BOOL isExistedUserFlag = [self isExistedUser:strPhone];
        if (isExistedUserFlag) {
            cell.uibtContactAdd.hidden=TRUE;
        }
        else {
            cell.uibtContactAdd.hidden=FALSE;
        }
        cell.uibtContactDel.hidden=TRUE;
        [cell.contentView addSubview:cell.thumbnailView];
        //todo : figure out is this line necessary
        //[self findFriend:[listOfItems objectAtIndex:([indexPath row])]];
        
    }
    //cell.lastNameLabel.text = [VEMContactName objectAtIndex:([indexPath row])];
    //cell.firstNameLabel.text = [listOfItems objectAtIndex:([indexPath row])];
    // Configure the cell...
    /*
    if( [indexPath row] == 0)
    {
        [searchBar setFrame:CGRectMake(0.0f, -44.0f, 320.0f, 44.0f)];
        [cell addSubview:searchBar];
        
        searchBar.delegate = self;
        CGRect cellFrame = [cell frame];
        
        cellFrame.size.height = 0;
        [cell setFrame:cellFrame];
        return cell;
    }*/
    //cell.textLabel.text = [listOfItems objectAtIndex:([indexPath row])];
    //cell.textLabel.text = [[NSString alloc] initWithFormat:@"test"]; 
    return cell;
}

- (BOOL)isExistedUser: (NSString *)strPhone
{
    for (int i=0; i<g_AccountPhone.count; i++)
    {
        if ([strPhone isEqualToString:[g_AccountPhone objectAtIndex:i]]){
            return YES;
        }
    }
    return NO;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%f %d", cell.frame.size.height, [indexPath row]);
    return cell.frame.size.height;
}

- (void)addPerson:(UIButton *)sender
{
    NSLog(@"list of phones: %d", [listOfPhones count]);
    NSString *phoneWithoutSeperates = [[listOfPhones objectAtIndex:sender.tag] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [self addRelationships:g_UserID  phonenumber:phoneWithoutSeperates];

}

- (void)delPerson:(UIButton *)sender
{
    NSString *relSlaveID = [g_AccountID objectAtIndex:sender.tag];
    [self delRelationships:g_UserID  slaveID:relSlaveID];
    [self getRelationships:g_UserID ];
    [self.tableView reloadData];
}

- (int) findRelationship:(NSString *) phone
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.entalkie.url.tw/findFriend.php?friendPhone=%@", phone];
    NSLog(@"%@", urlString);
    
    NSData *data = [DBHandler sendReqToUrl:urlString postString:nil];
	NSArray *array = nil;
    g_AccountName = [[NSMutableArray alloc] init ];
    g_AccountID = [[NSMutableArray alloc] init ];
    //NSMutableArray *ret = [[NSMutableArray alloc] init ];
	
	if(data)
	{
		NSString *responseString = [[NSString alloc] initWithData:data
                                                         encoding:NSUTF8StringEncoding];
		array = [responseString JSONValue];
        
        for (NSDictionary *dic in array)
        {
            NSString *name = [dic objectForKey:@"USER_NAME"];
            NSString *usr_id = [dic objectForKey:@"USER_ID"];
            [g_AccountName addObject:name];
            [g_AccountID addObject:usr_id];
        }
        
		[responseString release];
	}

}
- (void) getRelationships: (int) uid
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.entalkie.url.tw/getRelationships.php?masterID=%d", uid];
    NSLog(@"%@", urlString);
    
    NSData *data = [DBHandler sendReqToUrl:urlString postString:nil];
	NSArray *array = nil;
    g_AccountPhone = [[NSMutableArray alloc] init ];
    g_AccountName = [[NSMutableArray alloc] init ];
    g_AccountID = [[NSMutableArray alloc] init ];
    //NSMutableArray *ret = [[NSMutableArray alloc] init ];
	
	if(data)
	{
		NSString *responseString = [[NSString alloc] initWithData:data
                                                         encoding:NSUTF8StringEncoding];
		array = [responseString JSONValue];
        
        for (NSDictionary *dic in array)
        {
            NSString *name = [dic objectForKey:@"USER_NAME"];
            NSString *usr_id = [dic objectForKey:@"USER_ID"];
            [g_AccountName addObject:name];
            [g_AccountID addObject:usr_id];
        }
        
		[responseString release];
	}
}

- (void) addRelationships:(int) uid phonenumber:(NSString *) phone{
    NSString *urlString = [NSString stringWithFormat:@"http://www.entalkie.url.tw/addRelationships.php?srcID=%d&dstPhone=%@", g_UserID, phone];
    
    if (![self isExistedUser:phone]) {
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
    [Util getRelationships:g_UserID];
    [self.tableView reloadData];
}

- (BOOL)findFriend:(NSString *)phone
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.entalkie.url.tw/findFriend.php?friendPhone=%@", phone];
    
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

- (void) delRelationships:(int) uid slaveID:(NSString *) relSlaveID{
    NSString *urlString = [NSString stringWithFormat:@"http://www.entalkie.url.tw/delRelationships.php?srcID=%d&slaveID=%@", uid, relSlaveID];
    
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
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //todo: if in phone contact list, do nothing when cell is selected
    NSInteger row = [indexPath row];

    // check if user selected a VEM contact, and make sure the number of accounts larger than the number of index
    //than retrieve all messages related to that person
    
    if (filterButton.selected) {
        if( [g_AccountName count] > indexPath.row)
        {
            ChatViewController *chat = [[ChatViewController alloc] initWithRelation:g_UserID  DstID:[[g_AccountID objectAtIndex:row] integerValue]];
            chat.m_DstName = [g_AccountName objectAtIndex:indexPath.row];
            chat.m_dstid = [[g_AccountID objectAtIndex:indexPath.row] intValue];
            //ChatViewController *chat = [[ChatViewController alloc] initWithRelation:1 DstID:2];
            NSLog(@"m_dstid:%d", [[g_AccountID objectAtIndex:indexPath.row] intValue]);
            //[chat setContact:contact];
            UINavigationController *navCtlr = [[UINavigationController alloc] initWithRootViewController:chat];
            navCtlr.navigationBar.barStyle = UIBarStyleDefault;
            [g_RootController presentModalViewController:navCtlr animated:YES];
            [navCtlr release];
            //((UITabBarController *)g_RootController).tabBar.hidden = YES;
            //self.navigationController.navigationBar.delegate = self;
            
            [chat release];
        }
    }
    else
    {
        //do nothing
    }
}

// Creates and returns a person object.
- (ABRecordRef)personObject {
	// Create a new Person object.
	ABRecordRef newRecord = ABPersonCreate();
	
	// Setting the value to the ABPerson object.
	ABRecordSetValue(newRecord, kABPersonFirstNameProperty, @"Christian", nil);
	ABRecordSetValue(newRecord, kABPersonLastNameProperty, @"Linder", nil);
	ABRecordSetValue(newRecord, kABPersonNoteProperty, @"sweetsnippets - Address book example", nil);
    
	return newRecord;
}

#pragma mark -
#pragma mark Search Bar 

- (void)searchBarCancelButtonClicked:(UISearchBar *)theSearchBar
{
    [theSearchBar resignFirstResponder];
    [ovController.view removeFromSuperview];
	[ovController release];
	ovController = nil;
	
	[self.tableView reloadData];
    //theSearchBar.hidden = YES;
}


- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	
	//This method is called again when the user clicks back from teh detail view.
	//So the overlay is displayed on the results, which is something we do not want to happen.
	if(searching)
		return;
	
	//Add the overlay view.
	if(ovController == nil)
		ovController = [[OverlayViewController alloc] initWithNibName:@"OverlayView" bundle:[NSBundle mainBundle]];
	
	CGFloat yaxis = self.navigationController.navigationBar.frame.size.height;
	CGFloat width = self.view.frame.size.width;
	CGFloat height = self.view.frame.size.height;
	
	//Parameters x = origion on x-axis, y = origon on y-axis.
	CGRect frame = CGRectMake(0, yaxis, width, height);
	ovController.view.frame = frame;	
	ovController.view.backgroundColor = [UIColor grayColor];
	ovController.view.alpha = 0.5;
	
	ovController.rvController = self;
	
	[self.tableView insertSubview:ovController.view aboveSubview:self.parentViewController.view];
	
	searching = YES;
	letUserSelectRow = NO;
	self.tableView.scrollEnabled = NO;
	
	//Add the done button.
    /*
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
											   initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
											   target:self action:@selector(doneSearching_Clicked:)] autorelease];*/
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
	//Remove all objects first.
	[copyListOfItems removeAllObjects];
	
	if([searchText length] > 0) {
		
		[ovController.view removeFromSuperview];
		searching = YES;
		letUserSelectRow = YES;
		self.tableView.scrollEnabled = YES;
		[self searchTableView];
	}
	else {
		
		[self.tableView insertSubview:ovController.view aboveSubview:self.parentViewController.view];
		
		searching = NO;
		letUserSelectRow = NO;
		self.tableView.scrollEnabled = NO;
	}
	
	[self.tableView reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	
	[self searchTableView];
}

- (void) searchTableView {
	
	NSString *searchText = searchBar.text;
	NSMutableArray *searchArray = [[NSMutableArray alloc] init];
	
	for (NSDictionary *dictionary in listOfItems)
	{/*
		NSArray *array = [dictionary objectForKey:@"Countries"];
		[searchArray addObjectsFromArray:array];*/
        
	}
	
	for (NSString *sTemp in searchArray)
	{
		NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
		
		if (titleResultsRange.length > 0)
			[copyListOfItems addObject:sTemp];
	}
	
	[searchArray release];
	searchArray = nil;
}

- (void) doneSearching_Clicked:(id)sender {
	
	searchBar.text = @"";
	[searchBar resignFirstResponder];
	
	letUserSelectRow = YES;
	searching = NO;
	self.navigationItem.rightBarButtonItem = nil;
	self.tableView.scrollEnabled = YES;
	
	[ovController.view removeFromSuperview];
	[ovController release];
	ovController = nil;
	
	[self.tableView reloadData];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

@end
