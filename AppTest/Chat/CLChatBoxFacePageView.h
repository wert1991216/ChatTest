//
//  CLChatBoxFacePageView.h
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLFace.h"

@interface CLChatBoxFacePageView : UIView

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) UIControlEvents controlEvents;

- (void) showFaceGroup:(CLFaceGroup *)group formIndex:(int)fromIndex count:(int)count;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
@end
