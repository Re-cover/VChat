//
//  PersonalInfoViewController.m
//  VChat
//
//  Created by Recover on 16/5/1.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "BaseTextField.h"

@interface PersonalInfoViewController ()

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;

@property (weak, nonatomic) IBOutlet BaseTextField *nickNameTextField;

@property (weak, nonatomic) IBOutlet BaseTextField *passwordTextField;

@property (weak, nonatomic) IBOutlet BaseTextField *confirmPasswordTextField;

@property (weak, nonatomic) IBOutlet UIButton *enterButton;


@end

@implementation PersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.enterButton.enabled = NO;
    self.enterButton.backgroundColor = kVChatGrayGreen;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.avatarButton setImage:image forState:UIControlStateNormal];
}

- (IBAction)AvatarButtonDidClicked:(id)sender {
    [self.view endEditing:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    
    UIAlertAction *chooseImageAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:takePhotoAction];
    [alert addAction:chooseImageAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)textFiledDidChanged:(id)sender {
    if (![self.nickNameTextField.text isEqualToString:@""] && ![self.passwordTextField.text isEqualToString: @""] && ![self.confirmPasswordTextField.text isEqualToString: @""]) {
        self.enterButton.enabled = YES;
        self.enterButton.backgroundColor = kVChatGreen;
    } else {
        self.enterButton.enabled = NO;
        self.enterButton.backgroundColor = kVChatGrayGreen;
    }
}

- (IBAction)enterButtonDidClicked:(id)sender {
    if (![self.passwordTextField.text isEqualToString: self.confirmPasswordTextField.text]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"两次密码输入不一致" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        
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
