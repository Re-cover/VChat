//
//  WebViewController.m
//  VChat
//
//  Created by Recover on 16/5/19.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "WebViewController.h"
#import <NJKWebViewProgressView.h>

@interface WebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet NJKWebViewProgressView *webViewProgressView;

@property (strong, nonatomic) NJKWebViewProgress *webViewProgress;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webViewProgress = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = self.webViewProgress;
    self.webViewProgress.webViewProxyDelegate = self;
    self.webViewProgress.progressDelegate = self;
    self.webViewProgressView.progressBarView.backgroundColor = kVChatGreen;
    [self.webViewProgressView setProgress:0 animated:YES];
    NSURL *url = [NSURL URLWithString:self.urlString];
    self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    self.webViewProgressView.hidden = NO;
    [self.webViewProgressView setProgress:progress animated:YES];
//    if (progress == 1.0) {
//        self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
