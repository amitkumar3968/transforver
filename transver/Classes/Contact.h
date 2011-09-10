//
//  Contact.h
//  ChatMe
//
//  Created by Emerson Malca on 6/24/11.
//  Copyright (c) 2011 OneZeroWare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChatMeUser;

@interface Contact : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * isBlocked;
@property (nonatomic, retain) NSNumber * isChatOpen;
@property (nonatomic, retain) NSNumber * visibleContactUserStatus;
@property (nonatomic, retain) ChatMeUser * user;
@property (nonatomic, retain) ChatMeUser * contactUser;
@property (nonatomic, retain) NSString *lastCommunicationText;

@end
