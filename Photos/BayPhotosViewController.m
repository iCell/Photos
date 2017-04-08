//
//  BayPhotosViewController.m
//  Photos
//
//  Created by Xiaoyu Li on 07/04/2017.
//  Copyright © 2017 com.shanbay. All rights reserved.
//

#import "BayPhotosViewController.h"

#import "BayPhotosFetchHelper.h"

#import "BayPhotosReusableView.h"
#import "BayPhotosCell.h"

@import Photos;

static NSString * const kPhotosCellIdentifier = @"kPhotosCellIdentifier";
static NSString * const kPhotosResuableIdentifier = @"kPhotosResuableIdentifier";

CGFloat const kCellInset = 8;

@interface BayPhotosViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, BayPhotosFetcherHelperDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) BayPhotosFetchHelper *fetchHelper;

@property (strong, nonatomic) PHFetchResult<PHAsset *> *fetchResult;
@property (strong, nonatomic) PHCachingImageManager *imageManager;

@end

@implementation BayPhotosViewController

- (void)dealloc {
    [self.fetchHelper unregisterCollectionsChange];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureSubviews];
    [self.fetchHelper registerCollectionsChange];
}

- (void)configureSubviews {
    [self.view addSubview:self.collectionView];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:0 metrics:nil views:@{@"collectionView": self.collectionView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|" options:0 metrics:nil views:@{@"collectionView": self.collectionView}]];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.fetchResult.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BayPhotosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotosCellIdentifier forIndexPath:indexPath];
    PHAsset *asset = self.fetchResult[indexPath.row];
    CGFloat scale = [[UIScreen mainScreen] scale];
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(CGRectGetWidth(cell.frame) * scale, CGRectGetHeight(cell.frame) * scale) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        cell.thumbnail = result;
    }];
    return cell;
}

#pragma mark - UICollectionViewDelegateLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (CGRectGetWidth(collectionView.frame) - kCellInset * 4) / 3;
    return CGSizeMake(width, width);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kCellInset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kCellInset;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, kCellInset, 0, kCellInset);
}

#pragma mark - BayPhotosFetcherHelperDelegate
- (void)didFetchAllPhotos:(PHFetchResult<PHAsset *> *)allPhotos {
    self.fetchResult = allPhotos;
    [self.collectionView reloadData];
}

#pragma mark - getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        [_collectionView setAlwaysBounceVertical:YES];
        [_collectionView setBackgroundColor:self.view.backgroundColor];
        [_collectionView registerClass:[BayPhotosCell class] forCellWithReuseIdentifier:kPhotosCellIdentifier];
        [_collectionView registerClass:[BayPhotosReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kPhotosResuableIdentifier];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
    }
    return _collectionView;
}

- (BayPhotosFetchHelper *)fetchHelper {
    if (!_fetchHelper) {
        _fetchHelper = [[BayPhotosFetchHelper alloc] init];
        [_fetchHelper setDelegate:self];
    }
    return _fetchHelper;
}

- (PHCachingImageManager *)imageManager {
    if (!_imageManager) {
        _imageManager = [[PHCachingImageManager alloc] init];
    }
    return _imageManager;
}

@end
