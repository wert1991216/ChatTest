//
//  CLChatBoxFaceMenuView.h
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLFace.h"

@class CLChatBoxFaceMenuView;
@protocol CLChatBoxFaceMenuViewDelegate <NSObject>

- (void) chatBoxFaceMenuViewAddButtonDown;
- (void) chatBoxFaceMenuViewSendButtonDown;
- (void) chatBoxFaceMenuView:(CLChatBoxFaceMenuView *)chatBoxFaceMenuView didSelectedFaceMenuIndex:(NSInteger)index;

@end

@interface CLChatBoxFaceMenuView : UIView

@property (nonatomic, assign) id<CLChatBoxFaceMenuViewDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *faceGroupArray;

@end
