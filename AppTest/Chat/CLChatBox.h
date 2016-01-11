//
//  CLChatBox.h
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLFace.h"

typedef NS_ENUM(NSInteger, CLChatBoxStatus) {
    CLChatBoxStatusNothing,
    CLChatBoxStatusShowVoice,
    CLChatBoxStatusShowFace,
    CLChatBoxStatusShowMore,
    CLChatBoxStatusShowKeyboard,
};

@class CLChatBox;
@protocol CLChatBoxDelegate <NSObject>
- (void)chatBox:(CLChatBox *)chatBox changeStatusForm:(CLChatBoxStatus)fromStatus to:(CLChatBoxStatus)toStatus;
- (void)chatBox:(CLChatBox *)chatBox sendTextMessage:(NSString *)textMessage;
- (void)chatBox:(CLChatBox *)chatBox changeChatBoxHeight:(CGFloat)height;
@end

@interface CLChatBox : UIView

@property (nonatomic, assign) id<CLChatBoxDelegate>delegate;
@property (nonatomic, assign) CLChatBoxStatus status;

@property (nonatomic, assign) CGFloat curHeight;

- (void) addEmojiFace:(CLFace *)face;
- (void) sendCurrentMessage;
- (void) deleteButtonDown;

@end
