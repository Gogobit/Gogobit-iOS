//
//  GogobitTabBarController.m
//  Gogobit
//
//  Created by Wilson H. on 11/6/15.
//  Copyright © 2015 Wilson H. All rights reserved.
//

#import "GogobitTabBarController.h"

@implementation GogobitTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setSelectedIndex:2];
    [[UITabBar appearance] setBarTintColor:[UIColor grayColor]];
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1]];
//    [[UITabBar appearance] setBarTintColor:[UIColor yellowColor]];
    [[self tabBar] setTintColor:[UIColor colorWithRed:255.0f/255.0f green:139.0f/255.0f blue:16.0f/255.0f alpha:1]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
}

@end
