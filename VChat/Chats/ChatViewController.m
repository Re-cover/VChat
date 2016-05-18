//
//  ChatViewController.m
//  VChat
//
//  Created by Recover on 16/5/1.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "ChatViewController.h"
#import <RongIMKit/RongIMKit.h>

@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.conversationType == ConversationType_PRIVATE || self.conversationType == ConversationType_SYSTEM) {
        self.displayUserNameInCell = NO;
        [self setMessagePortraitSize:CGSizeMake(42, 42)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
