//
//  SystemMessageViewController.m
//  VChat
//
//  Created by Recover on 16/5/15.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "SystemMessageViewController.h"
#import "FriendInfoModel.h"
#import "FriendInfoViewController.h"
#import <AVQuery.h>

@interface SystemMessageViewController ()

@end

@implementation SystemMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self setDisplayConversationTypes: @[@(ConversationType_SYSTEM)]];
    [self setCollectionConversationType: nil];
    self.isEnteredToCollectionViewController = YES;
}

-(void)dealloc {
    NSLog(@"释放%@", self.classForCoder);
}

# pragma mark - 点击会话列表cell的回调
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", model.targetId);
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:model.targetId
                                 block:^(AVObject *object, NSError *error) {
                                     if (error == nil) {
                                         NSLog(@"%@", object);
                                         [self performSegueWithIdentifier:@"toFriendInfoView" sender:object];
                                     }
                                 }];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AVObject *object = (AVObject *)sender;
    FriendInfoViewController *controller = segue.destinationViewController;
    controller.model.objectId = object.objectId;
    controller.model.avatarUrl = [object valueForKey:@"avatarURL"];
    controller.model.vChatId = [object valueForKey:@"username"];
    controller.model.nickName = [object valueForKey:@"nickName"];
    controller.model.phoneNumber = [object valueForKey:@"mobilePhoneNumber"];
    controller.model.area =[object valueForKey:@"area"];
    controller.model.signature = [object valueForKey:@"signature"];\
    controller.model.isFriend = NO;
}


@end
