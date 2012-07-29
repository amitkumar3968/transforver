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

@interface MyContactsView : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate >{
    NSMutableArray *listOfItems;
	NSMutableArray *copyListOfItems;
    UINavigationBar *tableViewNavigationBar;
    
    IBOutlet UISearchBar *searchBar;
    UIButton *allButton, *filterButton;
	BOOL searching;
	BOOL letUserSelectRow;
    
    OverlayViewController *ovController;
}

- (ABRecordRef)personObject;
- (void) searchTableView;
- (void) doneSearching_Clicked:(id)sender;
@property (nonatomic, retain) UINavigationBar *tableViewNavigationBar;
@property (nonatomic, retain) NSMutableArray *listOfItems;
@end
