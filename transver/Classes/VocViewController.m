//
//  VocViewController.m
//  NavTab
//
//  Created by easystudio on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//@ Ray added for AudioPlayer UI
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#import "VocViewController.h"
#include "dovocode.h"



@implementation VocViewController

//@synthesize audioFile;
@synthesize audioRecorder;
@synthesize localFilePath;
@synthesize password;
@synthesize voice_opt;
@synthesize encrypt;
@synthesize vocodeCarrierOptions;
@synthesize delegate;


//@Ray add for AudioPlayer UI
@synthesize player,slider,increaseSound,timeSlider,timer;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	vocodeCarrierOptions = [[NSArray alloc] initWithObjects: @"Lion", @"Piano", nil];
    vocode_carrier_index=0;
	audioRecorder = [[[AudioRecorder	alloc] init] retain];
	
	//@ Ray added for audio player UI
    int a=0;
	//initialize string to the path of the song in the resource folder
	NSString *myMusic = [NSString stringWithFormat:@"%@/%@.aif", [Util getDocumentPath], @"recording"];
	NSString *stringEscapedMyMusic = [myMusic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:stringEscapedMyMusic] error:NULL];
	player.numberOfLoops = 0;
	player.volume = slider.value;
	timeSlider.maximumValue = player.duration;
	timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeLoader) userInfo:nil repeats:YES];
	//==========================
	
	[super viewDidLoad];	
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


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
}


- (void)dealloc {
	[player release];
    [super dealloc];
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
	NSString *filePath = [NSString stringWithFormat:@"%@/%@", [Util getDocumentPath], fileName]; 
	NSData *wavData = [NSData dataWithContentsOfFile:filePath];
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
	
	NSLog(@"%@",returnString);
}

- (IBAction)vocodeTapped :(id)sender{

	NSString *carrierFilename=[NSString stringWithFormat:@"%@.aif",[vocodeCarrierOptions objectAtIndex:vocode_carrier_index]];
	[Util copyFileWithFilename:carrierFilename];
	NSString *audioFile = [NSString stringWithFormat:@"%@/%@.aif", [Util getDocumentPath], @"recording"];
	const char *modulator_filepath = [audioFile UTF8String];
	audioFile = [NSString stringWithFormat:@"%@/%@.aif", [Util getDocumentPath], [vocodeCarrierOptions objectAtIndex:vocode_carrier_index]];
	const char *carrier_filepath = [audioFile UTF8String];
	audioFile = [NSString stringWithFormat:@"%@/%@.aif", [Util getDocumentPath], @"out"];
	const char *output_filepath=[audioFile UTF8String];
	audioFile = [NSString stringWithFormat:@"%@/%@.aif", [Util getDocumentPath], @"meta"];
	const char *meta_filepath=[audioFile UTF8String];
	int encrypt_para;
	if (encrypt.on==YES){
		encrypt_para=1;
	}
	else {
		encrypt_para=0;
	}	
	dovocode(encrypt_para, output_filepath, meta_filepath, modulator_filepath, carrier_filepath);
	done_vocode=1;
	///[self uploadFile:recording_filepath];
}


- (IBAction) playorig_playback:(id)sender{
	//NSString *audioFile = [NSString stringWithFormat:@"%@/%@.aif", [Util getDocumentPath], @"recording"];
	//[audioRecorder startPlaybackWithFilepath:audioFile];

	//@ Ray added for audio player UI	
	[player dealloc];
	int a=0;
	//initialize string to the path of the song in the resource folder
	NSString *myMusic = [NSString stringWithFormat:@"%@/%@.aif", [Util getDocumentPath], @"recording"];
	NSString *stringEscapedMyMusic = [myMusic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:stringEscapedMyMusic] error:NULL];
	player.numberOfLoops = 0;
	player.volume = slider.value;
	timeSlider.maximumValue = player.duration;
	timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeLoader) userInfo:nil repeats:YES];
	[player play];
	//==========================
};

