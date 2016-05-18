//
//  ContactsViewController.m
//  VChat
//
//  Created by Recover on 16/4/30.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactTableViewCell.h"
#import "BlurView.h"
#import <AVQuery.h>
#import <AVUser.h>
#import <AVStatus.h>
#import "FriendInfoModel.h"
#import "FriendInfoViewController.h"

@interface ContactsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *ContactsTableView;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) BlurView *blurView;
@property (strong, nonatomic) FriendInfoModel *model;

@end

@implementation ContactsViewController

# pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.ContactsTableView.dataSource = self;
    self.ContactsTableView.delegate = self;
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = self;
    self.ContactsTableView.tableHeaderView = self.searchController.searchBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"ContactTableViewCell";
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.avatarImageView.image = [UIImage imageNamed:@"default_avatar"];
    cell.nickNameLabel.text = @"昵称";
    return cell;
}

- (IBAction)addFriendButtonDidClicked:(id)sender {
    [self.searchController.searchBar becomeFirstResponder];
}

# pragma mark - UITableViewDelegate

# pragma mark - UISearchControllerDelegate

- (void)willPresentSearchController:(UISearchController*)searchController {
    [self.view addSubview:self.blurView];
}

- (void)willDismissSearchController:(UISearchController*)searchController {
    [self.blurView removeFromSuperview];
}

# pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if ([[AVUser currentUser].mobilePhoneNumber isEqualToString:searchBar.text]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你不能添加自己到通讯录" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:confirmAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    @weakify(self);
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query whereKey:@"mobilePhoneNumber" equalTo: searchBar.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"该用户不存在" message:@"无法找到该用户，请检查你填写的账号是否正确" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:confirmAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            AVObject *friendObject = [objects lastObject];
            [self setModelWith:friendObject];
            [[AVUser currentUser] getFollowees:^(NSArray *objects, NSError *error) {
                if (error == nil) {
                    AVObject *followee;
                    for(followee in objects){
                        if([followee.objectId isEqualToString:friendObject.objectId]) {
                            weak_self.model.isFriend = YES;
                        }
                    }
                    [self performSegueWithIdentifier:@"toFriendInfoView" sender:nil];
                } else {
                    NSLog(@"%@", error.description);
                }
            }];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    FriendInfoViewController *controller = segue.destinationViewController;
    controller.model = self.model;
}

# pragma mark Getters

- (BlurView *)blurView {
    if (!_blurView) {
        _blurView = [[BlurView alloc] initWithFrame:CGRectMake(0, 64, kSceenWidth, kSceenHeight - 64)];
    }
    return _blurView;
}

# pragma mark Setters

- (void)setModelWith:(AVObject *)object {
    _model = [[FriendInfoModel alloc] init];
    _model.objectId = object.objectId;
    _model.avatarUrl = [object valueForKey:@"avatarURL"];
    _model.vChatId = [object valueForKey:@"username"];
    _model.nickName = [object valueForKey:@"nickName"];
    _model.phoneNumber = [object valueForKey:@"mobilePhoneNumber"];
    _model.area =[object valueForKey:@"area"];
    _model.signature = [object valueForKey:@"signature"];
    _model.isFriend = NO;
}

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = YES;
        _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchController.searchBar.tintColor = kVChatGreen;
        _searchController.searchBar.backgroundColor = [UIColor whiteColor];
        self.definesPresentationContext = YES;
    }
    return _searchController;
}

@end
