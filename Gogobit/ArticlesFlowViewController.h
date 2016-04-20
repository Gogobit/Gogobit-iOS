//
//  ArticlesFlowViewController.h
//  Gogobit
//
//  Created by Wilson H. on 4/8/16.
//  Copyright © 2016 Wilson H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleCollectionViewCell.h"
#import "ArticleWebViewController.h"
#import "GogobitHttpClient.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"

NSString *const GOGOBIT_POSTS_API = @"http://www.gogobit.com/api/v0/app/posts";

@interface ArticlesFlowViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GogobitHttpProtocol>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *failView;
@property (strong, nonatomic) NSArray *postsArray;
@property (nonatomic, weak) MBProgressHUD *hud;
@property (weak, nonatomic) IBOutlet UILabel *failMessageLabel;

@end
