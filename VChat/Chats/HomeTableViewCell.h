//
//  HomeTableViewCell.h
//  VChat
//
//  Created by Recover on 16/4/29.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *lastMessageLabel;

@end
