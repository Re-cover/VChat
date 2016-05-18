//
//  FriendInfoModel.h
//  VChat
//
//  Created by Recover on 16/5/14.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendInfoModel : NSObject

@property (nonatomic, copy) NSString *objectId;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) NSString *vChatId;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSString *firstCharacter;
@property (nonatomic, assign) BOOL isFriend;

@end
