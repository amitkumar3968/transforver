//
//  FirstViewController.m
//  VEMsg
//
//  Created by sir 余 on 12/5/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "vwRecordController.h"
#import "Toast+UIView.h"
#import "Localization.h"
#define MAX_RECORD_SECONDS 10
#define MAX_PASSWORD_LENGTH 5


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

@synthesize recTimer;
@synthesize uibtRecord;
@synthesize recorder;
@synthesize progressView;
@synthesize coverView;
@synthesize uilbRecSec;
@synthesize recordingBar;
@synthesize vocodedFilepath;
@synthesize originalFilepath;
@synthesize txfPass;
@synthesize uilbAutoDel, uilbPassLock, uilbPassword, uilbSelectEncryType;

// Check password text field
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= MAX_PASSWORD_LENGTH && range.length == 0)
    {
        return NO; // return NO to not change text
    }
    else  if([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    else
    {return YES;}
}

- (void) threadStartAnimating:(id)data {
    coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [coverView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.5]];
    [coverView addSubview:progressView];
    [self.view addSubview:coverView];
    [progressView startAnimating];
}

- (IBAction)vocodeTapped :(id)sender{
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
	NSString *carrierFilename=[NSString stringWithFormat:@"%@.aif",[arrVocCarrierOpts objectAtIndex:carrierOptIndex]];
	[Util copyFileWithFilename:carrierFilename];
    
	NSString *audioFile = [NSString stringWithFormat:@"%@/%@", [Util getDocumentPath], RECORDING_FILE_AIF];
    if ([[NSFileManager defaultManager] fileExistsAtPath:audioFile])
    {
        const char *modulator_filepath = [audioFile UTF8String];
        audioFile = [NSString stringWithFormat:@"%@/%@", [Util getDocumentPath], carrierFilename];
        const char *carrier_filepath = [audioFile UTF8String];
        audioFile = [NSString stringWithFormat:@"%@/%@", [Util getDocumentPath], VOCODE_FILE_AIF];
        const char *output_filepath=[audioFile UTF8String];
        audioFile = [NSString stringWithFormat:@"%@/%@.aif", [Util getDocumentPath], @"meta"];
        const char *meta_filepath=[audioFile UTF8String];
        int encrypt_para;
        if (uiswPassLock.on==YES){
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
        [btnDelete addTarget:self action:@selector(deletePressed) forControlEvents:UIControlEventTouchUpInside];
        confirmView = [[UIView alloc] initWithFrame:CGRectMake(0, 436, 320, 44)];
        confirmView.backgroundColor=[UIColor clearColor];
        [confirmView addSubview:btnSend];
        [confirmView addSubview:btnDelete];
        [self.tabBarController.view addSubview:confirmView];
        self.tabBarController.tabBar.hidden=TRUE;
        ///[self uploadFile:recording_filepath];
    }
    else {
        UIAlertView *recordingFirst = [[UIAlertView alloc] initWithTitle:@"Recording First" message:@"You must record something before encryption" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [recordingFirst show];
    }
    [progressView stopAnimating];
    [coverView removeFromSuperview];
}

- (IBAction) deletePressed
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSError *err;
    /*
    if( [fileManager fileExistsAtPath:vocodedFilepath])
        [fileManager removeItemAtPath:vocodedFilepath error:&err];
    if ([fileManager fileExistsAtPath:originalFilepath]) {
        [fileManager removeItemAtPath:originalFilepath error:&err];
    } 
     */
    [confirmView removeFromSuperview];
    self.tabBarController.tabBar.hidden=FALSE;
}



- (IBAction) sendPressed
{
    if (destID<=0) {
        UIAlertView *alertSetReceiver = [[UIAlertView alloc] initWithTitle:@"Set Receiver" message:@"You need to select one receiver before sending message" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertSetReceiver show];
    }
    else {
        [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
        [self converAndSendMessage];
    }
}


-(void) converAndSendMessage
{
    NSString* processingRecordingFileName = RECORDING_FILE_AIF;
    NSString* processingVocodeFileName = VOCODE_FILE_AIF;
 
    // if no such recording.aif file, do not convert and upload file.
    if (![[NSFileManager defaultManager] isExecutableFileAtPath:[NSString stringWithFormat: [Util getDocumentPath], RECORDING_FILE_AIF]]) {
        return;
    }
    
    // converter the file: recording.aif & out.aif(if exist)
    // convert code
    if( IsAACHardwareEncoderAvailable ) {
        if ( [VoiceConverterModel convertAifFile:RECORDING_FILE_AIF toM4aFile:RECORDING_FILE_M4A] ) {
            processingRecordingFileName = RECORDING_FILE_M4A;
//            NSString* file = [NSString stringWithFormat:@"%@/%@", [Util getDocumentPath], RECORDING_FILE_M4A];
//            if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
//                NSLog(@"Have File ", RECORDING_FILE_M4A);
//            } else {
//                NSLog(@"DO NOt Have file ", RECORDING_FILE_M4A);
//            }
        }
        
        NSString* vocodeFilePath = [NSString stringWithFormat:@"%@/%@", [Util getDocumentPath], VOCODE_FILE_AIF];
        if ( [[NSFileManager defaultManager] fileExistsAtPath:vocodeFilePath] ) { // if have vocode file
            if ( [VoiceConverterModel convertAifFile:VOCODE_FILE_AIF toM4aFile:VOCODE_FILE_M4A] ) {
                processingVocodeFileName = VOCODE_FILE_M4A;
            }
        }
    }
    
	//rename and upload original audio
	NSMutableString *randomFilename = [self genRandStringLength:23];
	NSString *originalFilename = [NSString stringWithFormat:@"%@%@", randomFilename, processingRecordingFileName];
	originalFilepath = [NSString stringWithFormat:@"%@/%@", [Util getDocumentPath], originalFilename];
	NSString *targetPath= [NSString stringWithFormat:@"%@/%@", [Util getDocumentPath], processingRecordingFileName];
	NSFileManager * fileManager =  [NSFileManager defaultManager];
	[fileManager moveItemAtPath:targetPath
						 toPath:originalFilepath error:nil];
    if( [fileManager fileExistsAtPath:originalFilepath])
    {
        int error = [self uploadFile:originalFilepath];
        if( error )
        {
            [self.view makeToast:@"Fail!!"
                        duration:5.0
                        position:@"center"
                           title:@"UPLOAD FILE"];
        }else
        {
            [self.view makeToast:@"Success!!"
                        duration:5.0
                        position:@"center"
                           title:@"UPLOAD FILE"];
        }
    }
    else
    {
        NSLog(@"NO original file");
    }
	
	//rename and upload vocoded audio
	randomFilename = [self genRandStringLength:23];
	NSString *vocodedFilename = [NSString stringWithFormat:@"%@%@", randomFilename, processingVocodeFileName];
	vocodedFilepath = [NSString stringWithFormat:@"%@/%@", [Util getDocumentPath], vocodedFilename];
	targetPath= [NSString stringWithFormat:@"%@/%@", [Util getDocumentPath], processingVocodeFileName];
	[fileManager moveItemAtPath:targetPath
						 toPath:vocodedFilepath error:nil];
    if( [fileManager fileExistsAtPath:vocodedFilepath])
    {
        int error = [self uploadFile:vocodedFilepath];
        if( error )
        {
            [self.view makeToast:@"Fail!!"
                    duration:5.0
                    position:@"center"
                       title:@"UPLOAD FILE"];
        }else
        {
            [self.view makeToast:@"Success!!"
                    duration:5.0
                    position:@"center"
                       title:@"UPLOAD FILE"];
        }
    }
    else
    {
        NSLog(@"NO vocode file");
        vocodedFilename = @"";
    }
	
	//rename
	
    //time_t unixTime = [[NSDate date] timeIntervalSince1970];
    if (uiswPassLock) {
        [self sendVoice:originalFilename vocode:vocodedFilename pass:txfPass.text];
    }
    else{
        [self sendVoice:originalFilename vocode:vocodedFilename pass:@""];
    }
	[confirmView removeFromSuperview];
    self.tabBarController.tabBar.hidden=FALSE;
    [progressView stopAnimating];
    [coverView removeFromSuperview];
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
- (int) uploadFile:(NSString *)fileName {
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
    NSError        *error = nil;
    NSURLResponse  *response = nil;
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if( error )
    {
        NSLog(@"%@", error);
        return -1;
    }else
    {
        NSLog(@"success");
    }
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"upload file %@",returnString);
    return 0;
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
    [coverView removeFromSuperview];
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
        CGRect rectVocodeRect = CGRectMake(100, 260, 200,180);
        uipkVocodeOpt.delegate=self;
        uipkVocodeOpt.frame=rectVocodeRect;
        uipkVocodeOpt.showsSelectionIndicator=true;
        [uipkVocodeOpt setBackgroundColor:[UIColor clearColor]];
        uipkVocodeOpt.autoresizingMask=UIViewAutoresizingFlexibleHeight;
        coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        [coverView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]];
        [coverView addSubview:uipkVocodeOpt];
        [coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(hidePicker:)]];
        [self.view.window addSubview:coverView];
}
-(void) hidePicker:(UITapGestureRecognizer *) rocognizer{
    [coverView removeFromSuperview];
}
/*-(void) hidePicker:(UIPickerView*) uipkVocodeOpt{
 
 }*/

