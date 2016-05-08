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
    self.settingsArray = [[NSMutableArray alloc] initWithArray:@[@"關於", @"幣別", @"更新秒數", @"文章來源", @"回饋意見", @"給我們好評", @"去粉絲專頁按讚"]];
    self.settingsDetailArray = [[NSMutableArray alloc] initWithArray:@[@"", @"", @"", @"", @"", @"", @""]];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.topItem.title = @"設定";
    [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settingsArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 4) {
        NSLog(@"Feedback!");
        [self performSegueWithIdentifier:@"ToFeedbackWebViewSegue" sender:self];
    }
    else if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"ToAboutViewSegue" sender:self];
    }
    else if (indexPath.row == 3) {
        [self performSegueWithIdentifier:@"ToNewsSourcesViewSegue" sender:self];
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
    else if (indexPath.row == 2) {
        [self showEditSecondsForUpdateAlertView:[[NSUserDefaults standardUserDefaults] objectForKey:@"secondsForUpdate"]];
    }
    else if (indexPath.row == 5) {
        NSURL *gogobitURL = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1094365934"];
        if ([[UIApplication sharedApplication] canOpenURL:gogobitURL]) {
            [[UIApplication sharedApplication] openURL:gogobitURL];
        }
        else {
            NSURL *gogobitURL = [NSURL URLWithString:@"https://itunes.apple.com/tw/app/gogobit/id1094365934?mt=8&ign-mpt=uo%3D4"];
            if ([[UIApplication sharedApplication] canOpenURL:gogobitURL]) {
                [[UIApplication sharedApplication] openURL:gogobitURL];
            }
        }
    }
    else if (indexPath.row == 6) {
        NSURL *facebookURL = [NSURL URLWithString:@"fb://profile/1702805789972478"];
        if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
            [[UIApplication sharedApplication] openURL:facebookURL];
        }
        else {
            [self performSegueWithIdentifier:@"ToFanpageViewSegue" sender:self];
        }
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
    else if (indexPath.row == 2) {
        cell.detailTextLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"secondsForUpdate"] stringValue];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:255/255.0f green:139/255.0f blue:16/255.0f alpha:1.0f];
    }

    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showEditSecondsForUpdateAlertView:(NSNumber *)secondsForUpdate {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:NSLocalizedString(@"編輯秒數", @"")
                                          message:@"秒數可以介於 5 - 60 秒之間。"
                                          preferredStyle:UIAlertControllerStyleAlert];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
        textField.backgroundColor = [UIColor clearColor];
        textField.placeholder = NSLocalizedString(@"請輸入秒數", @"");
        textField.text = [secondsForUpdate stringValue];
    }];


    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"取消", @"")
                                   style:UIAlertActionStyleCancel
                                   handler:nil];

//    [AddressBook shareObject].sender = self;
    UIAlertAction *confirmAction = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"確認", @"")
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action) {
                                        UITextField *secondsForUpdateTextField = alertController.textFields.firstObject;
//                                        UITextField *name = alertController.textFields.lastObject;
//                                        NSInteger index = [[AddressBook shareObject] getIndexWithContactAddress:address.text];
                                        if ([secondsForUpdateTextField.text isEqualToString:@""]) {
                                            [self showAlertWithTitle: NSLocalizedString(@"錯誤", @"")message:NSLocalizedString(@"好像忘記填秒數囉！", @"") handler:^(UIAlertAction * action){
                                                [self presentViewController:alertController animated:YES completion:nil];
                                            }];
                                        }
                                        else if ([secondsForUpdateTextField.text integerValue] > 60) {
                                            [self showAlertWithTitle: NSLocalizedString(@"錯誤", @"")message:NSLocalizedString(@"秒數太長了，怕您等太久...", @"") handler:^(UIAlertAction * action){
                                                [self presentViewController:alertController animated:YES completion:nil];
                                            }];
                                        }
                                        else if ([secondsForUpdateTextField.text integerValue] < 5) {
                                            [self showAlertWithTitle: NSLocalizedString(@"錯誤", @"")message:NSLocalizedString(@"秒數太短了，我們會承受不住...", @"") handler:^(UIAlertAction * action){
                                                [self presentViewController:alertController animated:YES completion:nil];
                                            }];
                                        }
                                        else {
                                            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:[secondsForUpdateTextField.text integerValue]] forKey:@"secondsForUpdate"];
                                            [self.tableView reloadData];
                                        }
                                    }];
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];

    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message handler:(void (^)(UIAlertAction *action))handler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"確定", @"")
                                                     style:UIAlertActionStyleDefault
                                                   handler:handler];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
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
