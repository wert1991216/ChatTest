//
//  CLChatBoxFaceView.m
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import "CLChatBoxFaceView.h"
#import "CLChatBoxFaceMenuView.h"
#import "CLChatBoxFacePageView.h"
#import "CLFaceHelper.h"
#import "UIView+CL.h"
#import "macros.h"

#define     HEIGHT_BOTTOM_VIEW          36.0f

@interface CLChatBoxFaceView () <CLChatBoxFaceMenuViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) CLFaceGroup *curGroup;
@property (nonatomic, assign) int curPage;

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) CLChatBoxFaceMenuView *faceMenuView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *facePageViewArray;

@end

@implementation CLChatBoxFaceView

- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:DEFAULT_CHATBOX_COLOR];
        [self addSubview:self.topLine];
        [self addSubview:self.faceMenuView];
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
    }
    return self;
}

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.scrollView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - HEIGHT_BOTTOM_VIEW - 18)];
    [self.pageControl setFrame:CGRectMake(0, self.scrollView.frameHeight + 3, frame.size.width, 8)];
    for (CLChatBoxFacePageView *pageView in self.facePageViewArray) {
        [self.scrollView addSubview:pageView];
    }
}

#pragma mark - CLChatBoxFaceMenuViewDelegate
- (void) chatBoxFaceMenuView:(CLChatBoxFaceMenuView *)chatBoxFaceMenuView didSelectedFaceMenuIndex:(NSInteger)index
{
    _curGroup = [[[CLFaceHelper sharedFaceHelper] faceGroupArray] objectAtIndex:index];
    if (_curGroup.facesArray == nil) {
        _curGroup.facesArray = [[CLFaceHelper sharedFaceHelper] getFaceArrayByGroupID:_curGroup.groupID];
    }
    [self reloadScrollView];
}

- (void) chatBoxFaceMenuViewSendButtonDown
{
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxFaceViewDeleteButtonDown)]) {
        [_delegate chatBoxFaceViewSendButtonDown];
    }
}

- (void) chatBoxFaceMenuViewAddButtonDown
{
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxFaceViewSendButtonDown)]) {
        [_delegate chatBoxFaceViewSendButtonDown];
    }
}

#pragma mark - UIScrollViewDelegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / self.frameWidth;
    if (page > _curPage && (page * WIDTH_SCREEN - scrollView.contentOffset.x) < WIDTH_SCREEN * 0.2) {       // 向右翻
        [self showFaceFageAtIndex:page];
    }
    else if (page < _curPage && (scrollView.contentOffset.x - page * WIDTH_SCREEN) < WIDTH_SCREEN * 0.2) {
        [self showFaceFageAtIndex:page];
    }
}

#pragma mark - Event Response
- (void) didSelectedFace:(UIButton *)sender
{
    if (sender.tag == -1) {
        if (_delegate && [_delegate respondsToSelector:@selector(chatBoxFaceViewDeleteButtonDown)]) {
            [_delegate chatBoxFaceViewDeleteButtonDown];
        }
    }
    else {
        CLFace *face = [_curGroup.facesArray objectAtIndex:sender.tag];
        if (_delegate && [_delegate respondsToSelector:@selector(chatBoxFaceViewDidSelectedFace:type:)]) {
            [_delegate chatBoxFaceViewDidSelectedFace:face type:_curGroup.faceType];
        }
    }
}

- (void) pageControlClicked:(UIPageControl *)pageControl
{
    [self showFaceFageAtIndex:pageControl.currentPage];
    [self.scrollView scrollRectToVisible:CGRectMake(pageControl.currentPage * WIDTH_SCREEN, 0, WIDTH_SCREEN, self.scrollView.frameHeight) animated:YES];
}

#pragma mark - Private Methods
- (void) reloadScrollView
{
    int page = ceil(self.curGroup.facesArray.count / (self.curGroup.faceType == CLFaceTypeEmoji ? 20.0 : 7.0));
    [self.pageControl setNumberOfPages:page];
    [self.scrollView setContentSize:CGSizeMake(WIDTH_SCREEN * page, self.scrollView.frameHeight)];
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, WIDTH_SCREEN, self.scrollView.frameHeight) animated:NO];
    _curPage = -1;
    [self showFaceFageAtIndex:0];
}

