//
//  CLImageMessagePopView.m
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import "CLImageMessagePopView.h"
#import "UIImageView+WebCache.h"
#import "macros.h"

@implementation CLImageMessagePopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.popImageView];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)setMessage:(CLMessage *)message {
    _message = message;
    if(message.imagePath != nil || message.imageURL != nil) {
        if (message.imagePath.length > 0) {
            [self.popImageView setImage:message.image];
        }
        else {
            // network Image
            [self.popImageView sd_setImageWithURL:[NSURL URLWithString:message.imageURL] placeholderImage:[UIImage imageNamed:DEFAULT_CHAT_IMAGENAME]];
        }
    }
}

- (UIImageView *)popImageView {
    if (_popImageView == nil) {
        _popImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _popImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _popImageView;
}

- (void)tapGestureAction {
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self removeFromSuperview];
    
}

@end
