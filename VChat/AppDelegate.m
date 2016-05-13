//
//  AppDelegate.m
//  VChat
//
//  Created by Recover on 16/3/21.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "AppDelegate.h"
#import <AVOSCloud.h>
#import <AVUser.h>
#import <AVQuery.h>
#import <SVProgressHUD.h>
#import "MainTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:userId block:^(AVObject *object, NSError *error) {
        if (object != nil) {
            RCUserInfo *user = [[RCUserInfo alloc]init];
            user.userId = userId;
            user.name = [object objectForKey:@"nickName"];
            user.portraitUri = [object objectForKey:@"avatarURL"];
            return completion(user);
        } else {
            return completion(nil);
        }
    }];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UINavigationBar appearance].barStyle  = UIBarStyleBlack;
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    //[[RCIM sharedRCIM] setGroupInfoDataSource:self];
    
    [AVOSCloud setApplicationId:@"nRTh2Xb9aQ8Dfq8W4XwqNKtG-gzGzoHsz"
                      clientKey:@"WOrJmocpBoXkREXnuFus14Ov"];
    [[RCIM sharedRCIM] initWithAppKey:@"kj7swf8o7bdy2"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *mainStoryboard = nil;
    NSString *userToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
    
    if (userToken == nil) {
        mainStoryboard = [UIStoryboard storyboardWithName:@"PreLogin" bundle:nil];
    } else {
        NSLog(@"Token:%@", userToken);
        mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [[RCIM sharedRCIM] connectWithToken:userToken success:^(NSString *userId) {
            NSLog(@"登录成功");
        } error:^(RCConnectErrorCode status) {
            NSLog(@"%ld", status);
        } tokenIncorrect:^{
            NSLog(@"token错误");
        }];
        self.window.rootViewController = [mainStoryboard instantiateInitialViewController];
        [self.window makeKeyAndVisible];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
