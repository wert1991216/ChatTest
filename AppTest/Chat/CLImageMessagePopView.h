//
//  CLImageMessagePopView.h
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLMessage.h"

@interface CLImageMessagePopView : UIView

@property (nonatomic, strong) CLMessage *message;
@property (nonatomic, strong) UIImageView *popImageView;

@end
