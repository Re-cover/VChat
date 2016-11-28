//
//  ContactHeaderView.h
//  VChat
//
//  Created by Recover on 2016/11/28.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *label;

+ (instancetype)viewFromNib;

@end
