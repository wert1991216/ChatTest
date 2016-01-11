//
//  CLFace.h
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CLFaceType) {
    CLFaceTypeEmoji,//默认,3行7列
    CLFaceTypeCustom,//自定义，2行4列
};

@interface CLFace : NSObject

@property (nonatomic, strong) NSString *faceID;
@property (nonatomic, strong) NSString *faceName;

@end

@interface CLFaceGroup : NSObject

@property (nonatomic, assign) CLFaceType faceType;
@property (nonatomic, strong) NSString *groupID;
@property (nonatomic, strong) NSString *groupImageName;
@property (nonatomic, strong) NSArray *facesArray;

@end
