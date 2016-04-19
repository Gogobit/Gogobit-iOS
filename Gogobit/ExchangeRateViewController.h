//
//  ExchangeRateViewController.h
//  Gogobit
//
//  Created by Wilson H. on 11/6/15.
//  Copyright © 2015 Wilson H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GogobitHttpProtocol.h"

@interface ExchangeRateViewController : UIViewController <GogobitHttpProtocol>

@property (strong, nonatomic) NSMutableArray *exchangeNameList;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIButton *fiatCurrencyTypeButton;
@property (strong, nonatomic) UIFont *thinFont;
@property (nonatomic) double rate;

@property (nonatomic) BOOL isUserEntering;
@property (nonatomic) BOOL isFiatDisplaySelected;
@property (nonatomic) BOOL isFloatPointAppear;

@property (weak, nonatomic) IBOutlet UILabel *btcDisplayLabel;
@property (weak, nonatomic) IBOutlet UILabel *fiatDisplayLabel;
@property (weak, nonatomic) IBOutlet UIButton *btcSelectedButton;
@property (weak, nonatomic) IBOutlet UIButton *fiatSelectedButton;

- (IBAction)selectFiat:(UIButton *)sender;
- (IBAction)selectBtc:(UIButton *)sender;
- (IBAction)pressDigit:(UIButton *)sender;
- (IBAction)pressDelete:(UIButton *)sender;
- (IBAction)pressPoint:(UIButton *)sender;

@end
