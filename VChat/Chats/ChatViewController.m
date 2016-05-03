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
    if(self.conversationType == ConversationType_PRIVATE) {
        self.displayUserNameInCell = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
