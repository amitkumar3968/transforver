//
//  Message.h
//  ChatMe
//
//  Created by Emerson Malca on 6/24/11.
//  Copyright (c) 2011 OneZeroWare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChatMeUser;

@interface Message : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * sentDate;
@property (nonatomic, assign) NSInteger srcUser;
@property (nonatomic, assign) NSInteger dstUser;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * seenByRecepient;
@property (nonatomic, retain) ChatMeUser * fromUser;
@property (nonatomic, retain) ChatMeUser * toUser;

@end
