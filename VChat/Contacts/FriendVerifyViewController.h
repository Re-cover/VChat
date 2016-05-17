//
//  FriendVerifyViewController.h
//  VChat
//
//  Created by Recover on 16/5/16.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendInfoModel;

@interface FriendVerifyViewController : UIViewController<UITableViewDataSource>

@property (strong, nonatomic) FriendInfoModel *model;

@end
