//
//  NewsSourcesViewController.h
//  Gogobit
//
//  Created by Wilson H. on 5/3/16.
//  Copyright © 2016 Wilson H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GogobitHttpClient.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "SourceCollectionViewCell.h"

@interface NewsSourcesViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GogobitHttpProtocol>

@property (strong, nonatomic) NSArray *sourceArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
