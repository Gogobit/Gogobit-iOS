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
    self.exchangeNameList = [[NSMutableArray alloc] initWithArray:@[@"Coinbase", @"Bitstamp", @"Maicoin", @"OKCoin", @"Bitfinex"]];
    [self.inputTextField addTarget:self
                  action:@selector(inputTextFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    self.currencyPickerView.dataSource = self;
    self.currencyPickerView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)inputTextFieldDidChange:(id)sender {
    self.mainRateLabel.text = [NSString stringWithFormat:@"%.3lf", [self.inputTextField.text integerValue] * 367.32];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return [self.exchangeNameList count];
            break;

        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return [self.exchangeNameList objectAtIndex:row];
            break;

        default:
            return @"Error";
            break;
    }
}
@end
