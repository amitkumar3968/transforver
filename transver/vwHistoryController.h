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
}

@property (nonatomic, retain) IBOutlet UITableView *m_historyTableView;
@property (nonatomic, retain) NSMutableArray *m_HistoryDialog;
@end
