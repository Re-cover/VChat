//
//  AccountService.m
//  VChat
//
//  Created by Recover on 16/5/2.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "AccountService.h"
#import <AVOSCloud.h>
#import <AVUser.h>
#import <AVQuery.h>

@implementation AccountService

+ (instancetype)sharedRegister {
    static AccountService *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)requestSMSCodeViaPhoneNumber:(NSString *)number {
    [AVOSCloud requestSmsCodeWithPhoneNumber:number callback:^(BOOL succeeded, NSError *error) {
        if(succeeded) {
            [_verifySMSdelegate verifySMSSendSuccessed];
        } else {
            NSLog(@"短信发送失败，错误信息为%@", error.description);
            [_verifySMSdelegate verifySMSSendFailed];
        }
    }];
}

- (void)loginVerifyPhoneNumber:(NSString *)number With:(NSString *)code {
//    [AVUser logInWithMobilePhoneNumberInBackground:number smsCode:code
//                                             block:^(AVUser *user, NSError *error) {
//                                                 if(error == nil) {
//                                                     [_loginViaPhoneNumberDelegate LoginViaPhoneNumberSuccessed];
//                                                 } else {
//                                                     NSLog(@"短信验证码登录失败，错误信息为%@", error.description);
//                                                     [_loginViaPhoneNumberDelegate LoginViaPhoneNumberFailed];
//                                                 }
//                                             }];
    [AVUser signUpOrLoginWithMobilePhoneNumberInBackground:number smsCode:code block:^(AVUser *user, NSError *error) {
        if (error == nil) {
            [_loginViaPhoneNumberDelegate LoginViaPhoneNumberSuccessed];
        } else {
            NSLog(@"短信验证码登录失败，错误信息为%@", error.description);
            [_loginViaPhoneNumberDelegate LoginViaPhoneNumberFailed];
        }
    }];
}

- (void)registerVerifyPhoneNumber:(NSString*)number With:(NSString *)code {
    [AVUser signUpOrLoginWithMobilePhoneNumberInBackground:number smsCode:code block:^(AVUser *user, NSError *error) {
        if (error == nil) {
            [_registerViaPhoneNumberDelegate registerViaPhoneNumberSuccessed];
        } else {
            NSLog(@"验证失败，错误信息为%@", error.description);
            [_registerViaPhoneNumberDelegate registerViaPhoneNumberFailed];
        }
    }];
}

@end
