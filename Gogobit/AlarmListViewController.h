//
//  AlarmListViewController.h
//  Gogobit
//
//  Created by Wilson H. on 5/15/16.
//  Copyright © 2016 Wilson H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GogobitHttpClient.h"
#import "AlarmTableViewCell.h"
#import "SetAlarmViewController.h"

@interface AlarmListViewController : UIViewController <GogobitHttpProtocol>

@property (weak, nonatomic) IBOutlet UITableView *alarmTableView;

@end
