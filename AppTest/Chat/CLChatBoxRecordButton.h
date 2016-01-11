//
//  CLChatBoxRecordButton.h
//  AppTest
//
//  Created by clark on 16/1/4.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CLChatBoxRecordButtonDelegate <NSObject>

- (void)RecordButtonTouchBegain;
- (void)RecordButtonTouchInside;
- (void)RecordButtonTouchOutside;
- (void)RecordButtonEndInside;
- (void)RecordButtonEndOutside;

@end

@interface CLChatBoxRecordButton : UIView

@property (nonatomic, weak) id<CLChatBoxRecordButtonDelegate> delegate;

@end
