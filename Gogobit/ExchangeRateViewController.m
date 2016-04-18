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
//    [[self navigationController] setNavigationBarHidden:YES animated:YES];
//    self.navigationItem.title = @"比特幣換算機";
//    self.navigationController.navigationBar.topItem.title = @"比特幣換算機";
    self.rate = 13994.12;
    self.btcSelectedButton.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.2f];
    self.exchangeNameList = [[NSMutableArray alloc] initWithArray:@[@"Coinbase", @"Bitstamp", @"Maicoin(USD)", @"Maicoin(NTD)", @"OKCoin", @"Bitfinex"]];

    [self.usdInputField addTarget:self
                  action:@selector(usdInputTextFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    [self.btcInputField addTarget:self
                           action:@selector(btcInputTextFieldDidChange:)
                 forControlEvents:UIControlEventEditingChanged];

    self.currencyPickerView.dataSource = self;
    self.currencyPickerView.delegate = self;
    self.btcInputField.delegate = self;
    self.usdInputField.delegate = self;
    self.thinFont = [UIFont systemFontOfSize:50 weight:UIFontWeightThin];

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

- (void)keyboardWillShow:(NSNotification *)noti
{
    //键盘输入的界面调整
    //键盘的高度
    float height = 216.0;
    CGRect frame = self.view.frame;
    frame.size = CGSizeMake(frame.size.width, frame.size.height - height);
    [UIView beginAnimations:@"Curl"context:nil];//动画开始
    [UIView setAnimationDuration:0.30];
    [UIView setAnimationDelegate:self];
    [self.view setFrame:frame];
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    //CGRect rect = CGRectMake(0.0f, 20.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 286.0);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if (offset > 0) {
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        self.view.frame = rect;
    }
    [UIView commitAnimations];
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

- (IBAction)backgroundTap:(id)sender {
    [self.usdInputField resignFirstResponder];
    [self.btcInputField resignFirstResponder];
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;

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

- (void)usdInputTextFieldDidChange:(id)sender {
    NSNumber *averagePrice = [[NSUserDefaults standardUserDefaults] objectForKey:@"AveragePrice"];
    self.btcInputField.text = [NSString stringWithFormat:@"%.3lf", [self.usdInputField.text floatValue] / [averagePrice floatValue]];
    self.btcInputField.font = self.thinFont;
}

- (void)btcInputTextFieldDidChange:(id)sender {
    NSNumber *averagePrice = [[NSUserDefaults standardUserDefaults] objectForKey:@"AveragePrice"];
    self.usdInputField.text = [NSString stringWithFormat:@"%.3lf", [self.btcInputField.text floatValue] * [averagePrice floatValue]];
    self.usdInputField.font = self.thinFont;
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
