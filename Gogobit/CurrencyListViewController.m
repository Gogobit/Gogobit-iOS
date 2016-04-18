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
//    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getAveragePrice)
                                                 name:@"NowCanGetAveragePrice"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getBitoexPrice)
                                                 name:@"DidGetUsdTwdRate"
                                               object:nil];
    self.currencyTableView.dataSource = self;
//    self.currencyTableView.rowHeight = UITableViewAutomaticDimension;
    self.currencyTableView.rowHeight = 60;
    self.priceFlagArray = [[NSMutableArray alloc] initWithArray:@[@0, @0, @0, @0, @0, @0]];
    self.exchangeNameList = [[NSMutableArray alloc] initWithArray:@[@"Coinbase", @"Bitstamp", @"Maicoin", @"OKCoin", @"Bitfinex", @"Bitoex"]];
    self.currencyList = [[NSMutableArray alloc] initWithArray:@[@"Loading...", @"Loading...", @"Loading...", @"Loading...", @"Loading...", @"Loading..."]];
    self.exchangeImagePathList = [[NSMutableArray alloc] initWithArray:@[@"CoinbaseLogo", @"BitstampLogo", @"MaicoinLogo", @"OkcoinLogo", @"BitfinexLogo", @"BitoexLogo"]];
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    refreshControl.tintColor = [UIColor whiteColor];
    self.currencyTableView.backgroundColor = [UIColor clearColor];
//    refreshControl.backgroundColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.currencyTableView addSubview:refreshControl];
    [self.currencyTableView sendSubviewToBack:refreshControl];
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
//        NSLog(responseObject[@"query"][@"results"][@"rate"][@"Rate"]);
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
    [self getCoinbasePrice];
    [self getbitstampPrice];
    [self getMaicoinPrice];
    [self getOkcoinPrice];
    [self getBitfinexPrice];
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
//    [tableView registerNib:[UINib nibWithNibName:@"ExchangeTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
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

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 60;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currencyList.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getTodayPrice {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:DAILY_USD_PRICE_API parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        float todayPrice = [responseObject[@"data"][@"prices"][0][@"price"] floatValue];
        NSNumber *todayPriceNumber = [NSNumber numberWithFloat:todayPrice];
        [[NSUserDefaults standardUserDefaults] setObject:todayPriceNumber forKey:@"TodayPriceNumber"];
        [self.currencyTableView reloadData];
//        self.priceFlagArray[0] = @1;
//        [self checkGetAllPricesCompleted];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error!");
    }];
}

- (void)getCoinbasePrice {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:COINBASE_USD_PRICE_API parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.currencyList replaceObjectAtIndex:0 withObject:responseObject[@"data"][@"amount"]];
        [self.currencyTableView reloadData];
        self.priceFlagArray[0] = @1;
        [self checkGetAllPricesCompleted];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error!");
    }];
}

- (void)getbitstampPrice {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.bitstamp.net/api/ticker/"]]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.currencyList replaceObjectAtIndex:1 withObject:responseObject[@"last"]];
        [self.currencyTableView reloadData];
        self.priceFlagArray[1] = @1;
        [self checkGetAllPricesCompleted];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error!");
    }];
    [operation start];
}
- (void)getMaicoinPrice {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.maicoin.com/v1/prices/usd"]]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.currencyList replaceObjectAtIndex:2 withObject:[self unifyPriceFormat:responseObject[@"price"]]];
        [self.currencyTableView reloadData];
        self.priceFlagArray[2] = @1;
        [self checkGetAllPricesCompleted];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error!");
    }];
    [operation start];
}

- (void)getOkcoinPrice {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:OKCOIN_USD_PRICE_API parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.currencyList replaceObjectAtIndex:3 withObject:responseObject[@"ticker"][@"last"]];
        [self.currencyTableView reloadData];
        self.priceFlagArray[3] = @1;
        [self checkGetAllPricesCompleted];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error!");
    }];
}

- (void)getBitfinexPrice {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:BITFINEX_USD_PRICE_API parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.currencyList replaceObjectAtIndex:4 withObject:responseObject[@"last_price"]];
        [self.currencyTableView reloadData];
        self.priceFlagArray[4] = @1;
        [self checkGetAllPricesCompleted];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error!");
    }];
}

- (void)getBitoexPrice {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:BITOEX_USD_PRICE_API parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        float twdAveragePrice = ([responseObject[@"buy"] floatValue] + [responseObject[@"sell"] floatValue]) / 2;
        [self.currencyList replaceObjectAtIndex:5 withObject:[NSString stringWithFormat:@"%f", twdAveragePrice / [self.usdToTwdCurrenyString floatValue]]];
        [self.currencyTableView reloadData];
        self.priceFlagArray[5] = @1;
        [self checkGetAllPricesCompleted];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error!");
    }];
}

- (NSString *)unifyPriceFormat:(NSString *)priceString {
    return [NSString stringWithFormat:@"%.2f", [priceString floatValue]];
}

@end
