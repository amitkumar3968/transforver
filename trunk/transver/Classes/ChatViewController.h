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
#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>
#import "AudioRecorder.h"

@class Contact;

@interface ChatViewController : UIViewController <ChatBubbleViewDelegate, UINavigationBarDelegate, SectionHeaderViewDelegate, RKRequestQueueDelegate, RKRequestDelegate > {
    NSMutableArray *listOfItems;
    NSTimer *myTimer;
    NSInteger openSectionIndex;
    NSMutableArray *sectionInfoArray;
    NSMutableArray *m_Messages;
    int m_srcid;
    int m_dstid;
    NSString *m_DstName;
    NSMutableDictionary *m_DicMessages;
    RKRequestQueue *m_Quest;
    
    AudioRecorder *audioRecorder;
}

@property (nonatomic, retain) RKRequestQueue *m_Quest;
@property (nonatomic, assign) int m_srcid;
@property (nonatomic, assign) int m_dstid;
@property (nonatomic, retain) NSString *m_DstName;
@property (nonatomic, retain) NSMutableArray* sectionInfoArray;
@property (nonatomic, assign) NSInteger openSectionIndex;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet ChatBubbleView *bubbleView;
@property (nonatomic, retain) Contact *contact;
@property (nonatomic, retain) NSMutableArray *listOfItems;
@property (nonatomic, retain) NSMutableArray *m_Messages;
@property (nonatomic, retain) NSMutableDictionary *m_DicMessages;

@property (nonatomic,retain)  AudioRecorder *audioRecorder;


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (void) fetchMessages:(int) uid DstID:(int)dstid Messages:(NSMutableDictionary *)srcMessages;
- (NSArray*) sendMessages:(NSString *) message;
- (id) initWithRelation: (int) srcid DstID:(int) dstid;
- (void)configureCell:(MessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void) ScanMessages;
- (void)downloadToFile:(NSString *)filename;
- (void) playSound:(NSString *) filename;
- (void)queueRequests:(NSString *)filename;
- (IBAction)startRecording:(id)sender;
- (IBAction)stopRecording:(id)sender;
- (void)EditBtnCtrl:(id)sender;
@end
