//
//  SignatureSettingViewController.m
//  VChat
//
//  Created by Recover on 16/5/19.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "SignatureSettingViewController.h"
#import <SVProgressHUD.h>
#import <AVUser.h>

@interface SignatureSettingViewController ()
@property (weak, nonatomic) IBOutlet UITextField *signatureTextField;
@property (weak, nonatomic) IBOutlet UILabel *counterLabel;

@end

@implementation SignatureSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.signatureTextField.text = [[AVUser currentUser] objectForKey:@"signature"];
    self.counterLabel.text = [NSString stringWithFormat:@"%lu", 30 - self.signatureTextField.text.length];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
}

- (IBAction)signatureTextFieldDidChanged:(id)sender {
    if (self.signatureTextField.text.length > 30) {
        self.signatureTextField.text = [self.signatureTextField.text substringToIndex:30];
    }
    self.counterLabel.text = [NSString stringWithFormat:@"%lu", 30 - self.signatureTextField.text.length];
}
- (IBAction)saveButtonDidClicked:(id)sender {
    [self.view endEditing:YES];
    @weakify(self)
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [[AVUser currentUser] setObject:self.signatureTextField.text forKey:@"signature"];
    [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [SVProgressHUD showSuccessWithStatus:@"个性签名修改成功"];
            [weak_self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"个性签名修改失败，错误信息为%@", error.description);
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
