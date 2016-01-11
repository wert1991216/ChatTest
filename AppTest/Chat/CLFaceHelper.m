//
//  CLFaceHelper.m
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import "CLFaceHelper.h"

static CLFaceHelper *faceHelper = nil;

@implementation CLFaceHelper

+ (CLFaceHelper *) sharedFaceHelper
{
    if (faceHelper == nil) {
        faceHelper = [[CLFaceHelper alloc] init];
    }
    return faceHelper;
}

#pragma mark - Public Methods
- (NSArray *) getFaceArrayByGroupID:(NSString *)groupID
{
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:groupID ofType:@"plist"]];
    NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *dic in array) {
        CLFace *face = [[CLFace alloc] init];
        face.faceID = [dic objectForKey:@"face_id"];
        face.faceName = [dic objectForKey:@"face_name"];
        [data addObject:face];
     }
  
    return data;
}

#pragma mark - Getter
- (NSMutableArray *) faceGroupArray
{
    if (_faceGroupArray == nil) {
        _faceGroupArray = [[NSMutableArray alloc] init];
        
        CLFaceGroup *group = [[CLFaceGroup alloc] init];
        group.faceType = CLFaceTypeEmoji;
        group.groupID = @"normal_face";
        group.groupImageName = @"EmotionsEmojiHL";
        group.facesArray = nil;
        [_faceGroupArray addObject:group];
    }
    return _faceGroupArray;
}

@end
