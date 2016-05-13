//
//  BlurView.m
//  VChat
//
//  Created by Recover on 16/5/14.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "BlurView.h"

@implementation BlurView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIBlurEffect* blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView* effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        effectView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:effectView];
    }
    return self;
}

@end
