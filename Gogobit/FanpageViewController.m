//
//  FanpageViewController.m
//  Gogobit
//
//  Created by Wilson H. on 5/8/16.
//  Copyright © 2016 Wilson H. All rights reserved.
//

#import "FanpageViewController.h"

@interface FanpageViewController ()

@end

@implementation FanpageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"粉絲專頁";
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.facebook.com/Gogobit2016/"]];
    self.fanpageWebView.delegate = self;
    self.fanpageWebView.scalesPageToFit = YES;
    [self.fanpageWebView loadRequest:request];
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
