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

@interface vwHistoryController ()

@end

@implementation vwHistoryController

@synthesize m_historyTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"History", @"History");
        self.tabBarItem.image = [UIImage imageNamed:@"common_icon_his_rest.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[HistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
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
        //[self.tabViewController setTitle:[accounts objectAtIndex:indexPath.row]];
        //[self.navigationController pushViewController:self.tabViewController animated:YES];
        //Show the message chat view
        //ChatViewController *chat = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
        ChatViewController *chat = [[ChatViewController alloc] initWithRelation:g_UserID DstID:[[g_AccountID objectAtIndex:row] integerValue]];
        chat.m_DstName = [g_AccountName objectAtIndex:indexPath.row];
        chat.m_dstid = [[g_AccountID objectAtIndex:indexPath.row] intValue];
        //ChatViewController *chat = [[ChatViewController alloc] initWithRelation:1 DstID:2];
        NSLog(@"m_dstid:%d", [[g_AccountID objectAtIndex:indexPath.row] intValue]);
        //[chat setContact:contact];
        UINavigationController *navCtlr = [[UINavigationController alloc] initWithRootViewController:chat];
        navCtlr.navigationBar.barStyle = UIBarStyleDefault;
        
        [g_RootController presentModalViewController:navCtlr animated:YES];
        [navCtlr release];
        //((UITabBarController *)g_RootController).tabBar.hidden = YES;
        //self.navigationController.navigationBar.delegate = self;
        
        [chat release];
        
    }
}
@end
