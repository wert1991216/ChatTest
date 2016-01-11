//
//  CLChatBoxRecordButton.m
//  AppTest
//
//  Created by clark on 16/1/4.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import "CLChatBoxRecordButton.h"
#import "UIImage+CL.h"
#import "UIView+CL.h"

@interface CLChatBoxRecordButton ()
@property (nonatomic, strong) UIButton *recordBtn;
@end

@implementation CLChatBoxRecordButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.recordBtn];
    }
    return self;
}

- (UIButton *)recordBtn {
    if (_recordBtn == nil) {
        _recordBtn = [[UIButton alloc] initWithFrame:self.bounds];
        [_recordBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_recordBtn setTitle:@"松开 结束" forState:UIControlStateSelected];
        [_recordBtn setTitleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0] forState:UIControlStateNormal];
        [_recordBtn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_recordBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.5]] forState:UIControlStateSelected];
        [_recordBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [_recordBtn.layer setMasksToBounds:YES];
        [_recordBtn.layer setCornerRadius:4.0f];
        [_recordBtn.layer setBorderWidth:0.5f];
        [_recordBtn.layer setBorderColor:[UIColor grayColor].CGColor];
        _recordBtn.userInteractionEnabled = NO;
    }
    return _recordBtn;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.recordBtn.selected = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(RecordButtonTouchBegain)]) {
        [_delegate RecordButtonTouchBegain];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch  locationInView:self];
    if (point.x >= 0 && point.x <= self.frameWidth && point.y >= 0 && point.y <= self.frameHeight) {
        if (_delegate && [_delegate respondsToSelector:@selector(RecordButtonTouchInside)]) {
            [_delegate RecordButtonTouchInside];
        }
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(RecordButtonTouchOutside)]) {
            [_delegate RecordButtonTouchOutside];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.recordBtn.selected = NO;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch  locationInView:self];
    if (point.x >= 0 && point.x <= self.frameWidth && point.y >= 0 && point.y <= self.frameHeight) {
        if (_delegate && [_delegate respondsToSelector:@selector(RecordButtonEndInside)]) {
            [_delegate RecordButtonEndInside];
        }
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(RecordButtonEndOutside)]) {
            [_delegate RecordButtonEndOutside];
        }
    }
}

@end
