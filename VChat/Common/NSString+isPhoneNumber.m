//
//  NSString+isPhoneNumber.m
//  VChat
//
//  Created by Recover on 16/5/21.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "NSString+isPhoneNumber.h"

@implementation NSString (isPhoneNumber)

-(BOOL)isPhoneNumber {
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject: self];
}

@end
