//
//  ViewController.m
//  Gogobit
//
//  Created by Wilson H. on 11/3/15.
//  Copyright © 2015 Wilson H. All rights reserved.
//

#import "CurrencyListViewController.h"

@interface CurrencyListViewController ()

@property (nonatomic, strong) NSMutableArray *exchangeNameList;
@property (nonatomic, strong) NSMutableArray *currencyList;
@end

@implementation CurrencyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currencyTableView.dataSource = self;
    self.currencyTableView.rowHeight = UITableViewAutomaticDimension;
    self.currencyTableView.estimatedRowHeight = 120;

    self.exchangeNameList = [[NSMutableArray alloc] initWithArray:@[@"Coinbase", @"Bitstamp", @"Maicoin", @"OKCoin", @"Bitfinex"]];
    self.currencyList = [[NSMutableArray alloc] init];
    [self getAllExchangeCurrencyToList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.text = self.exchangeNameList[indexPath.row];
    cell.detailTextLabel.text = self.currencyList[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.exchangeNameList.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getAllExchangeCurrencyToList {
    NSMutableDictionary *responseObject = [[NSMutableDictionary alloc] init];
    NSString *coinbasePriceString = [[NSString alloc] init];
    NSString *bitstampPriceString = [[NSString alloc] init];
    NSString *maicoinPriceString = [[NSString alloc] init];
    NSString *okcoinPriceString = [[NSString alloc] init];
    NSString *bitfinexPriceString = [[NSString alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    NSData *coinbaseResponseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://api.coinbase.com/v2/prices/buy"] options:NSDataReadingUncached error:nil];
    NSData *bitstampResponseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://www.bitstamp.net/api/ticker/"] options:NSDataReadingUncached error:nil];
    NSData *maicoinResponseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://api.maicoin.com/v1/prices/usd"] options:NSDataReadingUncached error:nil];
    NSData *okcoinResponseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://www.okcoin.com/api/ticker.do?ok=1"] options:NSDataReadingUncached error:nil];
    NSData *bitfinexResponseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://api.bitfinex.com/v1/pubticker/BTCUSD"] options:NSDataReadingUncached error:nil];

    if (coinbaseResponseData) {
        responseObject = [NSJSONSerialization JSONObjectWithData:coinbaseResponseData options:NSUTF8StringEncoding error:nil];
        coinbasePriceString = responseObject[@"data"][@"amount"];
        [self.currencyList addObject:coinbasePriceString];
    }
    if (bitstampResponseData) {
        responseObject = [NSJSONSerialization JSONObjectWithData:bitstampResponseData options:NSUTF8StringEncoding error:nil];
        bitstampPriceString = responseObject[@"last"];
        [self.currencyList addObject:bitstampPriceString];
    }
    if (maicoinResponseData) {
        responseObject = [NSJSONSerialization JSONObjectWithData:maicoinResponseData options:NSUTF8StringEncoding error:nil];
        maicoinPriceString = responseObject[@"price"];
        [self.currencyList addObject:maicoinPriceString];
    }
    if (okcoinResponseData) {
        responseObject = [NSJSONSerialization JSONObjectWithData:okcoinResponseData options:NSUTF8StringEncoding error:nil];
        okcoinPriceString = responseObject[@"ticker"][@"last"];
        [self.currencyList addObject:okcoinPriceString];
    }
    if (bitfinexResponseData) {
        responseObject = [NSJSONSerialization JSONObjectWithData:bitfinexResponseData options:NSUTF8StringEncoding error:nil];
        bitfinexPriceString = responseObject[@"last_price"];
        [self.currencyList addObject:bitfinexPriceString];
    }
}

@end
