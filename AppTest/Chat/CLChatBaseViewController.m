//
//  CLChatViewController.m
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import "CLChatBaseViewController.h"
#import "UIView+CL.h"
#import "macros.h"

@interface CLChatBaseViewController () <CLChatMessageViewControllerInsideDelegate, CLChatBoxViewControllerInsideDelegate>
{
    CGFloat viewHeight;
}

@end

@implementation CLChatBaseViewController

#pragma mark - LifeCycle
- (void) viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:DEFAULT_BACKGROUND_COLOR];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self setHidesBottomBarWhenPushed:YES];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    viewHeight = HEIGHT_SCREEN - HEIGHT_NAVBAR - HEIGHT_STATUSBAR;
    
    self.chatMessageVC.otherUser = self.otherUser;
    self.chatMessageVC.currentUser = self.currUser;
    [self.chatMessageVC initTable];
    
    [self.view addSubview:self.chatMessageVC.view];
    [self addChildViewController:self.chatMessageVC];
    [self.view addSubview:self.chatBoxVC.view];
    [self addChildViewController:self.chatBoxVC];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - CLChatMessageViewControllerInsideDelegate
- (void) didTapChatMessageView:(CLChatMessageViewContrller *)chatMessageViewController
{
    [self.chatBoxVC resignFirstResponder];
}

#pragma mark - CLChatBoxViewControllerInsideDelegate
- (void) chatBoxViewController:(CLChatBoxViewController *)chatboxViewController sendMessage:(CLMessage *)message
{
    message.from = self.currUser;
    [self.chatMessageVC addNewMessage:message];
    
    [self.chatMessageVC scrollToBottom];
    
//    CLMessage *recMessage = [[CLMessage alloc] init];
//    recMessage.messageType = CLMessageTypeVoice;
//    recMessage.ownerTyper = CLMessageOwnerTypeSelf;
//    recMessage.date = [NSDate date];
//    recMessage.text = message.text;
//    recMessage.sysText = @"2016年12月12日 18:18";
//    recMessage.voiceSeconds = 1;
////    recMessage.imagePath = message.imagePath;
////    recMessage.imageURL = @"http://pic2.ooopic.com/01/03/51/25b1OOOPIC19.jpg";
//    recMessage.from = message.from;
//    [self.chatMessageVC addNewMessage:recMessage];
    
//    CLMessage *temMessate = [[CLMessage alloc] init];
//    temMessate.messageType = CLMessageTypeCustom;
//    temMessate.ownerTyper = CLMessageOwnerTypeOther;
//    temMessate.date = [NSDate date];
//    temMessate.text = message.text;
//    UIView *temView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, WIDTH_SCREEN)];
//    temView.backgroundColor = [UIColor yellowColor];
//    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 50, 50)];
//    redView.backgroundColor = [UIColor redColor];
//    [temView addSubview:redView];
//    temMessate.customView = temView;
//    temMessate.sysText = @"2016年12月12日 18:18";
//    temMessate.voiceSeconds = 1;
    //    recMessage.imagePath = message.imagePath;
    //    recMessage.imageURL = @"http://pic2.ooopic.com/01/03/51/25b1OOOPIC19.jpg";
//    temMessate.from = message.from;
//    [self.chatMessageVC addNewMessage:temMessate];
    
    
}

- (void) chatBoxViewController:(CLChatBoxViewController *)chatboxViewController didChangeChatBoxHeight:(CGFloat)height
{
    self.chatMessageVC.view.frameHeight = viewHeight - height;
    self.chatBoxVC.view.originY = self.chatMessageVC.view.originY + self.chatMessageVC.view.frameHeight;
    [self.chatMessageVC scrollToBottom];
}

#pragma mark - Getter and Setter
- (void) setOtherUser:(CLUser *)otherUser
{
    _otherUser = otherUser;
    [self.navigationItem setTitle:otherUser.username];
}

- (CLChatMessageViewContrller *) chatMessageVC
{
    if (_chatMessageVC == nil) {
        _chatMessageVC = [[CLChatMessageViewContrller alloc] init];
        [_chatMessageVC.view setFrame:CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_NAVBAR, WIDTH_SCREEN, viewHeight - HEIGHT_TABBAR)];
        [_chatMessageVC setInsideDelegate:self];
    }
    return _chatMessageVC;
}

- (CLChatBoxViewController *) chatBoxVC
{
    if (_chatBoxVC == nil) {
        _chatBoxVC = [[CLChatBoxViewController alloc] init];
        [_chatBoxVC.view setFrame:CGRectMake(0, HEIGHT_SCREEN - HEIGHT_TABBAR, WIDTH_SCREEN, HEIGHT_SCREEN)];
        [_chatBoxVC setInsideDelegate:self];
    }
    return _chatBoxVC;
}

@end
