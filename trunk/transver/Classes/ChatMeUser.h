//
//  ChatMeUser.h
//  ChatMe
//
//  Created by Emerson Malca on 6/24/11.
//  Copyright (c) 2011 OneZeroWare. All rights reserved.
//

@interface ImageToDataTransformer : NSValueTransformer {

}
@end

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Invitation, Message;

@interface ChatMeUser : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * letterForSorting;
@property (nonatomic, retain) NSNumber * userStatus;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) UIImage * image;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSSet* sentMessages;
@property (nonatomic, retain) NSSet* receivedMessages;
@property (nonatomic, retain) NSSet* contacts;
@property (nonatomic, retain) NSSet* contacted;
@property (nonatomic, retain) NSSet* contactRequestsSent;
@property (nonatomic, retain) NSSet* contactRequestsReceived;

@end
