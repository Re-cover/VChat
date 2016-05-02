//
//  VerifyViewController.m
//  VChat
//
//  Created by Recover on 16/5/1.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "VerifyViewController.h"
#import "BaseTextField.h"
#import "Register.h"
#import <SVProgressHUD.h>
#import <AVQuery.h>

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
                [self performSegueWithIdentifier:@"toMainView" sender:self];
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
