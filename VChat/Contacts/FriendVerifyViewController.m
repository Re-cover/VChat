//
//  FriendVerifyViewController.m
//  VChat
//
//  Created by Recover on 16/5/16.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "FriendVerifyViewController.h"
#import "FriendVerifyMessageTableViewCell.h"
#import "FriendInfoModel.h"
#import <AVUser.h>
#import "UserService.h"
#import <SVProgressHUD.h>

@interface FriendVerifyViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSString *verifyMessage;
@property (copy, nonatomic) NSString *currentNickName;

@end

@implementation FriendVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillDisappear:(BOOL)animated {
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
}

- (IBAction)verifyMeassgeChanged:(id)sender {
    UITextField *textFiled = (UITextField *)sender;
    self.verifyMessage = textFiled.text;
}

- (IBAction)CancelButtonDidClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:self];
}

- (IBAction)sendButtonDidClicked:(id)sender {
    [SVProgressHUD showWithStatus:@"发送中..."];
    @weakify(self);
    NSString *message = [NSString stringWithFormat:@"{\"content\":\"%@\",\"extra\":\"添加好友请求\"}", self.verifyMessage];
    [[UserService sharedUserService] sendSystemMessageWithSourceId:[AVUser currentUser].objectId
                                                          targetId: self.model.objectId
                                                        objectName: @"RC:TxtMsg"
                                                           content: message
                                                       pushContent: @"测试"
                                                          pushData: @"测试"
                                                          complete:^(id responseObject){
                                                              [SVProgressHUD showWithStatus:@"发送成功"];
                                                              [weak_self.navigationController popViewControllerAnimated:YES];
                                                          }
                                                           failure:^(NSError *error) {
                                                               NSLog(@"%@", error);
                                                           }];
}

# pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"你需要发送验证申请，等对方通过";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"FriendVerifyMessageTableViewCell";
    FriendVerifyMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.VerifyMessageTextField.text = [NSString stringWithFormat:@"%@%@", @"我是", self.currentNickName];
    self.verifyMessage = cell.VerifyMessageTextField.text;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (NSString *)currentNickName {
    if (!_currentNickName) {
        _currentNickName = [[AVUser currentUser] objectForKey:@"nickName"];
    }
    return _currentNickName;
}

- (void)endEdit {
    [self.view endEditing:YES];
}

@end
