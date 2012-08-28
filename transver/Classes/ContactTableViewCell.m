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

@synthesize uibtContactAdd;
@synthesize uibtContactDel;
@synthesize thumbnailView;
@synthesize statusView;
@synthesize chatsView;
@synthesize chatsLabel;
@synthesize firstNameLabel;
@synthesize lastNameLabel;
@synthesize subtextLabel;
@synthesize contact=_contact;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initialSetup];
    }
    
    self.lastNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 12, 160, 20)];
    self.firstNameLabel.hidden = true;
    self.firstNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 12, 160, 20)];
    uibtContactAdd = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;        
    uibtContactAdd.frame = CGRectMake(240, 12, 50, 24);
    [uibtContactAdd setTitle:@"ADD" forState:UIControlStateNormal];
    [uibtContactAdd setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [uibtContactAdd addTarget:self action:@selector(pressAddButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:uibtContactAdd];
    uibtContactDel = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;        
    uibtContactDel.frame = CGRectMake(240, 12, 50, 24);
    [uibtContactDel setTitle:@"DEL" forState:UIControlStateNormal];
    [uibtContactDel setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [self addSubview:uibtContactDel];
    [uibtContactDel setHidden:true];

    [self addSubview:thumbnailView];
    [self addSubview:firstNameLabel];
    [self addSubview:lastNameLabel];
    [self addSubview:uibtContactAdd];
    [self addSubview:uibtContactDel];
    return self;
}

- (void)pressAddButton
{
    [contactTableViewCellDelegate addPhoneNoToVEM];
}

- (void)initialSetup 
{
    //Customize the thumbnail view
    

    /*[self.thumbnailView.layer setBorderColor:[UIColor colorWithHue:0.1278 saturation:0.07 brightness:0.06 alpha:1.0].CGColor];
    [self.thumbnailView.layer setBorderWidth:kThumbnailFrameWidth];
    CGRect shadowRect = CGRectMake(0.0, 0.0, self.thumbnailView.frame.size.width, self.thumbnailView.frame.size.height);
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:shadowRect];
    [self.thumbnailView.layer setShadowPath:shadowPath.CGPath];
    [self.thumbnailView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.thumbnailView.layer setShadowOffset:CGSizeMake(-1.0, 1.0)];
    [self.thumbnailView.layer setShadowRadius:1.0];
    [self.thumbnailView.layer setShadowOpacity:0.2];
    [self addSubview:self.thumbnailView];*/
    
    //Customize the chat label
    [self.chatsLabel setTextColor:[UIColor blueColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
       [super layoutSubviews];
 
    //Make the first name label fit only the necessary space
    /*NSString *firstName = [[NSString alloc] initWithFormat:@""];
    CGSize firstNameSize = [firstName sizeWithFont:firstNameLabel.font];
    CGRect firstNameFrame = firstNameLabel.frame;
    firstNameFrame.size.width = firstNameSize.width;
    [firstNameLabel setFrame:firstNameFrame];
    
    //Make the last name start right after the first name
    NSString *lastName = [[NSString alloc] initWithFormat:@""];
    CGSize lastNameSize = [lastName sizeWithFont:lastNameLabel.font];
    CGRect lastNameFrame = lastNameLabel.frame;
    lastNameFrame.origin.x = CGRectGetMaxX(firstNameFrame) + kSeparationWidth;
    lastNameFrame.size.width = lastNameSize.width;
    //We might go over the bubble, so check
    CGFloat lastNameMaxX = CGRectGetWidth(self.contentView.frame) - kSeparationWidth*2 - kBubbleWidth;
    if (CGRectGetMaxX(lastNameFrame) > lastNameMaxX) {
        lastNameFrame.size.width = lastNameMaxX - CGRectGetMinX(lastNameFrame);
    }
    [lastNameLabel setFrame:lastNameFrame];
 */   
    
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
