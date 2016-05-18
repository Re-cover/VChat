//
//  AvatarSettingViewController.m
//  VChat
//
//  Created by Recover on 16/5/18.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "AvatarSettingViewController.h"
#import <SVProgressHUD.h>
#import <AVUser.h>
#import <AVFile.h>
#import <YYWebImage.h>


@interface AvatarSettingViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (strong, nonatomic) UIImagePickerController *picker;

@end

@implementation AvatarSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.avatarImageView yy_setImageWithURL:[NSURL URLWithString:[[AVUser currentUser] objectForKey:@"avatarURL"]] placeholder:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [SVProgressHUD showWithStatus:@"头像上传中..."];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.avatarImageView setImage:image];
    NSData *imageData = [self imageWithImage:self.avatarImageView.image scaledToSize:CGSizeMake(360, 360)];
    AVFile *imageFile = [AVFile fileWithData:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [[AVUser currentUser] setObject:(NSString*)imageFile.url forKey:@"avatarURL"];
            [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [SVProgressHUD showSuccessWithStatus:@"头像修改成功"];
                } else {
                    NSLog(@"头像修改失败，错误信息为%@", error.description);
                    [SVProgressHUD showErrorWithStatus:error.description];
                }
            }];
        } else {
            NSLog(@"头像上传失败，错误信息为%@", error.description);
            [SVProgressHUD showErrorWithStatus:error.description];
        }
    }];
}

- (IBAction)modifyAvatarButtonDidClicked:(id)sender {
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
        
- (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)targetSize;
{
    UIGraphicsBeginImageContext(targetSize);
    [image drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    UIImage* targetImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImagePNGRepresentation(targetImage);
}

@end
