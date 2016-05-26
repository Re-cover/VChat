//
//  MeViewController.m
//  VChat
//
//  Created by Recover on 16/4/30.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "MeViewController.h"
#import "MeTableViewCell.h"
#import "MeInfoTableViewCell.h"
#import <YYWebImage.h>
#import <AVUser.h>

@interface MeViewController ()

@property (weak, nonatomic) IBOutlet UITableView *meTableView;

@end

@implementation MeViewController


# pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.meTableView.dataSource = self;
    self.meTableView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.meTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 4;
        case 2:
            return 1;
        case 3:
            return 1;
        default:
            return 0;
    }
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
            NSString *identifier = @"MeInfoTableViewCell";
            MeInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            [cell.avatarImageView yy_setImageWithURL:[NSURL URLWithString:[[AVUser currentUser] objectForKey:@"avatarURL"]] placeholder:[UIImage imageNamed:@"default_avatar"]] ;
            cell.nickNameLabel.text = [[AVUser currentUser] objectForKey:@"nickName"];
            cell.wechatIDLabel.text = [NSString stringWithFormat:@"V信号：%@", [AVUser currentUser].mobilePhoneNumber];
            return cell;
        }
        case 1: {
            NSString *identifier = @"MeTableViewCell";
            MeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            switch (indexPath.row) {
                case 0:
                    cell.logoImageView.image = [UIImage imageNamed:@"MoreMyAlbum"];
                    cell.titleLabel.text = @"相册";
                    break;
                case 1:
                    cell.logoImageView.image = [UIImage imageNamed:@"MoreMyFavorites"];
                    cell.titleLabel.text = @"收藏";
                    break;
                case 2:
                    cell.logoImageView.image = [UIImage imageNamed:@"MoreMyBankCard"];
                    cell.titleLabel.text = @"钱包";
                    break;
                case 3:
                    cell.logoImageView.image = [UIImage imageNamed:@"MyCardPackageIcon"];
                    cell.titleLabel.text = @"卡券";
                    break;
                default:
                    break;
            }
            return cell;
        }
        case 2: {
            NSString *identifier = @"MeTableViewCell";
            MeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            cell.logoImageView.image = [UIImage imageNamed:@"MoreExpressionShops"];
            cell.titleLabel.text = @"表情";
            return cell;
        }
        case 3: {
            NSString *identifier = @"MeTableViewCell";
            MeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            cell.logoImageView.image = [UIImage imageNamed:@"MoreSetting"];
            cell.titleLabel.text = @"设置";
            return cell;
        }
        default:
            return nil;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            [self performSegueWithIdentifier:@"toMeInfoView" sender:nil];
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            [self performSegueWithIdentifier:@"toSettingView" sender:nil];
            break;
        default:
            break;
    }
}

@end
