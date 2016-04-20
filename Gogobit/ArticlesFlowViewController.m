//
//  ArticlesFlowViewController.m
//  Gogobit
//
//  Created by Wilson H. on 4/8/16.
//  Copyright © 2016 Wilson H. All rights reserved.
//

#import "ArticlesFlowViewController.h"
#import <YYCategories/YYCategories.h>

#define kCellHeight ceil((kScreenWidth) * 3.0 / 4.0)

@interface ArticlesFlowViewController ()

@end

@implementation ArticlesFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [[UIScreen mainScreen] bounds].size.width, 20)];
    statusBarView.backgroundColor = [UIColor colorWithRed:26/255.0f green:26/255.0f blue:26/255.0f alpha:0.9f];
    [self.navigationController.navigationBar addSubview:statusBarView];
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    [self.collectionView sendSubviewToBack:refreshControl];
    [self scrollViewDidScroll:self.collectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"文章列表";
    [[GogobitHttpClient sharedClient] checkNetworkReachableWithSender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)appCheckNetworkDidFailWithStatus:(NSUInteger)status {
    switch (status) {
        case AFNetworkReachabilityStatusNotReachable:
            self.failView.hidden = NO;
            self.failMessageLabel.hidden = NO;
            NSLog(@"No Internet Conexion");
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            [self getPosts];
            self.failView.hidden = YES;
            self.failMessageLabel.hidden = YES;
            NSLog(@"WIFI");
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            [self getPosts];
            self.failView.hidden = YES;
            self.failMessageLabel.hidden = YES;
            NSLog(@"WWAN");
            break;
        case AFNetworkReachabilityStatusUnknown:
            self.failView.hidden = NO;
            self.failMessageLabel.hidden = NO;
            break;
        default:
            self.failView.hidden = NO;
            self.failMessageLabel.hidden = NO;
            NSLog(@"Unkown network status");
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat viewHeight = scrollView.height + scrollView.contentInset.top;
    for (ArticleCollectionViewCell *cell in [self.collectionView visibleCells]) {
        CGFloat y = cell.centerY - scrollView.contentOffset.y;
        CGFloat p = y - viewHeight / 4;
        CGFloat scale = cos(p / viewHeight * 0.85) * 1.05;
        if (kiOS8Later) {
            [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
                cell.imageView.transform = CGAffineTransformMakeScale(scale, scale);
            } completion:NULL];
        } else {
            cell.imageView.transform = CGAffineTransformMakeScale(scale, scale);
        }
    }
}

- (void)handleRefresh:(UIRefreshControl *)refreshControl {
    if (self.postsArray.count > 0) {
        self.failView.hidden = YES;
        self.failMessageLabel.hidden = YES;
    }
    [self getPosts];
    [refreshControl endRefreshing];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.postsArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSURL *url = [NSURL URLWithString:self.postsArray[indexPath.row][@"imgUrl"]];
    ArticleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ArticleCollectionViewCellIdentifier" forIndexPath:indexPath];
    cell.titleLabel.text = self.postsArray[indexPath.row][@"title"];
    cell.sourceLabel.text = self.postsArray[indexPath.row][@"source"];
    cell.imageView.image = [UIImage yy_imageWithColor:[UIColor clearColor]];
    cell.imageView.clipsToBounds = YES;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [cell.imageView yy_setImageWithURL:url
                           placeholder:nil
                               options:YYWebImageOptionSetImageWithFadeAnimation
                            progress:nil
                             transform:nil
                            completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                if (from == YYWebImageFromDiskCache) {
                                    NSLog(@"load from disk cache");
                                }
                            }];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ArticleWebViewController *awvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleWebViewControllerIdentifier"];
    awvc.articleUrl = [self.postsArray objectAtIndex:indexPath.row][@"url"];
    [self.navigationController pushViewController:awvc animated:YES];
}

#pragma mark – UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height * 0.4);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}

- (void)getPosts {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = NSLocalizedString(@"讀取中...", @"");
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:GOGOBIT_POSTS_API parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.failView.hidden = YES;
        self.failMessageLabel.hidden = YES;
        self.postsArray = [NSArray arrayWithArray:responseObject];
        [self.hud hide:YES];
        [self.collectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.hud hide:YES];
        NSLog(@"error!");
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [touches anyObject];
    NSLog(@"touch!!");
//    originalLocation = [touch locationInView:self.view];
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
