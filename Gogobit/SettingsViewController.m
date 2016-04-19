//
//  SettingsViewController.m
//  Gogobit
//
//  Created by Wilson H. on 3/5/16.
//  Copyright © 2016 Wilson H. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.settingsTableView.backgroundColor = [UIColor clearColor];
    self.settingsArray = [[NSMutableArray alloc] initWithArray:@[@"關於", @"幣別", @"回饋意見"]];
    self.settingsDetailArray = [[NSMutableArray alloc] initWithArray:@[@"", @"", @""]];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
//    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBar.topItem.title = @"設定";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settingsArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        NSLog(@"Feedback!");
        [self performSegueWithIdentifier:@"ToFeedbackWebViewSegue" sender:self];
    }
    else if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"ToAboutViewSegue" sender:self];
    }
    else if (indexPath.row == 1) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"currencyType"] isEqualToString:@"TWD"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"USD" forKey:@"currencyType"];
        }
        else {
            [[NSUserDefaults standardUserDefaults] setObject:@"TWD" forKey:@"currencyType"];
        }
        [self.tableView reloadData];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Feedback" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SettingsCellIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell init] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.settingsArray[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.text = self.settingsDetailArray[indexPath.row];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    if (indexPath.row == 1) {
        cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"currencyType"];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:255/255.0f green:139/255.0f blue:16/255.0f alpha:1.0f];
    }

    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    return cell;
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
