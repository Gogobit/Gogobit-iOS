//
//  SetAlarmViewController.h
//  Gogobit
//
//  Created by Wilson H. on 5/15/16.
//  Copyright © 2016 Wilson H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetAlarmViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *brokerSegmentedBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priceTypeSegmentedBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *stateSegmentedBar;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)saveAction:(id)sender;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)brokerChanged:(id)sender;
- (IBAction)priceTypeChanged:(id)sender;
- (IBAction)stateChanged:(id)sender;

@end
