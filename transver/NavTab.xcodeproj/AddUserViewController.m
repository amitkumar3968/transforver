//
//  AddUserViewController.m
//  NavTab
//
//  Created by hank chen on 10/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddUserViewController.h"


@implementation AddUserViewController

@synthesize name;
@synthesize delegate;

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

- (void) save:(id)sender
{
	NSLog(@"save number!");
    if( [name.text isEqualToString:@""])
    {
        NSLog(@"wrong number!");
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(savePhoneNumber:)]) 
    {
        [self.delegate savePhoneNumber:name.text];
    }
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    name.keyboardType = UIKeyboardTypeDecimalPad;
    UIBarButtonItem *rightButton = 
	[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(save:)];
	
	self.navigationItem.rightBarButtonItem = rightButton;
	[rightButton release];
    self.navigationItem.hidesBackButton = TRUE;
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
