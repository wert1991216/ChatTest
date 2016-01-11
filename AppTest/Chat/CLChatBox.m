//
//  CLChatBox.m
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import "CLChatBox.h"
#import "UIView+CL.h"
#import "macros.h"
#import "UIImage+CL.h"
#import "CLChatBoxRecordButton.h"
#import "BlazeiceAudioRecordView.h"

#define     CHATBOX_BUTTON_WIDTH        37
#define     HEIGHT_TEXTVIEW             HEIGHT_TABBAR * 0.74
#define     MAX_TEXTVIEW_HEIGHT         104


@interface CLChatBox () <UITextViewDelegate, CLChatBoxRecordButtonDelegate, audioRecordDelegate>

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIButton *voiceButton;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *faceButton;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) CLChatBoxRecordButton *talkButton;
@property (nonatomic, strong) BlazeiceAudioRecordView *recordPopView;

@end

@implementation CLChatBox

- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _curHeight = frame.size.height;
        [self setBackgroundColor:DEFAULT_CHATBOX_COLOR];
        [self addSubview:self.topLine];
        [self addSubview:self.voiceButton];
        [self addSubview:self.textView];
        [self addSubview:self.faceButton];
        [self addSubview:self.moreButton];
        [self addSubview:self.talkButton];
        self.status = CLChatBoxStatusNothing;
    }
    return self;
}

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.topLine setFrameWidth:self.frameWidth];
    
    float y = self.frameHeight - self.voiceButton.frameHeight - (HEIGHT_TABBAR - CHATBOX_BUTTON_WIDTH) / 2;
    if (self.voiceButton.originY != y) {
        [UIView animateWithDuration:0.1 animations:^{
            [self.voiceButton setOriginY:y];
            [self.faceButton setOriginY:self.voiceButton.originY];
            [self.moreButton setOriginY:self.voiceButton.originY];
        }];
    }
}

#pragma Public Methods
- (BOOL) resignFirstResponder
{
    [self.textView resignFirstResponder];
    [_moreButton setImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateNormal];
    [_moreButton setImage:[UIImage imageNamed:@"TypeSelectorBtnHL_Black"] forState:UIControlStateHighlighted];
    [_faceButton setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
    [_faceButton setImage:[UIImage imageNamed:@"ToolViewEmotionHL"] forState:UIControlStateHighlighted];
    return [super resignFirstResponder];
}

- (void) addEmojiFace:(CLFace *)face
{
    [self.textView setText:[self.textView.text stringByAppendingString:face.faceName]];
    if (MAX_TEXTVIEW_HEIGHT < self.textView.contentSize.height) {
        float y = self.textView.contentSize.height - self.textView.frameHeight;
        y = y < 0 ? 0 : y;
        [self.textView scrollRectToVisible:CGRectMake(0, y, self.textView.frameWidth, self.textView.frameHeight) animated:YES];
    }
    [self textViewDidChange:self.textView];
}

- (void) sendCurrentMessage
{
    if (self.textView.text.length > 0) {     // send Text
        if (_delegate && [_delegate respondsToSelector:@selector(chatBox:sendTextMessage:)]) {
            [_delegate chatBox:self sendTextMessage:self.textView.text];
        }
    }
    [self.textView setText:@""];
    [self textViewDidChange:self.textView];
}

- (void) deleteButtonDown
{
    [self textView:self.textView shouldChangeTextInRange:NSMakeRange(self.textView.text.length - 1, 1) replacementText:@""];
    [self textViewDidChange:self.textView];
}

#pragma mark - audioRecordDelegate <NSObject>
-(void)recodeComplete:(NSString *)vedioPathString {
    NSLog(@"Path:%@", vedioPathString);
    if (vedioPathString && vedioPathString.length > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CHAT_RECORDFINISH object:nil userInfo:@{CHAT_RECORDFINISH:vedioPathString}];
    }
}

