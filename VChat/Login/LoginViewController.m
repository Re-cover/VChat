//
//  LoginViewController.m
//  VChat
//
//  Created by Recover on 16/3/21.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "LoginViewController.h"
#import <AVUser.h>
#import <RongIMKit/RCIM.h>
#import <SVProgressHUD.h>
#import "UserService.h"
#import "TokenModel.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *loginProblemButton;
@property (strong, nonatomic) TokenModel *tokenModel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginButton.enabled = NO;
    self.loginButton.backgroundColor = kVChatGrayGreen;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)didCancelButtonClicked:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)TextFieldDidChanged:(id)sender {
    if (self.userTextField.text.length != 0 && self.passwordTextField.text.length != 0) {
        self.loginButton.enabled = YES;
        self.loginButton.backgroundColor = kVChatGreen;
    } else {
        self.loginButton.enabled = NO;
        self.loginButton.backgroundColor = kVChatGrayGreen;
    }
}


- (IBAction)loginButtonDidClicked:(id)sender {
    [self endEdit];
    [SVProgressHUD showWithStatus:@"登录中..."];
    [AVUser logInWithUsernameInBackground:self.userTextField.text
                                 password:self.passwordTextField.text
                                    block:^(AVUser *user, NSError *error) {
        if (user != nil) {
            NSLog(@"leanCloud登录成功");
            [UserService sharedUserService].connectIMServerDelegate = self;
            [[UserService sharedUserService] connectIMServer];
        } else {
            switch (error.code) {
                case 210:
                    [SVProgressHUD showErrorWithStatus:@"账号与密码不匹配"];
                    break;
                case 211:
                    [SVProgressHUD showErrorWithStatus:@"该账户不存在"];
                    break;
                case 1:
                    [SVProgressHUD showErrorWithStatus:@"登录失败次数过多，请稍后再试"];
                    break;
                case 6:
                    [SVProgressHUD showErrorWithStatus:@"无法连接到网络"];
                    break;
                default:
                    NSLog(@"登录失败，错误信息为%@", error.description);
                    break;
            }
        }
    }];
}

- (IBAction)loginProblemButtonDidCilcked:(id)sender {
    NSLog(@"登录遇到问题");
    [self performSegueWithIdentifier:@"toLoginViaPhoneView" sender:nil];
}

- (void)endEdit {
    [self.view endEditing:YES];
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
}

@end
