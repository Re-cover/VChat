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
    
}

# pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
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

# pragma mark

@end
