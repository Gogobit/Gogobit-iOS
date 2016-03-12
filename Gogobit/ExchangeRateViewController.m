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
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
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

- (IBAction)backgroundTap:(id)sender {
    [self.usdInputField resignFirstResponder];
    [self.btcInputField resignFirstResponder];
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [[ExchangesClient sharedClient] getMaicoinUSDPriceWithSender:self];
//    [[ExchangesClient sharedClient] getMaicoinTWDPriceWithSender:self];
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
