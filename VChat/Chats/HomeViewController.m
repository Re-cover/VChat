//
//  HomeViewController.m
//  VChat
//
//  Created by Recover on 16/4/30.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "ChatViewController.h"
#import <RealReachability.h>

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UITableView *HomeTableView;

@end

@implementation HomeViewController


#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)dealloc {
    NSLog(@"释放%@", self.classForCoder);
}


# pragma mark - 
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"toChatView" sender:model];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ChatViewController *vc = segue.destinationViewController;
    RCConversationModel *model = sender;
    vc.conversationType = model.conversationType;
    vc.targetId = model.targetId;
    vc.title = model.conversationTitle;
}

@end
