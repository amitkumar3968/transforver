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
@synthesize TimerLabel;

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
    NSLog(@"drawRect %f", rect.size.height);
    int rectheight = rect.size.height;
    //Paint the background
    CGContextRef c = UIGraphicsGetCurrentContext();	
	CGContextSaveGState(c);
    UIColor *bgColor;
    CGRect backRect;
    CGFloat effectiveOriginY;
    CGRect LeftbottomRect, LefttopRect, LeftmiddleRect;
    CGRect MiddlebottomRect, MiddletopRect, MiddlemiddleRect;
    CGRect RightbottomRect, RighttopRect, RightmiddleRect;
    //hank draw the bubble image file
    UIImage *LeftbottomImg, *LefttopImg, *LeftmiddleImg;
    UIImage *MiddlebottomImg, *MiddletopImg, *MiddlemiddleImg;
    UIImage *RightbottomImg, *RighttopImg, *RightmiddleImg;
    
    
    if (messageAlignment == kMessageAlignmentLeft) {
        bgColor = [UIColor blackColor];
        backRect = CGRectMake(rect.origin.x+20, rect.origin.y , rect.size.width-20, rect.size.height);
    } else {
        bgColor = [UIColor blackColor];
        backRect = CGRectMake(rect.origin.x, rect.origin.y , rect.size.width-20, rect.size.height);
    }
    [bgColor setFill];
    CGContextFillRect(c, rect);
    CGContextRestoreGState(c);
    int middleHeight = 42;
    int middleWidth = 200;
    int xoffset = 90;
    int yoffset = 10;
    NSRange aRange = [text rangeOfString:@"caf"];
    if (aRange.location ==NSNotFound) {
        middleHeight = rectheight-42;
    }
    if (messageAlignment == kMessageAlignmentLeft) {
        
        LefttopImg = [UIImage imageNamed:@"message_div_dialogea_1.png"];
        LefttopRect = CGRectMake(rect.origin.x, rect.origin.y+yoffset , LefttopImg.size.width, LefttopImg.size.height);
        LeftmiddleImg = [UIImage imageNamed:@"message_div_dialogea_4.png"];
        LeftmiddleRect = CGRectMake(rect.origin.x, rect.origin.y+LefttopImg.size.height+yoffset , LeftmiddleImg.size.width, middleHeight);
        LeftbottomImg = [UIImage imageNamed:@"message_div_dialogea_7.png"];
        LeftbottomRect = CGRectMake(rect.origin.x, rect.origin.y+middleHeight+LefttopImg.size.height+yoffset , LeftbottomImg.size.width, LeftbottomImg.size.height);
        
        //right
        
        RighttopImg = [UIImage imageNamed:@"message_div_dialogea_3.png"];
        RighttopRect = CGRectMake(rect.origin.x+middleWidth+LefttopImg.size.width, rect.origin.y+yoffset , RighttopImg.size.width, RighttopImg.size.height);
        RightmiddleImg = [UIImage imageNamed:@"message_div_dialogea_6.png"];
        RightmiddleRect = CGRectMake(rect.origin.x+middleWidth+LefttopImg.size.width, rect.origin.y+RighttopImg.size.height+yoffset , RightmiddleImg.size.width, middleHeight);
        RightbottomImg = [UIImage imageNamed:@"message_div_dialogea_9.png"];
        RightbottomRect = CGRectMake(rect.origin.x+middleWidth+LefttopImg.size.width, rect.origin.y+middleHeight+RighttopImg.size.height+yoffset , RightbottomImg.size.width, RightbottomImg.size.height);
        //middle
        
        MiddletopImg = [UIImage imageNamed:@"message_div_dialogea_2.png"];
        MiddletopRect = CGRectMake(rect.origin.x+LefttopImg.size.width, rect.origin.y+yoffset , middleWidth, LefttopImg.size.height);
        MiddlemiddleImg = [UIImage imageNamed:@"message_div_dialogea_5.png"];
        MiddlemiddleRect = CGRectMake(rect.origin.x+LefttopImg.size.width, rect.origin.y+LefttopImg.size.height+yoffset , middleWidth, middleHeight);
        MiddlebottomImg = [UIImage imageNamed:@"message_div_dialogea_8.png"];
        MiddlebottomRect = CGRectMake(rect.origin.x+LefttopImg.size.width, rect.origin.y+middleHeight+LefttopImg.size.height+yoffset , middleWidth, LeftbottomImg.size.height);
    } else {
        LefttopImg = [UIImage imageNamed:@"message_div_dialogeb_1.png"];
        LefttopRect = CGRectMake(rect.origin.x+xoffset, rect.origin.y+yoffset , LefttopImg.size.width, LefttopImg.size.height);
        LeftmiddleImg = [UIImage imageNamed:@"message_div_dialogeb_4.png"];
        LeftmiddleRect = CGRectMake(rect.origin.x+xoffset, rect.origin.y+LefttopImg.size.height+yoffset , LeftmiddleImg.size.width, middleHeight);
        LeftbottomImg = [UIImage imageNamed:@"message_div_dialogeb_7.png"];
        LeftbottomRect = CGRectMake(rect.origin.x+xoffset, rect.origin.y+middleHeight+LefttopImg.size.height+yoffset , LeftbottomImg.size.width, LeftbottomImg.size.height);
        
        //right
        
        RighttopImg = [UIImage imageNamed:@"message_div_dialogeb_3.png"];
        RighttopRect = CGRectMake(rect.origin.x+middleWidth+LefttopImg.size.width+xoffset, rect.origin.y+yoffset , RighttopImg.size.width, RighttopImg.size.height);
        RightmiddleImg = [UIImage imageNamed:@"message_div_dialogeb_6.png"];
        RightmiddleRect = CGRectMake(rect.origin.x+middleWidth+LefttopImg.size.width+xoffset, rect.origin.y+RighttopImg.size.height+yoffset , RightmiddleImg.size.width, middleHeight);
        RightbottomImg = [UIImage imageNamed:@"message_div_dialogeb_9.png"];
        RightbottomRect = CGRectMake(rect.origin.x+middleWidth+LefttopImg.size.width+xoffset, rect.origin.y+middleHeight+RighttopImg.size.height+yoffset , RightbottomImg.size.width, RightbottomImg.size.height);
        //middle
        
        MiddletopImg = [UIImage imageNamed:@"message_div_dialogeb_2.png"];
        MiddletopRect = CGRectMake(rect.origin.x+LefttopImg.size.width+xoffset, rect.origin.y+yoffset , middleWidth, LefttopImg.size.height);
        MiddlemiddleImg = [UIImage imageNamed:@"message_div_dialogeb_5.png"];
        MiddlemiddleRect = CGRectMake(rect.origin.x+LefttopImg.size.width+xoffset, rect.origin.y+LefttopImg.size.height+yoffset , middleWidth, middleHeight);
        MiddlebottomImg = [UIImage imageNamed:@"message_div_dialogeb_8.png"];
        MiddlebottomRect = CGRectMake(rect.origin.x+LefttopImg.size.width+xoffset, rect.origin.y+middleHeight+LefttopImg.size.height+yoffset , middleWidth, LeftbottomImg.size.height);
    }
    [LeftbottomImg drawInRect:LeftbottomRect];
    [LefttopImg drawInRect:LefttopRect];
    [LeftmiddleImg drawInRect:LeftmiddleRect];
    
    //right
    [RightbottomImg drawInRect:RightbottomRect];
    [RighttopImg drawInRect:RighttopRect];
    [RightmiddleImg drawInRect:RightmiddleRect];
    
    //middle
    [MiddlebottomImg drawInRect:MiddlebottomRect];
    [MiddletopImg drawInRect:MiddletopRect];
    [MiddlemiddleImg drawInRect:MiddlemiddleRect];
    //[backgroundImg drawInRect:backRect];
    //[leftbottomImg drawInRect:backRect];
    //We want to draw the image (if any)
    if (image) {
        
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
    
    UITextAlignment alignment;
    if (messageAlignment == kMessageAlignmentLeft) {
        effectiveOriginY = kMessageSideSeparation*2 + kMessageImageWidth;
        alignment = UITextAlignmentLeft;
    } else {
        effectiveOriginY = kMessageBigSeparation;
        alignment = UITextAlignmentRight;
    }
    CGRect textRect = CGRectMake(effectiveOriginY, kMessageTopSeparation, rect.size.width - kMessageSideSeparation*2 - kMessageImageWidth - kMessageBigSeparation -20, kMaxHeight);
    
    //textRect.size.width -= 20;
    CGSize textSize = [text sizeWithFont:font constrainedToSize:textRect.size lineBreakMode:UILineBreakModeWordWrap];
    textRect.size.height = textSize.height;
    NSLog(@"%@", text);
    aRange = [text rangeOfString:@"caf"];
    if (aRange.location ==NSNotFound) {
        NSLog(@"string not found");
        [text drawInRect:textRect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:alignment];
    } 
    
    
    //Draw the date
    CGRect dateRect;
    if (messageAlignment == kMessageAlignmentLeft) {
        dateRect = CGRectMake(230.0, rectheight-20.0, 60.0, 50.0);
        alignment = UITextAlignmentLeft;
    } else {
        dateRect = CGRectMake(30.0, rectheight-20.0, 60.0, 50.0);
        alignment = UITextAlignmentRight;
    }
    font = [UIFont systemFontOfSize:12.0];
    [[UIColor colorWithRed:83/255.0
                     green:126/255.0
                      blue:240/255.0
                     alpha:1.0] set];
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
