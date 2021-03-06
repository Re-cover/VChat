//
//  ContactsViewController.m
//  VChat
//
//  Created by Recover on 16/4/30.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactTableViewCell.h"
#import "ContactHeaderView.h"
#import "BlurView.h"
#import "FriendInfoViewController.h"
#import "NSString+FirstCharacter.h"
#import <AVQuery.h>
#import <AVUser.h>
#import <AVStatus.h>
#import <YYWebImage.h>


@interface ContactsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) BlurView *blurView;
@property (strong, nonatomic) FriendInfoModel *model;
@property (strong, nonatomic) NSMutableArray *contactsArray;

@property (strong, nonatomic) NSMutableArray *contactsGroups;
@property (strong, nonatomic) NSMutableArray *contactsGroupsCount;

@end

@implementation ContactsViewController

# pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadContactsArrray) name:@"contactsRefresh" object:nil];
    [self loadContactsArrray];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.searchController.searchBar resignFirstResponder];
    [self.searchController.searchBar setText:nil];
    [self.blurView removeFromSuperview];
    [self.searchController.searchResultsController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

# pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _contactsGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_contactsGroupsCount[section] intValue];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ContactHeaderView *headerView = [ContactHeaderView viewFromNib];
    headerView.label.text = _contactsGroups[section];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"ContactTableViewCell";
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    FriendInfoModel *model = _contactsArray[[self realIndexfor:indexPath]];
    [cell.avatarImageView yy_setImageWithURL:[NSURL URLWithString:model.avatarUrl] placeholder:nil];
    cell.nickNameLabel.text = model.nickName;
    return cell;
}

- (IBAction)addFriendButtonDidClicked:(id)sender {
    [self.searchController.searchBar becomeFirstResponder];
}

# pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.model = _contactsArray[[self realIndexfor:indexPath]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"toFriendInfoView" sender:nil];
}

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
- (void)loadContactsArrray {
    if (!_contactsArray) {
        _contactsArray = [[NSMutableArray alloc] init];
    }
    [_contactsArray removeAllObjects];
    [[AVUser currentUser] getFollowees:^(NSArray *objects, NSError *error) {
        if (error == nil) {
            AVObject *contact = nil;
            for (contact in objects) {
                FriendInfoModel *contactModel = [[FriendInfoModel alloc] init];
                contactModel.objectId = contact.objectId;
                contactModel.avatarUrl = [contact valueForKey:@"avatarURL"];
                contactModel.vChatId = [contact valueForKey:@"username"];
                contactModel.nickName = [contact valueForKey:@"nickName"];
                contactModel.phoneNumber = [contact valueForKey:@"mobilePhoneNumber"];
                contactModel.area =[contact valueForKey:@"area"];
                contactModel.signature = [contact valueForKey:@"signature"];
                contactModel.firstCharacter = contactModel.nickName.firstCharacter;
                contactModel.isFriend = YES;
                NSLog(@"%@", contactModel.nickName);
                [_contactsArray addObject:contactModel];
            }
            _contactsArray = [_contactsArray sortedArrayUsingFunction:nickNameCompare context:NULL].mutableCopy;
            [self groupContacts];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.description);
        }
    }];
}

- (void)groupContacts {
    _contactsGroups = [[NSMutableArray alloc] init];
    _contactsGroupsCount = [[NSMutableArray alloc] init];
    FriendInfoModel *contact = nil;
    NSString *groupName = @"";
    NSUInteger index = -1;
    NSUInteger count = 0;
    for (contact in _contactsArray) {
        if(![contact.firstCharacter isEqualToString:groupName]) {
            groupName = contact.firstCharacter;
            ++index;
            count = 1;
            [_contactsGroups addObject: groupName];
            [_contactsGroupsCount addObject: [[NSNumber alloc] initWithUnsignedInteger:count]];
        } else {
            ++count;
            _contactsGroupsCount[index] = [[NSNumber alloc] initWithUnsignedInteger:count];
        }
    }
    NSLog(@"%@", _contactsGroups);
    NSLog(@"%@", _contactsGroupsCount);
}

- (NSUInteger)realIndexfor:(NSIndexPath *)indexPath{
    NSUInteger index = 0;
    for(int i = 0; i < indexPath.section; i++) {
        index += [_contactsGroupsCount[i] intValue];
    }
    index = index + indexPath.row;
    return index;
}

NSInteger nickNameCompare(FriendInfoModel *model1, FriendInfoModel *model2, void *context) {
    return [model1.nickName localizedCompare: model2.nickName];
}

# pragma mark Getters

- (BlurView *)blurView {
    if (!_blurView) {
        _blurView = [[BlurView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
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
        _searchController = [[UISearchController alloc] initWithSearchResultsController: [[UIViewController alloc] init]];
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
