//
//  CLMessageCell.m
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import "CLMessageCell.h"
#import "UIView+CL.h"
#import "UIImageView+WebCache.h"
#import "macros.h"

@implementation CLMessageCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.avatarImageView];
        [self addSubview:self.messageBackgroundImageView];
        [self addSubview:self.messageSendStatusImageView];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    if (_message.ownerTyper == CLMessageOwnerTypeSelf) {
        [self.avatarImageView setOrigin:CGPointMake(self.frameWidth - 10 - self.avatarImageView.frameWidth, 10)];
    }
    else if (_message.ownerTyper == CLMessageOwnerTypeOther) {
        [self.avatarImageView setOrigin:CGPointMake(10, 10)];
    }
}

#pragma mark - Getter and Stter
- (void) setMessage:(CLMessage *)message
{
    _message = message;
    
    switch (message.ownerTyper) {
        case CLMessageOwnerTypeSelf:
            if (message.sendState == CLMessageSendFail) {
                [self.messageSendStatusImageView setHidden:NO];
            } else {
                [self.messageSendStatusImageView setHidden:YES];
            }
            [self.avatarImageView setHidden:NO];
            if ([message.from.avatarURL containsString:@"http:"] || [message.from.avatarURL containsString:@"https:"]) {
                [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:message.from.avatarURL] placeholderImage:[UIImage imageNamed:DEFAULT_CHAT_USERHEADER]];
            } else {
                [self.avatarImageView setImage:[UIImage imageNamed:message.from.avatarURL]];
            }
            [self.messageBackgroundImageView setHidden:NO];
            self.messageBackgroundImageView.image = [[UIImage imageNamed:@"message_sender_background_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 15, 20) resizingMode:UIImageResizingModeStretch];
            self.messageBackgroundImageView.highlightedImage = [[UIImage imageNamed:@"message_sender_background_highlight"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 15, 20) resizingMode:UIImageResizingModeStretch];
            break;
        case CLMessageOwnerTypeOther:
            [self.avatarImageView setHidden:NO];
            if ([message.from.avatarURL containsString:@"http:"] || [message.from.avatarURL containsString:@"https:"]) {
                [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:message.from.avatarURL] placeholderImage:[UIImage imageNamed:DEFAULT_CHAT_USERHEADER]];
            } else {
                [self.avatarImageView setImage:[UIImage imageNamed:message.from.avatarURL]];
            }
            [self.messageBackgroundImageView setHidden:NO];
            [self.messageBackgroundImageView setImage:[[UIImage imageNamed:@"message_receiver_background_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 15, 20) resizingMode:UIImageResizingModeStretch]];
            self.messageBackgroundImageView.highlightedImage = [[UIImage imageNamed:@"message_receiver_background_highlight"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 15, 20) resizingMode:UIImageResizingModeStretch];
            break;
        case CLMessageOwnerTypeSystem:
            [self.avatarImageView setHidden:YES];
            [self.messageBackgroundImageView setHidden:YES];
            [self.messageSendStatusImageView setHidden:YES];
            break;
        default:
            break;
    }
}

- (UIImageView *)avatarImageView
{
    if (_avatarImageView == nil) {
        float imageWidth = 40;
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth)];
        [_avatarImageView setHidden:YES];
    }
    return _avatarImageView;
}

- (UIImageView *) messageBackgroundImageView
{
    if (_messageBackgroundImageView == nil) {
        _messageBackgroundImageView = [[UIImageView alloc] init];
        [_messageBackgroundImageView setHidden:YES];
    }
    return _messageBackgroundImageView;
}

- (UIImageView *)messageSendStatusImageView {
    if (_messageSendStatusImageView == nil) {
        _messageSendStatusImageView = [[UIImageView alloc] init];
        _messageSendStatusImageView.image = [UIImage imageNamed:@"message_send_fail"];
        [_messageSendStatusImageView setHidden:YES];
        _messageSendStatusImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFailViewAction)];
        [_messageSendStatusImageView addGestureRecognizer:tapGesture];
    }
    return _messageSendStatusImageView;
}

- (void)tapFailViewAction {
    if (_comDelegate && [_comDelegate respondsToSelector:@selector(CLMessageCellTapFailView:)]) {
        [_comDelegate CLMessageCellTapFailView:self];
    }
}

@end
