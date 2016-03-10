//
//  FeedbackWebViewController.h
//  Gogobit
//
//  Created by Wilson H. on 3/6/16.
//  Copyright © 2016 Wilson H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface FeedbackWebViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *feedbackWebView;
@property (nonatomic, weak) MBProgressHUD *hud;

@end
