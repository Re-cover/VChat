//
//  SettingViewController.m
//  VChat
//
//  Created by Recover on 16/5/19.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "SettingViewController.h"
#import "LogOutTableViewCell.h"
#import <RongIMKit/RCIM.h>
#import <AVUser.h>

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"LogOutTableViewCell";
    LogOutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.logOutLabel.text = @"退出登录";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要退出登录吗？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [NSUserDefaults resetStandardUserDefaults];
        [[RCIM sharedRCIM] clearUserInfoCache];
        [[RCIM sharedRCIM] clearGroupInfoCache];
        [[RCIM sharedRCIM] logout];
        [AVUser logOut];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PreLogin" bundle:nil];
        [UIApplication sharedApplication].keyWindow.rootViewController = [storyboard instantiateInitialViewController];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:confirmAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
