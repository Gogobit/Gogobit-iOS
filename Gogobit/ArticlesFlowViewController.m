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
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    [self.collectionView sendSubviewToBack:refreshControl];
    [self scrollViewDidScroll:self.collectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"文章";

    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];

    [button setTitleColor:[UIColor colorWithHexString:@"#FF8B10"] forState:UIControlStateNormal];
    [button setTitle:@"來源" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(toChooseArticleSource) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 36, 36)];
    UIBarButtonItem *sourceButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.tabBarController.navigationItem.rightBarButtonItem = sourceButton;

    [[GogobitHttpClient sharedClient] checkNetworkReachableWithSender:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)toChooseArticleSource {
    [self performSegueWithIdentifier:@"ToNewsSourcesViewSegue" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)appCheckNetworkDidFailWithStatus:(NSUInteger)status {
    switch (status) {
        case AFNetworkReachabilityStatusReachableViaWiFi:
        case AFNetworkReachabilityStatusReachableViaWWAN:
            [self getPosts];
            self.failView.hidden = YES;
            self.failMessageLabel.hidden = YES;
            [self.hud hide:YES];
            break;
        case AFNetworkReachabilityStatusNotReachable:
        case AFNetworkReachabilityStatusUnknown:
        default:
            self.failView.hidden = NO;
            self.failMessageLabel.hidden = NO;
            self.failMessageLabel.text = @"您目前沒有網路連線，請檢查後再試。";
            [self.hud hide:YES];
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
//        self.failView.hidden = YES;
//        self.failMessageLabel.hidden = YES;
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
//    NSString *urlString = [self.postsArray[indexPath.row][@"imgUrl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
                            completion:nil];
    [self.hud hide:YES];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ArticleWebViewController *awvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleWebViewControllerIdentifier"];
    awvc.articleUrl = [self.postsArray objectAtIndex:indexPath.row][@"url"];
    awvc.count = 0;
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
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = NSLocalizedString(@"讀取中...", @"");
    [[GogobitHttpClient sharedClient] getPostsWithSender:self];
}

- (void)flowDidGetPostsWithData:(id)data {
//    self.failView.hidden = YES;
//    self.failMessageLabel.hidden = YES;
    self.postsArray = [NSArray arrayWithArray:data];
    [self.hud hide:YES];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"sourceQueryCode"] integerValue] == 0 || self.postsArray.count == 0) {
        self.failView.hidden = NO;
        self.failMessageLabel.hidden = NO;
        self.failMessageLabel.text = @"目前沒有文章來源，可以在右上角或到設定去選取喔！";
    }
    else {
        self.failView.hidden = YES;
        self.failMessageLabel.hidden = YES;
    }
    [self.collectionView reloadData];
}

- (void)flowGetPostsDidFailWithCode:(NSInteger)code andResponse:(NSString *)errorResponse {
    [self.hud hide:YES];
    self.failView.hidden = NO;
    self.failMessageLabel.hidden = NO;
    self.failMessageLabel.text = @"伺服器維護中，請稍後再試。";
    NSLog(@"flowGetPostsDidFailWithCode code: %ld", (long)code);
    NSLog(@"errorResponse: %@", errorResponse);
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
