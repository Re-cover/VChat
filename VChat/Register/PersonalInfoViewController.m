//
//  PersonalInfoViewController.m
//  VChat
//
//  Created by Recover on 16/5/1.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "BaseTextField.h"
#import <AVUser.h>
#import <AVFile.h>
#import <SVProgressHUD.h>

@interface PersonalInfoViewController ()

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;

@property (weak, nonatomic) IBOutlet BaseTextField *nickNameTextField;

@property (weak, nonatomic) IBOutlet BaseTextField *passwordTextField;

@property (weak, nonatomic) IBOutlet BaseTextField *confirmPasswordTextField;

@property (weak, nonatomic) IBOutlet UIButton *enterButton;

@property (strong, nonatomic) UIImagePickerController *picker;


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

- (IBAction)AvatarButtonDidClicked:(id)sender {
    [self.view endEditing:YES];
    if (self.picker == nil) {
        self.picker = [[UIImagePickerController alloc] init];
        self.picker.delegate = self;
        self.picker.allowsEditing = YES;
    }
    @weakify(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weak_self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:weak_self.picker animated:YES completion:nil];
    }];
    
    UIAlertAction *chooseImageAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weak_self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:weak_self.picker animated:YES completion:nil];
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
    [self endEdit];
    if (![self.passwordTextField.text isEqualToString: self.confirmPasswordTextField.text]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"两次密码输入不一致" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [SVProgressHUD show];
        NSData *imageData = nil;
        if ([self.avatarButton.currentImage isEqual: [UIImage imageNamed:@"choose_avatar"]]) {
            imageData = UIImagePNGRepresentation([UIImage imageNamed:@"default_avatar"]);
        } else {
            imageData = [self imageWithImage:self.avatarButton.currentImage scaledToSize:CGSizeMake(360, 360)];
        }
        AVFile *imageFile = [AVFile fileWithData:imageData];
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"头像上传成功");
                [[AVUser currentUser] setObject:(NSString*)imageFile.url forKey:@"avatarURL"];
                [[AVUser currentUser] setObject:(NSString*)self.nickNameTextField.text forKey:@"nickName"];
                [[AVUser currentUser] setPassword:self.passwordTextField.text];
                [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"个人信息上传成功");
                        [UserService sharedUserService].connectIMServerDelegate = self;
                        [[UserService sharedUserService] connectIMServer];
                    } else {
                        NSLog(@"个人信息上传失败，错误信息为%@", error.description);
                        [SVProgressHUD showErrorWithStatus:error.description];
                    }
                }];
            } else {
                NSLog(@"头像上传失败，错误信息为%@", error.description);
                [SVProgressHUD showErrorWithStatus:error.description];
            }
        }];

    }
}
- (IBAction)cancelButtonDidClicked:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)endEdit {
    [self.view endEditing:YES];
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
}

- (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)targetSize;
{
    UIGraphicsBeginImageContext(targetSize);
    [image drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    UIImage* targetImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImagePNGRepresentation(targetImage);
}

@end
