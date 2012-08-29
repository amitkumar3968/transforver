//
//  HistoryTableViewCell.m
//  NavTab
//
//  Created by hank chen on 8/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HistoryTableViewCell.h"

@interface HistoryTableViewCell ()

@end

@implementation HistoryTableViewCell

@synthesize thumbnailView, arrowView, m_DestName, m_DestMsg, m_DestDate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //[self initialSetup];
    }
    
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIFont *font = [UIFont systemFontOfSize:16.0];
    
    self.thumbnailView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"contacts_bg_contact.png"]];
    self.thumbnailView.contentMode = UIViewContentModeScaleAspectFit;
    [self.thumbnailView setFrame:CGRectMake(0, 0, 62, 62)];
    [self addSubview:thumbnailView];
    
    self.arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_btn_nextpage.png"]];
    self.arrowView.contentMode = UIViewContentModeScaleAspectFit;
    [self.arrowView setFrame:CGRectMake(280, 40, 9, 13)];
    [self addSubview:arrowView];
    
    //Draw the name
    NSString *txtName = m_DestName;
    CGRect textRect = CGRectMake(80, 5, 180, 60);
    CGSize textSize = [txtName sizeWithFont:font constrainedToSize:textRect.size];
    textRect.size.height = textSize.height;
    NSLog(@"%@", txtName);
    [[UIColor colorWithRed:83/255.0
                     green:126/255.0
                      blue:240/255.0
                     alpha:1.0] set];
    [txtName drawInRect:textRect withFont:font];
    
    font = [UIFont systemFontOfSize:14.0];
    //Draw the text
    NSString *text = m_DestDate;
    textRect = CGRectMake(220, 5, 80, 60);
    textSize = [text sizeWithFont:font constrainedToSize:textRect.size];
    textRect.size.height = textSize.height;
    NSLog(@"%@", text);
    [[UIColor colorWithRed:83/255.0
                     green:126/255.0
                      blue:240/255.0
                     alpha:1.0] set];
    [text drawInRect:textRect withFont:font];
    
    //Draw Message
    
    NSString *txtMsg = m_DestMsg;
    textRect = CGRectMake(80, 25, 80, 60);
    textSize = [text sizeWithFont:font constrainedToSize:textRect.size];
    textRect.size.height = textSize.height;
    NSLog(@"%@", text);
    [[UIColor colorWithRed:0/255.0
                     green:0/255.0
                      blue:0/255.0
                     alpha:1.0] set];
    [txtMsg drawInRect:textRect withFont:font];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
