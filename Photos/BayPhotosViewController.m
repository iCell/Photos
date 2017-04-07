//
//  BayPhotosViewController.m
//  Photos
//
//  Created by Xiaoyu Li on 07/04/2017.
//  Copyright © 2017 com.shanbay. All rights reserved.
//

#import "BayPhotosViewController.h"

#import "BayPhotosReusableView.h"
#import "BayPhotosCell.h"

@import Photos;

static NSString * const kPhotosCellIdentifier = @"kPhotosCellIdentifier";
static NSString * const kPhotosResuableIdentifier = @"kPhotosResuableIdentifier";

@interface BayPhotosViewController ()

@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation BayPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureSubviews];
}

- (void)configureSubviews {
    [self.view addSubview:self.collectionView];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:0 metrics:nil views:@{@"collectionView": self.collectionView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|" options:0 metrics:nil views:@{@"collectionView": self.collectionView}]];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds];
        [_collectionView setAlwaysBounceVertical:YES];
        [_collectionView setBackgroundColor:self.view.backgroundColor];
        [_collectionView registerClass:[BayPhotosCell class] forCellWithReuseIdentifier:kPhotosCellIdentifier];
        [_collectionView registerClass:[BayPhotosReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kPhotosResuableIdentifier];
    }
    return _collectionView;
}

@end
