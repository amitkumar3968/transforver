//
//  FirstViewController.m
//  VEMsg
//
//  Created by sir 余 on 12/5/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "vwRecordController.h"
#import "VocViewController.h"

@implementation vwRecordController

@synthesize uilbTimeTotal;
@synthesize uisliderTime;
@synthesize uiswEncrypt;
@synthesize uiswPassLock;
@synthesize uiswAutoDel;
@synthesize switchView;
@synthesize player;
@synthesize uipkVocodeOpt;
@synthesize arrVocCarrierOpts;
@synthesize carrierOptIndex;
@synthesize btnSend;
@synthesize btnDelete;
@synthesize confirmView;
@synthesize delegate;

- (IBAction)vocodeTapped :(id)sender{
    
	NSString *carrierFilename=[NSString stringWithFormat:@"%@.aif",[arrVocCarrierOpts objectAtIndex:carrierOptIndex]];
	[Util copyFileWithFilename:carrierFilename];
	NSString *audioFile = [NSString stringWithFormat:@"%@/%@.aif", [Util getDocumentPath], @"recording"];
	const char *modulator_filepath = [audioFile UTF8String];
	audioFile = [NSString stringWithFormat:@"%@/%@", [Util getDocumentPath], carrierFilename];
	const char *carrier_filepath = [audioFile UTF8String];
	audioFile = [NSString stringWithFormat:@"%@/%@.aif", [Util getDocumentPath], @"out"];
	const char *output_filepath=[audioFile UTF8String];
	audioFile = [NSString stringWithFormat:@"%@/%@.aif", [Util getDocumentPath], @"meta"];
	const char *meta_filepath=[audioFile UTF8String];
	int encrypt_para;
	if (uiswEncrypt.on==YES){
		encrypt_para=1;
	}
	else {
		encrypt_para=0;
	}	
	dovocode(encrypt_para, output_filepath, meta_filepath, modulator_filepath, carrier_filepath);
	done_vocode=1;
    btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSend setFrame:CGRectMake(160.0, 0.0, 159.0, 44.0)];
    [btnSend setBackgroundImage:[UIImage imageNamed:@"record_btn_sendndelete_slected.png"] forState:UIControlStateNormal];
    [btnSend setTitle:@"Send" forState:UIControlStateNormal];
    [btnSend addTarget:self action:@selector(sendPressed) forControlEvents:UIControlEventTouchUpInside];
    btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDelete setFrame:CGRectMake(0.0, 0.0, 159.0, 44.0)];
    [btnDelete setBackgroundImage:[UIImage imageNamed:@"record_btn_sendndelete_slected.png"] forState:UIControlStateNormal];
    [btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
    confirmView = [[UIView alloc] initWithFrame:CGRectMake(0, 436, 320, 44)];
    confirmView.backgroundColor=[UIColor clearColor];
    [confirmView addSubview:btnSend];
    [confirmView addSubview:btnDelete];
    [self.tabBarController.view addSubview:confirmView];
    self.tabBarController.tabBar.hidden=TRUE;
	///[self uploadFile:recording_filepath];
}

- (void) sendPressed
{
	//rename and upload original audio
	NSMutableString *randomFilename = [self genRandStringLength:23];
	NSString *originalFilename = [NSString stringWithFormat:@"%@%@", randomFilename, @"recording.aif"];
	NSString *originalFilepath = [NSString stringWithFormat:@"%@/%@", [Util getDocumentPath], originalFilename];
	NSString *targetPath= [NSString stringWithFormat:@"%@/%@", [Util getDocumentPath], @"recording.aif"];
	NSFileManager * fileManager =  [NSFileManager defaultManager];
	[fileManager moveItemAtPath:targetPath
						 toPath:originalFilepath error:nil];
    if( [fileManager fileExistsAtPath:originalFilepath])
        [self uploadFile:originalFilepath];
    else
    {
        NSLog(@"NO orig file");
    }
	
	//rename and upload vocoded audio
	randomFilename = [self genRandStringLength:23];
	NSString *vocodedFilename = [NSString stringWithFormat:@"%@%@", randomFilename, @"out.aif"];
	NSString *vocodedFilepath = [NSString stringWithFormat:@"%@/%@", [Util getDocumentPath], vocodedFilename];
	targetPath= [NSString stringWithFormat:@"%@/%@", [Util getDocumentPath], @"out.aif"];
	[fileManager moveItemAtPath:targetPath
						 toPath:vocodedFilepath error:nil];	
    if( [fileManager fileExistsAtPath:vocodedFilepath])
        [self uploadFile:vocodedFilepath];
    else
    {
        NSLog(@"NO vocode file");
        vocodedFilename = @"";
    }
	
	//rename 
	
    //time_t unixTime = [[NSDate date] timeIntervalSince1970];
    //NSLog(@"%@",dateString);
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendVoice:vocode:pass:)]) 
    {
        [self.delegate sendVoice:originalFilename vocode:vocodedFilename pass:@"1234"];
    }
	[confirmView removeFromSuperview];
    self.tabBarController.tabBar.hidden=FALSE;
}

