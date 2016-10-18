//
//  ArticleWebViewController.h
//  Gogobit
//
//  Created by Wilson H. on 4/11/16.
//  Copyright © 2016 Wilson H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ArticleWebViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *articleWebView;
@property (nonatomic, weak) MBProgressHUD *hud;
@property (nonatomic, weak) NSString *articleUrl;
@property (nonatomic) NSInteger count;

@end
