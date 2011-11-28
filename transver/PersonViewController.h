//
//  PersonViewController.h
//  NavTab
//
//  Created by hank chen on 11/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>

@interface PersonViewController : UIViewController <ABPersonViewControllerDelegate>{
    ABPersonViewController *personController;
    ABPeoplePickerNavigationController *m_Picker;
}

- (void) displayContactInfo: (ABRecordRef)person;
- (void) savePhoneNumber: (NSString *)phonenumber;
- (void) addRelationships: (int) uid phonenumber:(NSString *) phone;
@end
