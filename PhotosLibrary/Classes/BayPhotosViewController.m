//
//  BayPhotosViewController.m
//  Photos
//
//  Created by Xiaoyu Li on 07/04/2017.
//  Copyright © 2017 com.shanbay. All rights reserved.
//

#import "BayPhotosViewController.h"

#import "BayPhotosCell.h"

@import Photos;

static NSString * const kCameraCellIdentifier = @"kCameraCellIdentifier";
static NSString * const kPhotosCellIdentifier = @"kPhotosCellIdentifier";

CGFloat const kCellInset = 8;

@interface BayPhotosViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPhotoLibraryChangeObserver>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) PHFetchResult<PHAsset *> *fetchResult;
@property (strong, nonatomic) NSMutableDictionary<NSIndexPath *, UIImage *> *images;

@end

@implementation BayPhotosViewController

- (void)dealloc {
    NSLog(@"BayPhotosViewController dealloc");
    [self unregisterCollectionsChange];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _maxSelect = 3;
        _supportMultiple = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureSubviews];
    [self registerCollectionsChange];
}

- (void)configureSubviews {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissAction)];
    self.navigationItem.leftBarButtonItem = closeButton;
    
    if (self.supportMultiple) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
    
    [self.view addSubview:self.collectionView];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:0 metrics:nil views:@{@"collectionView": self.collectionView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|" options:0 metrics:nil views:@{@"collectionView": self.collectionView}]];
}

- (void)dismissAction {
    if ([self.delegate respondsToSelector:@selector(cancelSelectImageInPhotosViewController:)]) {
        [self.delegate cancelSelectImageInPhotosViewController:self];
    }
}

- (void)doneAction {
    if ([self.delegate respondsToSelector:@selector(photosViewController:didSelectImages:)]) {
        [self.delegate photosViewController:self didSelectImages:[self.images allValues]];
    }
}

#pragma mark - fetch photos
- (void)registerCollectionsChange {
    PHFetchOptions *fetchOption = [[PHFetchOptions alloc] init];
    [fetchOption setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO]]];
    self.fetchResult = [PHAsset fetchAssetsWithOptions:fetchOption];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)unregisterCollectionsChange {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

#pragma mark - PHPhotoLibraryChangeObserver
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    dispatch_async(dispatch_get_main_queue(), ^{
        PHFetchResultChangeDetails *allPhotosChangeDetails = [changeInstance changeDetailsForFetchResult:self.fetchResult];
        if (allPhotosChangeDetails) {
            self.fetchResult = [allPhotosChangeDetails fetchResultAfterChanges];
            [self.collectionView reloadData];
        }
    });
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.fetchResult.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BayCameraCell *cameraCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCameraCellIdentifier forIndexPath:indexPath];
        return cameraCell;
    }

    BayPhotosCell *photosCell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotosCellIdentifier forIndexPath:indexPath];
    if (self.supportMultiple) {
        [photosCell setSelected:NO];
    }
    if (indexPath.row != 0) {
        PHAsset *asset = self.fetchResult[indexPath.row - 1];
        CGFloat scale = [[UIScreen mainScreen] scale];
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(CGRectGetWidth(photosCell.frame) * scale, CGRectGetHeight(photosCell.frame) * scale) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            photosCell.thumbnail = result;
        }];
    }
    return photosCell;
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

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self openCamera];
    } else {
        
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        [option setDeliveryMode:PHImageRequestOptionsDeliveryModeHighQualityFormat];
        [option setNetworkAccessAllowed:YES];
        PHAsset *asset = self.fetchResult[indexPath.row - 1];
        CGFloat scale = [UIScreen mainScreen].scale;
        CGSize targetSize = CGSizeMake(scale * CGRectGetWidth([UIScreen mainScreen].bounds), scale * CGRectGetHeight([UIScreen mainScreen].bounds));
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (self.supportMultiple) {
                if (self.images.allValues.count == self.maxSelect) {
                    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
                    return;
                }
                [self.images setObject:result forKey:indexPath];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([self.delegate respondsToSelector:@selector(photosViewController:didSelectImage:)]) {
                        [self.delegate photosViewController:self didSelectImage:result];
                    }
                });
            }
        }];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.images removeObjectForKey:indexPath];
}

#pragma mark - camera / UIImagePickerControllerDelegate
- (void)openCamera {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    UIImagePickerController *cameraController = [[UIImagePickerController alloc] init];
    [cameraController setSourceType:UIImagePickerControllerSourceTypeCamera];
    [cameraController setDelegate:self];
    [self presentViewController:cameraController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *photo = info[UIImagePickerControllerOriginalImage];
    if (photo) {
        UIImageWriteToSavedPhotosAlbum(photo, nil, nil, nil);
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        if (self.supportMultiple == NO) {
            if ([self.delegate respondsToSelector:@selector(photosViewController:didSelectImage:)]) {
                [self.delegate photosViewController:self didSelectImage:photo];
            }
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        [_collectionView setAlwaysBounceVertical:YES];
        [_collectionView setBackgroundColor:self.view.backgroundColor];
        [_collectionView registerClass:[BayCameraCell class] forCellWithReuseIdentifier:kCameraCellIdentifier];
        [_collectionView registerClass:[BayPhotosCell class] forCellWithReuseIdentifier:kPhotosCellIdentifier];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        [_collectionView setAllowsMultipleSelection:self.supportMultiple];
    }
    return _collectionView;
}

- (NSMutableDictionary<NSIndexPath *,UIImage *> *)images {
    if (!_images) {
        _images = [[NSMutableDictionary alloc] init];
    }
    return _images;
}

@end
