//
//  UserInfoModel.h
//  VChat
//
//  Created by Recover on 16/5/20.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "AVUser.h"

@interface UserInfoModel : AVUser

@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) NSString *vChatId;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *signature;

@end
