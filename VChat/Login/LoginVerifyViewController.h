//
//  LoginVerifyViewController.h
//  VChat
//
//  Created by Recover on 16/5/21.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountService.h"
#import "UserService.h"

@interface LoginVerifyViewController : UIViewController<LoginViaPhoneNumberDelegate, ConnectIMServerDelegate>

@property (nonatomic, copy)NSString *phoneNumber;

@end
