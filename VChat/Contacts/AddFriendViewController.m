//
//  AddFriendViewController.m
//  VChat
//
//  Created by Recover on 16/5/4.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "AddFriendViewController.h"
#import "SearchFriendCell.h"

@interface AddFriendViewController()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UISearchController *searchController;

@end

@implementation AddFriendViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    //self.searchController.searchResultsUpdater = self;
    //[self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    //self.navigationItem.titleView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
}

# pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchFriendCell"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40;
}

# pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        NSLog(@"搜索");
        self.searchController.searchBar.hidden = NO;
        [self.searchController.searchBar becomeFirstResponder];
    }
}
@end
