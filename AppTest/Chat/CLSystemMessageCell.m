//
//  CLSystemMessageCell.m
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import "CLSystemMessageCell.h"
#import "macros.h"

@implementation CLSystemMessageCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.sysTextLabel];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.sysTextLabel.frame = CGRectMake((WIDTH_SCREEN - self.message.messageSize.width - 10)/2.0, 13, self.message.messageSize.width + 10, self.message.messageSize.height + 4);
}

#pragma mark - Getter and Setter
- (void) setMessage:(CLMessage *)message
{
    [super setMessage:message];
    [_sysTextLabel setText:message.sysText];
}

- (UILabel *) sysTextLabel
{
    if (_sysTextLabel == nil) {
        _sysTextLabel = [[UILabel alloc] init];
        [_sysTextLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_sysTextLabel setNumberOfLines:0];
        _sysTextLabel.backgroundColor = WBColor(206, 206, 206, 1);
        _sysTextLabel.textColor = WBColor(244, 244, 244, 1);
        _sysTextLabel.layer.cornerRadius = 3;
        _sysTextLabel.layer.masksToBounds = YES;
        _sysTextLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _sysTextLabel;
}

@end
