//
//  ChatBubbleView.m
//  ChatMe
//
//  Created by Emerson Malca on 6/24/11.
//  Copyright 2011 OneZeroWare. All rights reserved.
//

#import "ChatBubbleView.h"

#define kBubbleViewMaxHeight      153.0 //Optimal for 7 lines
#define kBubbleViewMinHeight      40.0
#define kUITextViewTopInset        8.0
#define kUITextViewSideInset       6.0
#define kMaxFloat       9999.0

@interface ChatBubbleView (Private)

- (void)initialSetup;
- (void)resizeViews;

@end


@implementation ChatBubbleView

@synthesize bgImageView=_bgImageView;
@synthesize messageTextView=_messageTextView;
@synthesize sendBtn=_sendBtn;
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!initialSetupDone) {
        [self initialSetup];
        initialSetupDone = YES;
    }
    
    [self resizeViews];
}

- (void)initialSetup {
    UIImage *img = [UIImage imageNamed:@"bgTextBubbleLC20TC20"];
    UIImage *bg = [img stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    [self.bgImageView setImage:bg];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    self.bgImageView = nil;
    self.messageTextView = nil;
    self.sendBtn = nil;
    self.delegate = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Custom methods

- (void)resizeViews {
    //We want to resize both the UITextView and the BubbleView depending on the text (content) of the text view
    
    //The content size already includes the text insets
    CGSize contentSize = self.messageTextView.contentSize;
    UIFont *font = self.messageTextView.font;
    
    //SPECIAL CASE: When the text view is empty, the content size height is not right so we check for that case
    if (![self.messageTextView hasText]) {
        contentSize.height = [font lineHeight] + kUITextViewTopInset*2;
    }
    
    //The UITextView has to be taller than its content, we add the height of 3 lines
    CGRect textViewFrame = self.messageTextView.frame;
    textViewFrame.size.height = contentSize.height + [font lineHeight]*3;
    
    //The BubbleView's height should the the current yOffset of the textField*2 + the content's height
    CGFloat viewHeight = CGRectGetMinY(self.messageTextView.frame)*2 + contentSize.height;
    //We check the min case
    if (viewHeight < kBubbleViewMinHeight) {
        viewHeight = kBubbleViewMinHeight;
    } else if (viewHeight > kBubbleViewMaxHeight) {
        
        //VERY SPECIAL CASE: If we are about to go over the  max height for the bubble view we have to:
        // 1) Limit the bubble view's height to the max
        // 2) Make the text view's height the max size of the bubble view minus the offsets. This will make the
        //    text view scrollable.
        viewHeight = kBubbleViewMaxHeight;
        textViewFrame.size.height = kBubbleViewMaxHeight - CGRectGetMinY(self.messageTextView.frame)*2;
    }
    
    
    CGRect viewFrame = self.frame;
    CGFloat deltaHeight = CGRectGetHeight(viewFrame) - viewHeight;
    viewFrame.origin.y += deltaHeight;
    viewFrame.size.height = viewHeight;
    
    //Inform the delegate if we are resizing
    if (self.frame.size.height != viewHeight) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(chatBubbleView:willResizeToHeight:)]) {
            [self.delegate chatBubbleView:self willResizeToHeight:viewHeight];
        }
    }
    
    //Animate the change
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self setFrame:viewFrame];
                         [self.messageTextView setFrame:textViewFrame];
                     }];
}

/*
- (void)resizeViews {
    
    NSLog(@"Text view frame x:%f, y:%f, width:%f, height:%f", self.messageTextView.frame.origin.x, self.messageTextView.frame.origin.y, self.messageTextView.frame.size.width, self.messageTextView.frame.size.height);
    NSLog(@"Text view content size width:%f, height:%f", self.messageTextView.contentSize.width, self.messageTextView.contentSize.height);

    //The text
    UIFont *font = self.messageTextView.font;
    //This makes sure there is at least 1 line of text
    NSString *text = ([self.messageTextView hasText])?self.messageTextView.text:@" ";
    CGRect textFrame = CGRectInset(self.messageTextView.frame, kUITextViewSideInset, kUITextViewTopInset);
    CGSize maxTextSize = CGSizeMake(textFrame.size.width, kMaxFloat);
    CGSize textSize = [text sizeWithFont:font constrainedToSize:maxTextSize];
    
    //The size of the view should the the current yOffset of the textField*2
    // + the text field inset*2 + the neccessary lines to fit the text
    CGFloat viewHeight = CGRectGetMinY(self.messageTextView.frame)*2 + kUITextViewTopInset*2 + textSize.height;
    if (viewHeight < kBubbleViewMinHeight) {
        viewHeight = kBubbleViewMinHeight;
    
        //If we are exceeding the max, we need to limit the size
    } else if (viewHeight > kBubbleViewMaxHeight) {
        viewHeight = kBubbleViewMaxHeight;
    }
    
    
    CGRect viewFrame = self.frame;
    CGFloat deltaHeight = CGRectGetHeight(viewFrame) - viewHeight;
    viewFrame.origin.y += deltaHeight;
    viewFrame.size.height = viewHeight;
    
    //The text view should grow enough to fit the text + kUITextViewTopInset*2 + 2 lineHeights + 1 point
    //NOTE: The extra 2 lineHeights is a workaround cuz uitextview needs a couple of lines to work properly
    //NOTE:+1 point is another workaround cuz the text view MUST be greater than its content
    CGRect originalTextViewFrame = self.messageTextView.frame;
    CGFloat optimalTextViewHeight = textSize.height + 2*kUITextViewTopInset + 1.0;
    if (textSize.height < [font lineHeight]*4) {
        optimalTextViewHeight += [font lineHeight]*4;
    }
    //If we are exceeding the max, we need to limit the size
    if (optimalTextViewHeight > kBubbleViewMaxHeight - CGRectGetMinY(originalTextViewFrame)*2) {
        optimalTextViewHeight = kBubbleViewMaxHeight - CGRectGetMinY(originalTextViewFrame)*2;
    }
    CGRect textViewFrame = CGRectMake(CGRectGetMinX(originalTextViewFrame), CGRectGetMinY(originalTextViewFrame), CGRectGetWidth(originalTextViewFrame), optimalTextViewHeight);
    
    //Inform the delegate if we are resizing
    if (self.frame.size.height != viewFrame.size.height) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(chatBubbleView:willResizeToHeight:)]) {
            [self.delegate chatBubbleView:self willResizeToHeight:viewFrame.size.height];
        }
    }
    
    //Animate the change
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self setFrame:viewFrame];
                         [self.messageTextView setFrame:textViewFrame];
                     }];
}
*/
- (void)sendButtonTapped {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBubbleView:willSendText:)]) {
        [self.delegate chatBubbleView:self willSendText:self.messageTextView.text];
    }
    
    //delete the text
    [self.messageTextView setText:@""];
    
    //Resize accordingly
    [self resizeViews];
}

#pragma mark -
#pragma mark Text view delegate

- (void)textViewDidChange:(UITextView *)textView {
    
    //Resize accordingly
    [self resizeViews];
}

#pragma mark -
#pragma mark navigationbar methods

@end
