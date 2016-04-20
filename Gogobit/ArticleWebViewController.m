//
//  ArticleWebViewController.m
//  Gogobit
//
//  Created by Wilson H. on 4/11/16.
//  Copyright © 2016 Wilson H. All rights reserved.
//

#import "ArticleWebViewController.h"

@interface ArticleWebViewController ()

@end

@implementation ArticleWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.articleUrl]];
    self.articleWebView.delegate = self;
    self.articleWebView.scalesPageToFit = YES;
    [self.articleWebView loadRequest:request];
    // Do any additional setup after loading the view.
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.hud.labelText = NSLocalizedString(@"讀取中...", @"");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.hud hide:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
