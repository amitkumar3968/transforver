//
//  FavoritesTabViewController.h
//  NavTab
//
//  Created by Robert Conn on 04/04/2009.
//  Copyright 2009 WiredBob Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioRecorder.h"

@interface FavoritesTabViewController : UIViewController {
    IBOutlet UIButton *mybutton;
    NSString* localFilePath;
    NSFileHandle* audioFile;
    AudioRecorder *audioRecorder;

}

- (void) uploadFile;
- (void) downloadToFile;
- (IBAction)downloadingButtonClick:(id)sender;
- (IBAction)uploadButtonClick:(id)sender;
- (IBAction)recordingButtonClick:(id)sender;
- (IBAction)recordingButtonRelease:(id)sender;
@property (nonatomic, retain) UIButton *mybutton;
@property (nonatomic, retain) NSString *localFilePath;
@property (nonatomic, retain) NSFileHandle *audioFile;
@property (nonatomic,retain)  AudioRecorder *audioRecorder;
@end
