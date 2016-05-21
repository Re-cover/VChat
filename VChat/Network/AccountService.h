//
//  AccountService.h
//  VChat
//
//  Created by Recover on 16/5/2.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VerifySMSDelegate <NSObject>

- (void)verifySMSSendSuccessed;
- (void)verifySMSSendFailed;

@end

@protocol RegisterViaPhoneNumberDelegate <NSObject>

- (void)registerViaPhoneNumberSuccessed;

- (void)registerViaPhoneNumberFailed;

@end

@protocol LoginViaPhoneNumberDelegate <NSObject>

- (void)LoginViaPhoneNumberSuccessed;

- (void)LoginViaPhoneNumberFailed;

@end

@interface AccountService : NSObject

@property (nonatomic, weak) id<VerifySMSDelegate> verifySMSdelegate;

@property (nonatomic, weak) id<RegisterViaPhoneNumberDelegate> registerViaPhoneNumberDelegate;

@property (nonatomic, weak) id<LoginViaPhoneNumberDelegate> loginViaPhoneNumberDelegate;

+ (instancetype)sharedRegister;

- (void)requestSMSCodeViaPhoneNumber:(NSString *)number;

- (void)registerVerifyPhoneNumber:(NSString*)number With:(NSString *)code;

- (void)loginVerifyPhoneNumber:(NSString*)number With:(NSString *)code;

@end
