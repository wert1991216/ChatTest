//
//  ViewController.m
//  AppTest
//
//  Created by ccpp on 15/12/31.
//  Copyright © 2015年 ccpp. All rights reserved.
//

#import "ViewController.h"
#import "CLChatBaseViewController.h"
#import "TestChatViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *table;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息";
    
    table = [[UITableView alloc] initWithFrame:self.view.bounds];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.showsVerticalScrollIndicator = NO;
    table.showsHorizontalScrollIndicator = NO;
    table.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    table.dataSource = self;
    table.delegate = self;
    [self.view addSubview:table];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 43.5, self.view.frame.size.width, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:line];
    }
    cell.textLabel.text = @"小七";
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    TestChatViewController *chatVC = [[TestChatViewController alloc] init];
    CLUser *user7 = [[CLUser alloc] init];
    user7.username = @"小七";
    user7.userID = @"XQ";
    user7.nikename = @"小七";
    user7.avatarURL = @"10.jpeg";
    chatVC.otherUser = user7;
    
    CLUser *currUser = [[CLUser alloc] init];
    currUser.username = @"我";
    currUser.userID = @"wo";
    currUser.nikename = @"小九";
    currUser.avatarURL = @"10.jpeg";
    chatVC.currUser = currUser;
    [self.navigationController pushViewController:chatVC animated:YES];
}

@end
