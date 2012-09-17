//
//  FirstViewController.m
//  VEMsg
//
//  Created by sir 余 on 12/5/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "vwRecordController.h"

@implementation vwRecordController;

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
@synthesize destName;

@synthesize uibtSendToWho;
@synthesize selecteTargetPicker;

- (IBAction)vocodeTapped :(id)sender{
	NSString *carrierFilename=[NSString stringWithFormat:@"%@.aif",[arrVocCarrierOpts objectAtIndex:carrierOptIndex]];
	[Util copyFileWithFilename:carrierFilename];
	NSString *audioFile = [NSString stringWithFormat:@"%@/%@", [Util getDocumentPath], RECORDING_FILE_AIF];
	const char *modulator_filepath = [audioFile UTF8String];
	audioFile = [NSString stringWithFormat:@"%@/%@", [Util getDocumentPath], carrierFilename];
	const char *carrier_filepath = [audioFile UTF8String];
	audioFile = [NSString stringWithFormat:@"%@/%@", [Util getDocumentPath], VOCODE_FILE_AIF];
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
    NSString* processingRecordingFileName = RECORDING_FILE_AIF;
    NSString* processingVocodeFileName = VOCODE_FILE_AIF;
    
    // converter the file: recording.aif & out.aif(if exist)
    /*  // convert code
    if( IsAACHardwareEncoderAvailable ) {
        if ( [VoiceConverterModel convertAifFile:RECORDING_FILE_AIF toM4aFile:RECORDING_FILE_M4A] ) {
            processingRecordingFileName = RECORDING_FILE_M4A;
        }
        
        NSString* vocodeFilePath = [NSString stringWithFormat:@"%@/%@", [Util getDocumentPath], VOCODE_FILE_AIF];
        if ( [[NSFileManager defaultManager] fileExistsAtPath:vocodeFilePath] ) { // if have vocode file
            if ( [VoiceConverterModel convertAifFile:VOCODE_FILE_AIF toM4aFile:VOCODE_FILE_M4A] ) {
                processingVocodeFileName = VOCODE_FILE_M4A;
            }
        }
    }
    */
	//rename and upload original audio
	NSMutableString *randomFilename = [self genRandStringLength:23];
	NSString *originalFilename = [NSString stringWithFormat:@"%@%@", randomFilename, processingRecordingFileName];
	NSString *originalFilepath = [NSString stringWithFormat:@"%@/%@", [Util getDocumentPath], originalFilename];
	NSString *targetPath= [NSString stringWithFormat:@"%@/%@", [Util getDocumentPath], processingRecordingFileName];
	NSFileManager * fileManager =  [NSFileManager defaultManager];
	[fileManager moveItemAtPath:targetPath
						 toPath:originalFilepath error:nil];
    if( [fileManager fileExistsAtPath:originalFilepath])
        [self uploadFile:originalFilepath];
    else
    {
        NSLog(@"NO original file");
    }
	
	//rename and upload vocoded audio
	randomFilename = [self genRandStringLength:23];
	NSString *vocodedFilename = [NSString stringWithFormat:@"%@%@", randomFilename, processingVocodeFileName];
	NSString *vocodedFilepath = [NSString stringWithFormat:@"%@/%@", [Util getDocumentPath], vocodedFilename];
	targetPath= [NSString stringWithFormat:@"%@/%@", [Util getDocumentPath], processingVocodeFileName];
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

    [self sendVoice:originalFilename vocode:vocodedFilename pass:@"1234"];
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


- (void) sendVoice:(NSString *)origfilename vocode:(NSString *)vocodefilename pass:(NSString *)password{
    NSString *urlString = [NSString stringWithFormat:@"http://www.entalkie.url.tw/sendMessages.php"];
    NSString *postString = [NSString stringWithFormat:@"srcID=%d&dstID=%d&type=1&orig=%@&vocode=%@&password=%@",g_UserID, destID,origfilename,vocodefilename,password];
    //NSString *urlString = @"http://www.entalkie.url.tw/getRelationships.php?masterID=1";
    NSData *data = [DBHandler sendReqToUrl:urlString postString:postString];
    NSArray *array = nil;
    //NSMutableArray *ret = [[NSMutableArray alloc] init ];
    
    if(data)
    {
        NSString *responseString = [[NSString alloc] initWithData:data
                                                         encoding:NSUTF8StringEncoding];
        array = [responseString JSONValue];
        [responseString release];
    }
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
	NSString *boundary = [NSString stringWithFormat:@"%@",@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	/*
	 now lets create the body of the post
	 */
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n",fileName] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"%@",@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
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
            forComponent: (NSInteger)component
{
    if ( pickerView == uipkVocodeOpt) {
        return [[self arrVocCarrierOpts] objectAtIndex:row];
    } else if ( pickerView == selecteTargetPicker) {
        return [g_AccountName objectAtIndex:row];
    }
    return @"";
}
-(void) pickerView: (UIPickerView *) pickerView
      didSelectRow:(NSInteger) row
       inComponent:(NSInteger) component
{
    if ( pickerView == uipkVocodeOpt ) {
        carrierOptIndex=row;
    } else if ( pickerView == selecteTargetPicker ) {
        destID = [[g_AccountID objectAtIndex:row] integerValue];
        destName = [g_AccountName objectAtIndex:row];
        NSString* sendToWhoString = [NSString stringWithFormat:@"Send To: %@", destName];
        [uibtSendToWho setTitle:sendToWhoString forState:UIControlStateNormal];
    }
    [pickerView removeFromSuperview];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if ( pickerView == uipkVocodeOpt ) {
        return 1;
    } else if ( pickerView == selecteTargetPicker ){
        return 1;
    }
    return 1;
}

-(NSInteger)pickerView:(UIPickerView*) pickerView 
numberOfRowsInComponent:(NSInteger) component
{
    if ( pickerView == uipkVocodeOpt ) {
        return [arrVocCarrierOpts count];
    } else if ( pickerView == selecteTargetPicker ) {
        return [g_AccountID count];
    }
    return 0;
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

-(IBAction)showSendToWhoPicker:(id)sender {
    if ( selecteTargetPicker.superview == nil) {
        [self.view addSubview:selecteTargetPicker];
    } else {
        [selecteTargetPicker removeFromSuperview];
    }
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
    
//    uisliderTime.maximumValue=0;
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
    
    destID = -1;
    destName = nil;
    [self.uibtSendToWho setTitle:@"Select Receiver" forState:UIControlStateNormal];
    
    self.selecteTargetPicker = [[UIPickerView alloc] init];
    self.selecteTargetPicker.delegate = self;
    self.selecteTargetPicker.frame = CGRectMake(60, 50, 200,300);
    
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
    
    [self.selecteTargetPicker release];
}

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

// Audio Player Implementation
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

-(void) updateSliderValue:(id)sender{
    
    if ( self.player == nil ) { // is stop

    } else if ( [self.player isPlaying] ) { // playing
        NSLog(@"Player Time: %f", player.currentTime);
        uisliderTime.value=player.currentTime;
        uilbTimeElapse.text= [[NSString alloc] initWithFormat:@"%02i:%02i", (int)(uisliderTime.value)/60, (int)uisliderTime.value%60];
    } else { // is pause
        if ( self.player.currentTime == 0) { // player play end than natual stop
            [timer invalidate]; // if have bug, command this line
            self.player = nil;
            uilbTimeElapse.text = [NSString stringWithFormat:@"00:00"];
            uisliderTime.value = 0;
        } else {
            // do nothing
        }
    }
}

-(IBAction)playPlayer:(id)sender
{
    if ( self.player == nil ) { // is stop
        [self playerSetup];
        [self.player play];
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateSliderValue:) userInfo:nil repeats:YES];
    } else if ( [self.player isPlaying] ) { // is playing
        // do nothing.
    } else { // is pause
        [self.player play];
    }
}

-(IBAction)pausePlayer:(id)sender
{
    if ( self.player == nil ) { // is stop
        // do nothing
    } else if ( [self.player isPlaying] ) { // is playing
        [self.player pause];
    } else { // is pause
        // do nothing
    }
}

-(IBAction)stopPlayer:(id)sender
{
    if ( self.player == nil ) { // is stop
        // do nothing
    } else if ( [self.player isPlaying] ) { // is playing
        [timer invalidate];
        [self.player stop];
        // if release?
        self.player = nil;
        uilbTimeElapse.text = [NSString stringWithFormat:@"00:00"];
        uisliderTime.value = 0;
    } else { // is pause
        [timer invalidate];
        [self.player stop];
        // if release?
        self.player = nil;
        uilbTimeElapse.text = [NSString stringWithFormat:@"00:00"];
        uisliderTime.value = 0;
    }
}

-(IBAction)sliderValueChanged:(id)sender
{
    // change player time to uisliderTime.value
    if ( player != nil) player.currentTime = uisliderTime.value;
    uilbTimeElapse.text = [NSString stringWithFormat:@"%02d:%02d", (int)uisliderTime.value/60, (int)uisliderTime.value%60];
}

static Boolean IsAACHardwareEncoderAvailable(void)
{
    Boolean isAvailable = false;
    
    // get an array of AudioClassDescriptions for all installed encoders for the given format
    // the specifier is the format that we are interested in - this is 'aac ' in our case
    UInt32 encoderSpecifier = kAudioFormatMPEG4AAC;
    UInt32 size;
    
    OSStatus result = AudioFormatGetPropertyInfo(kAudioFormatProperty_Encoders, sizeof(encoderSpecifier), &encoderSpecifier, &size);
    if (result) { printf("AudioFormatGetPropertyInfo kAudioFormatProperty_Encoders result %lu %4.4s\n", result, (char*)&result); return false; }
    
    UInt32 numEncoders = size / sizeof(AudioClassDescription);
    AudioClassDescription encoderDescriptions[numEncoders];
    
    result = AudioFormatGetProperty(kAudioFormatProperty_Encoders, sizeof(encoderSpecifier), &encoderSpecifier, &size, encoderDescriptions);
    if (result) { printf("AudioFormatGetProperty kAudioFormatProperty_Encoders result %lu %4.4s\n", result, (char*)&result); return false; }
    
    for (UInt32 i=0; i < numEncoders; ++i) {
        if (encoderDescriptions[i].mSubType == kAudioFormatMPEG4AAC && encoderDescriptions[i].mManufacturer == kAppleHardwareAudioCodecManufacturer) isAvailable = true;
    }
    
    return isAvailable;
}

@end