-(IBAction)showSendToWhoPicker:(id)sender {
    if ( selecteTargetPicker.superview == nil) { // picker not in view now.
        // TODO change 320&480 to window parameter
        coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        [coverView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.5]];
        [coverView addSubview:selecteTargetPicker];
        [coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(hideSendToWhoPicker:)]];
        NSLog(@"aaa");
        [self.view addSubview:coverView];
    } else {
        [selecteTargetPicker removeFromSuperview];
    }
}

-(void)hideSendToWhoPicker:(UITapGestureRecognizer *)recognizer {
    NSLog(@"bbb");
    [self.selecteTargetPicker removeFromSuperview];
    [self.coverView removeFromSuperview];
}

- (void) recordButtonTapped:(id)sender
{
    UIButton *recButton = (UIButton*) sender;
    if (player.isPlaying){
        //do nothing
    }
    else {
        if (!recButton.selected){
            if (recorder==nil)
                recorder = [[AudioRecorder alloc] init];
            [recorder startRecording];
            [uibtRecord setSelected:YES];
            [uibtRecord setBackgroundImage:[UIImage imageNamed:@"record_btn_redrec_rest@2x.png"] forState:UIControlStateNormal];
            UIImage *recordLight = [UIImage imageNamed:@"record_icon_record@2x.png"];
            UIImage *smallRecLiht = [Util imageWithImage:recordLight scaledToSize:CGSizeMake(recordLight.size.width/2, recordLight.size.height/2)];
            [uibtRecord setImage:smallRecLiht forState:UIControlStateNormal];
            recTimer = [NSTimer scheduledTimerWithTimeInterval:.1f target:self selector:@selector(updateRecordingState:) userInfo:nil repeats:YES];
            recordingBar= [[UIView alloc] initWithFrame:CGRectMake(0, 48, 320, 30)];
            recordingBar.backgroundColor=[UIColor redColor];
            uilbRecSec =  [[UILabel alloc] initWithFrame: CGRectMake(30, 0, 180, 30)];
            uilbRecSec.backgroundColor = [UIColor clearColor];
            uilbRecSec.textColor = [UIColor yellowColor];
            uilbRecSec.text = @"Recording: Start !";
            [recordingBar addSubview:uilbRecSec];
            [self.view addSubview:recordingBar];
        }
        else {
            if (recorder!=nil){
                [recorder stopRecording];
                recorder=nil;
            }
            if ([recTimer isValid]) {
                [recTimer invalidate];
                recTimer=nil;
                recSeconds=0;
            }
            [uibtRecord setSelected:NO];
            [uibtRecord setBackgroundImage:[UIImage imageNamed:@"record_btn_redrec_pressed@2x.png"] forState:UIControlStateNormal];
            
            UIImage *recordLight = [UIImage imageNamed:@"record_icon_unrecord@2x.png"];
            UIImage *smallRecLiht = [Util imageWithImage:recordLight scaledToSize:CGSizeMake(recordLight.size.width/2, recordLight.size.height/2)];
            [uibtRecord setImage:smallRecLiht forState:UIControlStateNormal];
            done_vocode=0;
            [recordingBar removeFromSuperview];
        }

    }
}

