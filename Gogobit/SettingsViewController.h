//
//  SettingsViewController.h
//  Gogobit
//
//  Created by Wilson H. on 3/5/16.
//  Copyright © 2016 Wilson H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;
@property (strong, nonatomic) NSMutableArray *settingsArray;
@property (strong, nonatomic) NSMutableArray *settingsDetailArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end