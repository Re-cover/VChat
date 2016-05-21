//
//  UserInfoModel.m
//  VChat
//
//  Created by Recover on 16/5/20.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

#warning todo
- (NSString *)avatarUrl {
    return [[AVUser currentUser] objectForKey:@"avatarURL"];
}

- (NSString *)vChatId {
    return [[AVUser currentUser] objectForKey:@""];
}

- (NSString *)nickName {
    return [[AVUser currentUser] objectForKey:@"nickName"];
}

- (NSString *)phoneNumber {
    return [[AVUser currentUser] objectForKey:@""];
}

- (NSString *)sex {
    return [[AVUser currentUser] objectForKey:@"sex"];
}

- (NSString *)area {
    return [[AVUser currentUser] objectForKey:@"area"];
}

- (NSString *)signature {
    return [[AVUser currentUser] objectForKey:@"signature"];
}


@end