-(void) updateRecordingState:(NSTimer *)recTimer
{
    recSeconds += .1;
    uilbRecSec.text= [[NSString alloc] initWithFormat:@"Recording:  %02i:%02i", (int)(recSeconds)/60, (int)recSeconds%60];
    if (recSeconds>MAX_RECORD_SECONDS){
        [self recordButtonTapped:uibtRecord];
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
    
    [uibtRecord setBackgroundImage:[UIImage imageNamed:@"record_btn_redrec_rest@2x.png"] forState:UIControlStateSelected];
    [uibtRecord setBackgroundImage:[UIImage imageNamed:@"record_btn_redrec_pressed@2x.png"] forState:UIControlStateNormal];
    NSString *orignialFilepath= @"";
    NSString *vocodedFilepath=@"";
    //
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
    if (destName!=nil) {
        uibtSendToWho.titleLabel.text = [[NSString alloc] initWithFormat:@"Send to:%@", destName];
    }
    //localized appearance
    uilbAutoDel.text = LOC_TXT_RECORD_AUTO_DEL;
    uilbPassLock.text = LOC_TXT_RECORD_PASS_LOCK;
    uilbPassword.text = LOC_TXT_RECORD_PASSWORD;
    uilbSelectEncryType.text = LOC_TXT_RECORD_ENCRYPTION_TYPE;
    uibtRecord.titleLabel.text = LOC_TXT_RECORD_REC_BUTTON_TITLE;
    uibtSendToWho.titleLabel.text = LOC_TXT_RECORD_RECEIVER_BUTTON_TITLE;
    
    [super viewWillAppear:animated];
    recorder = [[AudioRecorder alloc] init];
    [progressView stopAnimating];
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
    if (recorder!=nil){
        [recorder stopRecording];
        recorder=nil;
         [uibtRecord setSelected:NO];
        [uibtRecord setBackgroundImage:[UIImage imageNamed:@"record_btn_redrec_pressed@2x.png"] forState:UIControlStateNormal];
        UIImage *recordLight = [UIImage imageNamed:@"record_icon_unrecord@2x.png"];
        UIImage *smallRecLiht = [Util imageWithImage:recordLight scaledToSize:CGSizeMake(recordLight.size.width/2, recordLight.size.height/2)];
        [uibtRecord setImage:smallRecLiht forState:UIControlStateNormal];
    }
    [recorder release];
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
    
    //balance volume
    if (done_vocode==1)
    {
        if (uiswPassLock.on==YES){
            player.volume=.4;
        }
        else {
            player.volume=1;
        }
    }
    else {
        player.volume=0.8;
    }
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
    if (uibtRecord.selected==YES)
    {
        //Do nothing 
    }
    else {
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


