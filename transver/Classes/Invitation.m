//
//  Invitation.m
//  ChatMe
//
//  Created by Emerson Malca on 6/24/11.
//  Copyright (c) 2011 OneZeroWare. All rights reserved.
//

#import "Invitation.h"
#import "ChatMeUser.h"
#import "Common.h"

@implementation Invitation
@dynamic date;
@dynamic invitationStatus;
@dynamic ownerUser;
@dynamic invitedUser;

#warning Complete before starting accepting invitations
- (void)setInvitationStatus:(NSNumber *)invitationStatus {
    [self willChangeValueForKey:@"invitationStatus"];
	[self setPrimitiveValue:invitationStatus forKey:@"invitationStatus"];
	[self didChangeValueForKey:@"invitationStatus"];
    
    if ([self.invitationStatus intValue] == kInvitationStatusAccepted) {
        
        //We need to make them contacts now and delete the invitation
    }
}


@end
