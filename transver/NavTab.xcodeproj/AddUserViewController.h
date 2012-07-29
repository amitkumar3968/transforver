//
//  AddUserViewController.h
//  NavTab
//
//  Created by hank chen on 10/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddUserViewDelegate;


@interface AddUserViewController : UIViewController {
    
    IBOutlet UITextField *name;
    id <AddUserViewDelegate> delegate;
}

- (IBAction) save:(id)sender;
@property (nonatomic, retain) UITextField *name;
@property (nonatomic, assign) id <AddUserViewDelegate> delegate;

@end

@protocol AddUserViewDelegate <NSObject>
@optional

- (void) savePhoneNumber:(NSString *)phonenumber;

@end

