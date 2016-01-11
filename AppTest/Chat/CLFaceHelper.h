//
//  CLFaceHelper.h
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLFace.h"

@interface CLFaceHelper : NSObject

@property (nonatomic, strong) NSMutableArray *faceGroupArray;

+ (CLFaceHelper *) sharedFaceHelper;

- (NSArray *) getFaceArrayByGroupID:(NSString *)groupID;

@end
