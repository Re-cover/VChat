//
//  Register.m
//  VChat
//
//  Created by Recover on 16/5/2.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "Register.h"
#import <AVOSCloud.h>
#import <AVUser.h>
#import <AVQuery.h>

@implementation Register

+ (instancetype)sharedRegister {
    static Register *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)registerViaPhoneNumber:(NSString *)number {
    [AVOSCloud requestSmsCodeWithPhoneNumber:number callback:^(BOOL succeeded, NSError *error) {
        if(succeeded) {
            [self.verifySMSdelegate verifySMSSendSuccessed];
        } else {
            NSLog(@"短信发送失败，错误信息为%@", error.description);
            [self.verifySMSdelegate verifySMSSendFailed];
        }
    }];
}

- (void)verifyPhoneNumber:(NSString*)number With:(NSString *)code {
    [AVUser signUpOrLoginWithMobilePhoneNumberInBackground:number smsCode:code block:^(AVUser *user, NSError *error) {
        if (error == nil) {
            [self.registerViaPhoneNumberDelegate registerViaPhoneNumberSuccessed];
        } else {
            NSLog(@"验证失败，错误信息为%@", error.description);
            [self.registerViaPhoneNumberDelegate registerViaPhoneNumberFailed];
        }
    }];
}

@end
