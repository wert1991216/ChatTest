//
//  TestChatViewController.m
//  AppTest
//
//  Created by clark on 16/1/4.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import "TestChatViewController.h"

@interface TestChatViewController ()<CLChatMessageViewControllerDelegate, CLChatBoxViewControllerDelegate>

@end

@implementation TestChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.chatMessageVC.delegate = self;
    self.chatBoxVC.delegate = self;
    CLChatBoxMoreItem *businessCardItem = [CLChatBoxMoreItem createChatBoxMoreItemWithTitle:@"名片"
                                                                                  imageName:@"sharemore_friendcard" ];
    CLChatBoxMoreItem *favItem = [CLChatBoxMoreItem createChatBoxMoreItemWithTitle:@"收藏"
                                                                           imageName:@"sharemore_myfav"];
    CLChatBoxMoreItem *walletItem = [CLChatBoxMoreItem createChatBoxMoreItemWithTitle:@"钱包"
                                                                               imageName:@"sharemore_wallet"];
    [self.chatBoxVC addMoreItems:@[businessCardItem, favItem, walletItem]];
}

#pragma mark CLChatMessageViewControllerDelegate <NSObject>
- (__kindof UIView *)CLChatCustomCellView:(NSIndexPath *)indexPath message:(CLMessage *)msg {
    UIView *cusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
    UIView *bview = [[UIView alloc] initWithFrame:CGRectMake(90, 20, 7, 20)];
    bview.backgroundColor = [UIColor blackColor];
    [cusView addSubview:bview];
    
    UIView *aview = [[UIView alloc] initWithFrame:CGRectMake(60, 180, 7, 10)];
    aview.backgroundColor = [UIColor blackColor];
    [cusView addSubview:aview];
    if (indexPath.row < 5) {
        cusView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
    } else {
        cusView.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.5];
    }
    return cusView;
}

- (float)CLChatCustomCellViewHeight:(NSIndexPath *)indexPath message:(CLMessage *)msg {
    return 200;
}

- (void)CLChatCustomCellViewDidSelect:(NSIndexPath *)indexPath message:(CLMessage *)msg {
    
}

- (void)CLChatMessageSend:(CLMessage *)message index:(NSUInteger)index {
    if (message.ownerTyper == CLMessageOwnerTypeSelf) {
        //此处将消息发送到网络，如果发送失败则调用CLChatMessageViewContrller的updateMessate方法更新消息状态
//        message.sendState = CLMessageSendFail;
//        [self.chatMessageVC updateMessate:message index:index];
    }
}

- (void)CLChatMessageTapFailView:(CLMessage *)message index:(NSUInteger)index {
    NSLog(@"点击失败图片：%ld", index);
}

#pragma mark CLChatBoxViewControllerDelegate <NSObject>
- (void)chatBoxMoreViewItem:(CLChatBoxMoreItem *)moreItem index:(int)index {
    if (index > 1) {
        NSLog(@"选择：%d, %@", index, moreItem.title);
    }
}

@end
