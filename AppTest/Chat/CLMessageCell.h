//
//  CLMessageCell.h
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLMessage.h"

@class CLMessageCell;
@protocol CLMessageCellDelegate <NSObject>

- (void)CLMessageCellTapFailView:(CLMessageCell *)messageCell;

@end

@interface CLMessageCell : UITableViewCell

@property (nonatomic, strong) CLMessage *message;

@property (nonatomic, weak) id<CLMessageCellDelegate>comDelegate;
@property (nonatomic, strong) UIImageView *avatarImageView;                 // 头像
@property (nonatomic, strong) UIImageView *messageBackgroundImageView;      // 消息背景
@property (nonatomic, strong) UIImageView *messageSendStatusImageView;      // 消息发送状态



@end
