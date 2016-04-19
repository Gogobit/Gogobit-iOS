//
//  ArticleCollectionViewCell.h
//  Gogobit
//
//  Created by Wilson H. on 4/10/16.
//  Copyright © 2016 Wilson H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYWebImage/YYWebImage.h>

@interface ArticleCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UIView *filterView;

- (void)performSelectionAnimations;
- (void)performDeselectionAnimations;

@end
