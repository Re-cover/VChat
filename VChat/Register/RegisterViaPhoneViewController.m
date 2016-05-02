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
    [SVProgressHUD showInfoWithStatus:@"验证短信发送失败"];
}

- (BOOL)isPhoneNumber:(NSString *)num {
    
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject: num];
}

- (void)endEdit {
    [self.view endEditing:YES];
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
}

- (IBAction)phoneNumberDidChanged:(id)sender {
    if ([self isPhoneNumber: self.phoneNumberTextField.text]) {
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
    [Register sharedRegister].verifySMSdelegate = self;
    [[Register sharedRegister] registerViaPhoneNumber:self.phoneNumberTextField.text];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"toVerifyView"]) {
        VerifyViewController *vc = segue.destinationViewController;
        vc.phoneNumber = self.phoneNumberTextField.text;
    }
}

@end
