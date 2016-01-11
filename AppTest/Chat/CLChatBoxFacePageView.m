//
//  CLChatBoxFacePageView.m
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import "CLChatBoxFacePageView.h"
#import "UIView+CL.h"
#import "macros.h"

@interface CLChatBoxFacePageView ()

@property (nonatomic, strong) UIButton *delButton;
@property (nonatomic, strong) NSMutableArray *faceViewArray;
@property (nonatomic, assign) CLFaceType currFaceType;

@end

@implementation CLChatBoxFacePageView

- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.delButton];
    }
    return self;
}

#pragma mark - Public Methods
- (void) showFaceGroup:(CLFaceGroup *)group formIndex:(int)fromIndex count:(int)count
{
    if (self.currFaceType != group.faceType) {
        self.currFaceType = group.faceType;
        _faceViewArray = [[NSMutableArray alloc] init];
        for (UIView *view in self.subviews) {
            if (view != self.delButton) {
                [view removeFromSuperview];
            }
        }
    }
    int index = 0;
    float spaceX = 12;//距屏幕边缘间隔
    float spaceY = 10;//距父视图上下间隔
    int row = (group.faceType == CLFaceTypeEmoji ? 3 : 2);
    int col = (group.faceType == CLFaceTypeEmoji ? 7 : 4);
    float w = (WIDTH_SCREEN - spaceX * 2) / col;
    float h = (self.frameHeight - spaceY * 2) / row;
    float x = spaceX;
    float y = spaceY;
    for (int i = fromIndex; i < fromIndex + count; i ++) {
        UIButton *button;
        if (index < self.faceViewArray.count) {
            button = [self.faceViewArray objectAtIndex:index];
        }
        else {
            button = [[UIButton alloc] init];
            [button addTarget:_target action:_action forControlEvents:_controlEvents];
            [self addSubview:button];
            [self.faceViewArray addObject:button];
        }
        index ++;
        
        if (i >= group.facesArray.count || i < 0) {
            [button setHidden:YES];
        }
        else {
            CLFace *face = [group.facesArray objectAtIndex:i];
            button.tag = i;
            [button setImage:[UIImage imageNamed:face.faceName] forState:UIControlStateNormal];
            [button setFrame:CGRectMake(x, y, w, h)];
            [button setHidden:NO];
            
            x = spaceX + w*(index % col);
            y = spaceY + h*(index / col);
        }
        
    }
    [_delButton setHidden:fromIndex >= group.facesArray.count];
    [_delButton setFrame:CGRectMake(x, y, w, h)];
}

- (void) addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    _target = target;
    _action = action;
    _controlEvents = controlEvents;
    [self.delButton addTarget:_target action:_action forControlEvents:_controlEvents];
    for (UIButton *button in self.faceViewArray) {
        [button addTarget:target action:action forControlEvents:controlEvents];
    }
}

#pragma mark - Getter
- (NSMutableArray *) faceViewArray
{
    if (_faceViewArray == nil) {
        _faceViewArray = [[NSMutableArray alloc] init];
    }
    return _faceViewArray;
}

- (UIButton *) delButton
{
    if (_delButton == nil) {
        _delButton = [[UIButton alloc] init];
        _delButton.tag = -1;
        [_delButton setImage:[UIImage imageNamed:@"DeleteEmoticonBtn"] forState:UIControlStateNormal];
    }
    return _delButton;
}


@end
