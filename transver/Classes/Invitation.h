//
//  Invitation.h
//  ChatMe
//
//  Created by Emerson Malca on 6/24/11.
//  Copyright (c) 2011 OneZeroWare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChatMeUser;

@interface Invitation : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * invitationStatus;
@property (nonatomic, retain) ChatMeUser * ownerUser;
@property (nonatomic, retain) ChatMeUser * invitedUser;

@end
