//
//  CLUser.h
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLUser : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *userID;//不能为空且不能相同，通过userID查询及保存数据
@property (nonatomic, strong) NSString *nikename;
@property (nonatomic, strong) NSString *avatarURL;
@property (nonatomic, strong) NSString *motto;
@property (nonatomic, strong) NSString *phoneNumber;

@property (nonatomic, strong) NSString *pinyin;
@property (nonatomic, strong) NSString *initial;


@end
