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

@protocol ConnectIMServerDelegate <NSObject>

- (void)getTokenSuccessed;

- (void)getTokenFailed:(NSError *)error;

- (void)connectIMServerSuccessed;

- (void)connectIMServerFailed:(NSInteger)status;

- (void)connectIMServerTokenIncorrect;

@end

@interface UserService : NSObject

@property (nonatomic, strong) NSMutableArray *contactsArray;

@property (weak, nonatomic) id<ConnectIMServerDelegate> connectIMServerDelegate;

+ (instancetype)sharedUserService;

- (void)tokenWithUserId:(NSString *)userId
                   name:(NSString *)name
            portraitUri:(NSString *)uri
               complete:(success)successBlock
                failure:(failure)failureBlock;

- (void)connectIMServer;

- (void)sendSystemMessageWithSourceId:(NSString *)sourceId
                             targetId:(NSString *)targetId
                           objectName:(NSString *)objectName
                              content:(NSString *)content
                          pushContent:(NSString *)pushContent
                             pushData:(NSString*)pushData
                             complete:(success)successBlock
                              failure:(failure)failureBlock;

- (void)loadContactsArrray;

@end
