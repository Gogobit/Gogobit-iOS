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
@property (nonatomic, strong) NSTimer *autoTimer;
@property (nonatomic, strong) NSTimer *updateTimer;
@end

@implementation CurrencyListViewController

int secondsLeft;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [[UIScreen mainScreen] bounds].size.width, 20)];
    statusBarView.backgroundColor = [UIColor colorWithRed:26/255.0f green:26/255.0f blue:26/255.0f alpha:0.9f];
    [self.navigationController.navigationBar addSubview:statusBarView];
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

    [self getUsdToTwdCurrency];
    [self getAllExchangesCurrency];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = NSLocalizedString(@"讀取中...", @"");
    NSLog(@"%@", [self uuid]);
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.fillMode = kCAFillModeForwards;
    transition.duration = 0.5;
    transition.subtype = kCATransitionFromTop;

    [[self.currencyTableView layer] addAnimation:transition forKey:@"UITableViewReloadDataAnimationKey"];
    self.avgPriceLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToChangeAvgCurrencyType)];
    [self.avgPriceLabel addGestureRecognizer:tapGesture];
}

- (void)tapToChangeAvgCurrencyType {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"currencyType"] isEqualToString:@"TWD"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"USD" forKey:@"currencyType"];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setObject:@"TWD" forKey:@"currencyType"];
    }
    [self getAveragePrice];
    [self.currencyTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"交易所";
    [self getAveragePrice];
    [self.currencyTableView reloadData];
    [[GogobitHttpClient sharedClient] checkNetworkReachableWithSender:self];
    [[GogobitHttpClient sharedClient] getNewsSourceListWithSender:self];
    secondsLeft = [[[NSUserDefaults standardUserDefaults] objectForKey:@"secondsForUpdate"] intValue];
    self.autoTimer = [NSTimer scheduledTimerWithTimeInterval:[[[NSUserDefaults standardUserDefaults] objectForKey:@"secondsForUpdate"] floatValue] target:self selector:@selector(getAllExchangesCurrency) userInfo:nil repeats:YES];
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCountdown) userInfo:nil repeats: YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.autoTimer invalidate];
    [self.updateTimer invalidate];
}

- (void)updateCountdown {
    secondsLeft--;
    self.countDownLabel.text = [NSString stringWithFormat:@"還有 %02d 秒更新", secondsLeft];
    if (secondsLeft == 0) {
        secondsLeft = [[[NSUserDefaults standardUserDefaults] objectForKey:@"secondsForUpdate"] intValue];;
    }
}

- (void)getAveragePrice {
    float sum = 0, flag = 0;
    for (int i = 0; i < self.priceFlagArray.count; i++) {
        flag += [self.priceFlagArray[i] intValue];
    }
    for (int i = 0; i < [self.priceFlagArray count]; i++) {
        if (self.priceFlagArray[i] > 0) {
            sum += [self.currencyList[i] floatValue];
        }
    }
    NSNumber *averagePrice = [[NSNumber alloc] initWithFloat:sum / flag];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"currencyType"] isEqualToString:@"TWD"]) {
        double currency = [[[NSUserDefaults standardUserDefaults] objectForKey:@"currency"] doubleValue];
        if (![self.avgPriceLabel.text isEqualToString:[NSString stringWithFormat:@"%.2f", [averagePrice floatValue] * currency]]) {
//            [UIView beginAnimations:@"FlipCellAnimation" context:nil];
//            [UIView setAnimationDuration:1.0];
//            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.avgPriceLabel cache:YES];
//            [self.avgPriceLabel removeFromSuperview];
            if (isnan([averagePrice floatValue] * currency)) {
                self.avgPriceLabel.text = @"Calculating...";
            }
            else {
                self.avgPriceLabel.text = [NSString stringWithFormat:@"%.2f", [averagePrice floatValue] * currency];
            }

//            [self.view addSubview:self.avgPriceLabel];
//            [UIView commitAnimations];
        }
    }
    else {
        if (![self.avgPriceLabel.text isEqualToString:[NSString stringWithFormat:@"%.2f", [averagePrice floatValue]]]) {
//            [UIView beginAnimations:@"FlipCellAnimation" context:nil];
//            [UIView setAnimationDuration:1.0];
//            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.avgPriceLabel cache:YES];
//            [self.avgPriceLabel removeFromSuperview];
            if (isnan([averagePrice floatValue])) {
                self.avgPriceLabel.text = @"Calculating...";
            }
            else {
                self.avgPriceLabel.text = [NSString stringWithFormat:@"%.2f", [averagePrice floatValue]];
            }
//            [self.view addSubview:self.avgPriceLabel];
//            [UIView commitAnimations];
        }
    }
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

- (void)getAllExchangesCurrency {
    NSLog(@"getAllExchangesCurrency!");
    [[GogobitHttpClient sharedClient] getYesterDayPriceWithSender:self];
    [[GogobitHttpClient sharedClient] getExchangePriceWithName:Coinbase andSender:self];
    [[GogobitHttpClient sharedClient] getExchangePriceWithName:Bitstamp andSender:self];
    [[GogobitHttpClient sharedClient] getExchangePriceWithName:Maicoin andSender:self];
    [[GogobitHttpClient sharedClient] getExchangePriceWithName:Okcoin andSender:self];
    [[GogobitHttpClient sharedClient] getExchangePriceWithName:Bitfinex andSender:self];
}

