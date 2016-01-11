//
//  CLChatBoxMoreItem.h
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLChatBoxMoreItem : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageName;

+ (CLChatBoxMoreItem *) createChatBoxMoreItemWithTitle:(NSString *)title
                                             imageName:(NSString *)imageName;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
@end
