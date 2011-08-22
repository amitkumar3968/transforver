//
//  ContactTableViewCell.h
//  ChatMe
//
//  Created by Emerson Malca on 6/24/11.
//  Copyright 2011 OneZeroWare. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Contact;

@interface ContactTableViewCell : UITableViewCell {
    
}

@property (nonatomic, retain) Contact *contact;
@property (nonatomic, retain) IBOutlet UIImageView *thumbnailView;
@property (nonatomic, retain) IBOutlet UIImageView *statusView;
@property (nonatomic, retain) IBOutlet UIImageView *chatsView;
@property (nonatomic, retain) IBOutlet UILabel *chatsLabel;
@property (nonatomic, retain) IBOutlet UILabel *firstNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *lastNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *subtextLabel;

- (void)initialSetup;

@end
