//
//  VerifyViewController.m
//  VChat
//
//  Created by Recover on 16/5/1.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "VerifyViewController.h"
#import "BaseTextField.h"
#import "TokenModel.h"
#import <SVProgressHUD.h>
#import <AVQuery.h>
#import <AVUser.h>

@interface VerifyViewController ()

@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

@property (weak, nonatomic) IBOutlet BaseTextField *VerifyCodeTextField;

@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@end

@implementation VerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.phoneNumberLabel.text = self.phoneNumber;
    self.commitButton.enabled = NO;
    self.commitButton.backgroundColor = kVChatGrayGreen;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

# pragma mark - RegisterViaPhoneNumberDelegate

- (void)registerViaPhoneNumberSuccessed{
    NSLog(@"验证成功");
    [self performSegueWithIdentifier:@"toPersonalInfoView" sender:self];
}

- (void)registerViaPhoneNumberFailed {
    [SVProgressHUD showInfoWithStatus:@"验证失败"];
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

- (IBAction)VeifyCodeTextDidChanged:(id)sender {
    if (self.VerifyCodeTextField.text.length == 6) {
        self.commitButton.enabled = YES;
        self.commitButton.backgroundColor = kVChatGreen;
    } else {
        self.commitButton.enabled = NO;
        self.commitButton.backgroundColor = kVChatGrayGreen;
    }
}

- (IBAction)cancelButtonDidClicked:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)commitButtonDidClicked:(id)sender {
    [self endEdit];
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query whereKey:@"mobilePhoneNumber" equalTo: self.phoneNumber];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count != 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"该手机号已注册" message:@"是否使用该手机号直接登录" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [SVProgressHUD showWithStatus:@"登录中..."];
                [AVUser signUpOrLoginWithMobilePhoneNumberInBackground:self.phoneNumber
                                                               smsCode:self.VerifyCodeTextField.text
                                                                 block:^(AVUser *user, NSError *error) {
                                                                     if (user != nil) {
                                                                         NSLog(@"已注册用户登录成功");
                                                                         [UserService sharedUserService].connectIMServerDelegate = self;
                                                                         [[UserService sharedUserService] connectIMServer];
                                                                     } else {
                                                                         NSLog(@"已注册用户登录失败，错误信息为%@", error.description);
                                                                     }
                                                                 }];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:confirmAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            [Register sharedRegister].registerViaPhoneNumberDelegate = self;
            [[Register sharedRegister] verifyPhoneNumber:self.phoneNumber With:self.VerifyCodeTextField.text];
        }
    }];

}

- (void)endEdit {
    [self.view endEditing:YES];
    if([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
}
@end
