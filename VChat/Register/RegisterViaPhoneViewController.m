//
//  RegisterViaPhoneViewController.m
//  VChat
//
//  Created by Recover on 16/5/1.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "RegisterViaPhoneViewController.h"
#import "VerifyViewController.h"
#import "BaseTextField.h"
#import "NSString+isPhoneNumber.h"
#import <SVProgressHUD.h>

@interface RegisterViaPhoneViewController ()

@property (weak, nonatomic) IBOutlet BaseTextField *phoneNumberTextField;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation RegisterViaPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.registerButton.enabled = NO;
    self.registerButton.backgroundColor = kVChatGrayGreen;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - VerifySMSDelegate

- (void)verifySMSSendSuccessed {
    NSLog(@"验证短信发送成功");
    [self performSegueWithIdentifier:@"toVerifyView" sender:self];
}

- (void)verifySMSSendFailed {
    [SVProgressHUD showErrorWithStatus:@"验证短信发送失败"];
}

- (void)endEdit {
    [self.view endEditing:YES];
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
}

- (IBAction)phoneNumberDidChanged:(id)sender {
    if ([self.phoneNumberTextField.text isPhoneNumber]) {
        self.registerButton.enabled = YES;
        self.registerButton.backgroundColor = kVChatGreen;
    } else {
        self.registerButton.enabled = NO;
        self.registerButton.backgroundColor = kVChatGrayGreen;
    }
}
- (IBAction)cancelButtonDidClicked:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registerButtonDidClicked:(id)sender {
    [self endEdit];
    [AccountService sharedRegister].verifySMSdelegate = self;
    [[AccountService sharedRegister] requestSMSCodeViaPhoneNumber: self.phoneNumberTextField.text];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"toVerifyView"]) {
        VerifyViewController *vc = segue.destinationViewController;
        vc.phoneNumber = self.phoneNumberTextField.text;
    }
}

@end
