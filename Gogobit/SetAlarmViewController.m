//
//  SetAlarmViewController.m
//  Gogobit
//
//  Created by Wilson H. on 5/15/16.
//  Copyright © 2016 Wilson H. All rights reserved.
//

#import "SetAlarmViewController.h"

@interface SetAlarmViewController ()

@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *priceType;
@property (nonatomic, strong) NSString *sourceName;
@property (nonatomic, strong) NSString *currencyType;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSNumber *serialNumber;
@property (nonatomic, strong) NSNumber *price;

@end

@implementation SetAlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    self.currencyType = @"twd";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveAction:(id)sender {
    NSDictionary *alarmObject = [NSDictionary dictionaryWithObjectsAndKeys:
                                 self.deviceToken, @"deviceToken",
                                 self.serialNumber, @"serialNumber",
                                 self.
                                 nil]
}

- (IBAction)backgroundTap:(id)sender {
    NSLog(@"tap!");
    [self.priceTextField resignFirstResponder];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    self.price = [f numberFromString:self.priceTextField.text];
//    [self.view endEditing:YES];
//    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (IBAction)brokerChanged:(id)sender {
    switch ([sender selectedSegmentIndex]) {
        case 0:
            NSLog(@"Maicoin");
            self.sourceName = @"maicoin";
            break;

        case 1:
            NSLog(@"Bitoex");
            self.sourceName = @"bitoex";
            break;
        default:
            NSLog(@"Something Error");
            break;
    }
}

- (IBAction)priceTypeChanged:(id)sender {
    switch ([sender selectedSegmentIndex]) {
        case 0:
            NSLog(@"買");
            self.priceType = @"buy";
            break;

        case 1:
            NSLog(@"賣");
            self.priceType = @"sell";
            break;
        default:
            NSLog(@"Something Error");
            break;
    }
}

- (IBAction)stateChanged:(id)sender {
    switch ([sender selectedSegmentIndex]) {
        case 0:
            NSLog(@"onetime");
            self.state = @"onetime";
            break;

        case 1:
            NSLog(@"persistent");
            self.state = @"persistent";
            break;
        default:
            NSLog(@"Something Error");
            break;
    }
}

@end
