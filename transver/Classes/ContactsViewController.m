//
//  ContactsViewController.m
//  NavTab
//
//  Created by hank chen on 12/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactTableViewCell.h"
#import <AddressBookUI/AddressBookUI.h>
#import "AddUserViewController.h"

int m_userid;
@implementation ContactsViewController

@synthesize listContent, filteredListContent, sectionedListContent, savedSearchTerm, savedScopeButtonIndex, searchWasActive, delegate, searchBar, tabViewController, m_AccountID;

- (void)setListContent:(NSMutableArray *)inListContent
{
    if (listContent == inListContent) {
        return;
    }
    [listContent release]; 
    listContent = [inListContent retain];                                   
    
    NSMutableArray *sections = [NSMutableArray array];
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    NSArray *addresses = (NSArray *) ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSInteger addressesCount = [addresses count];
    
    for (int i = 0; i < addressesCount; i++) {
        ABRecordRef record = [addresses objectAtIndex:i];
        NSString *firstName = (NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty);
        NSString *lastName = (NSString *)ABRecordCopyValue(record, kABPersonLastNameProperty);
        //UIImageView *contactImage = (UIImageView *)ABPersonCopyImageData(record);
        if( firstName == nil)
            firstName = @"";
        NSString *contactFirstLast = [NSString stringWithFormat: @"%@ %@", firstName, lastName];
        
        [sections addObject:contactFirstLast];
        
        //Here I think something goes wrong, but I don't know what
        // If I comment out this line, the application works, but now pictures is showing.
        //[imageList addObject:contactImage];
        
        [firstName release];
        [lastName release];
    }


    
    NSInteger section = 0;
    for (section = 0; section < [sections count]; section++) {
        NSArray *sortedSubarray = [collation sortedArrayFromArray:[sections objectAtIndex:section]
                                          collationStringSelector:@selector(name)];
        [sections replaceObjectAtIndex:section withObject:sortedSubarray];
    }
    [sectionedListContent release];
    sectionedListContent = [sections retain];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
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

- (void) getLogin
{
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
	
	
    m_AccountID = [[NSMutableArray alloc] init];
    if( m_userid != -1)
    {
        NSArray *array = [self fetchRelationships:m_userid];//[[NSArray alloc] initWithObjects:@"find friends",@"Jerry", @"Raymond", @"John", nil];
        self.accounts = array;
        //[array release];
        NSLog(@"%d", [array retainCount]);
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [searchBar setBackgroundImage:[UIImage imageNamed:@"contacts_bg_search.png"]];
    listContent = [[NSMutableArray alloc] init];
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    NSArray *addresses = (NSArray *) ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSInteger addressesCount = [addresses count];
    
    for (int i = 0; i < addressesCount; i++) {
        ABRecordRef record = [addresses objectAtIndex:i];
        NSString *firstName = (NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty);
        NSString *lastName = (NSString *)ABRecordCopyValue(record, kABPersonLastNameProperty);
        //UIImageView *contactImage = (UIImageView *)ABPersonCopyImageData(record);
        if( firstName == nil)
            firstName = @"";
        if( lastName == nil)
            lastName = @"";
        NSString *contactFirstLast = [NSString stringWithFormat: @"%@ %@", firstName, lastName];
        
        [listContent addObject:contactFirstLast];
        
        //Here I think something goes wrong, but I don't know what
        // If I comment out this line, the application works, but now pictures is showing.
        //[imageList addObject:contactImage];
        
        [firstName release];
        [lastName release];
    }
#if 1
    if( addressesCount == 0)
    {
        NSString *contactFirstLast = [NSString stringWithFormat: @"Ray"];
        
        [listContent addObject:contactFirstLast];
    }
#endif	
	// create a filtered list that will contain products for the search results table.
	self.filteredListContent = [NSMutableArray arrayWithCapacity:[self.listContent count]];
	
	// restore search settings if they were saved in didReceiveMemoryWarning.
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
	
	[self.tableView reloadData];
	self.tableView.scrollEnabled = YES;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
	
	self.filteredListContent = nil;
    [listContent release];
    [sectionedListContent release]; 
    sectionedListContent = nil;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    return [listContent count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ContactTableViewCell *cell = (ContactTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    [cell.textLabel setText:[listContent objectAtIndex:indexPath.row]];
    
    return cell;
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
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(SwitchTab:)]) 
    {
        [self.delegate SwitchTab:@"0912555345"];
    }
    //[((UITabBarController *)self.parentViewController.parentViewController).selectedViewController viewDidAppear:YES];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	[self.filteredListContent removeAllObjects]; // First clear the filtered array.
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
    /*
    for (NSArray *section in self.sectionedListContent) {
        for (Product *product in section)
        {
            if ([scope isEqualToString:@"All"] || [product.type isEqualToString:scope])
            {
                NSComparisonResult result = [product.name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
                if (result == NSOrderedSame)
                {
                    [self.filteredListContent addObject:product];
                }
            }
        }
    }*/
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

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

#pragma mark -

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        return [[self.sectionedListContent objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:
                [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 0;
    } else {
        if (title == UITableViewIndexSearch) {
            [tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
            return -1;
        } else {
            return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index-1];
        }
    }
}

@end
