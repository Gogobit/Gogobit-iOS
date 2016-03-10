//
//  ExchangeRateViewController.h
//  Gogobit
//
//  Created by Wilson H. on 11/6/15.
//  Copyright © 2015 Wilson H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExchangesClient.h"
#import "GogobitHttpProtocol.h"

@interface ExchangeRateViewController : UIViewController <GogobitHttpProtocol, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *mainRateLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *currencyPickerView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (strong, nonatomic) NSMutableArray *exchangeNameList;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UITextField *usdInputField;
@property (weak, nonatomic) IBOutlet UITextField *btcInputField;
@property (strong, nonatomic) UIFont *thinFont;

- (IBAction)backgroundTap:(id)sender;

@end
