//
//  ContactsViewController.h
//  NavTab
//
//  Created by hank chen on 12/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UICustomTabViewController.h"
#import "AddUserViewController.h"

@protocol ContactsViewControllerDelegate;

@interface ContactsViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate, AddUserViewDelegate>
{
	NSMutableArray			*listContent;			// The master content.
	NSMutableArray	*filteredListContent;	// The content filtered as a result of a search.
    NSArray         *sectionedListContent;  // The content filtered into alphabetical sections.
	
	// The saved state of the search UI if a memory warning removed the view.
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
    UISearchBar*    searchBar;
    UICustomTabViewController *tabViewController;
    int             m_ShowMenu;
    NSMutableArray  *m_AccountID;
    NSArray         *accounts;
}

@property (nonatomic, retain) NSMutableArray *listContent;
@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic, retain) NSMutableArray *m_AccountID;
@property (nonatomic, retain) NSArray *accounts;
@property (nonatomic, retain, readonly) NSArray *sectionedListContent;
@property (nonatomic, retain) UICustomTabViewController *tabViewController;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;
@property (nonatomic, assign) id <ContactsViewControllerDelegate> delegate;
@property (strong,nonatomic) IBOutlet UISearchBar *searchBar;

@end

@protocol ContactsViewControllerDelegate <NSObject>
@optional
- (void) SwitchTab:(NSString *) number;
@end
