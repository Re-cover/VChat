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
#import <AVStatus.h>

@interface SystemMessageViewController ()

@property (nonatomic, strong) FriendInfoModel *model;

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
    self.conversationModel = model;
    NSLog(@"%@", model.targetId);
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:model.targetId
                                 block:^(AVObject *object, NSError *error) {
                                     if (error == nil) {
                                         [self setModelWith: object];
                                         [self performSegueWithIdentifier:@"toFriendInfoView" sender:nil];
                                     }
                                 }];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    FriendInfoViewController *controller = segue.destinationViewController;
    controller.model = self.model;
    controller.conversationModel = self.conversationModel;
    controller.isReciveFriendRequest = !self.model.isFriend;
}

# pragma mark Setters

- (void)setModelWith:(AVObject *)object {
    _model = [[FriendInfoModel alloc] init];
    _model.objectId = object.objectId;
    _model.avatarUrl = [object valueForKey:@"avatarURL"];
    _model.vChatId = [object valueForKey:@"username"];
    _model.nickName = [object valueForKey:@"nickName"];
    _model.phoneNumber = [object valueForKey:@"mobilePhoneNumber"];
    _model.area =[object valueForKey:@"area"];
    _model.signature = [object valueForKey:@"signature"];
    _model.isFriend = NO;
//    [[AVUser currentUser] getFollowees:^(NSArray *objects, NSError *error) {
//        if (error == nil) {
//            AVObject *followee;
//            for(followee in objects){
//                if(followee.objectId == _model.objectId)
//                    _model.isFriend = YES;
//            }
//        } else {
//            NSLog(@"%@", error.description);
//        }
//    }];
}

@end
