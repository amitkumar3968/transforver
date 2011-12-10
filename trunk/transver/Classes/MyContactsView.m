//
//  MyContactsView.m
//  NavTab
//
//  Created by hank chen on 11/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyContactsView.h"
#import "OverlayViewController.h"


@implementation MyContactsView

@synthesize tableViewNavigationBar;
@synthesize listOfItems;

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    listOfItems = [[NSMutableArray alloc] init];

   
    self.tableView.tableHeaderView = searchBar;
    //searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
    NSMutableArray *imageList = [[NSMutableArray alloc] init];
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    NSArray *addresses = (NSArray *) ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSInteger addressesCount = [addresses count];
    
    for (int i = 0; i < addressesCount; i++) {
        ABRecordRef record = [addresses objectAtIndex:i];
        NSString *firstName = (NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty);
        NSString *lastName = (NSString *)ABRecordCopyValue(record, kABPersonLastNameProperty);
        UIImageView *contactImage = (UIImageView *)ABPersonCopyImageData(record);
        NSString *contactFirstLast = [NSString stringWithFormat: @"%@ %@", firstName, lastName];
        
        [listOfItems addObject:contactFirstLast];
        
        //Here I think something goes wrong, but I don't know what
        // If I comment out this line, the application works, but now pictures is showing.
        //[imageList addObject:contactImage];
        
        [firstName release];
        [lastName release];
    }
    
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
    [listOfItems release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    tableViewNavigationBar = [[UINavigationBar alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    
	UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    imageButton.frame = CGRectMake(20.0, 5.0, 70.0, 30.0);
    [imageButton setTitle:@"ALL" forState:UIControlStateNormal];
	[imageButton addTarget:self action:@selector(buttonPushed:)
		  forControlEvents:UIControlEventTouchUpInside];
    UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    filterButton.frame = CGRectMake(90.0, 5.0, 90.0, 30.0);
    [filterButton setTitle:@"Messenger" forState:UIControlStateNormal];
	[filterButton addTarget:self action:@selector(buttonPushed:)
           forControlEvents:UIControlEventTouchUpInside];
    //[imageButton setImage:[UIImage imageNamed:@"phone.png"] forState:UIControlStateNormal];
    CGRect transparentViewFrame = CGRectMake(50.0f, 0.0f, 320.0f, 44.0f);
    UIView *m_view = [[UIView alloc] initWithFrame:transparentViewFrame];
    //m_view.backgroundColor = [UIColor orangeColor];
    m_view.alpha = 1;
    m_view.tag = 1;
    [m_view addSubview:imageButton];
    [m_view addSubview:filterButton];
    
    //searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 44.0f, 320.0f, 44.0f)];
    //[searchBar setFrame:CGRectMake(0.0f, 44.0f, 320.0f, 44.0f)];
    //[self.tableView setFrame:CGRectMake(0.0f, 88.0f, 320.0f, 44.0f)];

    
	[tableViewNavigationBar addSubview:m_view];
    //[tableViewNavigationBar addSubview:searchBar];
    
    self.navigationItem.titleView = m_view;
    [m_view release];
    
	[super.tableView addSubview:tableViewNavigationBar];
    //[super.tableView addSubview:searchBar];
    
    [tableViewNavigationBar release];
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
    return [listOfItems count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    if( [indexPath row] == 0)
    {
        [searchBar setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
        [cell addSubview:searchBar];
        searchBar.delegate = self;
        return cell;
    }
    cell.textLabel.text = [listOfItems objectAtIndex:([indexPath row]-1)];
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
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
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
											   initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
											   target:self action:@selector(doneSearching_Clicked:)] autorelease];
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
	{
		NSArray *array = [dictionary objectForKey:@"Countries"];
		[searchArray addObjectsFromArray:array];
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

@end
