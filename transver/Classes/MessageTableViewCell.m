//
//  MessageTableViewCell.m
//  ChatMe
//
//  Created by Emerson Malca on 6/25/11.
//  Copyright 2011 OneZeroWare. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "Common.h"

@implementation MessageTableViewCell

@synthesize messageAlignment;
@synthesize text;
@synthesize image;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    //Paint the background
    CGContextRef c = UIGraphicsGetCurrentContext();	
	CGContextSaveGState(c);
    UIColor *bgColor;
    if (messageAlignment == kMessageAlignmentLeft) {
        bgColor = [UIColor whiteColor];
    } else {
        bgColor = [UIColor colorWithHue:215.0/360.0 saturation:0.05 brightness:1.0 alpha:1.0];
    }
    [bgColor setFill];
    CGContextFillRect(c, rect);
    CGContextRestoreGState(c);
    
    //We want to draw the image (if any)
    if (image) {
        CGFloat effectiveOriginY;
        if (messageAlignment == kMessageAlignmentLeft) {
            effectiveOriginY = kMessageSideSeparation;
        } else {
            effectiveOriginY = CGRectGetWidth(rect) - kMessageSideSeparation - kMessageImageWidth;
        }
        CGRect imageRect = CGRectMake(effectiveOriginY, kMessageTopSeparation, kMessageImageWidth, kMessageImageWidth);
        
        [image drawInRect:imageRect];
    }
    
    UIFont *font = [UIFont systemFontOfSize:16.0];
    
    //Draw the text
    CGFloat effectiveOriginY;
    UITextAlignment alignment;
    if (messageAlignment == kMessageAlignmentLeft) {
        effectiveOriginY = kMessageSideSeparation*2 + kMessageImageWidth;
        alignment = UITextAlignmentLeft;
    } else {
        effectiveOriginY = kMessageBigSeparation;
        alignment = UITextAlignmentRight;
    }
    CGRect textRect = CGRectMake(effectiveOriginY, kMessageTopSeparation, rect.size.width - kMessageSideSeparation*2 - kMessageImageWidth - kMessageBigSeparation, kMaxHeight);
    CGSize textSize = [text sizeWithFont:font constrainedToSize:textRect.size lineBreakMode:UILineBreakModeWordWrap];
    textRect.size.height = textSize.height;
    [text drawInRect:textRect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:alignment];
    
}

- (void)dealloc
{
    self.text = nil;
    self.image = nil;
    [super dealloc];
}

@end
