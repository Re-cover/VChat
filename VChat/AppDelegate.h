//
//  AppDelegate.h
//  VChat
//
//  Created by Recover on 16/3/21.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RCIM.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,RCIMUserInfoDataSource>

@property (strong, nonatomic) UIWindow *window;


@end

