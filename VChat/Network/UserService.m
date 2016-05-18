//
//  UserService.m
//  VChat
//
//  Created by Recover on 16/5/2.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "UserService.h"
#import "NSString+SHA1.h"
#import "TokenModel.h"
#import "FriendInfoModel.h"
#import "NSString+FirstCharacter.h"
#import <AFNetworking.h>
#import <YYModel.h>
#import <AVUser.h>
#import <AVStatus.h>
#import <RongIMKit/RCIM.h>

@interface UserService()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation UserService

- (instancetype)init {
    if (self = [super init]) {
        self.manager = [[AFHTTPSessionManager alloc] init];
        self.contactsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (instancetype)sharedUserService {
    static UserService *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)tokenWithUserId:(NSString *)userId
                   name:(NSString *)name
            portraitUri:(NSString *)uri
               complete:(success)successBlock
                failure:(failure)failureBlock {
    NSString *urlString =@"https://api.cn.rong.io/user/getToken.json";
    NSDictionary *parameters =@{@"userId": userId,
                               @"name":name,
                               @"portraitUri":uri
                               };
    NSString* timestamp = [[NSString alloc] initWithFormat:@"%ld",(NSInteger)[NSDate timeIntervalSinceReferenceDate]];
    NSString* nonce = [NSString stringWithFormat:@"%d",arc4random()];
    NSString* appKey = kAppKey;
    NSString* appSecret = kAppSecret;
    NSString* signature = [[NSString stringWithFormat:@"%@%@%@",appSecret, nonce, timestamp] sha1String];

    [self.manager.requestSerializer setValue:appKey forHTTPHeaderField:@"App-Key"];
    [self.manager.requestSerializer setValue:nonce forHTTPHeaderField:@"Nonce"];
    [self.manager.requestSerializer setValue:timestamp forHTTPHeaderField:@"Timestamp"];
    [self.manager.requestSerializer setValue:signature forHTTPHeaderField:@"Signature"];
    [self.manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [self.manager POST:urlString
            parameters:parameters
              progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSLog(@"%@", responseObject);
                   TokenModel *model = [TokenModel yy_modelWithJSON: responseObject];
                   if (model) {
                       successBlock(model);
                   }
               }
               failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   failureBlock(error);
               }];
}

- (void)connectIMServer {
    [self tokenWithUserId:(NSString *)(NSString *)[[AVUser currentUser] objectForKey:@"objectId"]
                     name:(NSString *)(NSString *)[[AVUser currentUser] objectForKey:@"nickName"]
              portraitUri:(NSString *)[[AVUser currentUser] objectForKey:@"avatarURL"]
                 complete:^(TokenModel* model) {
                     [_connectIMServerDelegate getTokenSuccessed];
                     [[NSUserDefaults standardUserDefaults] setObject:model.token forKey:@"userToken"];
                     [[RCIM sharedRCIM] connectWithToken:model.token success:^(NSString *userId) {
                         [_connectIMServerDelegate connectIMServerSuccessed];
                     } error:^(RCConnectErrorCode status) {
                         NSLog(@"连接IM服务器失败，错误码为%ld", (long)status);
                         [_connectIMServerDelegate connectIMServerFailed:status];
                     } tokenIncorrect:^{
                         NSLog(@"连接IM服务器失败，token错误");
                         [_connectIMServerDelegate connectIMServerTokenIncorrect];
                     }];
                 } failure:^(NSError *error) {
                     [_connectIMServerDelegate getTokenFailed:error];
                 }
     ];
}

- (void)sendSystemMessageWithSourceId:(NSString *)sourceId
                             targetId:(NSString *)targetId
                           objectName:(NSString *)objectName
                              content:(NSString *)content
                          pushContent:(NSString *)pushContent
                             pushData:(NSString *)pushData
                             complete:(success)successBlock
                              failure:(failure)failureBlock {
    NSString *urlString =@"https://api.cn.ronghub.com/message/system/publish.json";
    NSDictionary *parameters =@{@"fromUserId": sourceId,
                                @"toUserId": targetId,
                                @"objectName": objectName,
                                @"content": content,
                                @"pushContent": pushContent,
                                @"pushData": pushData
                                };
    NSString* timestamp = [[NSString alloc] initWithFormat:@"%ld",(NSInteger)[NSDate timeIntervalSinceReferenceDate]];
    NSString* nonce = [NSString stringWithFormat:@"%d",arc4random()];
    NSString* appKey = kAppKey;
    NSString* appSecret = kAppSecret;
    NSString* signature = [[NSString stringWithFormat:@"%@%@%@",appSecret, nonce, timestamp] sha1String];
    
    [self.manager.requestSerializer setValue:appKey forHTTPHeaderField:@"App-Key"];
    [self.manager.requestSerializer setValue:nonce forHTTPHeaderField:@"Nonce"];
    [self.manager.requestSerializer setValue:timestamp forHTTPHeaderField:@"Timestamp"];
    [self.manager.requestSerializer setValue:signature forHTTPHeaderField:@"Signature"];
    [self.manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    [self.manager POST:urlString
            parameters:parameters
              progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   successBlock(responseObject);
               }
               failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   failureBlock(error);
               }];
}

- (void)loadContactsArrray {
    [_contactsArray removeAllObjects];
    [[AVUser currentUser] getFollowees:^(NSArray *objects, NSError *error) {
        if (error == nil) {
            AVObject *contact = nil;
            FriendInfoModel *contactModel = [[FriendInfoModel alloc] init];
            for (contact in objects) {
                contactModel.objectId = contact.objectId;
                contactModel.avatarUrl = [contact valueForKey:@"avatarURL"];
                contactModel.vChatId = [contact valueForKey:@"username"];
                contactModel.nickName = [contact valueForKey:@"nickName"];
                contactModel.phoneNumber = [contact valueForKey:@"mobilePhoneNumber"];
                contactModel.area =[contact valueForKey:@"area"];
                contactModel.signature = [contact valueForKey:@"signature"];
                contactModel.firstCharacter = contactModel.nickName.firstCharacter;
                contactModel.isFriend = YES;
                [_contactsArray addObject:contactModel];
            }
            _contactsArray = [_contactsArray sortedArrayUsingFunction:nickNameCompare context:NULL].mutableCopy;
        } else {
            NSLog(@"%@", error.description);
        }
    }];
}

NSInteger nickNameCompare(FriendInfoModel *model1, FriendInfoModel *model2, void *context) {
    return [model1.nickName localizedCompare: model2.nickName];
}

@end
