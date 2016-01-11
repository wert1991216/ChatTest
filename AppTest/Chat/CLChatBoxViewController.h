//
//  CLChatBoxViewController.h
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLMessage.h"
#import "CLChatBoxMoreItem.h"

@class CLChatBoxViewController;

//由CLChatBaseViewController的子类实现
@protocol CLChatBoxViewControllerDelegate <NSObject>
- (void)chatBoxMoreViewItem:(CLChatBoxMoreItem *)moreItem index:(int)index;
@end

//由CLChatBaseViewController实现
@protocol CLChatBoxViewControllerInsideDelegate <NSObject>
- (void) chatBoxViewController:(CLChatBoxViewController *)chatboxViewController
        didChangeChatBoxHeight:(CGFloat)height;
- (void) chatBoxViewController:(CLChatBoxViewController *)chatboxViewController
                   sendMessage:(CLMessage *)message;
@end


@interface CLChatBoxViewController : UIViewController

@property id<CLChatBoxViewControllerDelegate>delegate;
@property id<CLChatBoxViewControllerInsideDelegate>insideDelegate;

- (void)addMoreItems:(NSArray<CLChatBoxMoreItem *> *)items;

@end
