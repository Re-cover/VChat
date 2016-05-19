//
//  WebViewController.h
//  VChat
//
//  Created by Recover on 16/5/19.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NJKWebViewProgress.h>

@interface WebViewController : UIViewController<UIWebViewDelegate, NJKWebViewProgressDelegate>

@property (nonatomic, copy) NSString *urlString;

@end
