//
//  MessageTableViewCell.h
//  ChatMe
//
//  Created by Emerson Malca on 6/25/11.
//  Copyright 2011 OneZeroWare. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMessageSideSeparation      10.0
#define kMessageTopSeparation      5.0
#define kMessageImageWidth      30.0
#define kMessageBigSeparation   70.0
#define kMaxHeight              9999.0

@interface MessageTableViewCell : UITableViewCell {
    
}

@property (nonatomic) NSInteger messageAlignment;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) UIImage *image;

@end
