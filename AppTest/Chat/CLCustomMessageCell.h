//
//  CLCustomMessageCell.h
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import "CLMessageCell.h"

@class CLCustomMessageCell;
@protocol CLCustomMessageCellDelegate <NSObject>

- (void)didTapCustomMessageCell:(CLCustomMessageCell *)customMessageCell;

@end

@interface CLCustomMessageCell : CLMessageCell

@property (nonatomic, strong) __kindof UIView *cusView;
@property (nonatomic, weak) id<CLCustomMessageCellDelegate>delegate;

@end
