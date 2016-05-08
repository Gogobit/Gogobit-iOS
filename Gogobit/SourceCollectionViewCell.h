//
//  SourceCollectionViewCell.h
//  Gogobit
//
//  Created by Wilson H. on 5/3/16.
//  Copyright © 2016 Wilson H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYWebImage/YYWebImage.h>

@interface SourceCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *filterView;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *imageView;

@end
