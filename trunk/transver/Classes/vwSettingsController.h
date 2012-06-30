//
//  vwSettingsController.h
//  VEMsg
//
//  Created by sir 余 on 12/5/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface vwSettingsController : UIViewController
{
    IBOutlet UIButton *uibtEraseHist;
    
}
@property (nonatomic, retain) UIButton *uibtEraseHist;
- (IBAction)setEraseHistPeriod:(id)sender;
@end
