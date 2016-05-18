//
//  AlarmTableViewCell.h
//  Gogobit
//
//  Created by Wilson H. on 5/12/16.
//  Copyright © 2016 Wilson H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *openSwitch;
@property (weak, nonatomic) IBOutlet UILabel *currenyTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *brokerImageView;

@end
