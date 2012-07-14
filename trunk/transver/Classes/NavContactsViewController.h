//
//  NavContactsViewController.h
//  NavTab
//
//  Created by hank chen on 12/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsViewController.h"


@interface NavContactsViewController : UIViewController <ContactsViewControllerDelegate>{
    UINavigationController *navigationController;
    UIButton *allButton, *filterButton;
}

- (void) buttonPushed:(id)sender;
- (void) SwitchTab:(NSString *) number;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet ContactsViewController *contactsController;
@end
