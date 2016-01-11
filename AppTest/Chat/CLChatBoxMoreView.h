//
//  CLChatBoxMoreView.h
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLChatBoxMoreItem.h"

typedef NS_ENUM(NSInteger, CLChatBoxItem) {
    CLChatBoxItemAlbum = 0,
    CLChatBoxItemCamera,
};


@class CLChatBoxMoreView;
@protocol CLChatBoxMoreViewDelegate <NSObject>
- (void)chatBoxMoreView:(CLChatBoxMoreView *)chatBoxMoreView didSelectItem:(CLChatBoxItem)itemType;
@end

@interface CLChatBoxMoreView : UIView

@property (nonatomic, strong) id<CLChatBoxMoreViewDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *items;

@end
