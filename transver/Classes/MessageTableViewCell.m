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
@synthesize backgroundImg;
@synthesize m_date;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    NSString *imagefile = [[NSBundle mainBundle] pathForResource:@"topRow" ofType:@"png"];
    backgroundImg = [[UIImage alloc] initWithContentsOfFile:imagefile];
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
    CGRect backRect;
    //hank draw the bubble image file
    UIImage *userImg = [UIImage imageNamed:@"userWaldo.png"];
    if (messageAlignment == kMessageAlignmentLeft) {
        bgColor = [UIColor whiteColor];
        backRect = CGRectMake(rect.origin.x+20, rect.origin.y , rect.size.width-20, rect.size.height);
    } else {
        bgColor = [UIColor colorWithHue:215.0/360.0 saturation:0.05 brightness:1.0 alpha:1.0];
        backRect = CGRectMake(rect.origin.x, rect.origin.y , rect.size.width-20, rect.size.height);
    }
    [bgColor setFill];
    CGContextFillRect(c, rect);
    CGContextRestoreGState(c);
    
    [backgroundImg drawInRect:backRect];
    
    //We want to draw the image (if any)
    if (image) {
        CGFloat effectiveOriginY;
        //messageAlignment = kMessageAlignmentRight;
        if (messageAlignment == kMessageAlignmentLeft) {
            effectiveOriginY = kMessageSideSeparation;
        } else {
            NSString *myImagePath =  [[NSBundle mainBundle] pathForResource:@"user" ofType:@"png"];
            image = [UIImage imageWithContentsOfFile:myImagePath];
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
    
    NSRange aRange = [text rangeOfString:@"aif"];
    if (aRange.location ==NSNotFound) {
        NSLog(@"string not found");
        [text drawInRect:textRect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:alignment];
    } 
    
    
    //Draw the date
    CGRect dateRect;
    if (messageAlignment == kMessageAlignmentLeft) {
        dateRect = CGRectMake(210.0, 5.0, 60.0, 50.0);
        alignment = UITextAlignmentLeft;
    } else {
        dateRect = CGRectMake(30.0, 5.0, 60.0, 50.0);
        alignment = UITextAlignmentRight;
    }
    font = [UIFont systemFontOfSize:12.0];
    [m_date drawInRect:dateRect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:alignment];
}

- (void)dealloc
{
    self.text = nil;
    self.image = nil;
    [backgroundImg release];
    self.m_date = nil;
    [super dealloc];
}

@end
