//
//  LoginVerifyViewController.m
//  VChat
//
//  Created by Recover on 16/5/21.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "LoginVerifyViewController.h"
#import "BaseTextField.h"
#import <SVProgressHUD.h>

@interface LoginVerifyViewController ()
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@property (weak, nonatomic) IBOutlet BaseTextField *verifyCodeTextField;
@end

@implementation LoginVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.phoneNumberLabel.text = self.phoneNumber;
    self.commitButton.enabled = NO;
    self.commitButton.backgroundColor = kVChatGrayGreen;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    [self.view addGestureRecognizer:tap];
}

# pragma mark - LoginViaPhoneNumberDelegate

- (void)LoginViaPhoneNumberSuccessed {
    NSLog(@"短信验证码登录成功");
    [self performSegueWithIdentifier:@"toMainView" sender:nil];
}

- (void)LoginViaPhoneNumberFailed {
    [SVProgressHUD showErrorWithStatus:@"短信验证码登录失败"];
}

# pragma mark - ConnectIMServerDelegate

- (void)getTokenSuccessed {
    NSLog(@"获取token成功");
}

- (void)getTokenFailed:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:@"获取token失败"];
}

- (void)connectIMServerSuccessed {
    NSLog(@"连接IM服务器成功");
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
    [self performSegueWithIdentifier:@"toMainView" sender:self];
}

- (void)connectIMServerFailed:(NSInteger)status {
    NSString *info = [NSString stringWithFormat:@"连接IM服务器失败，错误代码为%ld", status];
    [SVProgressHUD showErrorWithStatus: info];
}

- (void)connectIMServerTokenIncorrect {
    [SVProgressHUD showErrorWithStatus:@"连接IM服务器失败，token错误"];
}

- (IBAction)cancelButtonDidClicked:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)verifyCodeTextFieldDidChanged:(id)sender {
    if (self.verifyCodeTextField.text.length == 6) {
        self.commitButton.enabled = YES;
        self.commitButton.backgroundColor = kVChatGreen;
    } else {
        self.commitButton.enabled = NO;
        self.commitButton.backgroundColor = kVChatGrayGreen;
    }
}
- (IBAction)commitButtonDidClicked:(id)sender {
    [self endEdit];
    [AccountService sharedRegister].loginViaPhoneNumberDelegate = self;
    [[AccountService sharedRegister] loginVerifyPhoneNumber:self.phoneNumber With:self.verifyCodeTextField.text];

}

- (void)endEdit {
    [self.view endEditing:YES];
    if([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
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
