//
//  FeedbackWebViewController.m
//  Gogobit
//
//  Created by Wilson H. on 3/6/16.
//  Copyright © 2016 Wilson H. All rights reserved.
//

#import "FeedbackWebViewController.h"

@interface FeedbackWebViewController () <UIWebViewDelegate>

@end

@implementation FeedbackWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"回饋意見";
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://wilsonhuang.typeform.com/to/FK0qpl"]];
    self.feedbackWebView.delegate = self;
    self.feedbackWebView.scalesPageToFit = YES;
    [self.feedbackWebView loadRequest:request];
    // Do any additional setup after loading the view.
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
