//
//  ContactTableViewCell.m
//  ChatMe
//
//  Created by Emerson Malca on 6/24/11.
//  Copyright 2011 OneZeroWare. All rights reserved.
//

#import "ContactTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
//#import "Contact.h"
//#import "Message.h"
//#import "ChatMeUser.h"
//#import "Common.h"

#define kThumbnailWidth     44.0
#define kThumbnailFrameWidth 2.0
#define kBubbleWidth        44.0
#define kSeparationWidth     10.0

@implementation ContactTableViewCell

@synthesize thumbnailView=_thumbnailView;
@synthesize statusView=_statusView;
@synthesize chatsView=_chatsView;
@synthesize chatsLabel=_chatsLabel;
@synthesize firstNameLabel=_firstNameLabel;
@synthesize lastNameLabel=_lastNameLabel;
@synthesize subtextLabel=_subtextLabel;
@synthesize contact=_contact;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initialSetup];
    }
    return self;
}

- (void)initialSetup {
    //Customize the thumbnail view
    [self.thumbnailView.layer setBorderColor:[UIColor colorWithHue:0.1278 saturation:0.07 brightness:0.96 alpha:1.0].CGColor];
    [self.thumbnailView.layer setBorderWidth:kThumbnailFrameWidth];
    CGRect shadowRect = CGRectMake(0.0, 0.0, self.thumbnailView.frame.size.width, self.thumbnailView.frame.size.height);
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:shadowRect];
    [self.thumbnailView.layer setShadowPath:shadowPath.CGPath];
    [self.thumbnailView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.thumbnailView.layer setShadowOffset:CGSizeMake(-1.0, 1.0)];
    [self.thumbnailView.layer setShadowRadius:1.0];
    [self.thumbnailView.layer setShadowOpacity:0.2];
    
    //Customize the chat label
    [self.chatsLabel setTextColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"redTextColor"]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //Make the first name label fit only the necessary space
    NSString *firstName = _firstNameLabel.text;
    CGSize firstNameSize = [firstName sizeWithFont:_firstNameLabel.font];
    CGRect firstNameFrame = _firstNameLabel.frame;
    firstNameFrame.size.width = firstNameSize.width;
    [_firstNameLabel setFrame:firstNameFrame];
    
    //Make the last name start right after the first name
    NSString *lastName = _lastNameLabel.text;
    CGSize lastNameSize = [lastName sizeWithFont:_lastNameLabel.font];
    CGRect lastNameFrame = _lastNameLabel.frame;
    lastNameFrame.origin.x = CGRectGetMaxX(firstNameFrame) + kSeparationWidth;
    lastNameFrame.size.width = lastNameSize.width;
    //We might go over the bubble, so check
    CGFloat lastNameMaxX = CGRectGetWidth(self.contentView.frame) - kSeparationWidth*2 - kBubbleWidth;
    if (CGRectGetMaxX(lastNameFrame) > lastNameMaxX) {
        lastNameFrame.size.width = lastNameMaxX - CGRectGetMinX(lastNameFrame);
    }
    [_lastNameLabel setFrame:lastNameFrame];
    
    
}

- (void)dealloc
{
    self.thumbnailView = nil;
    self.statusView = nil;
    self.chatsView = nil;
    self.chatsLabel = nil;
    self.firstNameLabel = nil;
    self.lastNameLabel = nil;
    self.subtextLabel = nil;
    self.contact = nil;
    [super dealloc];
}

- (void)setContact:(Contact *)contact {
    if (contact != _contact) {
        [_contact release];
        _contact = [contact retain];
    }
    
    //Sanity check
    if (_contact == nil) {
        return;
    }
    
    //Setting the contact's info
    //ChatMeUser *contactUser = _contact.contactUser;
    
    //UIImage *thumb = [contactUser image];
    //[self.thumbnailView setImage:thumb];
    
    //[self.firstNameLabel setText:contactUser.firstName];
    //[self.lastNameLabel setText:contactUser.lastName];
    /*
    [self.subtextLabel setText:_contact.lastCommunicationText];
    
    if ([_contact.visibleContactUserStatus intValue] == kUserStatusOnline) {
        [self.statusView setImage:[UIImage imageNamed:@"statusOnline"]];
    } else {
        [self.statusView setImage:nil];
    }
    
    //Indicate unseen messages (if any)
    NSInteger unseenMessages = 0;
    ChatMeUser *currentUser = _contact.user;
    NSSet *receivedMessages = currentUser.receivedMessages;
    for (Message *message in receivedMessages) {
        if ([message.seenByRecepient boolValue] == NO && message.fromUser == contactUser) {
            unseenMessages++;
        }
    }
    NSLog(@"unseen messages %d", unseenMessages);
    if (unseenMessages > 0) {
        [self.chatsView setImage:[UIImage imageNamed:@"imgMiniBubble"]];
        [self.chatsLabel setText:[NSString stringWithFormat:@"%d",unseenMessages]];
    } else {
        [self.chatsView setImage:nil];
        [self.chatsLabel setText:nil];
    }
    */
    [self setNeedsLayout];
}

@end
