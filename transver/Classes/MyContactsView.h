//
//  MyContactsView.h
//  NavTab
//
//  Created by hank chen on 11/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>

@class OverlayViewController;

@interface MyContactsView : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate, UITextFieldDelegate>{
    NSMutableArray *listOfItems;
    NSMutableArray *listOfPhones;
	NSMutableArray *copyListOfItems;
    UINavigationBar *tableViewNavigationBar;
    
    IBOutlet UISearchBar *searchBar;
    UIButton *allButton, *filterButton, *btnAddByPhone;
	BOOL searching;
	BOOL letUserSelectRow;
    
    OverlayViewController *ovController;
    NSMutableArray *filteredListContent;
    NSString *savedSearchTerm;
    NSInteger savedScopeButtonIndex;
    BOOL searchWasActive;
    BOOL initTable;
}

- (ABRecordRef)personObject;
- (void) searchTableView;
- (void) doneSearching_Clicked:(id)sender;
- (void) allbuttonPushed: (id) sender;
- (void) filterbuttonPushed: (id) sender;
- (BOOL)isExistedUser: (NSString *)strPhone;
-(void) addContactToAddressBook:(ABAddressBookRef)addressesBookRef;
@property (nonatomic, retain) UIView *coverView;
@property (nonatomic, retain) UITextField *phoneInput;
@property (nonatomic, retain) UINavigationBar *tableViewNavigationBar;
@property (nonatomic, retain) NSMutableArray *listOfItems;
@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;
@property (strong,nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain)     NSMutableArray *listOfPhones;
@property (nonatomic, retain) UIView *m_view;
@end
