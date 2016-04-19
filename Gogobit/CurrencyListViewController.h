//
//  ViewController.h
//  Gogobit
//
//  Created by Wilson H. on 11/3/15.
//  Copyright © 2015 Wilson H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "GogobitHttpClient.h"

NSString *const DAILY_USD_PRICE_API = @"https://api.coinbase.com/v2/prices/historic?days=1";
NSString *const YAHOO_USDTWD_CURRENCY_API = @"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22USDTWD%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=";

@interface CurrencyListViewController : UIViewController <UITableViewDataSource, GogobitHttpProtocol>

@property (weak, nonatomic) IBOutlet UILabel *avgPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *avgPriceUnitLabel;
@property (weak, nonatomic) IBOutlet UITableView *currencyTableView;
@property (nonatomic, weak) MBProgressHUD *hud;

@end

