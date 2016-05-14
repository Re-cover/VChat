//
//  SystemMessageViewController.m
//  VChat
//
//  Created by Recover on 16/5/15.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "SystemMessageViewController.h"
#import "FriendInfoModel.h"
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
    [self performSegueWithIdentifier:@"toFriendInfoView" sender:model];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}


@end
