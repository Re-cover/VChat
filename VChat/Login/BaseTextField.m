//
//  BaseTextField.m
//  VChat
//
//  Created by Recover on 16/3/23.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "BaseTextField.h"

@implementation BaseTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 40, 0);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 40, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 40, 0);
}

@end
