//
//  QRCodeScanViewController.m
//  VChat
//
//  Created by Recover on 16/5/19.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "QRCodeScanViewController.h"
#import "FriendInfoModel.h"
#import "FriendInfoViewController.h"
#import "WebViewController.h"
#import <AVQuery.h>
#import <AVStatus.h>
#import <AVUser.h>

@interface QRCodeScanViewController ()

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (strong, nonatomic) FriendInfoModel *model;

@property (copy, nonatomic) NSString *scanResult;

@end

@implementation QRCodeScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.style = [self style];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:self.tipLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (LBXScanViewStyle *)style {
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 2;
    style.photoframeAngleW = 18;
    style.photoframeAngleH = 18;
    style.isNeedShowRetangle = YES;
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    style.colorAngle = kVChatGreen;
    UIImage *imgLine = [UIImage imageNamed:@"ScanLine"];
    style.animationImage = imgLine;
    return style;
}

- (UIImage*)createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array {
    if (array.count < 1) {
        NSLog(@"扫描失败");
        return;
    }
    LBXScanResult *result = [array firstObject];
    NSLog(@"%@",result.strScanned);
    @weakify(self);
    if ([[result.strScanned substringToIndex:8] isEqualToString:@"vchat://"]) {
        self.scanResult = [result.strScanned substringFromIndex:8];
        if ([self.scanResult isEqualToString:[AVUser currentUser].objectId]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你不能添加自己到通讯录" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weak_self reStartDevice];
            }];
            [alert addAction:confirmAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        AVQuery *query = [AVQuery queryWithClassName:@"_User"];
        [query getObjectInBackgroundWithId:self.scanResult block:^(AVObject *object, NSError *error) {
            if (!object || error) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"该用户不存在" message:@"无法找到该用户，请检查你填写的账号是否正确" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:confirmAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else {
                [self setModelWith:object];
                [[AVUser currentUser] getFollowees:^(NSArray *objects, NSError *error) {
                    if (error == nil) {
                        AVObject *followee;
                        for(followee in objects){
                            if([followee.objectId isEqualToString:object.objectId]) {
                                weak_self.model.isFriend = YES;
                            }
                        }
                        [self performSegueWithIdentifier:@"toFriendInfoView" sender:nil];
                    } else {
                        NSLog(@"%@", error.description);
                    }
                }];
            }
        }];
        
    } else if ([[result.strScanned substringToIndex:7] isEqualToString:@"http://"] ||
               [[result.strScanned substringToIndex:8] isEqualToString:@"https://"]){
        self.scanResult = result.strScanned;
        [self performSegueWithIdentifier:@"toWebView" sender:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法识别该二维码" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [weak_self reStartDevice];
        }];
        [alert addAction:confirmAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toFriendInfoView"]) {
        FriendInfoViewController *controller = segue.destinationViewController;
        controller.model = self.model;
    }else if ([segue.identifier isEqualToString:@"toWebView"]) {
        WebViewController *controller = segue.destinationViewController;
        controller.urlString = self.scanResult;
    }
}

# pragma mark Setters

- (void)setModelWith:(AVObject *)object {
    _model = [[FriendInfoModel alloc] init];
    _model.objectId = object.objectId;
    _model.avatarUrl = [object valueForKey:@"avatarURL"];
    _model.vChatId = [object valueForKey:@"username"];
    _model.nickName = [object valueForKey:@"nickName"];
    _model.phoneNumber = [object valueForKey:@"mobilePhoneNumber"];
    _model.area =[object valueForKey:@"area"];
    _model.signature = [object valueForKey:@"signature"];
    _model.isFriend = NO;
}

@end
