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
#import <AFNetworking.h>
#import <YYModel.h>
#import <AVUser.h>
#import <RongIMKit/RCIM.h>

@interface UserService()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation UserService

- (instancetype)init {
    if (self = [super init]) {
        self.manager = [[AFHTTPSessionManager alloc] init];
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

- (void)tokenWithUserId:(NSString *)userId name:(NSString *)name portraitUri:(NSString *)uri
               complete:(success)successBlock failure:(failure)failureBlock {
    NSString *urlString =@"https://api.cn.rong.io/user/getToken.json";
    NSDictionary *parameters =@{@"userId": userId,
                               @"name":name,
                               @"portraitUri":uri
                               };
    NSString* timestamp = [[NSString alloc] initWithFormat:@"%ld",(NSInteger)[NSDate timeIntervalSinceReferenceDate]];
    NSString* nonce = [NSString stringWithFormat:@"%d",arc4random()];
    NSString* appKey = @"kj7swf8o7bdy2";
    NSString* appSecret = @"0siNNZXjUk";
    NSString* signature = [[NSString stringWithFormat:@"%@%@%@",appKey, nonce, timestamp] sha1String];

    [self.manager.requestSerializer setValue:appKey forHTTPHeaderField:@"App-Key"];
    [self.manager.requestSerializer setValue:nonce forHTTPHeaderField:@"Nonce"];
    [self.manager.requestSerializer setValue:timestamp forHTTPHeaderField:@"Timestamp"];
    [self.manager.requestSerializer setValue:signature forHTTPHeaderField:@"Signature"];
    [self.manager.requestSerializer setValue:appSecret forHTTPHeaderField:@"appSecret"];
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
                                            }];
}

@end
