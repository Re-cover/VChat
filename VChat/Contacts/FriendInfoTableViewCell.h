//
//  FriendInfoTableViewCell.h
//  VChat
//
//  Created by Recover on 16/5/14.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@property (weak, nonatomic) IBOutlet UILabel *vChatIDLabel;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@end
