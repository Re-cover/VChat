//
//  FriendInfoViewController.h
//  VChat
//
//  Created by Recover on 16/5/14.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendInfoModel.h"
#import <RongIMKit/RCConversationModel.h>

@interface FriendInfoViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) FriendInfoModel *model;

@property (nonatomic, strong) RCConversationModel *conversationModel;

@property (nonatomic, assign) BOOL isReciveFriendRequest;

@end
