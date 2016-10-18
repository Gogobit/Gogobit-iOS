//
//  BrokerDetailViewController.m
//  Gogobit
//
//  Created by Wilson H. on 5/6/16.
//  Copyright © 2016 Wilson H. All rights reserved.
//

#import "BrokerDetailViewController.h"
#import "AlarmTableViewCell.h"

@interface BrokerDetailViewController ()

@end

@implementation BrokerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.alarmTableView.rowHeight = 60;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (AlarmTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AlarmTableViewCellIdentifier";

    AlarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AlarmTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.priceLabel.text = [NSString stringWithFormat:@"%ld", 12000 * indexPath.row];
    cell.brokerImageView.image = [UIImage imageNamed:@"MaicoinLogo"];
    cell.currenyTypeLabel.text = @"TWD";
    cell.orderTypeLabel.text = @"賣";

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
