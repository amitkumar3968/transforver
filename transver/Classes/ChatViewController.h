//
//  ChatViewController.h
//  ChatMe
//
//  Created by Emerson Malca on 6/24/11.
//  Copyright 2011 OneZeroWare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ChatBubbleView.h"
#import "DBHandler.h"
#import "JSON.h"
#import "SectionInfo.h"
#import "SectionHeaderView.h"
#import "MessageTableViewCell.h"

@class Contact;

@interface ChatViewController : UIViewController <ChatBubbleViewDelegate, UINavigationBarDelegate, SectionHeaderViewDelegate> {
    NSMutableArray *listOfItems;
    NSTimer *myTimer;
    NSInteger openSectionIndex;
    NSMutableArray* sectionInfoArray;
    NSMutableArray *m_Messages;
}

@property (nonatomic, retain) NSMutableArray* sectionInfoArray;
@property (nonatomic, assign) NSInteger openSectionIndex;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet ChatBubbleView *bubbleView;
@property (nonatomic, retain) Contact *contact;
@property (nonatomic, retain) NSMutableArray *listOfItems;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSMutableArray *m_Messages;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSArray*) fetchMessages:(int) uid DstID:(int)dstid;
- (NSArray*) sendMessages:(int) uid;
- (id) initWithRelation: (int) srcid DstID:(int) dstid;
- (void)configureCell:(MessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath ;
@end
