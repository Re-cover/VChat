//
//  UserService.h
//  VChat
//
//  Created by Recover on 16/5/2.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^success)(id);
typedef void(^failure)(NSError *error);

@interface UserService : NSObject

+ (instancetype)sharedUserService;

- (void)tokenWithUserId:(NSString *)userId name:(NSString *)name portraitUri:(NSString *)uri
               complete:(success)successBlock failure:(failure)failureBlock;

@end
