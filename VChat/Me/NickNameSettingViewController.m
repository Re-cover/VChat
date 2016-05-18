//
//  NickNameSettingViewController.m
//  VChat
//
//  Created by Recover on 16/5/18.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "NickNameSettingViewController.h"
#import <SVProgressHUD.h>
#import <AVUser.h>

@interface NickNameSettingViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;

@end

@implementation NickNameSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nickNameTextField.text = [[AVUser currentUser] objectForKey:@"nickName"];
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
    [[AVUser currentUser] setObject:self.nickNameTextField.text forKey:@"nickName"];
    [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [SVProgressHUD showSuccessWithStatus:@"名字修改成功"];
            [weak_self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"名字修改失败，错误信息为%@", error.description);
            [SVProgressHUD showErrorWithStatus:error.description];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
