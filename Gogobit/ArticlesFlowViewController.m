//
//  ArticlesFlowViewController.m
//  Gogobit
//
//  Created by Wilson H. on 4/8/16.
//  Copyright © 2016 Wilson H. All rights reserved.
//

#import "ArticlesFlowViewController.h"

@interface ArticlesFlowViewController ()

@end

@implementation ArticlesFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [[UIScreen mainScreen] bounds].size.width, 20)];
    statusBarView.backgroundColor = [UIColor colorWithRed:26/255.0f green:26/255.0f blue:26/255.0f alpha:0.9f];
    [self.navigationController.navigationBar addSubview:statusBarView];

//    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
//    UINavigationBar *navigationBar = self.navigationController.navigationBar;
//
//    [navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBarBackground"]
//                       forBarPosition:UIBarPositionAny
//                           barMetrics:UIBarMetricsDefault];
//
//    [navigationBar setShadowImage:[UIImage new]];
//    [[self navigationController] setNavigationBarHidden:NO animated:YES];
//    self.navigationItem.title = @"文章列表";
//    self.navigationController.navigationBar.topItem.title = @"文章列表";

    [self getPosts];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"文章列表";
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}
//
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.postsArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    ArticleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ArticleCollectionViewCellIdentifier" forIndexPath:indexPath];
    cell.titleLabel.text = self.postsArray[indexPath.row][@"title"];
    cell.sourceLabel.text = self.postsArray[indexPath.row][@"source"];
    cell.imageView.image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.postsArray[indexPath.row][@"imgUrl"]]]];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ArticleCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:0.1
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         NSLog(@"animation start");
                         [cell performSelectionAnimations];
                     }
                     completion:^(BOOL finished){
                         NSLog(@"animation end");
                         [cell performDeselectionAnimations];
                     }
     ];
    ArticleWebViewController *awvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleWebViewControllerIdentifier"];
    awvc.articleUrl = [self.postsArray objectAtIndex:indexPath.row][@"url"];

    [self.navigationController pushViewController:awvc animated:YES];
    NSLog(@"Select indexPath.row: %li", (long)indexPath.row);
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
    ArticleCollectionViewCell *cell = (ArticleCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    [cell performDeselectionAnimations];
    NSLog(@"Deselect indexPath.row: %li", (long)indexPath.row);
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
        self.postsArray = [NSArray arrayWithArray:responseObject];
        [self.hud hide:YES];
        [self.collectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error!");
    }];
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
