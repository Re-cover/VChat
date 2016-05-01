//
//  HomeViewController.m
//  VChat
//
//  Created by Recover on 16/4/30.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "ChatViewController.h"
#import <RealReachability.h>

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UITableView *HomeTableView;

@end

@implementation HomeViewController


#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.HomeTableView.delegate = self;
    self.HomeTableView.dataSource = self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (GLobalRealReachability.currentReachabilityStatus == RealStatusNotReachable) {
        self.title = @"微信(未连接)";
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged:)
                                                 name:kRealReachabilityChangedNotification
                                               object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

# pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"HomeTableViewCell";
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.avatarImage.image = [UIImage imageNamed:@"default_avatar"];
    cell.nickNameLabel.text = @"昵称";
    cell.lastMessageLabel.text = @"最后一条信息";
    return cell;
}

# pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"toChat" sender:cell];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ChatViewController *vc = segue.destinationViewController;
    HomeTableViewCell *cell = sender;
    vc.title = cell.nickNameLabel.text;
}

#pragma mark - 事件回调
- (void)networkChanged:(NSNotification *)notification {
    RealReachability *reachability = (RealReachability *)notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    switch (status) {
        case RealStatusNotReachable:
            self.title = @"微信(未连接)";
            break;
        case RealStatusViaWiFi:
            self.title = @"微信(WIFI)";
            break;
        case RealStatusViaWWAN:
            self.title = @"微信(WWAN)";
            break;
        default:
            break;
    }
}

@end
