//
//  Common.h
//  ChatMe
//
//  Created by Emerson Malca on 6/23/11.
//  Copyright 2011 OneZeroWare. All rights reserved.
//

typedef enum {
    kUserStatusOffline = 0,
    kUserStatusOnline = 1
} kUserStatus;

typedef enum {
    kInvitationStatusPending = 0,
    kInvitationStatusAccepted = 1,
    kInvitationStatusDenied = 2
} kInvitationStatus;

typedef enum {
    kMessageAlignmentLeft = 0,
    kMessageAlignmentRight = 1
} kMessageAlignment;