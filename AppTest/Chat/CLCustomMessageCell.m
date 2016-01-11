//
//  CLCustomMessageCell.m
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import "CLCustomMessageCell.h"
#import "UIView+CL.h"
#import "macros.h"

@interface CLCustomMessageCell ()

@property (nonatomic, strong) UIView *containerView;

@end

@implementation CLCustomMessageCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self insertSubview:self.containerView belowSubview:self.messageBackgroundImageView];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.containerView.frame = _cusView.frame;
    
    float y = self.avatarImageView.originY - 3;
    if (self.message.ownerTyper == CLMessageOwnerTypeSelf) {
        float x = self.avatarImageView.originX - self.containerView.frameWidth - 5;
        [self.containerView setOrigin:CGPointMake(x , y)];
        [self.messageBackgroundImageView setFrame:CGRectMake(x, y, self.containerView.frameWidth, self.containerView.frameHeight + 10)];
    }
    else if (self.message.ownerTyper == CLMessageOwnerTypeOther) {
        float x = self.avatarImageView.originX + self.avatarImageView.frameWidth + 5;
        [self.containerView setOrigin:CGPointMake(x, y)];
        [self.messageBackgroundImageView setFrame:CGRectMake(x, y, self.containerView.frameWidth, self.containerView.frameHeight + 10)];
    }
    [self.messageSendStatusImageView setFrame:CGRectMake(self.messageBackgroundImageView.originX - 5 - 22, self.messageBackgroundImageView.originY + 5 + (self.messageBackgroundImageView.frameHeight - 15 - 22)/2.0, 22, 22)];
}

#pragma mark - Getter and Setter
- (void) setMessage:(CLMessage *)message
{
    [super setMessage:message];
    
    _cusView.frame = CGRectMake(0, 0, _cusView.frame.size.width > (WIDTH_SCREEN * 0.65) ? (WIDTH_SCREEN * 0.65) : _cusView.frame.size.width, _cusView.frame.size.height);
    _cusView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction)];
    [_cusView addGestureRecognizer:tapGesture];
    for (UIView *view in self.containerView.subviews) {
        [view removeFromSuperview];
    }
    [self.containerView addSubview:_cusView];
    
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

- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor clearColor];
        _containerView.layer.masksToBounds = YES;
    }
    return _containerView;
}

- (void)tapGestureAction {
    if (_delegate && [_delegate respondsToSelector:@selector(didTapCustomMessageCell:)]) {
        [_delegate didTapCustomMessageCell:self];
    }
}

@end
