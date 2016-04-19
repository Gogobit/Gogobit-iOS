//
//  ViewController.m
//  Gogobit
//
//  Created by Wilson H. on 11/3/15.
//  Copyright © 2015 Wilson H. All rights reserved.
//

#import "CurrencyListViewController.h"
#import "ExchangeTableViewCell.h"

@interface CurrencyListViewController ()

@property (nonatomic, strong) NSMutableArray *exchangeNameList;
@property (nonatomic, strong) NSMutableArray *currencyList;
@property (nonatomic, strong) NSMutableArray *exchangeImagePathList;
@property (nonatomic, strong) NSMutableArray *priceFlagArray;
@property (nonatomic, strong) NSString *usdToTwdCurrenyString;
@property (nonatomic, strong) AFHTTPRequestOperationManager *reachabilityManager;

@end

@implementation CurrencyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getAveragePrice)
                                                 name:@"NowCanGetAveragePrice"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getBitoexPrice)
                                                 name:@"DidGetUsdTwdRate"
                                               object:nil];
    self.currencyTableView.dataSource = self;
    self.currencyTableView.rowHeight = 60;
    self.priceFlagArray = [[NSMutableArray alloc] initWithArray:@[@0, @0, @0, @0, @0, @0]];
    self.exchangeNameList = [[NSMutableArray alloc] initWithArray:@[@"Coinbase", @"Bitstamp", @"Maicoin", @"OKCoin", @"Bitfinex", @"Bitoex"]];
    self.currencyList = [[NSMutableArray alloc] initWithArray:@[@"Loading...", @"Loading...", @"Loading...", @"Loading...", @"Loading...", @"Loading..."]];
    self.exchangeImagePathList = [[NSMutableArray alloc] initWithArray:@[@"CoinbaseLogo", @"BitstampLogo", @"MaicoinLogo", @"OkcoinLogo", @"BitfinexLogo", @"BitoexLogo"]];
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.currencyTableView addSubview:refreshControl];
    [self.currencyTableView sendSubviewToBack:refreshControl];
    self.currencyTableView.backgroundColor = [UIColor clearColor];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = NSLocalizedString(@"讀取中...", @"");
}

- (void)getAveragePrice {
    float sum = 0;
    for (int i = 0; i < [self.priceFlagArray count]; i++) {
        sum += [self.currencyList[i] floatValue];
    }
    self.avgPriceLabel.text = [NSString stringWithFormat:@"%.2f", sum / self.currencyList.count];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"currencyType"] isEqualToString:@"TWD"]) {
        double currency = [[[NSUserDefaults standardUserDefaults] objectForKey:@"currency"] doubleValue];
        self.avgPriceLabel.text = [NSString stringWithFormat:@"%.2f", sum / self.currencyList.count * currency];
    }
    NSNumber *averagePrice = [[NSNumber alloc] initWithFloat:sum / self.currencyList.count];
    [[NSUserDefaults standardUserDefaults] setObject:averagePrice forKey:@"AveragePrice"];
    [self.hud hide:YES];
}

- (void)getUsdToTwdCurrency {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:YAHOO_USDTWD_CURRENCY_API parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.usdToTwdCurrenyString = responseObject[@"query"][@"results"][@"rate"][@"Rate"];
        [[NSUserDefaults standardUserDefaults] setObject:self.usdToTwdCurrenyString forKey:@"currency"];
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"DidGetUsdTwdRate"
         object:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error!");
    }];
}

- (void)checkGetAllPricesCompleted {
    int flag = 0;
    for (int i = 0; i < self.priceFlagArray.count; i++) {
        flag += [self.priceFlagArray[i] intValue];
    }
    if (flag >= self.priceFlagArray.count) {
        [self.hud hide:YES];
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"NowCanGetAveragePrice"
         object:self];
    }
}

- (void)getAllExchangesCurrency {
    [self getTodayPrice];
    [[GogobitHttpClient sharedClient] getExchangePriceWithName:Coinbase andSender:self];
    [[GogobitHttpClient sharedClient] getExchangePriceWithName:Bitstamp andSender:self];
    [[GogobitHttpClient sharedClient] getExchangePriceWithName:Maicoin andSender:self];
    [[GogobitHttpClient sharedClient] getExchangePriceWithName:Okcoin andSender:self];
    [[GogobitHttpClient sharedClient] getExchangePriceWithName:Bitfinex andSender:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"交易所";
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:NSLocalizedString(@"錯誤", @"")
                                message:NSLocalizedString(@"您目前沒有網路連接，請檢查後再試。", @"")
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"我知道了", @"")
                                                    style:UIAlertActionStyleDefault
                                                  handler:nil];
    [alert addAction:confirm];
    [self getUsdToTwdCurrency];
    for (int i = 0; i < [self.priceFlagArray count]; i++) {
        [self.priceFlagArray replaceObjectAtIndex:i withObject:@0];
    }
    [self getAllExchangesCurrency];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusReachableViaWiFi:
            case AFNetworkReachabilityStatusReachableViaWWAN:
                // Our connection is fine
                // Resume our requests or do nothing
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"no connection!");
                [self.hud hide:YES];
                [self presentViewController:alert animated:YES completion:nil];
                // We have no active connection - disable all requests and don’t let the user do anything
                break;
            default:
                // If we get here, we’re most likely timing out
                break;
        }
    }];
    // Set the reachabilityManager to actively wait for these events
    [manager.reachabilityManager startMonitoring];

}

