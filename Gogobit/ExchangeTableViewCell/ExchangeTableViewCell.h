//
//  ExchangeTableViewCell.h
//  Gogobit
//
//  Created by Wilson H. on 2/26/16.
//  Copyright © 2016 Wilson H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExchangeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *exchangeImageView;
@property (weak, nonatomic) IBOutlet UILabel *exchangeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;

@end
