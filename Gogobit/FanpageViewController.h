//
//  FanpageViewController.h
//  Gogobit
//
//  Created by Wilson H. on 5/8/16.
//  Copyright © 2016 Wilson H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface FanpageViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *fanpageWebView;
@property (nonatomic, weak) MBProgressHUD *hud;

@end
