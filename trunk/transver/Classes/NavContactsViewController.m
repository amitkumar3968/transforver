//
//  NavContactsViewController.m
//  NavTab
//
//  Created by hank chen on 12/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NavContactsViewController.h"


@implementation NavContactsViewController

@synthesize navigationController, contactsController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) buttonPushed:(id)sender
{
    UIButton *imageButton = (UIButton *)sender;
    [imageButton setSelected:YES];
    //[((UITabBarController *) self.parentViewController) setSelectedIndex:2];
}

- (void) SwitchTab:(NSString *) number
{
    [((UITabBarController *) self.parentViewController) setSelectedIndex:2];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //tableViewNavigationBar = [[UINavigationBar alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    
	UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    imageButton.frame = CGRectMake(21.0, 0.0, 138.0, 44.0);
    [imageButton setTitle:@"ALL" forState:UIControlStateNormal];
    [imageButton setBackgroundImage:[UIImage imageNamed:@"contacts_btn_header_unslected.png"] forState:UIControlStateNormal];
    [imageButton setBackgroundImage:[UIImage imageNamed:@"contacts_btn_header_unslected.png"] forState:UIControlStateHighlighted];
    [imageButton setBackgroundImage:[UIImage imageNamed:@"contacts_btn_header_slected.png"] forState:UIControlStateSelected];
    [imageButton setSelected:YES];
	[imageButton addTarget:self action:@selector(buttonPushed:)
		  forControlEvents:UIControlEventTouchUpInside];
    UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filterButton.frame = CGRectMake(161.0, 0.0, 138.0, 44.0);
    [filterButton setTitle:@"Messenger" forState:UIControlStateNormal];
    [filterButton setBackgroundImage:[UIImage imageNamed:@"contacts_btn_header_unslected.png"] forState:UIControlStateNormal];
    [filterButton setBackgroundImage:[UIImage imageNamed:@"contacts_btn_header_slected.png"] forState:UIControlStateSelected];
    [filterButton setBackgroundImage:[UIImage imageNamed:@"contacts_btn_header_slected.png"] forState:UIControlStateSelected];
	[filterButton addTarget:self action:@selector(buttonPushed:)
           forControlEvents:UIControlEventTouchUpInside];
    //[imageButton setImage:[UIImage imageNamed:@"phone.png"] forState:UIControlStateNormal];
    CGRect transparentViewFrame = CGRectMake(0.0, 0.0f, 320.0f, 44.0f);
    
    UIView *m_view = [[UIView alloc] initWithFrame:transparentViewFrame];
    m_view.backgroundColor = [UIColor blackColor];
    m_view.alpha = 1;
    m_view.tag = 1;
    [m_view addSubview:imageButton];
    [m_view addSubview:filterButton];
    
    //searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 44.0f, 320.0f, 44.0f)];
    //[searchBar setFrame:CGRectMake(0.0f, 44.0f, 320.0f, 44.0f)];
    //[self.tableView setFrame:CGRectMake(0.0f, 88.0f, 320.0f, 44.0f)];
    //[m_view addSubview:search];
    
	//[tableViewNavigationBar addSubview:m_view];
    //[tableViewNavigationBar addSubview:searchBar];
    CGRect leftsidebar = CGRectMake(1.0, 0.0f, 19.0f, 44.0f);
    UIImageView *m_leftsideview = [[UIImageView alloc] initWithFrame:leftsidebar];
    [m_leftsideview setImage:[UIImage imageNamed:@"contacts_bg_sideheader.png"]];
    CGRect rightsidebar = CGRectMake(300.0, 0.0f, 19.0f, 44.0f);
    UIImageView *m_rightsideview = [[UIImageView alloc] initWithFrame:rightsidebar];
    [m_rightsideview setImage:[UIImage imageNamed:@"contacts_bg_sideheader.png"]];
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    [self.navigationController.navigationBar addSubview:m_view];
    [self.navigationController.navigationBar addSubview:m_leftsideview];
    [self.navigationController.navigationBar addSubview:m_rightsideview];
    [m_view release];
    self.contactsController.delegate = self;
	//[super.tableView addSubview:tableViewNavigationBar];
    [self.view addSubview:navigationController.view];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
