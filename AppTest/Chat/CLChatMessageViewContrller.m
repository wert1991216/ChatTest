//
//  CLChatMessageViewContrller.m
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import "CLChatMessageViewContrller.h"

#import "CLTextMessageCell.h"
#import "CLImageMessageCell.h"
#import "CLVoiceMessageCell.h"
#import "CLSystemMessageCell.h"
#import "CLCustomMessageCell.h"
#import "macros.h"
#import "CLChatCoreDataManager.h"
#import "BlazeicePublicMethod.h"

@interface CLChatMessageViewContrller ()<CLCustomMessageCellDelegate, CLMessageCellDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *tapGR;

@end

@implementation CLChatMessageViewContrller

#pragma mark - LifeCycle
- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:DEFAULT_CHAT_BACKGROUND_COLOR];
    [self.view addGestureRecognizer:self.tapGR];
    [self.tableView setTableFooterView:[UIView new]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.tableView registerClass:[CLTextMessageCell class] forCellReuseIdentifier:@"TextMessageCell"];
    [self.tableView registerClass:[CLImageMessageCell class] forCellReuseIdentifier:@"ImageMessageCell"];
    [self.tableView registerClass:[CLVoiceMessageCell class] forCellReuseIdentifier:@"VoiceMessageCell"];
    [self.tableView registerClass:[CLSystemMessageCell class] forCellReuseIdentifier:@"SystemMessageCell"];
    [self.tableView registerClass:[CLCustomMessageCell class] forCellReuseIdentifier:@"CustomMessageCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatRecordFinish:) name:CHAT_RECORDFINISH object:nil];
    
}

- (void)chatRecordFinish:(NSNotification *)sender {
    NSDictionary *dic = sender.userInfo;
    NSString *temPath = [dic objectForKey:CHAT_RECORDFINISH];
    if (temPath.length > 0) {
        CLMessage *msg = [[CLMessage alloc] init];
        msg.msgIdentifier = self.otherUser.userID;
        msg.messageType = CLMessageTypeVoice;
        msg.ownerTyper = CLMessageOwnerTypeSelf;
        msg.voicePath = [BlazeicePublicMethod getPathByFileName:temPath ofType:@"wav"];
        msg.voiceUrl = [BlazeicePublicMethod getPathByFileName:[temPath stringByAppendingString:@"wavToAmr"] ofType:@"amr"];
        int length=[BlazeicePublicMethod getVedioLength:temPath];
        msg.voiceSeconds = length;
        msg.from = self.currentUser;
        [self addNewMessage:msg];
        
    }
    
    
}

- (void) initTable {
    NSMutableArray *temData = [[CLChatCoreDataManager shareCoreDataManager] fetchDataByUserId:self.otherUser.userID];
    if (temData && temData.count > 0) {
        _data = [NSMutableArray arrayWithArray:temData];
    }
    [self.tableView reloadData];
}

#pragma mark - Public Methods
- (void) addNewMessage:(CLMessage *)message
{
    message.msgIdentifier = self.otherUser.userID;
    message.date = [NSDate date];
    if (self.data.count > 0) {
        CLMessage *lastMessage = self.data[self.data.count - 1];
        NSTimeInterval seconds = [[NSDate date] timeIntervalSinceDate:lastMessage.date];
        NSLog(@"seconds:%f", seconds);
        if (fabs(seconds) >= 5) {
            CLMessage *sysMessage = [[CLMessage alloc] init];
            sysMessage.msgIdentifier = self.otherUser.userID;
            sysMessage.messageType = CLMessageTypeSystem;
            sysMessage.ownerTyper = CLMessageOwnerTypeSystem;
            sysMessage.date = [NSDate date];
            sysMessage.from = message.from;
            [self.data addObject:sysMessage];
            [[CLChatCoreDataManager shareCoreDataManager] insertCoreData:sysMessage];
        }
    }else {
        CLMessage *sysMessage = [[CLMessage alloc] init];
        sysMessage.msgIdentifier = self.otherUser.userID;
        sysMessage.messageType = CLMessageTypeSystem;
        sysMessage.ownerTyper = CLMessageOwnerTypeSystem;
        sysMessage.date = [NSDate date];
        sysMessage.from = message.from;
        [self.data addObject:sysMessage];
        [[CLChatCoreDataManager shareCoreDataManager] insertCoreData:sysMessage];
    }
    [self.data addObject:message];
    [self.tableView reloadData];
    [self scrollToBottom];
    [[CLChatCoreDataManager shareCoreDataManager] insertCoreData:message];
    if (message.ownerTyper == CLMessageOwnerTypeSelf) {
        if (_delegate && [_delegate respondsToSelector:@selector(CLChatMessageSend:index:)]) {
            [_delegate CLChatMessageSend:message index:self.data.count - 1];
        }
    }
}

