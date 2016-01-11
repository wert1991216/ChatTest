//
//  CLChatBoxFaceView.h
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLFace.h"

@protocol CLChatBoxFaceViewDelegate <NSObject>
- (void) chatBoxFaceViewDidSelectedFace:(CLFace *)face type:(CLFaceType)type;
- (void) chatBoxFaceViewDeleteButtonDown;
- (void) chatBoxFaceViewSendButtonDown;
@end

@interface CLChatBoxFaceView : UIView

@property (nonatomic, assign) id<CLChatBoxFaceViewDelegate>delegate;

@end
