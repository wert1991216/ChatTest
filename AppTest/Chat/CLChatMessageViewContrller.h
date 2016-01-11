//
//  CLChatMessageViewContrller.h
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLMessage.h"
#import "CLUser.h"

@class CLChatMessageViewContrller;
//由CLChatBaseViewController的子类实现
//自定义单元格的视图及点击代理
@protocol CLChatMessageViewControllerDelegate <NSObject>

// 自定义视图,最大宽度WIDTH_SCREEN * 0.65
- (__kindof UIView *)CLChatCustomCellView:(NSIndexPath *)indexPath message:(CLMessage *)msg;
- (float)CLChatCustomCellViewHeight:(NSIndexPath *)indexPath message:(CLMessage *)msg;
- (void)CLChatCustomCellViewDidSelect:(NSIndexPath *)indexPath message:(CLMessage *)msg;
//发送消息，仅对当前用户而言
- (void)CLChatMessageSend:(CLMessage *)message index:(NSUInteger)index;
//发送失败，点击失败图片
- (void)CLChatMessageTapFailView:(CLMessage *)message index:(NSUInteger)index;

@end
//由CLChatBaseViewController实现
@protocol CLChatMessageViewControllerInsideDelegate <NSObject>

- (void) didTapChatMessageView:(CLChatMessageViewContrller *)chatMessageViewController;

@end

@interface CLChatMessageViewContrller : UITableViewController

@property (nonatomic, assign) id<CLChatMessageViewControllerDelegate>delegate;
@property (nonatomic, assign) id<CLChatMessageViewControllerInsideDelegate>insideDelegate;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) CLUser *otherUser;
@property (nonatomic, strong) CLUser *currentUser;

- (void) addNewMessage:(CLMessage *)message;
- (void) updateMessate:(CLMessage *)messate index:(NSUInteger)index;
- (void) clearAllMessate;
- (void) scrollToBottom;
- (void) initTable;

@end
