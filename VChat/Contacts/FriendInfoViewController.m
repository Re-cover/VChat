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

@interface FriendInfoViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *FriendOperationButtton;

@end

@implementation FriendInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
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
            cell.avatarImageView.image = [UIImage imageNamed:@"default_avatar"];\
            cell.remarkLabel.text = @"胡腾宇";
            cell.vChatIDLabel.text = @"微信号：recover2012";
            cell.nickNameLabel.text = @"昵称：Terry.";
            return cell;
        }
        case 1: {
            NSString *identifier = @"FriendTableViewCell";
            FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            cell.titleLabel.text = @"电话号码";
            cell.contentLabel.text = @"186 1111 1111";
            return cell;
        }
        case 2: {
            NSString *identifier = @"FriendTableViewCell";
            FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            switch (indexPath.row) {
                case 0: {
                    cell.titleLabel.text = @"地区";
                    cell.contentLabel.text = @"北京";
                    break;
                }
                case 1: {
                    cell.titleLabel.text = @"个性签名";
                    cell.contentLabel.text = @"这是一条很有个性的签名";
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

- (IBAction)FriendOperation:(id)sender {
    NSLog(@"添加到通讯录");
}


@end
