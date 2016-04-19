//
//  ExchangeRateViewController.m
//  Gogobit
//
//  Created by Wilson H. on 11/6/15.
//  Copyright © 2015 Wilson H. All rights reserved.
//

#import "ExchangeRateViewController.h"

@implementation ExchangeRateViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    self.rate = 13994.12;
    self.btcSelectedButton.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.2f];
    self.exchangeNameList = [[NSMutableArray alloc] initWithArray:@[@"Coinbase", @"Bitstamp", @"Maicoin(USD)", @"Maicoin(NTD)", @"OKCoin", @"Bitfinex"]];

    self.isUserEntering = NO;
    self.isFiatDisplaySelected = NO;
    self.isFloatPointAppear = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"比特幣換算機";
    NSNumber *averageUsdPrice = [[NSUserDefaults standardUserDefaults] objectForKey:@"AveragePrice"];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"currencyType"] isEqualToString:@"TWD"]) {
        self.rate = [averageUsdPrice doubleValue] * [[[NSUserDefaults standardUserDefaults] objectForKey:@"currency"] doubleValue];
        [self.fiatCurrencyTypeButton setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"currencyType"] forState:UIControlStateNormal];
    }
    else {
        self.rate = [averageUsdPrice doubleValue];
        [self.fiatCurrencyTypeButton setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"currencyType"] forState:UIControlStateNormal];
    }

}

- (IBAction)selectFiat:(UIButton *)sender {
    self.isFiatDisplaySelected = YES;
    self.fiatDisplayLabel.text = @"0";
    self.isUserEntering = NO;
    self.isFloatPointAppear = NO;
    self.btcSelectedButton.backgroundColor = [UIColor clearColor];
    self.fiatSelectedButton.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.2f];
}

- (IBAction)selectBtc:(UIButton *)sender {
    self.isFiatDisplaySelected = NO;
    self.btcDisplayLabel.text = @"0";
    self.isUserEntering = NO;
    self.isFloatPointAppear = NO;
    self.fiatSelectedButton.backgroundColor = [UIColor clearColor];
    self.btcSelectedButton.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.2f];
}

- (IBAction)pressDigit:(UIButton *)sender {
    NSString *digitChar = [NSString stringWithFormat:@"%@", sender.currentTitle];
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"(([0-9]*[.]*[0-9]*)*)"
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    if (self.isFiatDisplaySelected) {
        NSString *resultString = [NSString stringWithFormat:@"%@%@", self.fiatDisplayLabel.text, digitChar];
        if (self.isUserEntering) {
            [regex enumerateMatchesInString:resultString options:0 range:NSMakeRange(0, [resultString length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                // your code to handle matches here
                NSLog(@"%@", @"match!");
                self.fiatDisplayLabel.text = resultString;
            }];
        }
        else {
            self.fiatDisplayLabel.text = digitChar;
            self.isUserEntering = YES;
        }
        double result = [self.fiatDisplayLabel.text doubleValue];
        self.btcDisplayLabel.text = [NSString stringWithFormat:@"%.8f", result / self.rate];
    }
    else {
        NSString *resultString = [NSString stringWithFormat:@"%@%@", self.btcDisplayLabel.text, digitChar];
        if (self.isUserEntering) {
            [regex enumerateMatchesInString:resultString options:0 range:NSMakeRange(0, [resultString length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                // your code to handle matches here
                NSLog(@"%@", @"match!");
                self.btcDisplayLabel.text = resultString;
            }];
        }
        else {
            self.btcDisplayLabel.text = digitChar;
            self.isUserEntering = YES;
        }
        double result = [self.btcDisplayLabel.text doubleValue];
        self.fiatDisplayLabel.text = [NSString stringWithFormat:@"%.3f", result * self.rate];
    }



    NSLog(@"%@", @"pressDigit!");
}

- (IBAction)pressDelete:(UIButton *)sender {
    if (self.isFiatDisplaySelected) {
        if (self.fiatDisplayLabel.text.length > 1) {
            NSString *lastChar = [self.fiatDisplayLabel.text substringFromIndex:[self.fiatDisplayLabel.text length] - 1];
            if ([lastChar isEqualToString:@"."]) {
                self.isFloatPointAppear = NO;
            }
            self.fiatDisplayLabel.text = [self.fiatDisplayLabel.text substringToIndex:[self.fiatDisplayLabel.text length] - 1];
        }
        else {
            self.fiatDisplayLabel.text = @"0";
            self.isUserEntering = NO;
            self.isFloatPointAppear = NO;
        }
        double result = [self.fiatDisplayLabel.text doubleValue];
        self.btcDisplayLabel.text = [NSString stringWithFormat:@"%.8f", result / self.rate];
    }
    else {
        if (self.btcDisplayLabel.text.length > 1) {
            NSString *lastChar = [self.btcDisplayLabel.text substringFromIndex:[self.btcDisplayLabel.text length] - 1];
            if ([lastChar isEqualToString:@"."]) {
                self.isFloatPointAppear = NO;
            }
            self.btcDisplayLabel.text = [self.btcDisplayLabel.text substringToIndex:[self.btcDisplayLabel.text length] - 1];
        }
        else {
            self.btcDisplayLabel.text = @"0";
            self.isUserEntering = NO;
            self.isFloatPointAppear = NO;
        }
        double result = [self.btcDisplayLabel.text doubleValue];
        self.fiatDisplayLabel.text = [NSString stringWithFormat:@"%.3f", result * self.rate];
    }
}

- (IBAction)pressPoint:(UIButton *)sender {
    if (self.isFiatDisplaySelected) {
        if (self.isUserEntering) {
            if (!self.isFloatPointAppear) {
                self.fiatDisplayLabel.text = [NSString stringWithFormat:@"%@%@", self.fiatDisplayLabel.text, @"."];
                self.isFloatPointAppear = YES;
            }
        }
        else {
            self.fiatDisplayLabel.text = @"0.";
            self.isUserEntering = YES;
            self.isFloatPointAppear = YES;
        }
    }
    else {
        if (self.isUserEntering) {
            if (!self.isFloatPointAppear) {
                self.btcDisplayLabel.text = [NSString stringWithFormat:@"%@%@", self.btcDisplayLabel.text, @"."];
                self.isFloatPointAppear = YES;
            }
        }
        else {
            self.btcDisplayLabel.text = @"0.";
            self.isUserEntering = YES;
            self.isFloatPointAppear = YES;
        }
    }
}

- (void)appDidGetMaicoinTWDWithData:(NSDictionary *)data {
//    NSLog(data);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
