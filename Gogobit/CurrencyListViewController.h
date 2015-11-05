//
//  ViewController.h
//  Gogobit
//
//  Created by Wilson H. on 11/3/15.
//  Copyright © 2015 Wilson H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrencyListViewController : UIViewController <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *currencyTableView;

@end

