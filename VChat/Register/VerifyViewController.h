//
//  VerifyViewController.h
//  VChat
//
//  Created by Recover on 16/5/1.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountService.h"
#import "UserService.h"

@interface VerifyViewController : UIViewController<RegisterViaPhoneNumberDelegate, ConnectIMServerDelegate>

@property (nonatomic, copy) NSString *phoneNumber;

@end
