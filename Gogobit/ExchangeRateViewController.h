//
//  ExchangeRateViewController.h
//  Gogobit
//
//  Created by Wilson H. on 11/6/15.
//  Copyright © 2015 Wilson H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExchangeRateViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *mainRateLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *currencyPickerView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (strong, nonatomic) NSMutableArray *exchangeNameList;

@end