-(NSMutableString *) genRandStringLength: (int) len
{
	NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
	
    for (int i=0; i<len; i++) {
		[randomString appendFormat: @"%c", [letters characterAtIndex: arc4random()%[letters length]] ];
	}
	return randomString;
}

- (void) uploadFile:(NSString *)fileName {
	/*
	 turning the image into a NSData object
	 getting the image back out of the UIImageView
	 setting the quality to 90
	 */
	UIImageView *image = [[UIImageView alloc] initWithFrame:
                          CGRectMake(100.0, 100.0, 57.0, 57.0)];
	image.image = 
	[UIImage imageNamed:@"phone.png"];
	//NSData *imageData = UIImageJPEGRepresentation(image.image, 90);
	//NSString* str =  [[NSBundle mainBundle] pathForResource:@"mysoundcompressed" ofType:@"caf"];
	//NSString *filePath = [NSString stringWithFormat:@"%@/%@", [Util getDocumentPath], fileName]; 
	NSData *wavData = [NSData dataWithContentsOfFile:fileName];
	// setting up the URL to post to
	NSString *urlString = @"http://www.entalkie.url.tw/upload.php";
	
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	/*
	 add some header info now
	 we always need a boundary when we post a file
	 also we need to set the content type
	 
	 You might want to generate a random boundary.. this is just the same
	 as my output from wireshark on a valid html post
	 */
	NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	/*
	 now lets create the body of the post
	 */
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n",fileName] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:wavData]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
	// now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"upload file %@",returnString);
}


-(NSString *) pickerView: (UIPickerView *) pickerView 
             titleForRow: (NSInteger)row 
            forComponent:(NSInteger)component
{
    return [[self arrVocCarrierOpts] objectAtIndex:row];
}
-(void) pickerView: (UIPickerView *) pickerView
      didSelectRow:(NSInteger) row
       inComponent:(NSInteger) component
{
    carrierOptIndex=row;
    [pickerView removeFromSuperview];

}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView*) pickerView 
numberOfRowsInComponent:(NSInteger) component
{
    return [arrVocCarrierOpts count];
}

-(void) initVars{
    arrVocCarrierOpts=[[NSArray alloc] initWithObjects:@"Lion", @"Piano", nil];
}

-(IBAction) showPicker{
    if (uipkVocodeOpt.superview==nil){
        CGRect rectVocodeRect = CGRectMake(100, 260, 200,180);
        uipkVocodeOpt.delegate=self;
        uipkVocodeOpt.frame=rectVocodeRect;
        uipkVocodeOpt.showsSelectionIndicator=true;
        [uipkVocodeOpt setBackgroundColor:[UIColor clearColor]];
        uipkVocodeOpt.autoresizingMask=UIViewAutoresizingFlexibleHeight;
        [self.view.window addSubview:uipkVocodeOpt];
    }
}
-(IBAction) hidePicker{
    [uipkVocodeOpt removeFromSuperview];
}
/*-(void) hidePicker:(UIPickerView*) uipkVocodeOpt{
 
 }*/



-(void) playerSetup
{
    NSString *myMusic;
    if (done_vocode==1)
    {    
        myMusic = [NSString stringWithFormat:@"%@/%@.aif", [Util getDocumentPath], @"out"];
    }
    else {
        myMusic = [NSString stringWithFormat:@"%@/%@.aif", [Util getDocumentPath], @"recording"];
    }
	NSString *stringEscapedMyMusic = [myMusic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:stringEscapedMyMusic] error:NULL];
	player.numberOfLoops = 0;
	player.volume = 1;
	uisliderTime.maximumValue = player.duration;
    uilbTimeTotal.text= [[NSString alloc] initWithFormat:@"%i:%02i", (int)(uisliderTime.maximumValue)/60, (int)uisliderTime.maximumValue%60];
    //[myMusic release];
    //[stringEscapedMyMusic release];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Record", @"Record");
        self.tabBarItem.image = [UIImage imageNamed:@"common_icon_rec_rest.png"];
    }
    return self;
}

