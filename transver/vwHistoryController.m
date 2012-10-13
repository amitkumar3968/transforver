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

@synthesize m_historyTableView, m_HistoryDialog, m_RelationKey, m_AlreadyAdd, m_ShowHistoryList, navBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"History", @"History");
        self.tabBarItem.image = [UIImage imageNamed:@"common_icon_his_rest.png"];
        
        UIImage *origImg =     [[UIImage imageNamed:@"common_bg_header@2x.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0f];
        UIImage *headerImg= [[UIImage alloc] initWithCGImage:origImg scale:.5f orientation:UIImageOrientationUp];
        
        //[self.navBar setBackgroundImage:headerImg forBarMetrics:UIBarMetricsDefault];        m_HistoryDialog = [[NSMutableArray alloc] init];
        
        m_RelationKey = [[NSMutableDictionary alloc] init];
        m_AlreadyAdd = [[NSMutableDictionary alloc] init];
        m_ShowHistoryList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) SortHistory {
    NSDictionary *dic;
    int result;
    for (int i=0; i< [m_HistoryDialog count]; i++) 
    {
        result = i;
        if( [m_AlreadyAdd objectForKey:[[NSNumber alloc] initWithInt:i]] )
            continue;
        [m_AlreadyAdd setObject:[[NSNumber alloc] initWithInt:i] forKey:[[NSNumber alloc] initWithInt:i]];
        dic = [m_HistoryDialog objectAtIndex:i];
        for ( int j=0; j< [m_HistoryDialog count]; j++)
        {
            
            NSDictionary *tmpdic = [m_HistoryDialog objectAtIndex:j];
            if( [m_AlreadyAdd objectForKey:[[NSNumber alloc] initWithInt:j]] )
                continue;
            if( i == j)
                continue;
            
            NSLog(@"tmpdic SOURCE id:%@ DEST id:%@ %@",[tmpdic objectForKey:@"DIALOG_SOURCEID"] ,[tmpdic objectForKey:@"DIALOG_DESTINATIONID"],[dic objectForKey:@"USER_NAME"]);
            NSLog(@"dic SOURCE id:%@ DEST id:%@",[dic objectForKey:@"DIALOG_SOURCEID"] ,[dic objectForKey:@"DIALOG_DESTINATIONID"]);
            if( ([[dic objectForKey:@"DIALOG_DESTINATIONID"] intValue] != g_UserID && ([[tmpdic objectForKey:@"DIALOG_SOURCEID"] intValue]==[[dic objectForKey:@"DIALOG_DESTINATIONID"] intValue] || [[tmpdic objectForKey:@"DIALOG_DESTINATIONID"] intValue]==[[dic objectForKey:@"DIALOG_DESTINATIONID"] intValue] ) )|| ([[dic objectForKey:@"DIALOG_SOURCEID"] intValue] != g_UserID && ([[tmpdic objectForKey:@"DIALOG_SOURCEID"] intValue]==[[dic objectForKey:@"DIALOG_SOURCEID"] intValue] || [[tmpdic objectForKey:@"DIALOG_DESTINATIONID"] intValue]==[[dic objectForKey:@"DIALOG_SOURCEID"] intValue] ) ))
            {
                
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *Date1 = [format dateFromString:[dic objectForKey:@"DIALOG_CREATEDTIME"]];
                NSDate *Date2 = [format dateFromString:[tmpdic objectForKey:@"DIALOG_CREATEDTIME"]];
                if( ![m_AlreadyAdd objectForKey:[[NSNumber alloc] initWithInt:j]] )
                    [m_AlreadyAdd setObject:[[NSNumber alloc] initWithInt:j] forKey:[[NSNumber alloc] initWithInt:j]];
                if( [Date2 compare:Date1]>0 )
                {
                    NSLog(@"restult change:%@ %@ %d %d %d", Date2, Date1, [Date2 compare:Date1], i, j);
                    dic = [m_HistoryDialog objectAtIndex:i];
                    result = j;
                }
            }
        }
        [m_ShowHistoryList addObject:[[NSNumber alloc] initWithInt:result]];
    }
    NSLog(@"%d %@", [m_ShowHistoryList count], m_ShowHistoryList);

}

- (void) ScanHistory
{
    NSArray *array = [Util fetchHistory:g_UserID];
    m_HistoryDialog = [array mutableCopy];
    NSLog(@"%@", m_HistoryDialog);
    [self SortHistory];
    [self.m_historyTableView reloadData];
}

- (void) Scan
{
    [self performSelectorOnMainThread:@selector(ScanHistory) withObject:nil waitUntilDone:NO];

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    NSArray *array = [Util fetchHistory:g_UserID];
    m_HistoryDialog = [array mutableCopy];
    [self SortHistory];
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
    for (int i=0; i< [m_HistoryDialog count]; i++) 
    {
        NSDictionary *dic = [m_HistoryDialog objectAtIndex:i];
        NSLog(@"SOURCE id:%@ DEST id:%@",[dic objectForKey:@"DIALOG_SOURCEID"] ,[dic objectForKey:@"DIALOG_DESTINATIONID"]);
        if( [[dic objectForKey:@"DIALOG_DESTINATIONID"] intValue]==g_UserID)
        {
            if( ![dic objectForKey:[dic objectForKey:@"DIALOG_SOURCEID"]] )
                [m_RelationKey setObject:[dic objectForKey:@"DIALOG_SOURCEID"] forKey:[dic objectForKey:@"DIALOG_SOURCEID"]];
        }else {
            if( ![dic objectForKey:[dic objectForKey:@"DIALOG_DESTINATIONID"]] )
                [m_RelationKey setObject:[dic objectForKey:@"DIALOG_DESTINATIONID"] forKey:[dic objectForKey:@"DIALOG_DESTINATIONID"]];
        }
    }
    NSLog(@"%d", [m_RelationKey count]);
    [m_AlreadyAdd removeAllObjects];
    return [m_RelationKey count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[HistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSLog(@"row:%d count:%d", [indexPath row], [m_HistoryDialog count]);
    NSDictionary *dic;
    /*
    int roundindex = [indexPath row];
    
    while( [m_AlreadyAdd objectForKey:[[NSNumber alloc] initWithInt:roundindex]] )
        roundindex++;
    NSLog(@"row:%d roundindex:%d", [indexPath row], roundindex);
    
    if ( roundindex == 13)
        roundindex = [indexPath row];
    dic = [m_HistoryDialog objectAtIndex:roundindex];
    int result = roundindex;
    if( ![m_AlreadyAdd objectForKey:[[NSNumber alloc] initWithInt:roundindex]] )
    [m_AlreadyAdd setObject:[[NSNumber alloc] initWithInt:roundindex] forKey:[[NSNumber alloc] initWithInt:roundindex]];
    for (int i=0; i< [m_HistoryDialog count]; i++) 
    {
        if( i == [indexPath row])
            continue;
        NSDictionary *tmpdic = [m_HistoryDialog objectAtIndex:i];
        NSLog(@"tmpdic SOURCE id:%@ DEST id:%@ %@",[tmpdic objectForKey:@"DIALOG_SOURCEID"] ,[tmpdic objectForKey:@"DIALOG_DESTINATIONID"],[dic objectForKey:@"USER_NAME"]);
        NSLog(@"dic SOURCE id:%@ DEST id:%@",[dic objectForKey:@"DIALOG_SOURCEID"] ,[dic objectForKey:@"DIALOG_DESTINATIONID"]);
        if( ([[dic objectForKey:@"DIALOG_DESTINATIONID"] intValue] != g_UserID && ([[tmpdic objectForKey:@"DIALOG_SOURCEID"] intValue]==[[dic objectForKey:@"DIALOG_DESTINATIONID"] intValue] || [[tmpdic objectForKey:@"DIALOG_DESTINATIONID"] intValue]==[[dic objectForKey:@"DIALOG_DESTINATIONID"] intValue] ) )|| ([[dic objectForKey:@"DIALOG_SOURCEID"] intValue] != g_UserID && ([[tmpdic objectForKey:@"DIALOG_SOURCEID"] intValue]==[[dic objectForKey:@"DIALOG_SOURCEID"] intValue] || [[tmpdic objectForKey:@"DIALOG_DESTINATIONID"] intValue]==[[dic objectForKey:@"DIALOG_SOURCEID"] intValue] ) ))
        {
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *Date1 = [format dateFromString:[dic objectForKey:@"DIALOG_CREATEDTIME"]];
            NSDate *Date2 = [format dateFromString:[tmpdic objectForKey:@"DIALOG_CREATEDTIME"]];
            if( ![m_AlreadyAdd objectForKey:[[NSNumber alloc] initWithInt:i]] )
                [m_AlreadyAdd setObject:[[NSNumber alloc] initWithInt:i] forKey:[[NSNumber alloc] initWithInt:i]];
            if( [Date2 compare:Date1]>0 )
            {
                NSLog(@"restult change:%@ %@ %d %d", Date2, Date1, [Date2 compare:Date1], i);
                dic = [m_HistoryDialog objectAtIndex:i];
                result = i;
            }
        }
    }
    NSLog(@"dic SOURCE id:%@ DEST id:%@",[dic objectForKey:@"DIALOG_SOURCEID"] ,[dic objectForKey:@"DIALOG_DESTINATIONID"]);
    NSLog(@"%d resutl:%d", [indexPath row], result);
    NSLog(@"%@ %@", m_AlreadyAdd, [dic objectForKey:@"DIALOG_MESSAGE"]);
    */
    int index = [indexPath row];
    NSLog(@"%@", [m_ShowHistoryList objectAtIndex:index]);
    dic = [m_HistoryDialog objectAtIndex:[[m_ShowHistoryList objectAtIndex:index] intValue]];
    ((HistoryTableViewCell *)cell).index = [[m_ShowHistoryList objectAtIndex:index] intValue];
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
    NSLog(@"DEST id:%@ %@",[dic objectForKey:@"DIALOG_DESTINATIONID"], [dic objectForKey:@"USER_NAME"]);
    
    
    NSLog(@"%d", [indexPath row]);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tbView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 63.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryTableViewCell *myCell = [tableView cellForRowAtIndexPath:indexPath];
    NSInteger row = [indexPath row];
    {
        /*
        NSDictionary *dic = [m_HistoryDialog objectAtIndex:row];
        for (int i=0; i< [m_HistoryDialog count]; i++) 
        {
            if( i == [indexPath row])
                continue;
            NSDictionary *tmpdic = [m_HistoryDialog objectAtIndex:i];
            NSLog(@"SOURCE id:%@ DEST id:%@",[tmpdic objectForKey:@"DIALOG_SOURCEID"] ,[tmpdic objectForKey:@"DIALOG_DESTINATIONID"]);
            if( [[tmpdic objectForKey:@"DIALOG_SOURCEID"] intValue]==[[dic objectForKey:@"DIALOG_DESTINATIONID"] intValue])
            {
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *Date1 = [format dateFromString:[dic objectForKey:@"DIALOG_CREATEDTIME"]];
                NSDate *Date2 = [format dateFromString:[tmpdic objectForKey:@"DIALOG_CREATEDTIME"]];
                if( [Date2 compare:Date1]>0 )
                    dic = [m_HistoryDialog objectAtIndex:i];
            }
        }
        NSLog(@"%@", [dic objectForKey:@"USER_NAME"]);
        */
        NSDictionary *dic = [m_HistoryDialog objectAtIndex:myCell.index];
        ChatViewController *chat = [[ChatViewController alloc] initWithRelation:g_UserID DstID:[[dic objectForKey:@"DIALOG_DESTINATIONID"] integerValue]];
        chat.m_DstName = ([dic objectForKey:@"USER_NAME"] == [NSNull null])?@"NO NAME":[dic objectForKey:@"USER_NAME"];
        chat.m_dstid = ([[dic objectForKey:@"DIALOG_DESTINATIONID"] intValue]==g_UserID)?[[dic objectForKey:@"DIALOG_SOURCEID"] intValue]:[[dic objectForKey:@"DIALOG_DESTINATIONID"] intValue];
        //ChatViewController *chat = [[ChatViewController alloc] initWithRelation:1 DstID:2];
        NSLog(@"m_dstid:%d %d", chat.m_dstid, [[dic objectForKey:@"DIALOG_DESTINATIONID"] intValue]);
        //[chat setContact:contact];
        UINavigationController *navCtlr = [[UINavigationController alloc] initWithRootViewController:chat];
        navCtlr.navigationBar.barStyle = UIBarStyleDefault;
        UIImage *origImg =     [[UIImage imageNamed:@"common_bg_header@2x.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0f];
        UIImage *headerImg= [[UIImage alloc] initWithCGImage:origImg scale:.5f orientation:UIImageOrientationUp];

        //[navCtlr.navigationBar setBackgroundImage:headerImg forBarMetrics:UIBarMetricsDefault];
        
        [g_RootController presentModalViewController:navCtlr animated:NO];
        [navCtlr release];
        //((UITabBarController *)g_RootController).tabBar.hidden = YES;
        //self.navigationController.navigationBar.delegate = self;
        
        [chat release];
        
    }
}
@end
