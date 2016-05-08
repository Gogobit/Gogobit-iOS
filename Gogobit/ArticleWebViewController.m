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

//NSInteger webViewLoads = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.articleUrl]];
    self.articleWebView.delegate = self;
    self.articleWebView.scalesPageToFit = YES;
    [self.articleWebView loadRequest:request];
    // Do any additional setup after loading the view.
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(forcedToStopHud) userInfo:nil repeats:NO];
    if (self.count == 0) {
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.labelText = NSLocalizedString(@"讀取中...", @"");
        self.count++;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"Web View Did Fail Load With Error : %@",error);
    [self.hud hide:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.hud hide:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)forcedToStopHud {
    [self.hud hide:YES];
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
