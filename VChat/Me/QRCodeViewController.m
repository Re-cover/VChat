//
//  QRCodeViewController.m
//  VChat
//
//  Created by Recover on 16/5/19.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "QRCodeViewController.h"
#import <AVUser.h>
#import <YYWebImage.h>
#import <CoreImage/CoreImage.h>

@interface QRCodeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *centerAvatarImageView;
@property (strong, nonatomic) UIImage *QRCodeImage;

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.avatarImageView yy_setImageWithURL:[NSURL URLWithString:[[AVUser currentUser] objectForKey:@"avatarURL"]] placeholder:nil];
    [self.centerAvatarImageView yy_setImageWithURL:[NSURL URLWithString:[[AVUser currentUser] objectForKey:@"avatarURL"]] placeholder:nil];
    self.nickNameLabel.text = [[AVUser currentUser] objectForKey:@"nickName"];
    self.areaLabel.text = [[AVUser currentUser] objectForKey:@"area"];
    self.QRCodeImageView.image = self.QRCodeImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)QRCodeImage {
    if (!_QRCodeImage) {
        CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        [filter setDefaults];
        NSString *objectId = [AVUser currentUser].objectId;
        NSData *data = [objectId dataUsingEncoding:NSUTF8StringEncoding];
        [filter setValue:data forKey:@"inputMessage"];
        CIImage *outPutImage = [filter outputImage];
        _QRCodeImage = [UIImage imageWithCIImage:outPutImage];
    }
    return _QRCodeImage;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
