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

@interface ContactsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *ContactsTableView;
@property (strong, nonatomic) BlurView *blurView;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) UIViewController *searchResultController;

@end

@implementation ContactsViewController

# pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.ContactsTableView.dataSource = self;
    self.ContactsTableView.delegate = self;
    self.searchController.delegate = self;
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

# pragma mark - UITableViewDelegate
- (IBAction)addFriendButtonDidClicked:(id)sender {
}

#pragma mark - UISearchControllerDelegate

- (void)willPresentSearchController:(UISearchController*)searchController
{
    [self.view addSubview:self.blurView];
}

- (void)willDismissSearchController:(UISearchController*)searchController
{
    [self.blurView removeFromSuperview];
}


# pragma mark getters

- (BlurView *)blurView {
    if (!_blurView) {
        _blurView = [[BlurView alloc] initWithFrame:CGRectMake(0, 64, kSceenWidth, kSceenHeight - 64)];
    }
    return _blurView;
}

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil
                             ];
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = YES;
        _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchController.searchBar.tintColor = kVChatGreen;
        _searchController.searchBar.backgroundColor = [UIColor whiteColor];
        self.definesPresentationContext = YES;
    }
    return _searchController;
}

#warning 未调用
- (UIViewController *)searchResultController {
    if (!_searchResultController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Search" bundle:nil];
        _searchResultController = [storyboard instantiateInitialViewController];
    }
    return _searchResultController;
}
@end
