//
//  ChatBubbleView.h
//  ChatMe
//
//  Created by Emerson Malca on 6/24/11.
//  Copyright 2011 OneZeroWare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioRecorder.h"
#import "VocViewController.h"

@protocol ChatBubbleViewDelegate;

@interface ChatBubbleView : UIView <UITextViewDelegate, VocSendVoiceDelegate> {
    BOOL initialSetupDone;
    NSFileHandle* audioFile;
    AudioRecorder *audioRecorder;
    VocViewController *m_vocView;
    UIView *view;
}

@property (nonatomic, retain) UIView *view;
@property (nonatomic, retain) IBOutlet UIImageView *bgImageView;
@property (nonatomic, retain) IBOutlet UITextView *messageTextView;
@property (nonatomic, retain) IBOutlet UIButton *sendBtn;
@property (nonatomic, assign) id<ChatBubbleViewDelegate> delegate;
@property (nonatomic, retain) NSFileHandle *audioFile;
@property (nonatomic,retain)  AudioRecorder *audioRecorder;
@property (nonatomic,retain)  VocViewController *m_vocView;

- (IBAction)sendButtonTapped;
- (IBAction)recordButtonTapped;
- (IBAction)recordButtonTouchUp;

@end

@protocol ChatBubbleViewDelegate <NSObject>
@optional

- (void)chatBubbleView:(ChatBubbleView *)bubbleView willResizeToHeight:(CGFloat)newHeight;
- (void)chatBubbleView:(ChatBubbleView *)bubbleView willSendText:(NSString *)message;
- (void)sendVoice:(NSString *)origfilename vocode:(NSString *)vocodefilename pass:(NSString *)password;

@end