/* markID:038405-3  implementation of customized UISwitch on ios4
 -(IBAction)checkOnOffState:(id)sender{
 
 UISegmentedControl* tempSeg=(UISegmentedControl *)sender;
 if(tempSeg.selectedSegmentIndex==0){
 [tempSeg setImage:[UIImage imageNamed:@"encrypt_btn_swift.png"] forSegmentAtIndex:0];
 [tempSeg setImage:[UIImage imageNamed:@"encrypt_bg_swiftoff.png"] forSegmentAtIndex:1];
 }
 else{
 [tempSeg setImage:[UIImage imageNamed:@"encrypt_btn_swift.png"] forSegmentAtIndex:1];
 [tempSeg setImage:[UIImage imageNamed:@"encrypt_bg_swifton.png"] forSegmentAtIndex:0];
 }   
 }*/


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
-(void)customizeAppearance{
	[Util copyFileWithFilename:@"record_btn_recording.png"];    
	[Util copyFileWithFilename:@"record_bg_recordline.png"];
	[Util copyFileWithFilename:@"encode_btn_swift.png"];    
    UIImage *thumbImage = [UIImage imageNamed:@"record_btn_recording.png"];
    UIImage *maxImage = [UIImage imageNamed:@"record_bg_recordline.png"];
    UIImage *imgSWThumb = [UIImage imageNamed:@"encode_btn_swift.png"];
    
    uisliderTime.maximumValue=200;
    [uisliderTime setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    [uisliderTime setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [uisliderTime setThumbImage:thumbImage forState:UIControlStateNormal];
        
    //[uiswEncrypt setOnTintColor:[UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:82.0/255.0 alpha:1.0]];
    //[uiswPassLock setOnTintColor:[UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:82.0/255.0 alpha:1.0]];
    //[uiswAutoDel setOnTintColor:[UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:82.0/255.0 alpha:1.0]];    
    //[[uiswEncrypt appearance] setThumbImage:[UIImage imageNamed:@"encode_btn_swift.png"] forstate:UIControlStateNormal];
    /* markID:038405-3  implementation of customized UISwitch on ios4
     UISegmentedControl* switchView=[[UISegmentedControl alloc] initWithItems:[[NSMutableArray alloc] initWithObjects:@"On",@"Off",nil]];
     [switchView setFrame:CGRectMake(20,365,140,28)];
     switchView.selectedSegmentIndex=0;
     switchView.segmentedControlStyle=UISegmentedControlStyleBar;
     [switchView setImage:[UIImage imageNamed:@"encrypt_btn_swift.png"] forSegmentAtIndex:0];
     [switchView setImage:[UIImage imageNamed:@"encrypt_bg_swiftoff.png"] forSegmentAtIndex:1];
     //[switchView setImage:imgSWThumb forSegmentAtIndex:2];
     [switchView addTarget:self action:@selector(checkOnOffState:) forControlEvents:UIControlEventValueChanged];
     [[self view] addSubview:switchView];
     */
    
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self initVars];
    [self customizeAppearance]; 
    [Util copyFileWithFilename:@"Lion.aif"];
    [Util copyFileWithFilename:@"Piano.aif"];
    [super viewDidLoad];
    done_vocode=0;
    //
    //[self initRecorderSetup];
	//timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeLoader) userInfo:nil repeats:YES];    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    done_vocode=0;
}



-(IBAction) updateSliderValue:(id)sender{
    uisliderTime.value=player.currentTime;
    uilbTimeElapse.text= [[NSString alloc] initWithFormat:@"%i:%02i", (int)(uisliderTime.value)/60, (int)uisliderTime.value%60];
}

-(IBAction)playPlayer:(id)sender
{   
    //[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self playerSetup];
    if (uisliderTime.value==0)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired:) userInfo:nil repeats:true];
    }
    player.currentTime=uisliderTime.value;
	[player playAtTime:MAX((uisliderTime.value)-.5,0)];
}

-(IBAction)pausePlayer:(id)sender
{
    [player pause];
    uisliderTime.value=player.currentTime;
    NSLog([[NSString alloc] initWithFormat:@"%f", player.currentTime]);

}

-(IBAction)stopPlayer:(id)sender
{
    //if (player.playing)
    {
        [player stop];
        [player setCurrentTime:0];
        uisliderTime.value=0;
        uilbTimeElapse.text=@"0:00";
        [timer invalidate];
        timer=nil;
        playerPlaying=FALSE;
    }
}

-(void)timerFired:(id)sender{
    if (player.playing) {
        uisliderTime.value=player.currentTime;
        uilbTimeElapse.text=[[NSString alloc] initWithFormat:@"%i:%.02i", (int)player.currentTime/60,(int)player.currentTime%60];
    }
    
    /*else
    {   
        if (timer.isValid)
        {    
            [player stop];
            NSLog(@"player stop; timer invalidate");
            [timer invalidate];
            uisliderTime.value=0;
            timer=nil;
        }
    }
     */
}

//====================================

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    uipkVocodeOpt = [[UIPickerView alloc] initWithFrame:CGRectZero];
    //[self showPicker:uipkVocodeOpt];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}
//==========
@end
