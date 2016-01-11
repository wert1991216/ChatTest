//
//  CLVoiceMessageCell.m
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import "CLVoiceMessageCell.h"
#import "UIView+CL.h"
#import <AVFoundation/AVFoundation.h>

@interface CLVoiceMessageCell ()<AVAudioPlayerDelegate>
{
    AVAudioPlayer *audioPlayer;
}
@end

@implementation CLVoiceMessageCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.voiceImageView];
        [self addSubview:self.voiceTextLabel];
        self.messageBackgroundImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction)];
        [self.messageBackgroundImageView addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    float y = self.avatarImageView.originY + 11;
    float x = self.avatarImageView.originX + (self.message.ownerTyper == CLMessageOwnerTypeSelf ? - self.message.messageSize.width - 27 : self.avatarImageView.frameWidth + 23);
    
    x -= 18;                                    // 左边距离头像 5
    y = self.avatarImageView.originY - 5;       // 上边与头像对齐 (北京图像有5个像素偏差)
    [self.messageBackgroundImageView setFrame:CGRectMake(x, y, self.message.messageSize.width + 40, self.avatarImageView.frameHeight + 10)];
    
    float voiceImageX = self.message.ownerTyper == CLMessageOwnerTypeSelf ? (self.messageBackgroundImageView.frameRight - 20 - 20) : (self.messageBackgroundImageView.originX + 20);
    [self.voiceImageView setFrame:CGRectMake(voiceImageX, 20, 20, 20)];
    
    float voiceLabelX = self.message.ownerTyper == CLMessageOwnerTypeSelf ? (self.messageBackgroundImageView.originX - 60 - 2) : (self.messageBackgroundImageView.frameRight + 2);
    [self.voiceTextLabel setFrame:CGRectMake(voiceLabelX, 20, 60, 20)];
    [self.messageSendStatusImageView setFrame:CGRectMake(self.messageBackgroundImageView.originX - 5 - 22, self.messageBackgroundImageView.originY + 5 + (self.messageBackgroundImageView.frameHeight - 15 - 22)/2.0, 22, 22)];
}

- (void)tapGestureAction {
    if (!_voiceImageView.isAnimating) {
        if (self.message.ownerTyper == CLMessageOwnerTypeSelf) {
            _voiceImageView.animationImages = @[
                                                [UIImage imageNamed:@"message_voice_sender_playing_1"],
                                                [UIImage imageNamed:@"message_voice_sender_playing_2"],
                                                [UIImage imageNamed:@"message_voice_sender_playing_3"]];
        } else {
            _voiceImageView.animationImages = @[
                                                [UIImage imageNamed:@"message_voice_receiver_playing_1"],
                                                [UIImage imageNamed:@"message_voice_receiver_playing_2"],
                                                [UIImage imageNamed:@"message_voice_receiver_playing_3"]];
        }
        
        _voiceImageView.animationDuration = 0.5 * 3;
        _voiceImageView.animationRepeatCount = 0;
        [_voiceImageView startAnimating];
        [self playAudio];
        [self performSelector:@selector(stopVoiceImageViewAnimate) withObject:nil afterDelay:self.message.voiceSeconds];
    } else {
        [self stopVoiceImageViewAnimate];
    }
}

- (void)playAudio{
    if (self.message.voicePath && self.message.voicePath.length > 0) {
        NSURL *fileUrl = [NSURL fileURLWithPath:self.message.voicePath];
        NSError *error = nil;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:&error];
        if (audioPlayer) {
            [audioPlayer setNumberOfLoops:0]; //默认为0，即播放一次就结束；如果设置为负值，则音频内容会不停的循环播放下去。
            [audioPlayer setDelegate:self];
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            NSError *err = nil;
            [audioSession setCategory :AVAudioSessionCategoryPlayback error:&err];
            [audioPlayer play];
        }
    }
    
}

- (void)stopVoiceImageViewAnimate {
    if (audioPlayer) {
        [audioPlayer stop];
    }
    [_voiceImageView stopAnimating];
    if (self.message.ownerTyper == CLMessageOwnerTypeSelf) {
        _voiceImageView.image = [UIImage imageNamed:@"message_voice_sender_normal"];
    } else {
        _voiceImageView.image = [UIImage imageNamed:@"message_voice_receiver_normal"];
    }
}

#pragma mark - Getter and Setter
- (void) setMessage:(CLMessage *)message
{
    [super setMessage:message];
    [_voiceTextLabel setText:[NSString stringWithFormat:@"%ld''", message.voiceSeconds]];
    if (self.message.ownerTyper == CLMessageOwnerTypeSelf) {
        _voiceTextLabel.textAlignment = NSTextAlignmentRight;
        _voiceImageView.image = [UIImage imageNamed:@"message_voice_sender_normal"];
    } else {
        _voiceTextLabel.textAlignment = NSTextAlignmentLeft;
        _voiceImageView.image = [UIImage imageNamed:@"message_voice_receiver_normal"];
    }
}

- (UILabel *) voiceTextLabel
{
    if (_voiceTextLabel == nil) {
        _voiceTextLabel = [[UILabel alloc] init];
        [_voiceTextLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_voiceTextLabel setNumberOfLines:0];
        _voiceTextLabel.textColor = [UIColor lightGrayColor];
    }
    return _voiceTextLabel;
}

- (UIImageView *)voiceImageView {
    if (_voiceImageView == nil) {
        _voiceImageView = [[UIImageView alloc] init];
    }
    return _voiceImageView;
}

//程序中断时，停止播放
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    [player stop];
    
}

@end