#pragma mark - UITextViewDelegate
- (void) textViewDidBeginEditing:(UITextView *)textView
{
    CLChatBoxStatus lastStatus = self.status;
    self.status = CLChatBoxStatusShowKeyboard;
    if (lastStatus == CLChatBoxStatusShowFace) {
        [_faceButton setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
        [_faceButton setImage:[UIImage imageNamed:@"ToolViewEmotionHL"] forState:UIControlStateHighlighted];
    }
    else if (lastStatus == CLChatBoxStatusShowMore) {
        [_moreButton setImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:@"TypeSelectorBtnHL_Black"] forState:UIControlStateHighlighted];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(chatBox:changeStatusForm:to:)]) {
        [_delegate chatBox:self changeStatusForm:lastStatus to:self.status];
    }
}

- (void) textViewDidChange:(UITextView *)textView
{
    CGFloat height = [textView sizeThatFits:CGSizeMake(self.textView.frameWidth, MAXFLOAT)].height;
    height = height > HEIGHT_TEXTVIEW ? height : HEIGHT_TEXTVIEW;
    height = height < MAX_TEXTVIEW_HEIGHT ? height : textView.frameHeight;
    _curHeight = height + HEIGHT_TABBAR - HEIGHT_TEXTVIEW;
    if (_curHeight != self.frameHeight) {
        [UIView animateWithDuration:0.05 animations:^{
            [self setFrameHeight:_curHeight];
            if (_delegate && [_delegate respondsToSelector:@selector(chatBox:changeChatBoxHeight:)]) {
                [_delegate chatBox:self changeChatBoxHeight:_curHeight];
            }
        }];
    }
    if (height != textView.frameHeight) {
        [UIView animateWithDuration:0.05 animations:^{
            [textView setFrameHeight:height];
        }];
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [self sendCurrentMessage];
        return NO;
    }
    else if (textView.text.length > 0 && [text isEqualToString:@""]) {       // delete
        if ([textView.text characterAtIndex:range.location] == ']') {
            NSUInteger location = range.location;
            NSUInteger length = range.length;
            while (location != 0) {
                location --;
                length ++ ;
                char c = [textView.text characterAtIndex:location];
                if (c == '[') {
                    textView.text = [textView.text stringByReplacingCharactersInRange:NSMakeRange(location, length) withString:@""];
                    return NO;
                }
                else if (c == ']') {
                    return YES;
                }
            }
        }
    }
    
    return YES;
}

#pragma mark - CLChatBoxRecordButtonDelegate <NSObject>

- (void)RecordButtonTouchBegain {
    [[UIApplication sharedApplication].keyWindow addSubview:self.recordPopView];
    [self.recordPopView showRecordView];
    [self.recordPopView beginToRecordAudio];
}

- (void)RecordButtonTouchInside {
    [self.recordPopView showRecordView];
}

- (void)RecordButtonTouchOutside {
    [self.recordPopView showCancelView];
}

- (void)RecordButtonEndInside {
    [self.recordPopView endRecord];
}

- (void)RecordButtonEndOutside {
    [self.recordPopView cancleRecord];
}

