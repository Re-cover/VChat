//
//  BaseViewController.m
//  VChat
//
//  Created by Recover on 16/4/29.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "BaseViewController.h"
#import <UINavigationController+FDFullscreenPopGesture.h>

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)dealloc
{
    //[super dealloc];
    NSLog(@"释放%@", self.classForCoder);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
