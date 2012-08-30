//
//  vwHistoryController.m
//  NavTab
//
//  Created by hank chen on 8/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "vwHistoryController.h"
#import "HistoryTableViewCell.h"
#import "ChatViewController.h"
#import "Util.h"

@interface vwHistoryController ()

@end

@implementation vwHistoryController

@synthesize m_historyTableView, m_HistoryDialog;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"History", @"History");
        self.tabBarItem.image = [UIImage imageNamed:@"common_icon_his_rest.png"];
        m_HistoryDialog = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) ScanHistory
{
    NSArray *array = [Util fetchHistory:g_UserID];
    m_HistoryDialog = [array mutableCopy];
    [self.m_historyTableView reloadData];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    NSArray *array = [Util fetchHistory:g_UserID];
    m_HistoryDialog = [array mutableCopy];
    myTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(ScanHistory) userInfo:nil repeats:YES];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [m_HistoryDialog count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[HistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    NSDictionary *dic = [m_HistoryDialog objectAtIndex:[indexPath row]];
    if( [dic objectForKey:@"USER_NAME"] == [NSNull null])
        ((HistoryTableViewCell *)cell).m_DestName = @"NO NAME";
    else
        ((HistoryTableViewCell *)cell).m_DestName = [dic objectForKey:@"USER_NAME"];
    if( [dic objectForKey:@"DIALOG_MESSAGE"] == [NSNull null])
        ((HistoryTableViewCell *)cell).m_DestMsg = @"";
    else
        ((HistoryTableViewCell *)cell).m_DestMsg = [dic objectForKey:@"DIALOG_MESSAGE"];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLog(@"%@", [dic objectForKey:@"DIALOG_CREATEDTIME"]);
     NSDate *tmpDate = [format dateFromString:[dic objectForKey:@"DIALOG_CREATEDTIME"]];
    [format setDateFormat:@"yyyy-MM-dd"];
    if( [dic objectForKey:@"DIALOG_CREATEDTIME"] == [NSNull null])
        ((HistoryTableViewCell *)cell).m_DestDate = @"";
    else
        ((HistoryTableViewCell *)cell).m_DestDate = [format stringFromDate:tmpDate];
    NSLog(@"DEST id:%@",[dic objectForKey:@"DIALOG_DESTINATIONID"]);
    
    
    NSLog(@"%d", [indexPath row]);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tbView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 63.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    {
        NSDictionary *dic = [m_HistoryDialog objectAtIndex:row];
        NSLog(@"%@", [dic objectForKey:@"USER_NAME"]);
        
        ChatViewController *chat = [[ChatViewController alloc] initWithRelation:g_UserID DstID:[[dic objectForKey:@"DIALOG_DESTINATIONID"] integerValue]];
        chat.m_DstName = ([dic objectForKey:@"USER_NAME"] == [NSNull null])?@"NO NAME":[dic objectForKey:@"USER_NAME"];
        chat.m_dstid = ([[dic objectForKey:@"DIALOG_DESTINATIONID"] intValue]==g_UserID)?[[dic objectForKey:@"DIALOG_SOURCEID"] intValue]:[[dic objectForKey:@"DIALOG_DESTINATIONID"] intValue];
        //ChatViewController *chat = [[ChatViewController alloc] initWithRelation:1 DstID:2];
        NSLog(@"m_dstid:%d %d", chat.m_dstid, [[dic objectForKey:@"DIALOG_DESTINATIONID"] intValue]);
        //[chat setContact:contact];
        UINavigationController *navCtlr = [[UINavigationController alloc] initWithRootViewController:chat];
        navCtlr.navigationBar.barStyle = UIBarStyleDefault;
        
        [g_RootController presentModalViewController:navCtlr animated:NO];
        [navCtlr release];
        //((UITabBarController *)g_RootController).tabBar.hidden = YES;
        //self.navigationController.navigationBar.delegate = self;
        
        [chat release];
        
    }
}
@end
