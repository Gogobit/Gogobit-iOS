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

@property (nonatomic, strong) NSMutableArray *alarmArray;
@property (nonatomic) NSUInteger maxSerialNumber;
@property (nonatomic) NSMutableDictionary *alarmObject;

@end

@implementation AlarmListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.alarmTableView.rowHeight = 60;
    self.alarmTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.alarmTableView addSubview:refreshControl];
    [self.alarmTableView sendSubviewToBack:refreshControl];
    // Do any additional setup after loading the view.
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"] isEqualToString:@"simulator"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"要接收鬧鐘提醒的話，請到設定打開接收通知喔！"
                                                                                 message:@""
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"我知道了"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
    }
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
    [[GogobitHttpClient sharedClient] getDeviceAlarmListWithSender:self];
//    [self.alarmTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)handleRefresh:(UIRefreshControl *)refreshControl {
    [[GogobitHttpClient sharedClient] getDeviceAlarmListWithSender:self];
    [refreshControl endRefreshing];
}

- (void)alarmDidGetListWithData:(id)data {
    NSLog(@"success get alarm list: %@", data);
    self.alarmArray = data;
    [self.alarmTableView reloadData];
    self.maxSerialNumber = [self getMaxSerialNumberWithAlarmList:data];
}

- (NSUInteger)getMaxSerialNumberWithAlarmList:(id)alarmList {
    NSUInteger max = 0;
    for (NSDictionary *dic in alarmList) {
        if ([dic[@"serialNumber"] integerValue] > max) {
            max = [dic[@"serialNumber"] integerValue];
        }
    }
    return max + 1;
}

- (void)alarmGetListDidFailWithCode:(NSInteger)code andResponse:(NSString *)errorResponse {
    NSLog(@"fail get alarm list: %lu, error: %@", code, errorResponse);
}

- (void)addAlarm {
//    SetAlarmViewController *savc = [[SetAlarmViewController alloc] init];
//    savc.serialNumber = [NSNumber numberWithUnsignedInteger:self.maxSerialNumber];
//    [self.navigationController pushViewController:savc animated:YES];

    [self performSegueWithIdentifier:@"ToAddAlarmSegue" sender:self];
}

- (AlarmTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AlarmTableViewCellIdentifier";

    AlarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AlarmTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@", self.alarmArray[indexPath.row][@"price"]];
    if ([self.alarmArray[indexPath.row][@"sourceName"] isEqualToString:@"maicoin"]) {
        cell.brokerImageView.image = [UIImage imageNamed:@"MaicoinLogo"];
    }
    else {
        cell.brokerImageView.image = [UIImage imageNamed:@"BitoexLogo"];
    }

    if ([self.alarmArray[indexPath.row][@"priceType"] isEqualToString:@"buy"]) {
        cell.priceTypeLabel.text = @"買價";
    }
    else {
        cell.priceTypeLabel.text = @"賣價";
    }

    if ([self.alarmArray[indexPath.row][@"state"] isEqualToString:@"onetime"]) {
        cell.stateLabel.text = @"單次";
    }
    else if ([self.alarmArray[indexPath.row][@"state"] isEqualToString:@"persistent"]){
        cell.stateLabel.text = @"持續";
    }
    else {
        cell.stateLabel.text = @"關閉";
    }
    cell.currenyTypeLabel.text = @"TWD";
    cell.serialNumber = [self.alarmArray[indexPath.row][@"serialNumber"] integerValue];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.alarmArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    self.alarmObject = [[NSMutableDictionary alloc] init];x
    self.alarmObject = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"], @"deviceToken", nil];
    [self.alarmObject setValue:self.alarmArray[indexPath.row][@"serialNumber"] forKey:@"serialNumber"];
    [self.alarmObject setObject:self.alarmArray[indexPath.row][@"sourceName"] forKey:@"sourceName"];
    [self.alarmObject setValue:self.alarmArray[indexPath.row][@"price"] forKey:@"price"];
    [self.alarmObject setObject:self.alarmArray[indexPath.row][@"priceType"] forKey:@"priceType"];
    [self.alarmObject setObject:self.alarmArray[indexPath.row][@"state"] forKey:@"state"];
    [self.alarmObject setObject:self.alarmArray[indexPath.row][@"desc"] forKey:@"desc"];
    [self.alarmObject setObject:self.alarmArray[indexPath.row][@"currencyType"] forKey:@"currencyType"];
    [self performSegueWithIdentifier:@"ToSetAlarmSegue" sender:self];

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        NSMutableDictionary *deleteObject = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"], @"deviceToken", nil];
        [deleteObject setValue:self.alarmArray[indexPath.row][@"serialNumber"] forKey:@"serialNumber"];
//        [self.alarmArray removeObjectAtIndex:indexPath.row];
//        [self.alarmTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [[GogobitHttpClient sharedClient] deleteAlarmWithSender:self andAlarmObject:deleteObject];
    }
}

- (void)alarmDidDeleteListWithData:(id)data {
    NSLog(@"success delete alarm data: %@", data);
    [self.alarmTableView reloadData];
    [[GogobitHttpClient sharedClient] getDeviceAlarmListWithSender:self];
}

- (void)alarmDeleteDidFailWithCode:(NSInteger)code andResponse:(NSString *)errorResponse {
    NSLog(@"fail delete alarm list: %lu, error: %@", code, errorResponse);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ToAddAlarmSegue"]) {
        SetAlarmViewController *savc = segue.destinationViewController;
        savc.isAdd = YES;
        savc.serialNumber = [NSNumber numberWithUnsignedInteger:self.maxSerialNumber];
    }
    else if ([[segue identifier] isEqualToString:@"ToSetAlarmSegue"]) {
        SetAlarmViewController *savc = segue.destinationViewController;
        savc.isAdd = NO;
        savc.price = self.alarmObject[@"price"];
        savc.sourceName = self.alarmObject[@"sourceName"];
        savc.priceType = self.alarmObject[@"priceType"];
        savc.state = self.alarmObject[@"state"];
        savc.serialNumber = self.alarmObject[@"serialNumber"];
    }
}

- (IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    if ([segue.identifier isEqualToString:@"unwindToAlarmListSegue"]) {
        NSLog(@"Violets are %@", segue.identifier);
    }
}

- (BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    return YES;
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
