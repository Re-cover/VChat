//
//  DiscoverViewController.m
//  VChat
//
//  Created by Recover on 16/4/30.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoverTableViewCell.h"
#import "WebViewController.h"
#import <LBXScanView.h>

@interface DiscoverViewController ()

@property (weak, nonatomic) IBOutlet UITableView *discoverTableView;

@property (copy, nonatomic) NSString *urlString;

@end

# pragma mark - 生命周期
@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.discoverTableView.dataSource = self;
    self.discoverTableView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 2;
        case 2:
            return 2;
        case 3:
            return 2;
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"DiscoverTableViewCell";
    DiscoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    switch (indexPath.section) {
        case 0:
            cell.logoImageView.image = [UIImage imageNamed:@"ff_IconShowAlbum"];
            cell.titleLabel.text = @"朋友圈";
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.logoImageView.image = [UIImage imageNamed:@"ff_IconQRCode"];
                    cell.titleLabel.text = @"扫一扫";
                    break;
                case 1:
                    cell.logoImageView.image = [UIImage imageNamed:@"ff_IconShake"];
                    cell.titleLabel.text = @"摇一摇";
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    cell.logoImageView.image = [UIImage imageNamed:@"ff_IconLocationService"];
                    cell.titleLabel.text = @"附近的人";
                    break;
                case 1:
                    cell.logoImageView.image = [UIImage imageNamed:@"ff_IconBottle"];
                    cell.titleLabel.text = @"漂流瓶";
                    break;
                default:
                    break;
            }
            break;
        case 3:
            switch (indexPath.row) {
                case 0:
                    cell.logoImageView.image = [UIImage imageNamed:@"CreditCard_ShoppingBag"];
                    cell.titleLabel.text = @"购物";
                    break;
                case 1:
                    cell.logoImageView.image = [UIImage imageNamed:@"MoreGame"];
                    cell.titleLabel.text = @"游戏";
                default:
                    break;
            }
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    [self performSegueWithIdentifier:@"toQRCodeScanView" sender:nil];
                    break;
                case 1:
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    break;
                case 1:
                    break;
                default:
                    break;
            }
            break;
        case 3:
            switch (indexPath.row) {
                case 0:
                    self.urlString = @"http://www.jd.com";
                    [self performSegueWithIdentifier:@"toWebView" sender:nil];
                    break;
                case 1:
                    self.urlString = @"http://h5.static.myappgame.com/liujiaosuipian/index.html";
                    [self performSegueWithIdentifier:@"toWebView" sender:nil];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toWebView"]) {
        WebViewController *controller = segue.destinationViewController;
        controller.urlString = self.urlString;
    }
}

@end
