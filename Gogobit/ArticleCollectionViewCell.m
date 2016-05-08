//
//  ArticleCollectionViewCell.m
//  Gogobit
//
//  Created by Wilson H. on 4/10/16.
//  Copyright © 2016 Wilson H. All rights reserved.
//

#import "ArticleCollectionViewCell.h"

@implementation ArticleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    if (self.highlighted) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor(context, 0, 0, 0, 0);
        CGContextFillRect(context, self.bounds);
    }
}

- (void)performSelectionAnimations {
    self.filterView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5];
}

- (void)performDeselectionAnimations {
    self.filterView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.36];
}

@end
