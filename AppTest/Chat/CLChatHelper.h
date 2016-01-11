//
//  CLChatHelper.h
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLChatHelper : NSObject
//系统默认表情格式化
+ (NSAttributedString *) formatMessageString:(NSString *)text;

@end