- (void)appCheckNetworkDidFailWithStatus:(NSUInteger)status {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:NSLocalizedString(@"錯誤", @"")
                                message:NSLocalizedString(@"您目前沒有網路連線，請檢查後再試。", @"")
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"我知道了", @"")
                                                      style:UIAlertActionStyleDefault
                                                    handler:nil];
    [alert addAction:confirm];
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusReachableViaWiFi:
        case AFNetworkReachabilityStatusReachableViaWWAN:
            break;
        case AFNetworkReachabilityStatusNotReachable:
            NSLog(@"no connection!");
            [self.hud hide:YES];
            [self presentViewController:alert animated:YES completion:nil];
            break;
        default:
            break;
    }
}

- (void)flowDidGetNewsSourceListWithData:(id)data {
//    NSLog(@"In News :%@", data);
    NSArray *sourceList = [NSArray arrayWithArray:data];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedInteger:sourceList.count] forKey:@"sourceNum"];
    [[NSUserDefaults standardUserDefaults] setObject:sourceList forKey:@"sourceList"];
}

- (void)flowGetSourceDidFailWithCode:(NSInteger)code andResponse:(NSString *)errorResponse {
    NSLog(@"flowGetSourceDidFailWithCode: %ld", (long)code);
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
    [self getAveragePrice];
}

- (void)boardGetExchangePriceDidFailWithCode:(NSInteger)code name:(NSInteger)name andResponse:(NSString *)errorResponse {
    NSLog(@"protocol client fail code: %ld , name: %ld", (long)code, (long)name);
    NSLog(@"errorResponse: %@", errorResponse);
}

- (void)handleRefresh:(UIRefreshControl *)refreshControl {
    secondsLeft = [[[NSUserDefaults standardUserDefaults] objectForKey:@"secondsForUpdate"] intValue];
    [self.autoTimer invalidate];
    self.autoTimer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(getAllExchangesCurrency) userInfo:nil repeats:YES];
    [self getAllExchangesCurrency];
    [refreshControl endRefreshing];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == Bitoex) {
        [self performSegueWithIdentifier:@"ToBrokerDetailSegue" sender:self];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(ExchangeTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    float yesterdayPrice = [[[NSUserDefaults standardUserDefaults] objectForKey:@"YesterdayPriceNumber"] floatValue];
    float rate = (([self.currencyList[indexPath.row] floatValue] - yesterdayPrice) / yesterdayPrice) * 100;
    ExchangeTableViewCell *cell = (ExchangeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ExchangeTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    if (tableView == self.currencyTableView) {
        cell.backgroundColor = [UIColor clearColor];
        if ([self.currencyList[indexPath.row] floatValue] > 0.1) {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"currencyType"] isEqualToString:@"TWD"]) {
                double currency = [[[NSUserDefaults standardUserDefaults] objectForKey:@"currency"] doubleValue];
                if (![cell.priceLabel.text isEqualToString:[NSString stringWithFormat:@"%.2f", [self.currencyList[indexPath.row] floatValue] * currency]]) {
                    [UIView beginAnimations:@"FlipCellAnimation" context:nil];
                    [UIView setAnimationDuration:1.0];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:cell.priceLabel cache:YES];
                    [cell removeFromSuperview];
                    cell.priceLabel.text = [NSString stringWithFormat:@"%.2f", [self.currencyList[indexPath.row] floatValue] * currency];
                    [cell.contentView addSubview:cell.priceLabel];
                    [UIView commitAnimations];
                }
            }
            else {
                if (![cell.priceLabel.text isEqualToString:[NSString stringWithFormat:@"%.2f", [self.currencyList[indexPath.row] floatValue]]]) {
                    [UIView beginAnimations:@"FlipCellAnimation" context:nil];
                    [UIView setAnimationDuration:1.0];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:cell.priceLabel cache:YES];
                    [cell removeFromSuperview];
                    cell.priceLabel.text = [NSString stringWithFormat:@"%.2f", [self.currencyList[indexPath.row] floatValue]];
                    [cell.contentView addSubview:cell.priceLabel];
                    [UIView commitAnimations];
                }
            }
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

- (void)boardDidGetYesterdayPriceWithData:(id)data {
    float yesterdayPrice = [data[@"data"][@"amount"] floatValue];
    NSNumber *yesterdayPriceNumber = [NSNumber numberWithFloat:yesterdayPrice];
    [[NSUserDefaults standardUserDefaults] setObject:yesterdayPriceNumber forKey:@"YesterdayPriceNumber"];
    [self.currencyTableView reloadData];
}

- (void)boardGetYesterdayPriceDidFailWithCode:(NSInteger)code andResponse:(NSString *)errorResponse {
    NSLog(@"protocol client fail code: %ld", (long)code);
    NSLog(@"errorResponse: %@", errorResponse);
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

- (NSString *)uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

@end
