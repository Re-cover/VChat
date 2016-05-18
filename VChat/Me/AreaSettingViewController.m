//
//  AreaSettingViewController.m
//  VChat
//
//  Created by Recover on 16/5/19.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "AreaSettingViewController.h"
#import <SVProgressHUD.h>
#import <AVUser.h>

@interface AreaSettingViewController ()
@property (weak, nonatomic) IBOutlet UITextField *areaTextField;

@end

@implementation AreaSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.areaTextField.text = [[AVUser currentUser] objectForKey:@"area"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
}


- (IBAction)saveButtonDidClicked:(id)sender {
    [self.view endEditing:YES];
    @weakify(self)
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [[AVUser currentUser] setObject:self.areaTextField.text forKey:@"area"];
    [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [SVProgressHUD showSuccessWithStatus:@"地区修改成功"];
            [weak_self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"地区修改失败，错误信息为%@", error.description);
            [SVProgressHUD showErrorWithStatus:error.description];
        }
    }];
}


@end
