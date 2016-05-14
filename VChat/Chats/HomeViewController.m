//
//  HomeViewController.m
//  VChat
//
//  Created by Recover on 16/4/30.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "HomeViewController.h"
#import "ChatViewController.h"
#import "SystemMessageViewController.h"


@interface HomeViewController ()


@end

@implementation HomeViewController


#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_SYSTEM)]];
    [self setCollectionConversationType:@[@(ConversationType_SYSTEM)]];
}

-(void)dealloc {
    NSLog(@"释放%@", self.classForCoder);
}


# pragma mark - 点击会话列表cell的回调

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_COLLECTION) {
        [self performSegueWithIdentifier:@"toSystemMessageView" sender:nil];
    } else if (model.conversationModelType == ConversationType_PRIVATE){
        [self performSegueWithIdentifier:@"toChatView" sender:model];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"toChatView"]) {
        ChatViewController *vc = segue.destinationViewController;
        RCConversationModel *model = sender;
        vc.conversationType = model.conversationType;
        vc.targetId = model.targetId;
        vc.title = model.conversationTitle;
    }
}

@end
