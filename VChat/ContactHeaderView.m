//
//  ContactHeaderView.m
//  VChat
//
//  Created by Recover on 2016/11/28.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "ContactHeaderView.h"

@implementation ContactHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)viewFromNib {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return views[0];
}

@end
