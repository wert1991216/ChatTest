//
//  CLChatViewController.h
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import "CLUser.h"
#import "CLChatMessageViewContrller.h"
#import "CLChatBoxViewController.h"

@interface CLChatBaseViewController : UIViewController

@property (nonatomic, strong) CLUser *currUser;//本人
@property (nonatomic, strong) CLUser *otherUser;
@property (nonatomic, strong) CLChatMessageViewContrller *chatMessageVC;
@property (nonatomic, strong) CLChatBoxViewController *chatBoxVC;

@end
