//
//  VocViewController.m
//  NavTab
//
//  Created by easystudio on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VocViewController.h"


@implementation VocViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
@synthesize audioFile;
@synthesize audioRecorder;

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)initialSetup {
    UIImage *img = [UIImage imageNamed:@"bgTextBubbleLC20TC20"];
    UIImage *bg = [img stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    //audioRecorder = [[[AudioRecorder	alloc] init] retain];	
}


- (void)dealloc {
    [super dealloc];
}

- (IBAction)vocodeTapped :(id)sender{
	NSLog(@"show up!");
}

- (void)recordButtonTapped {
    NSLog(@"Record");
	[audioRecorder startRecording];
}

- (void)recordButtonTouchUp {
	[audioRecorder stopRecording];
    NSLog(@"Record stop");

}

@end
