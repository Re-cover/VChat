//
//  ContactsViewController.m
//  VChat
//
//  Created by Recover on 16/4/30.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactTableViewCell.h"

@interface ContactsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *ContactsTableView;

@end

@implementation ContactsViewController

# pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.ContactsTableView.dataSource = self;
    self.ContactsTableView.delegate = self;
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

@end
