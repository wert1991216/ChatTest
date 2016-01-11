//
//  CLUser.m
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import "CLUser.h"
#import "NSString+CL.h"

@implementation CLUser

- (void) setUsername:(NSString *)username
{
    _username = username;
    _pinyin = username.pinyin;
    _initial = username.pinyinInitial;
}

@end
