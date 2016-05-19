//
//  FriendInfoViewController.m
//  VChat
//
//  Created by Recover on 16/5/14.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "FriendInfoViewController.h"
#import "FriendTableViewCell.h"
#import "FriendInfoTableViewCell.h"
#import "FriendVerifyViewController.h"
#import "ChatViewController.h"
#import <YYWebImage.h>
#import <RongIMKit/RCIM.h>
#import <RongIMLib/RCIMClient.h>
#import <AVStatus.h>

@interface FriendInfoViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *friendOperationButtton;

@property (weak, nonatomic) IBOutlet UIButton *refuseFriendRequestButton;

@end

@implementation FriendInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    if (self.isReciveFriendRequest) {
        [self.friendOperationButtton setTitle:@"通过验证" forState:UIControlStateNormal];
        [self.refuseFriendRequestButton setTitle:@"拒绝" forState:UIControlStateNormal];
        [self.refuseFriendRequestButton setHidden:NO];
    } else {
        if (self.model.isFriend) {
            [self.friendOperationButtton setTitle:@"发消息" forState:UIControlStateNormal];
        } else {
            [self.friendOperationButtton setTitle:@"添加到通讯录" forState:UIControlStateNormal];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 2 ? 2 : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 90 : 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            NSString *identifier = @"FriendInfoTableViewCell";
            FriendInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            [cell.avatarImageView yy_setImageWithURL:[NSURL URLWithString:self.model.avatarUrl] placeholder:nil];
            cell.remarkLabel.text = self.model.nickName;
            cell.vChatIDLabel.text = [NSString stringWithFormat:@"%@%@", @"微信号：", self.model.vChatId];
            cell.nickNameLabel.text = [NSString stringWithFormat:@"%@%@", @"昵称：", self.model.nickName];
            return cell;
        }
        case 1: {
            NSString *identifier = @"FriendTableViewCell";
            FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            cell.titleLabel.text = @"电话号码";
            cell.contentLabel.text = self.model.phoneNumber;
            return cell;
        }
        case 2: {
            NSString *identifier = @"FriendTableViewCell";
            FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            switch (indexPath.row) {
                case 0: {
                    cell.titleLabel.text = @"地区";
                    cell.contentLabel.text = self.model.area;
                    break;
                }
                case 1: {
                    cell.titleLabel.text = @"个性签名";
                    cell.contentLabel.text = self.model.signature;
                    break;
                }
                default:
                    break;
            }
            return cell;
        }
        default:
            return nil;
            break;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (IBAction)friendOperationButtonDidClicked:(id)sender {
    @weakify(self);
    if (self.isReciveFriendRequest) {
        [[AVUser currentUser] follow:self.model.objectId andCallback:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"添加好友成功");
                weak_self.model.isFriend = YES;
                weak_self.isReciveFriendRequest = NO;
                weak_self.refuseFriendRequestButton.hidden = YES;
                [weak_self.friendOperationButtton setTitle:@"发消息" forState:UIControlStateNormal];
                RCTextMessage *message = [RCTextMessage messageWithContent:@"我们已经是好友了，赶快开始聊天吧"];
                [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE
                                      targetId:weak_self.model.objectId
                                       content:message
                                   pushContent:@""
                                      pushData:@""
                                       success:^(long messageId) {
                                           NSLog(@"信息发送成功 @%ld", messageId);
                                           [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_SYSTEM
                                                                                    targetId:weak_self.model.objectId];
                                       } error:^(RCErrorCode nErrorCode, long messageId) {
                                           NSLog(@"信息发送失败 %ld，错误ID %ld", messageId, nErrorCode);
                                       }];
            } else {
                NSLog(@"添加好友失败 %@",error.description);
            }
        }];
    }else if (!self.model.isFriend) {
        [self performSegueWithIdentifier:@"toFriendVerifyView" sender:nil];
    } else {
        [self performSegueWithIdentifier:@"toChatView" sender:nil];
    }
}

- (IBAction)refuseFriendRequestButtonClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toFriendVerifyView"]) {
        FriendVerifyViewController *controller = [[FriendVerifyViewController alloc] init];
        controller = segue.destinationViewController;
        controller.model = self.model;
    } else if ([segue.identifier isEqualToString:@"toChatView"]) {
        ChatViewController *vc = segue.destinationViewController;
        vc.conversationType = ConversationType_PRIVATE;
        vc.targetId = self.model.objectId;
        vc.title = self.model.nickName;
    }
}

@end
