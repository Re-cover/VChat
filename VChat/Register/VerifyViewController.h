//
//  VerifyViewController.h
//  VChat
//
//  Created by Recover on 16/5/1.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Register.h"

@interface VerifyViewController : UIViewController<RegisterViaPhoneNumberDelegate>

@property (nonatomic, copy) NSString *phoneNumber;

@end
