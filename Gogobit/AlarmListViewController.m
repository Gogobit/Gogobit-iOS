//
//  AlarmListViewController.m
//  Gogobit
//
//  Created by Wilson H. on 5/15/16.
//  Copyright © 2016 Wilson H. All rights reserved.
//

#import "AlarmListViewController.h"
#import <YYCategories/YYCategories.h>

@interface AlarmListViewController ()

@end

@implementation AlarmListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"鬧鐘";
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];

    [button setTitleColor:[UIColor colorWithHexString:@"#FF8B10"] forState:UIControlStateNormal];
//    [button setTitle:@"來源" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addAlarm) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 18, 18)];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.tabBarController.navigationItem.rightBarButtonItem = addButton;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
}


- (void)addAlarm {
    [self performSegueWithIdentifier:@"ToSetAlarmSegue" sender:self];
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

@end
