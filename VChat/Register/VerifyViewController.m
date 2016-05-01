//
//  VerifyViewController.m
//  VChat
//
//  Created by Recover on 16/5/1.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "VerifyViewController.h"
#import "BaseTextField.h"

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
    // Dispose of any resources that can be recreated.
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

- (void)endEdit {
    [self.view endEditing:YES];
}


@end
