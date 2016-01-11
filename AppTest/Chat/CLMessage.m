//
//  CLMessage.m
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import "CLMessage.h"
#import "CLChatHelper.h"
#import "macros.h"

static UILabel *label = nil;

@implementation CLMessage

- (id) init
{
    if (self = [super init]) {
        if (label == nil) {
            label = [[UILabel alloc] init];
            [label setNumberOfLines:0];
            [label setFont:[UIFont systemFontOfSize:16.0f]];
        }
    }
    return self;
}

#pragma mark - Setter
- (void) setText:(NSString *)text
{
    _text = text;
    if (text.length > 0) {
        _attrText = [CLChatHelper formatMessageString:text];
    }
}

- (void)setDate:(NSDate *)date {
    _date = date;
    _sysText = [self getTimeByDate:date FormatStr:@"yyyy年MM月dd日 HH:mm"];
}

- (NSString *)getTimeByDate:(NSDate *)date FormatStr:(NSString *)formatStr
{
    if (!date)
        return nil;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:formatStr];
    
    static NSTimeZone *timeZone=nil;
    if (!timeZone)
        timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:date];
}

#pragma mark - Getter
- (void) setMessageType:(CLMessageType)messageType
{
    _messageType = messageType;
    switch (messageType) {
        case CLMessageTypeText:
            self.cellIndentify = @"TextMessageCell";
            break;
        case CLMessageTypeImage:
            self.cellIndentify = @"ImageMessageCell";
            break;
        case CLMessageTypeVoice:
            self.cellIndentify = @"VoiceMessageCell";
            break;
        case CLMessageTypeSystem:
            self.cellIndentify = @"SystemMessageCell";
            break;
        case CLMessageTypeCustom:
            self.cellIndentify = @"CustomMessageCell";
            break;
        default:
            break;
    }
}

- (CGSize) messageSize
{
    switch (self.messageType) {
        case CLMessageTypeText:
        {
            [label setAttributedText:self.attrText];
            _messageSize = [label sizeThatFits:CGSizeMake(WIDTH_SCREEN * 0.58, MAXFLOAT)];
        }
            break;
        case CLMessageTypeImage:
        {
            NSString *path = [NSString stringWithFormat:@"%@/%@", PATH_CHATREC_IMAGE, self.imagePath];
            _image = [UIImage imageNamed:path];
            if (_image != nil) {
                _messageSize = (_image.size.width > WIDTH_SCREEN * 0.5 ? CGSizeMake(WIDTH_SCREEN * 0.5, WIDTH_SCREEN * 0.5 / _image.size.width * _image.size.height) : _image.size);
                _messageSize = (_messageSize.height > 40 ? _messageSize : CGSizeMake(_messageSize.width, 40));
            }
            else {
                if (_imageURL) {
                    if (_webImageSize.width != 0 && _webImageSize.height != 0) {
                        _messageSize = _webImageSize;
                    } else {
                        _messageSize = CGSizeMake(WIDTH_SCREEN * 0.5, WIDTH_SCREEN * 0.5);
                    }
                    
                } else {
                    _messageSize = CGSizeMake(0, 0);
                }
            }
        }
            break;
        case CLMessageTypeVoice:
        {
            if (_voiceSeconds > 20) {
                _messageSize = CGSizeMake(WIDTH_SCREEN * 0.5, 40);
            } else if (_voiceSeconds > 1) {
                _messageSize = CGSizeMake(40 + (WIDTH_SCREEN * 0.5 - 40)*(_voiceSeconds - 1)/19.0, 40);
            } else {
                _messageSize = CGSizeMake(40, 40);
            }
        }
            break;
        case CLMessageTypeSystem:
        {
            [label setText:self.sysText];
            [label setFont:[UIFont systemFontOfSize:12.0f]];
            _messageSize = [label sizeThatFits:CGSizeMake(WIDTH_SCREEN - 100, MAXFLOAT)];
            [label setFont:[UIFont systemFontOfSize:16.0f]];
        }
            break;
        case CLMessageTypeCustom:
        {
            
        }
            break;
        default:
            break;
    }
    return _messageSize;
}

- (CGFloat) cellHeight
{
    switch (self.messageType) {     // cell 上下间隔为10
        case CLMessageTypeText:
            return self.messageSize.height + 40 > 60 ? self.messageSize.height + 40 : 60;
            break;
        case CLMessageTypeImage:
            return self.messageSize.height + 20;
            break;
        case CLMessageTypeVoice:
            return self.messageSize.height + 20;
            break;
        case CLMessageTypeSystem:
            return self.messageSize.height + 20;
            break;
        case CLMessageTypeCustom:
            
            break;
        default:
            break;
    }
    return 0;
}

@end
