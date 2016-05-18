//
//  SexSettingViewController.m
//  VChat
//
//  Created by Recover on 16/5/19.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "SexSettingViewController.h"
#import "SexTableViewCell.h"
#import <SVProgressHUD.h>
#import <AVUser.h>

@interface SexSettingViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SexSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
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
    NSString *identifier = @"SexTableViewCell";
    SexTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.sexLabel.text = indexPath.row == 0 ? @"男" : @"女";
    if ([[[AVUser currentUser] objectForKey:@"sex"] isEqualToString:@"男"] && indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else if ([[[AVUser currentUser] objectForKey:@"sex"] isEqualToString:@"女"] && indexPath.row == 1){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

# pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sex = indexPath.row == 0 ? @"男" : @"女";
    if (![sex isEqualToString:[[AVUser currentUser] objectForKey:@"sex"]]) {
        @weakify(self)
        [SVProgressHUD showWithStatus:@"正在加载..."];
        [[AVUser currentUser] setObject:sex forKey:@"sex"];
        [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [SVProgressHUD showSuccessWithStatus:@"性别修改成功"];
                [weak_self.navigationController popViewControllerAnimated:YES];
            } else {
                NSLog(@"性别修改失败，错误信息为%@", error.description);
                [SVProgressHUD showErrorWithStatus:error.description];
            }
        }];
    }
}
@end