- (void)boardDidGetExchangePriceWithName:(NSInteger)name andData:(id)data {
    float twdAveragePrice;
    switch (name) {
        case Coinbase:
            [self.currencyList replaceObjectAtIndex:name withObject:data[@"data"][@"amount"]];
            break;
        case Bitstamp:
            [self.currencyList replaceObjectAtIndex:name withObject:data[@"last"]];
            break;
        case Maicoin:
            [self.currencyList replaceObjectAtIndex:name withObject:[self unifyPriceFormat:data[@"price"]]];
            break;
        case Okcoin:
            [self.currencyList replaceObjectAtIndex:name withObject:data[@"ticker"][@"last"]];
            break;
        case Bitfinex:
            [self.currencyList replaceObjectAtIndex:name withObject:data[@"last_price"]];
            break;
        case Bitoex:
            twdAveragePrice = ([data[@"buy"] floatValue] + [data[@"sell"] floatValue]) / 2;
            [self.currencyList replaceObjectAtIndex:name withObject:[NSString stringWithFormat:@"%f", twdAveragePrice / [self.usdToTwdCurrenyString floatValue]]];
            break;
        default:
            break;
    }
    self.priceFlagArray[name] = @1;
    [self.currencyTableView reloadData];
    [self checkGetAllPricesCompleted];
}

- (void)boardGetExchangePriceDidFailWithCode:(NSInteger)code name:(NSInteger)name andResponse:(NSString *)errorResponse {
    NSLog(@"protocol client fail code: %ld , name: %ld", (long)code, (long)name);
    NSLog(@"error!");
}

- (void)handleRefresh:(UIRefreshControl *)refreshControl {
    for (int i = 0; i < [self.priceFlagArray count]; i++) {
        [self.priceFlagArray replaceObjectAtIndex:i withObject:@0];
    }
    [self getAllExchangesCurrency];
    [refreshControl endRefreshing];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    float todayPrice = [[[NSUserDefaults standardUserDefaults] objectForKey:@"TodayPriceNumber"] floatValue];
    float rate = (([self.currencyList[indexPath.row] floatValue] - todayPrice) / todayPrice) * 100;
    ExchangeTableViewCell *cell = (ExchangeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ExchangeTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    if (tableView == self.currencyTableView) {
        cell.backgroundColor = [UIColor clearColor];
        cell.priceLabel.text = [NSString stringWithFormat:@"%.2f", [self.currencyList[indexPath.row] floatValue]];

        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"currencyType"] isEqualToString:@"TWD"]) {
            double currency = [[[NSUserDefaults standardUserDefaults] objectForKey:@"currency"] doubleValue];
            cell.priceLabel.text = [NSString stringWithFormat:@"%.2f", [self.currencyList[indexPath.row] floatValue] * currency];
        }
        cell.unitLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"currencyType"];
        cell.exchangeNameLabel.text = self.exchangeNameList[indexPath.row];
        cell.exchangeImageView.image = [UIImage imageNamed:self.exchangeImagePathList[indexPath.row]];
        cell.rateLabel.text = [NSString stringWithFormat:@"%.1f%%", rate];
        if (rate >= 0) {
            cell.rateLabel.textColor = [UIColor greenColor];
            cell.arrowImageView.image = [UIImage imageNamed:@"greenArrow"];
        }
        else {
            cell.rateLabel.textColor = [UIColor redColor];
            cell.arrowImageView.image = [UIImage imageNamed:@"redArrow"];
        }
    }
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currencyList.count;
}

- (void)getTodayPrice {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:DAILY_USD_PRICE_API parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        float todayPrice = [responseObject[@"data"][@"prices"][0][@"price"] floatValue];
        NSNumber *todayPriceNumber = [NSNumber numberWithFloat:todayPrice];
        [[NSUserDefaults standardUserDefaults] setObject:todayPriceNumber forKey:@"TodayPriceNumber"];
        [self.currencyTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error!");
    }];
}

- (void)getBitoexPrice {
    [[GogobitHttpClient sharedClient] getExchangePriceWithName:Bitoex andSender:self];
}

- (NSString *)unifyPriceFormat:(NSString *)priceString {
    return [NSString stringWithFormat:@"%.2f", [priceString floatValue]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
