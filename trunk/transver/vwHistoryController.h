//
//  vwHistoryController.h
//  NavTab
//
//  Created by hank chen on 8/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface vwHistoryController : UIViewController <UINavigationBarDelegate, UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *m_historyTableView;
    NSMutableArray *m_HistoryDialog;
    NSTimer *myTimer;
    NSMutableDictionary *m_RelationKey;
    NSMutableDictionary *m_AlreadyAdd;
    NSMutableArray *m_ShowHistoryList;
}

@property (nonatomic, retain) IBOutlet UITableView *m_historyTableView;
@property (nonatomic, retain) NSMutableArray *m_HistoryDialog;
@property (nonatomic, retain) NSMutableDictionary *m_RelationKey;
@property (nonatomic, retain) NSMutableDictionary *m_AlreadyAdd;
@property (nonatomic, retain) NSMutableArray *m_ShowHistoryList;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;

@end
