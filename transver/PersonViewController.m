//
//  PersonViewController.m
//  NavTab
//
//  Created by hank chen on 11/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PersonViewController.h"
#import "DBHandler.h"
#import "JSON.h"

@interface ABPeoplePickerNavigationController ()

- (void)setAllowsCardEditing:(BOOL)allowCardEditing;
- (void)setAllowsCancel:(BOOL)allowsCancel;

@end

extern int m_userid;
@implementation PersonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    m_Picker = [[ABPeoplePickerNavigationController alloc] init];
    [m_Picker setAllowsCancel:NO];
    //m_Picker.navigationBar.topItem.prompt = @"Choose a contact to...";
    m_Picker.navigationBar.tintColor = [UIColor orangeColor];
    
    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    imageButton.frame = CGRectMake(10.0, 5.0, 70.0, 30.0);
    [imageButton setTitle:@"ALL" forState:UIControlStateNormal];
	[imageButton addTarget:self action:@selector(buttonPushed:)
		  forControlEvents:UIControlEventTouchUpInside];
    UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    filterButton.frame = CGRectMake(80.0, 5.0, 90.0, 30.0);
    [filterButton setTitle:@"Messenger" forState:UIControlStateNormal];
	[filterButton addTarget:self action:@selector(buttonPushed:)
		  forControlEvents:UIControlEventTouchUpInside];
    //[imageButton setImage:[UIImage imageNamed:@"phone.png"] forState:UIControlStateNormal];
    CGRect transparentViewFrame = CGRectMake(m_Picker.navigationBar.frame.origin.x, m_Picker.navigationBar.frame.origin.y,m_Picker.navigationBar.frame.size.width,m_Picker.navigationBar.frame.size.height);
    UIView *m_view = [[UIView alloc] initWithFrame:transparentViewFrame];
    //m_view.backgroundColor = [UIColor orangeColor];
    m_view.alpha = 1;
    m_view.tag = 1;
    [m_view addSubview:imageButton];
    [m_view addSubview:filterButton];
    //[imageButton release];
    //[filterButton release];
    m_Picker.navigationBar.topItem.titleView = m_view;
    
    //[m_view release];
    [m_Picker setPeoplePickerDelegate:(id<ABPeoplePickerNavigationControllerDelegate>)self];
    //myPicker.peoplePickerDelegate = self;   
    // 只show e-mail
    //myPicker.displayedProperties = [NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonEmailProperty]]; 
    //ABPersonViewController* ppnc = [[ABPersonViewController alloc] init];
    //[self.view addSubview:[m_Picker view]];
    
    //[myPicker release];
    //[myPicker release];
    /*
    personController = [[ABPersonViewController alloc] init];
    
    [personController setPersonViewDelegate:self];
    [personController setAllowsEditing:NO];
    personController.addressBook = ABAddressBookCreate();   
    
    personController.displayedProperties = [NSArray arrayWithObjects:
                                            [NSNumber numberWithInt:kABPersonPhoneProperty], 
                                            nil];
    */
    //[self setView:personController.view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [m_Picker release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) displayContactInfo: (ABRecordRef)person
{
    [personController setDisplayedPerson:person];
}

- (BOOL) personViewController:(ABPersonViewController*)personView shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
    // This is where you pass the selected contact property elsewhere in your program
    [[self navigationController] dismissModalViewControllerAnimated:YES];
    return NO;
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

- (void) savePhoneNumber:(NSString *)phonenumber{
    NSLog(@"save phone: %@", phonenumber);
    {
        //add user for contact list
        [self addRelationships:m_userid phonenumber:phonenumber];
        //[self fetchRelationships:m_userid];
    }
    //[self.navigationController popViewControllerAnimated:YES];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{	
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.text = @"Add contact";
    return cell;
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

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController didCompleteWithNewPerson:(ABRecordRef)person {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.row == 0) {
		ABNewPersonViewController *newPersonViewController = [[ABNewPersonViewController alloc] init];
		newPersonViewController.displayedPerson = [self personObject];
		newPersonViewController.newPersonViewDelegate = self;
		[self.navigationController pushViewController:newPersonViewController animated:YES];
	}
}
/*
 - (ABAddressBookRef) getFilteredAddressBook {
 /// open the default address book. 
 ABAddressBookRef addressBook = ABAddressBookCreate();
 
 CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
 CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
 
 for (int i=0;i < nPeople;i++) { 
 ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);	
 
 if () {
     ABAddressBookRemoveRecord(addressBook, ref, nil);
 }

}
return addressBook;

}
*/

@end