- (void) showFaceFageAtIndex:(NSUInteger)index
{
    if (index == _curPage) {
        return;
    }
    [self.pageControl setCurrentPage:index];
    int count = _curGroup.faceType == CLFaceTypeEmoji ? 20 : 7;
    if (_curPage == -1) {
        CLChatBoxFacePageView *pageView1 = [self.facePageViewArray objectAtIndex:0];
        [pageView1 showFaceGroup:_curGroup formIndex:0 count:0];
        [pageView1 setOrigin:CGPointMake(-WIDTH_SCREEN, 0)];
        [pageView1 addTarget:self action:@selector(didSelectedFace:) forControlEvents:UIControlEventTouchUpInside];
        CLChatBoxFacePageView *pageView2 = [self.facePageViewArray objectAtIndex:1];
        [pageView2 showFaceGroup:_curGroup formIndex:0 count:count];
        [pageView2 setOrigin:CGPointMake(0, 0)];
        [pageView2 addTarget:self action:@selector(didSelectedFace:) forControlEvents:UIControlEventTouchUpInside];
        CLChatBoxFacePageView *pageView3 = [self.facePageViewArray objectAtIndex:2];
        [pageView3 showFaceGroup:_curGroup formIndex:count count:count];
        [pageView3 addTarget:self action:@selector(didSelectedFace:) forControlEvents:UIControlEventTouchUpInside];
        [pageView3 setOrigin:CGPointMake(WIDTH_SCREEN, 0)];
    }
    else {
        if (_curPage < index) {
            CLChatBoxFacePageView *pageView1 = [self.facePageViewArray objectAtIndex:0];
            [pageView1 showFaceGroup:_curGroup formIndex:(int)(index + 1) * count count:count];
            [pageView1 setOrigin:CGPointMake((index + 1) * WIDTH_SCREEN, 0)];
            [self.facePageViewArray removeObjectAtIndex:0];
            [self.facePageViewArray addObject:pageView1];
        }
        else {
            CLChatBoxFacePageView *pageView3 = [self.facePageViewArray objectAtIndex:2];
            [pageView3 showFaceGroup:_curGroup formIndex:(int)(index - 1) * count count:count];
            [pageView3 setOrigin:CGPointMake((index - 1) * WIDTH_SCREEN, 0)];
            [self.facePageViewArray removeObjectAtIndex:2];
            [self.facePageViewArray insertObject:pageView3 atIndex:0];
        }
    }
    _curPage = (int)index;
}

#pragma mark - Getter
- (UIView *) topLine
{
    if (_topLine == nil) {
        _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 0.5)];
        [_topLine setBackgroundColor:DEFAULT_LINE_GRAY_COLOR];
    }
    return _topLine;
}

- (CLChatBoxFaceMenuView *) faceMenuView
{
    if (_faceMenuView == nil) {
        _faceMenuView = [[CLChatBoxFaceMenuView alloc] initWithFrame:CGRectMake(0, self.frameHeight - HEIGHT_BOTTOM_VIEW, WIDTH_SCREEN, HEIGHT_BOTTOM_VIEW)];
        [_faceMenuView setDelegate:self];
//        CLFaceGroup *temGroup = [[CLFaceGroup alloc] init];
//        temGroup.faceType = CLFaceTypeCustom;
//        temGroup.groupID = @"custom_face";
//        temGroup.groupImageName = @"EmotionsEmojiHL";
//        temGroup.facesArray = nil;
//        [[CLFaceHelper sharedFaceHelper].faceGroupArray addObject:temGroup];
        [_faceMenuView setFaceGroupArray:[[CLFaceHelper sharedFaceHelper] faceGroupArray]];
    }
    return _faceMenuView;
}

- (UIPageControl *) pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
        _pageControl.pageIndicatorTintColor = DEFAULT_LINE_GRAY_COLOR;
        [_pageControl addTarget:self action:@selector(pageControlClicked:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

- (UIScrollView *) scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setScrollsToTop:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setDelegate:self];
        [_scrollView setPagingEnabled:YES];
    }
    return _scrollView;
}

- (NSMutableArray *) facePageViewArray
{
    if (_facePageViewArray == nil) {
        _facePageViewArray = [[NSMutableArray alloc] initWithCapacity:3];
        for (int i = 0; i < 3; i ++) {
            CLChatBoxFacePageView *view = [[CLChatBoxFacePageView alloc] initWithFrame:self.scrollView.bounds];
            [_facePageViewArray addObject:view];
        }
    }
    return _facePageViewArray;
}

@end
