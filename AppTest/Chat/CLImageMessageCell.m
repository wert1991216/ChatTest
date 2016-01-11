//
//  CLImageMessageCell.m
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import "CLImageMessageCell.h"
#import "UIView+CL.h"
#import "UIImageView+WebCache.h"
#import "macros.h"
#import "CLImageMessagePopView.h"

@interface CLImageMessageCell ()

@property (nonatomic, strong) CLImageMessagePopView *popView;

@end

@implementation CLImageMessageCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self insertSubview:self.messageImageView belowSubview:self.messageBackgroundImageView];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    float y = self.avatarImageView.originY - 3;
    if (self.message.ownerTyper == CLMessageOwnerTypeSelf) {
        float x = self.avatarImageView.originX - self.messageImageView.frameWidth - 5;
        [self.messageImageView setOrigin:CGPointMake(x , y)];
        [self.messageBackgroundImageView setFrame:CGRectMake(x, y, self.message.messageSize.width+ 10, self.message.messageSize.height + 10)];
    }
    else if (self.message.ownerTyper == CLMessageOwnerTypeOther) {
        float x = self.avatarImageView.originX + self.avatarImageView.frameWidth + 5;
        [self.messageImageView setOrigin:CGPointMake(x, y)];
        [self.messageBackgroundImageView setFrame:CGRectMake(x, y, self.message.messageSize.width+ 10, self.message.messageSize.height + 10)];
    }
    [self.messageSendStatusImageView setFrame:CGRectMake(self.messageBackgroundImageView.originX - 5 - 22, self.messageBackgroundImageView.originY + 5 + (self.messageBackgroundImageView.frameHeight - 15 - 22)/2.0, 22, 22)];
}

#pragma mark - Getter and Setter
- (void) setMessage:(CLMessage *)message
{
    [super setMessage:message];
    if(message.imagePath != nil || message.imageURL != nil) {
        if (message.imagePath.length > 0) {
            [self.messageImageView setImage:message.image];
        }
        else {
            // network Image
            [self.messageImageView sd_setImageWithURL:[NSURL URLWithString:message.imageURL] placeholderImage:[UIImage imageNamed:DEFAULT_CHAT_IMAGENAME]];
        }
        
        [self.messageImageView setSize:CGSizeMake(message.messageSize.width + 10, message.messageSize.height + 10)];
    }
    switch (self.message.ownerTyper) {
        case CLMessageOwnerTypeSelf:
            self.messageBackgroundImageView.image = [[UIImage imageNamed:@"message_sender_background_reversed"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 15, 20) resizingMode:UIImageResizingModeStretch];
            break;
        case CLMessageOwnerTypeOther:
            [self.messageBackgroundImageView setImage:[[UIImage imageNamed:@"message_receiver_background_reversed"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 15, 20) resizingMode:UIImageResizingModeStretch]];
            break;
        default:
            break;
    }
}

- (UIImageView *) messageImageView
{
    if (_messageImageView == nil) {
        _messageImageView = [[UIImageView alloc] init];
        [_messageImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_messageImageView setClipsToBounds:YES];
        _messageImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction)];
        [_messageImageView addGestureRecognizer:tapGesture];
    }
    return _messageImageView;
}

- (void)tapGestureAction {
    self.popView.message = self.message;
    [UIApplication sharedApplication].statusBarHidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self.popView];
}

- (CLImageMessagePopView *)popView {
    if (_popView == nil) {
        _popView = [[CLImageMessagePopView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _popView;
}

@end
