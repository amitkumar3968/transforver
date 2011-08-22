//
//  ChatMeUser.m
//  ChatMe
//
//  Created by Emerson Malca on 6/24/11.
//  Copyright (c) 2011 OneZeroWare. All rights reserved.
//

#import "ChatMeUser.h"
#import "Invitation.h"
#import "Message.h"


@implementation ChatMeUser
@dynamic userID;
@dynamic firstName;
@dynamic letterForSorting;
@dynamic userStatus;
@dynamic fullName;
@dynamic username;
@dynamic image;
@dynamic lastName;
@dynamic sentMessages;
@dynamic receivedMessages;
@dynamic contacts;
@dynamic contacted;
@dynamic contactRequestsSent;
@dynamic contactRequestsReceived;

- (void)setFirstName:(NSString *)firstName {
    [self willChangeValueForKey:@"firstName"];
	[self setPrimitiveValue:firstName forKey:@"firstName"];
	[self didChangeValueForKey:@"firstName"];
    
    //Get the first letter
    NSString *aString = [firstName uppercaseString];

	// support UTF-16:
	if (aString != nil && ![aString isEqualToString:@""]) {
		aString = [aString substringWithRange:[aString rangeOfComposedCharacterSequenceAtIndex:0]];
	} else {
		aString = @"#";
	}
    
    //Update the letter for sorting
    [self setLetterForSorting:aString];
}

- (NSString *)fullName {
    NSString *_fullName;
    
    [self willAccessValueForKey:@"fullName"];
	_fullName = [self primitiveValueForKey:@"fullName"];
	[self didAccessValueForKey:@"fullName"];
	
	if (_fullName == nil) {
		_fullName = [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
		[self setPrimitiveValue:_fullName forKey:@"fullName"]; 
	}  
    return _fullName;
}

- (void)addSentMessagesObject:(Message *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"sentMessages" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"sentMessages"] addObject:value];
    [self didChangeValueForKey:@"sentMessages" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeSentMessagesObject:(Message *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"sentMessages" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"sentMessages"] removeObject:value];
    [self didChangeValueForKey:@"sentMessages" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addSentMessages:(NSSet *)value {    
    [self willChangeValueForKey:@"sentMessages" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"sentMessages"] unionSet:value];
    [self didChangeValueForKey:@"sentMessages" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeSentMessages:(NSSet *)value {
    [self willChangeValueForKey:@"sentMessages" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"sentMessages"] minusSet:value];
    [self didChangeValueForKey:@"sentMessages" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addReceivedMessagesObject:(Message *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"receivedMessages" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"receivedMessages"] addObject:value];
    [self didChangeValueForKey:@"receivedMessages" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeReceivedMessagesObject:(Message *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"receivedMessages" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"receivedMessages"] removeObject:value];
    [self didChangeValueForKey:@"receivedMessages" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addReceivedMessages:(NSSet *)value {    
    [self willChangeValueForKey:@"receivedMessages" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"receivedMessages"] unionSet:value];
    [self didChangeValueForKey:@"receivedMessages" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeReceivedMessages:(NSSet *)value {
    [self willChangeValueForKey:@"receivedMessages" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"receivedMessages"] minusSet:value];
    [self didChangeValueForKey:@"receivedMessages" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addContactsObject:(NSManagedObject *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"contacts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"contacts"] addObject:value];
    [self didChangeValueForKey:@"contacts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeContactsObject:(NSManagedObject *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"contacts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"contacts"] removeObject:value];
    [self didChangeValueForKey:@"contacts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addContacts:(NSSet *)value {    
    [self willChangeValueForKey:@"contacts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"contacts"] unionSet:value];
    [self didChangeValueForKey:@"contacts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeContacts:(NSSet *)value {
    [self willChangeValueForKey:@"contacts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"contacts"] minusSet:value];
    [self didChangeValueForKey:@"contacts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

- (void)addContactedObject:(NSManagedObject *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"contacted" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"contacted"] addObject:value];
    [self didChangeValueForKey:@"contacted" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeContactedObject:(NSManagedObject *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"contacted" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"contacted"] removeObject:value];
    [self didChangeValueForKey:@"contacted" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addContacted:(NSSet *)value {    
    [self willChangeValueForKey:@"contacted" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"contacted"] unionSet:value];
    [self didChangeValueForKey:@"contacted" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeContacted:(NSSet *)value {
    [self willChangeValueForKey:@"contacted" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"contacted"] minusSet:value];
    [self didChangeValueForKey:@"contacted" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

- (void)addContactRequestsSentObject:(Invitation *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"contactRequestsSent" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"contactRequestsSent"] addObject:value];
    [self didChangeValueForKey:@"contactRequestsSent" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeContactRequestsSentObject:(Invitation *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"contactRequestsSent" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"contactRequestsSent"] removeObject:value];
    [self didChangeValueForKey:@"contactRequestsSent" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addContactRequestsSent:(NSSet *)value {    
    [self willChangeValueForKey:@"contactRequestsSent" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"contactRequestsSent"] unionSet:value];
    [self didChangeValueForKey:@"contactRequestsSent" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeContactRequestsSent:(NSSet *)value {
    [self willChangeValueForKey:@"contactRequestsSent" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"contactRequestsSent"] minusSet:value];
    [self didChangeValueForKey:@"contactRequestsSent" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addContactRequestsReceivedObject:(Invitation *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"contactRequestsReceived" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"contactRequestsReceived"] addObject:value];
    [self didChangeValueForKey:@"contactRequestsReceived" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeContactRequestsReceivedObject:(Invitation *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"contactRequestsReceived" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"contactRequestsReceived"] removeObject:value];
    [self didChangeValueForKey:@"contactRequestsReceived" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addContactRequestsReceived:(NSSet *)value {    
    [self willChangeValueForKey:@"contactRequestsReceived" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"contactRequestsReceived"] unionSet:value];
    [self didChangeValueForKey:@"contactRequestsReceived" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeContactRequestsReceived:(NSSet *)value {
    [self willChangeValueForKey:@"contactRequestsReceived" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"contactRequestsReceived"] minusSet:value];
    [self didChangeValueForKey:@"contactRequestsReceived" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

- (void)awakeFromInsert {
	[super awakeFromInsert];
	
	CFUUIDRef   uuid;
    CFStringRef uuidStr;
	
	//Creating a unique identifier
	uuid = CFUUIDCreate(NULL);
	//Getting the string for this unique identifier
	uuidStr = CFUUIDCreateString(NULL, uuid);
	
	//Setting the Unique Note Identifier string
    [self setUserID:(NSString*)uuidStr];
	
	//Cleaning up
	CFRelease(uuidStr);
    CFRelease(uuid);
}

@end

@implementation ImageToDataTransformer


+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}


- (id)transformedValue:(id)value {
	NSData *data = UIImagePNGRepresentation(value);
	return data;
}


- (id)reverseTransformedValue:(id)value {
	UIImage *uiImage = [[UIImage alloc] initWithData:value];
	return [uiImage autorelease];
}


@end