- (void) updateMessate:(CLMessage *)messate index:(NSUInteger)index {
    [self.data replaceObjectAtIndex:index withObject:messate];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [[CLChatCoreDataManager shareCoreDataManager] updateDataByUserId:self.otherUser.userID index:index message:messate];
}

- (void) clearAllMessate {
    [self.data removeAllObjects];
    [self.tableView reloadData];
    [[CLChatCoreDataManager shareCoreDataManager] deleteDataByUserId:self.otherUser.userID];
}

- (void) scrollToBottom
{
    if (_data.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_data.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - CLMessageCellDelegate <NSObject>
- (void)CLMessageCellTapFailView:(CLMessageCell *)messageCell {
    if (_delegate && [_delegate respondsToSelector:@selector(CLChatMessageTapFailView:index:)]) {
        [_delegate CLChatMessageTapFailView:messageCell.message index:messageCell.tag];
    }
}

#pragma mark - CLCustomMessageCellDelegate <NSObject>
- (void)didTapCustomMessageCell:(CLCustomMessageCell *)customMessageCell {
    if (_delegate && [_delegate respondsToSelector:@selector(CLChatCustomCellViewDidSelect:message:)]) {
        [_delegate CLChatCustomCellViewDidSelect:[NSIndexPath indexPathForRow:customMessageCell.tag inSection:0] message:customMessageCell.message];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLMessage *message = [_data objectAtIndex:indexPath.row];
    id cell = [tableView dequeueReusableCellWithIdentifier:message.cellIndentify];
    if ([cell isKindOfClass:[CLCustomMessageCell class]]) {
        CLCustomMessageCell *temCell = (CLCustomMessageCell *)cell;
        if (_delegate && [_delegate respondsToSelector:@selector(CLChatCustomCellView:message:)]) {
            temCell.cusView = [_delegate CLChatCustomCellView:indexPath message:message];
        }
        temCell.delegate = self;
    }
    [cell setTag:indexPath.row];
    [cell setComDelegate:self];
    [cell setMessage:message];
    return cell;
}

#pragma mark - UITableViewCellDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLMessage *message = [_data objectAtIndex:indexPath.row];
    if (message.messageType == CLMessageTypeCustom) {
        if (_delegate && [_delegate respondsToSelector:@selector(CLChatCustomCellViewHeight:message:)]) {
            float cusHeight = [_delegate CLChatCustomCellViewHeight:indexPath message:message];
            return cusHeight + 15;
        } else {
            return 0;
        }
    }
    return message.cellHeight;
}

#pragma mark - UIScrollViewDelegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

#pragma mark - Event Response
- (void) didTapView
{
    if (_insideDelegate && [_insideDelegate respondsToSelector:@selector(didTapChatMessageView:)]) {
        [_insideDelegate didTapChatMessageView:self];
    }
}

#pragma mark - Getter
- (UITapGestureRecognizer *) tapGR
{
    if (_tapGR == nil) {
        _tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView)];
    }
    return _tapGR;
}

- (NSMutableArray *) data
{
    if (_data == nil) {
        _data = [[NSMutableArray alloc] init];
    }
    return _data;
}

@end
