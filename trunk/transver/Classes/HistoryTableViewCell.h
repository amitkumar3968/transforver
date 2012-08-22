//
//  HistoryTableViewCell.h
//  NavTab
//
//  Created by hank chen on 8/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell
{
    NSString *m_DestName;
    NSString *m_DestMsg;
    NSString *m_DestDate;
}

@property (nonatomic, retain) IBOutlet UIImageView *thumbnailView;
@property (nonatomic, retain) IBOutlet UIImageView *arrowView;
@property (nonatomic, retain) NSString *m_DestName;
@property (nonatomic, retain) NSString *m_DestMsg;
@property (nonatomic, retain) NSString *m_DestDate;
@end