#pragma mark - Event Response
- (void) voiceButtonDown:(UIButton *)sender
{
    CLChatBoxStatus lastStatus = self.status;
    if (lastStatus == CLChatBoxStatusShowVoice) {      // 正在显示talkButton，改为现实键盘状态
        self.status = CLChatBoxStatusShowKeyboard;
        [self.talkButton setHidden:YES];
        [self.textView setHidden:NO];
        [self.textView becomeFirstResponder];
        [_voiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
        [_voiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoiceHL"] forState:UIControlStateHighlighted];
        
        [self textViewDidChange:self.textView];
        if (_delegate && [_delegate respondsToSelector:@selector(chatBox:changeStatusForm:to:)]) {
            [_delegate chatBox:self changeStatusForm:lastStatus to:self.status];
        }
    }
    else {          // 显示talkButton
        self.curHeight = HEIGHT_TABBAR;
        [self setFrameHeight:self.curHeight];
        self.status = CLChatBoxStatusShowVoice;
        [self.textView resignFirstResponder];
        [self.textView setHidden:YES];
        [self.talkButton setHidden:NO];
        [_voiceButton setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateNormal];
        [_voiceButton setImage:[UIImage imageNamed:@"ToolViewKeyboardHL"] forState:UIControlStateHighlighted];
        if (lastStatus == CLChatBoxStatusShowFace) {
            [_faceButton setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
            [_faceButton setImage:[UIImage imageNamed:@"ToolViewEmotionHL"] forState:UIControlStateHighlighted];
        }
        else if (lastStatus == CLChatBoxStatusShowMore) {
            [_moreButton setImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateNormal];
            [_moreButton setImage:[UIImage imageNamed:@"TypeSelectorBtnHL_Black"] forState:UIControlStateHighlighted];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(chatBox:changeStatusForm:to:)]) {
            [_delegate chatBox:self changeStatusForm:lastStatus to:self.status];
        }
    }
}

- (void) faceButtonDown:(UIButton *)sender
{
    CLChatBoxStatus lastStatus = self.status;
    if (lastStatus == CLChatBoxStatusShowFace) {       // 正在显示表情，改为现实键盘状态
        self.status = CLChatBoxStatusShowKeyboard;
        [_faceButton setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
        [_faceButton setImage:[UIImage imageNamed:@"ToolViewEmotionHL"] forState:UIControlStateHighlighted];
        [self.textView becomeFirstResponder];
        if (_delegate && [_delegate respondsToSelector:@selector(chatBox:changeStatusForm:to:)]) {
            [_delegate chatBox:self changeStatusForm:lastStatus to:self.status];
        }
    }
    else {
        self.status = CLChatBoxStatusShowFace;
        [_faceButton setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateNormal];
        [_faceButton setImage:[UIImage imageNamed:@"ToolViewKeyboardHL"] forState:UIControlStateHighlighted];
        if (lastStatus == CLChatBoxStatusShowMore) {
            [_moreButton setImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateNormal];
            [_moreButton setImage:[UIImage imageNamed:@"TypeSelectorBtnHL_Black"] forState:UIControlStateHighlighted];
        }
        else if (lastStatus == CLChatBoxStatusShowVoice) {
            [_voiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
            [_voiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoiceHL"] forState:UIControlStateHighlighted];
            [_talkButton setHidden:YES];
            [_textView setHidden:NO];
            [self textViewDidChange:self.textView];
        }
        else if (lastStatus == CLChatBoxStatusShowKeyboard) {
            [self.textView resignFirstResponder];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(chatBox:changeStatusForm:to:)]) {
            [_delegate chatBox:self changeStatusForm:lastStatus to:self.status];
        }
    }
}

- (void) moreButtonDown:(UIButton *)sender
{
    CLChatBoxStatus lastStatus = self.status;
    if (lastStatus == CLChatBoxStatusShowMore) {
        self.status = CLChatBoxStatusShowKeyboard;
        [_moreButton setImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:@"TypeSelectorBtnHL_Black"] forState:UIControlStateHighlighted];
        [self.textView becomeFirstResponder];
        if (_delegate && [_delegate respondsToSelector:@selector(chatBox:changeStatusForm:to:)]) {
            [_delegate chatBox:self changeStatusForm:lastStatus to:self.status];
        }
    }
    else {
        self.status = CLChatBoxStatusShowMore;
        [_moreButton setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:@"ToolViewKeyboardHL"] forState:UIControlStateHighlighted];
        if (lastStatus == CLChatBoxStatusShowFace) {
            [_faceButton setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
            [_faceButton setImage:[UIImage imageNamed:@"ToolViewEmotionHL"] forState:UIControlStateHighlighted];
        }
        else if (lastStatus == CLChatBoxStatusShowVoice) {
            [_voiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
            [_voiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoiceHL"] forState:UIControlStateHighlighted];
            [_talkButton setHidden:YES];
            [_textView setHidden:NO];
            [self textViewDidChange:self.textView];
        }
        else if (lastStatus == CLChatBoxStatusShowKeyboard) {
            [self.textView resignFirstResponder];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(chatBox:changeStatusForm:to:)]) {
            [_delegate chatBox:self changeStatusForm:lastStatus to:self.status];
        }
    }
}

#pragma mark - Getter
- (UIView *) topLine
{
    if (_topLine == nil) {
        _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.5)];
        [_topLine setBackgroundColor:WBColor(165, 165, 165, 1.0)];
    }
    return _topLine;
}

- (UIButton *) voiceButton
{
    if (_voiceButton == nil) {
        _voiceButton = [[UIButton alloc] initWithFrame:CGRectMake(0, (HEIGHT_TABBAR - CHATBOX_BUTTON_WIDTH) / 2, CHATBOX_BUTTON_WIDTH, CHATBOX_BUTTON_WIDTH)];
        [_voiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
        [_voiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoiceHL"] forState:UIControlStateHighlighted];
        [_voiceButton addTarget:self action:@selector(voiceButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceButton;
}

- (UITextView *) textView
{
    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:self.talkButton.frame];
        [_textView setFont:[UIFont systemFontOfSize:16.0f]];
        [_textView.layer setMasksToBounds:YES];
        [_textView.layer setCornerRadius:4.0f];
        [_textView.layer setBorderWidth:0.5f];
        [_textView.layer setBorderColor:self.topLine.backgroundColor.CGColor];
        [_textView setScrollsToTop:NO];
        [_textView setReturnKeyType:UIReturnKeySend];
        [_textView setDelegate:self];
    }
    return _textView;
}

- (UIButton *) faceButton
{
    if (_faceButton == nil) {
        _faceButton = [[UIButton alloc] initWithFrame:CGRectMake(self.moreButton.originX - CHATBOX_BUTTON_WIDTH, (HEIGHT_TABBAR - CHATBOX_BUTTON_WIDTH) / 2, CHATBOX_BUTTON_WIDTH, CHATBOX_BUTTON_WIDTH)];
        [_faceButton setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
        [_faceButton setImage:[UIImage imageNamed:@"ToolViewEmotionHL"] forState:UIControlStateHighlighted];
        [_faceButton addTarget:self action:@selector(faceButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _faceButton;
}

- (UIButton *) moreButton
{
    if (_moreButton == nil) {
        _moreButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH_SCREEN - CHATBOX_BUTTON_WIDTH, (HEIGHT_TABBAR - CHATBOX_BUTTON_WIDTH) / 2, CHATBOX_BUTTON_WIDTH, CHATBOX_BUTTON_WIDTH)];
        [_moreButton setImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:@"TypeSelectorBtnHL_Black"] forState:UIControlStateHighlighted];
        [_moreButton addTarget:self action:@selector(moreButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (CLChatBoxRecordButton *) talkButton
{
    if (_talkButton == nil) {
        _talkButton = [[CLChatBoxRecordButton alloc] initWithFrame:CGRectMake(self.voiceButton.originX + self.voiceButton.frameWidth + 4, self.frameHeight * 0.13, self.faceButton.originX - self.voiceButton.originX - self.voiceButton.frameWidth - 8, HEIGHT_TEXTVIEW)];
        _talkButton.hidden = YES;
        _talkButton.delegate = self;
    }
    return _talkButton;
}

- (BlazeiceAudioRecordView *)recordPopView {
    if (_recordPopView == nil) {
        _recordPopView = [[BlazeiceAudioRecordView alloc] initWithFrame:CGRectMake(0, 64, WIDTH_SCREEN, HEIGHT_SCREEN - 64*2)];
        _recordPopView.delegate = self;
    }
    return _recordPopView;
}

@end
