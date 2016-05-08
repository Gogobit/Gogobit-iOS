//
//  NewsSourcesViewController.m
//  Gogobit
//
//  Created by Wilson H. on 5/3/16.
//  Copyright © 2016 Wilson H. All rights reserved.
//

#import "NewsSourcesViewController.h"
#import <YYCategories/YYCategories.h>

@interface NewsSourcesViewController ()

@end

@implementation NewsSourcesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"文章來源";
    self.collectionView.allowsMultipleSelection = YES;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.sourceArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"sourceList"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sourceArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSURL *url = [NSURL URLWithString:self.sourceArray[indexPath.row][@"imgUrl"]];
    NSUInteger codeLength = [[[NSUserDefaults standardUserDefaults] objectForKey:@"sourceNum"] integerValue];
    NSString *sourceQueryCode = [[[NSUserDefaults standardUserDefaults] objectForKey:@"sourceQueryCode"] substringWithRange:NSMakeRange(0, codeLength)];

    SourceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SourceCollectionViewCellIdentifier" forIndexPath:indexPath];
    if ([[sourceQueryCode substringWithRange:NSMakeRange(indexPath.row, 1)] isEqualToString:@"1"]) {
        cell.filterView.backgroundColor = [UIColor clearColor];
    }
    else {
        cell.filterView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    }
    cell.imageView.image = [UIImage yy_imageWithColor:[UIColor clearColor]];
    cell.imageView.clipsToBounds = YES;
    cell.imageView.contentMode = UIViewContentModeScaleToFill;
    [cell.imageView yy_setImageWithURL:url
                           placeholder:nil
                               options:YYWebImageOptionSetImageWithFadeAnimation
                              progress:nil
                             transform:nil
                            completion:nil];
//    [self.hud hide:YES];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sourceQueryCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"sourceQueryCode"];
    if ([[sourceQueryCode substringWithRange:NSMakeRange(indexPath.row, 1)] isEqualToString:@"1"]) {
        sourceQueryCode = [sourceQueryCode stringByReplacingCharactersInRange:NSMakeRange(indexPath.row, 1) withString:@"0"];
        [[NSUserDefaults standardUserDefaults] setObject:sourceQueryCode forKey:@"sourceQueryCode"];
    }
    else {
        sourceQueryCode = [sourceQueryCode stringByReplacingCharactersInRange:NSMakeRange(indexPath.row, 1) withString:@"1"];
        [[NSUserDefaults standardUserDefaults] setObject:sourceQueryCode forKey:@"sourceQueryCode"];
    }
    [collectionView reloadData];
}

#pragma mark – UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake([[UIScreen mainScreen] bounds].size.width / 2 - 1, [[UIScreen mainScreen] bounds].size.height * 0.25);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
