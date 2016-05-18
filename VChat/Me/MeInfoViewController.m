//
//  MeInfoViewController.m
//  VChat
//
//  Created by Recover on 16/5/18.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "MeInfoViewController.h"
#import "AvatarTableViewCell.h"
#import "InfoTableViewCell.h"
#import <AVUser.h>
#import <YYWebImage.h>

@interface MeInfoViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 90;
    }
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 4;
        case 1:
            return 3;
        default:
            return 0;
    }
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
            NSString *identifier = @"InfoTableViewCell";
            InfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            switch (indexPath.row) {
                case 0: {
                    NSString *identifier = @"AvatarTableViewCell";
                    AvatarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    cell.titleLabel.text = @"头像";
                    [cell.avatarImageView yy_setImageWithURL:[NSURL URLWithString:[[AVUser currentUser] objectForKey:@"avatarURL"]] placeholder:[UIImage imageNamed:@"default_avatar"]];
                    return cell;
                }
                case 1:
                    cell.titleLabel.text = @"名字";
                    cell.contentLabel.text = [[AVUser currentUser] objectForKey:@"nickName"];
                    break;
                case 2:
                    cell.titleLabel.text = @"微信号";
                    cell.contentLabel.text = [AVUser currentUser].mobilePhoneNumber;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                case 3:
                    cell.titleLabel.text = @"我的二维码";
                    cell.contentLabel.text = @"二维码";
                    break;
                default:
                    break;
            }
            return cell;
        }
        case 1: {
            NSString *identifier = @"InfoTableViewCell";
            InfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            switch (indexPath.row) {
                case 0:
                    cell.titleLabel.text = @"性别";
                    cell.contentLabel.text = [[AVUser currentUser] objectForKey:@"sex"];
                    break;
                case 1:
                    cell.titleLabel.text = @"地区";
                    cell.contentLabel.text = [[AVUser currentUser] objectForKey:@"area"];
                    break;
                case 2:
                    cell.titleLabel.text = @"个性签名";
                    cell.contentLabel.text = [[AVUser currentUser] objectForKey:@"signature"];
                    break;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:
                    [self performSegueWithIdentifier:@"toAvatarSettingView" sender:nil];
                    break;
                case 1:
                    [self performSegueWithIdentifier:@"toNickNameSettingView" sender:nil];
                    break;
                case 2:
                    break;
                case 3:
                    [self performSegueWithIdentifier:@"toQRCodeView" sender:nil];
                    break;
                default:
                    break;
            }
            break;
        }
        case 1: {
            switch (indexPath.row) {
                case 0:
                    [self performSegueWithIdentifier:@"toSexSettingView" sender:nil];
                    break;
                    
                default:
                    break;
            }
        }
        default:
            break;
    }
}


@end
