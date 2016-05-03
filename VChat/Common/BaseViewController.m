//
//  BaseViewController.m
//  VChat
//
//  Created by Recover on 16/4/29.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)dealloc {
    NSLog(@"释放%@", self.classForCoder);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
