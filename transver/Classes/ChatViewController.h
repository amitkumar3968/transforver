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

@class Contact;

@interface ChatViewController : UIViewController <ChatBubbleViewDelegate, NSFetchedResultsControllerDelegate> {
    
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet ChatBubbleView *bubbleView;
@property (nonatomic, retain) Contact *contact;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
