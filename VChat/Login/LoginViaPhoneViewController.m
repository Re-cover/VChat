//
//  LoginViaPhoneViewController.m
//  VChat
//
//  Created by Recover on 16/5/21.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "LoginViaPhoneViewController.h"
#import "BaseTextField.h"
#import "LoginVerifyViewController.h"
#import "NSString+isPhoneNumber.h"
#import <SVProgressHUD.h>
#import <AVQuery.h>

@interface LoginViaPhoneViewController ()

@property (weak, nonatomic) IBOutlet BaseTextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation LoginViaPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nextButton.enabled = NO;
    self.nextButton.backgroundColor = kVChatGrayGreen;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)verifySMSSendSuccessed {
    NSLog(@"验证短信发送成功");
    [self performSegueWithIdentifier:@"toLoginVerifyView" sender:self];
}

- (void)verifySMSSendFailed {
    [SVProgressHUD showErrorWithStatus:@"验证短信发送失败"];
}

- (IBAction)phoneNumberDidChanged:(id)sender {
    if ([self.phoneNumberTextField.text isPhoneNumber]) {
        self.nextButton.enabled = YES;
        self.nextButton.backgroundColor = kVChatGreen;
    } else {
        self.nextButton.enabled = NO;
        self.nextButton.backgroundColor = kVChatGrayGreen;
    }
}
- (IBAction)cancelButtonDidClicked:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nextButtonDidClicked:(id)sender {
    [self endEdit];
    @weakify(self);
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query whereKey:@"mobilePhoneNumber" equalTo: self.phoneNumberTextField.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"该手机号未注册" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:confirmAction];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            [AccountService sharedRegister].verifySMSdelegate = self;
            [[AccountService sharedRegister] requestSMSCodeViaPhoneNumber: weak_self.phoneNumberTextField.text];
        }
    }];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"toLoginVerifyView"]) {
        LoginVerifyViewController *vc = segue.destinationViewController;
        vc.phoneNumber = self.phoneNumberTextField.text;
    }
}

- (void)endEdit {
    [self.view endEditing:YES];
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
}

@end
