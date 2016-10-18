//
//  SetAlarmViewController.h
//  Gogobit
//
//  Created by Wilson H. on 5/15/16.
//  Copyright © 2016 Wilson H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GogobitHttpClient.h"

@interface SetAlarmViewController : UIViewController <GogobitHttpProtocol>
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *brokerSegmentedBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priceTypeSegmentedBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *stateSegmentedBar;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (nonatomic, strong) NSNumber *serialNumber;
@property (nonatomic) BOOL isAdd;

@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *priceType;
@property (nonatomic, strong) NSString *sourceName;
@property (nonatomic, strong) NSString *currencyType;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSNumber *price;

@property (weak, nonatomic) IBOutlet UILabel *nowBuyPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nowSellPriceLabel;

- (IBAction)saveAction:(id)sender;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)brokerChanged:(id)sender;
- (IBAction)priceTypeChanged:(id)sender;
- (IBAction)stateChanged:(id)sender;

@end