- (IBAction) playtrans_playback:(id)sender{
	if(done_vocode==1){
		//NSString *audioFile = [NSString stringWithFormat:@"%@/%@.aif", [Util getDocumentPath], @"out"];
		//[audioRecorder startPlaybackWithFilepath:audioFile];
		//@ Ray added for audio player UI	
		[player dealloc];
		int a=0;
		//initialize string to the path of the song in the resource folder
		NSString *myMusic = [NSString stringWithFormat:@"%@/%@.aif", [Util getDocumentPath], @"out"];
		NSString *stringEscapedMyMusic = [myMusic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:stringEscapedMyMusic] error:NULL];
		player.numberOfLoops = 0;
		player.volume = slider.value;
		timeSlider.maximumValue = player.duration;
		timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeLoader) userInfo:nil repeats:YES];
		[player play];
		//==========================		
	}
};

- (IBAction) sendexit_playback:(id)sender{
	//NSMutableString *randomFilename = [self genRandStringLength:23];
	
	//NSString *originalFilename = [NSString stringWithFormat:@"%@%@", randomFilename, @"recording.aif"];
	/*if(done_vocode==1){
		randomFilename = [self genRandStringLength:23];
		NSString *vocodedFilename = [NSString stringWithFormat:@"%@%@", randomFilename, @"out.aif"];
		[self uploadFile:vocodedFilepath];
	}*/
	
	if (encrypt.on==YES&&done_vocode==1){

	}

	NSString *recordedFilepath = [NSString stringWithString:@"recording.aif"];
	[self uploadFile:recordedFilepath];
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY_MM_dd HH_MM_ss"];
    NSString *dateString = [dateFormat stringFromDate:date];  
    [dateFormat release];
	NSMutableString *randomFilename = [self genRandStringLength:23];
	NSString *vocodedFilename = [NSString stringWithFormat:@"%@%@%@", randomFilename, dateString, @"out.aif"];
	randomFilename = [self genRandStringLength:23];
	
	NSString *originalFilename = [NSString stringWithFormat:@"%@%@%@", randomFilename, dateString, @"recording.aif"];
	
    //time_t unixTime = [[NSDate date] timeIntervalSince1970];
    NSLog(@"%@",dateString);
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendVoice:vocode:pass:)]) 
    {
        [self.delegate sendVoice:originalFilename vocode:vocodedFilename pass:password.text];
    }
	[self.view removeFromSuperview];

};

- (IBAction) quit_playback:(id)sender{
	[self.view removeFromSuperview];
};

//UIPickerViewDeligate
- (NSString *)pickerView:(UIPickerView *)pickerView 
		titleForRow:(NSInteger)row 
			forComponent:(NSInteger)component
{
	return [vocodeCarrierOptions objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView 
	  didSelectRow:(NSInteger)row 
	   inComponent:(NSInteger)component
{
	vocode_carrier_index=row;
}

//UIPickerViewDatasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView 
numberOfRowsInComponent:(NSInteger)component
{
	return vocodeCarrierOptions.count;
}

//@Ray add for audio player UI
-(void)timeLoader
{  
	NSTimeInterval time = player.currentTime;
	timeSlider.value = time;
}


-(IBAction)timerPosition:(id)sender
{
	double timeValue = timeSlider.value;
	player.currentTime = (NSTimeInterval) timeValue;
	
}


-(IBAction)playPlayer:(id)sender
{   
	[player play];
}

-(IBAction)pausePlayer:(id)sender
{
	[player pause];
}

-(IBAction)stopPlayer:(id)sender
{
	[self pausePlayer]; 
	[player stop];
}

-(IBAction)sound:(id)sender
{
	increaseSound = slider.value;
	player.volume = increaseSound;
}


-(NSMutableString *) genRandStringLength: (int) len
{
	NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
	
    for (int i=0; i<len; i++) {
		[randomString appendFormat: @"%c", [letters characterAtIndex: rand()%[letters length]] ];
	}
	return randomString;
}
		 

@end
