//
//  SetAlarmViewController.m
//  Gogobit
//
//  Created by Wilson H. on 5/15/16.
//  Copyright © 2016 Wilson H. All rights reserved.
//

#import "SetAlarmViewController.h"

@interface SetAlarmViewController ()

@end

@implementation SetAlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    if (self.isAdd) {
        self.currencyType = @"twd";
        self.desc = @"default";
        self.sourceName = @"maicoin";
        self.priceType = @"buy";
        self.state = @"onetime";
        self.price = @10000;
    }
    else {
        self.priceTypeSegmentedBar.selectedSegmentIndex = [self getSegementedIndexWithPriceType:self.priceType];
        self.stateSegmentedBar.selectedSegmentIndex = [self getSegementedIndexWithState:self.state];
        self.brokerSegmentedBar.selectedSegmentIndex = [self getSegementedIndexWithSourceName:self.sourceName];
        self.priceTextField.text = [self.price stringValue];
        self.desc = @"default";
        self.currencyType = @"twd";
    }
    if (self.brokerSegmentedBar.selectedSegmentIndex == 0) {
        self.nowBuyPriceLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"MaicoinBuyPrice"] stringValue];
        self.nowSellPriceLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"MaicoinSellPrice"] stringValue];
    }
    else {
        self.nowBuyPriceLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"BitoexBuyPrice"] stringValue];
        self.nowSellPriceLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"BitoexSellPrice"] stringValue];
    }
}


- (NSUInteger)getSegementedIndexWithSourceName:(NSString *)sourceName {
    if ([sourceName isEqualToString:@"maicoin"]) {
        return 0;
    }
    else {
        return 1;
    }
}

- (NSUInteger)getSegementedIndexWithPriceType:(NSString *)priceType {
    if ([priceType isEqualToString:@"buy"]) {
        return 0;
    }
    else {
        return 1;
    }
}

- (NSUInteger)getSegementedIndexWithState:(NSString *)state {
    if ([state isEqualToString:@"onetime"]) {
        return 0;
    }
    else if ([state isEqualToString:@"off"]) {
        self.state = @"persistent";
        return 1;
    }
    else {
        return 1;
    }
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
    NSLog(@"save!");
    NSMutableDictionary *alarmObject = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.deviceToken, @"deviceToken", nil];
    [alarmObject setValue:self.serialNumber forKey:@"serialNumber"];
    [alarmObject setObject:self.sourceName forKey:@"sourceName"];
    [alarmObject setValue:self.price forKey:@"price"];
    [alarmObject setObject:self.priceType forKey:@"priceType"];
    [alarmObject setObject:self.state forKey:@"state"];
    [alarmObject setObject:self.desc forKey:@"desc"];
    [alarmObject setObject:self.currencyType forKey:@"currencyType"];

    [[GogobitHttpClient sharedClient] setAlarmWithSender:self andAlarmObject:alarmObject];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alarmDidSetListWithData:(id)data {
    NSLog(@"success set alarm: %@", data);
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
//    [[GogobitHttpClient sharedClient] getDeviceAlarmListWithSender:self];
}

- (void)alarmSetDidFailWithCode:(NSInteger)code andResponse:(NSString *)errorResponse {
    NSLog(@"fail set code: %lu, and error: %@", code, errorResponse);
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    if ([segue.identifier isEqualToString:@"unwindToAlarmListSegue"]) {
        NSLog(@"Violets are %@", segue.identifier);
    }
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
            self.nowBuyPriceLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"MaicoinBuyPrice"] stringValue];
            self.nowSellPriceLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"MaicoinSellPrice"] stringValue];
            break;

        case 1:
            NSLog(@"Bitoex");
            self.sourceName = @"bitoex";
            self.nowBuyPriceLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"BitoexBuyPrice"] stringValue];
            self.nowSellPriceLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"BitoexSellPrice"] stringValue];
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
