//
//  Register.h
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

@interface Register : NSObject

@property (nonatomic, weak) id<VerifySMSDelegate> verifySMSdelegate;

@property (nonatomic, weak) id<RegisterViaPhoneNumberDelegate> registerViaPhoneNumberDelegate;

+ (instancetype)sharedRegister;

- (void)registerViaPhoneNumber:(NSString *)number;

- (void)verifyPhoneNumber:(NSString *)number With:(NSString *)code;

@end
