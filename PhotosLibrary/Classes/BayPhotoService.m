//
//  BayPhotoService.m
//  Pods
//
//  Created by Xiaoyu Li on 09/04/2017.
//
//

#import "BayPhotoService.h"

#import "BayPhotosViewController.h"
#import "BayImageCropViewController.h"

@interface BayPhotoService() <BayPhotosViewControllerDelegate, BayImageCropViewControllerDelegate>

@property (weak, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (assign, nonatomic) BOOL needToCrop;
@property (assign, nonatomic) CGFloat ratio;
@property (copy, nonatomic) void (^singleImageBlock)(UIImage *);
@property (copy, nonatomic) void (^imagesBlock)(NSArray<UIImage *> *);

@end

@implementation BayPhotoService

- (void)selectSinglePhotoInViewController:(UIViewController *)viewController completion:(void (^)(UIImage *image))completion {
    self.singleImageBlock = completion;
    self.viewController = viewController;
    
    BayPhotosViewController *photosViewController = [[BayPhotosViewController alloc] init];
    [photosViewController setDelegate:self];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:photosViewController];
    if (viewController.navigationController != nil) {
        self.navigationController = [[viewController.navigationController.class alloc] initWithRootViewController:photosViewController];
    }
    [viewController presentViewController:self.navigationController animated:YES completion:nil];
}

- (void)selectSinglePhotoInViewController:(UIViewController *)viewController needCropWithCropRatio:(CGFloat)cropRatio completion:(void (^)(UIImage *image))completion {
    self.needToCrop = YES;
    self.ratio = cropRatio;
    [self selectSinglePhotoInViewController:viewController completion:completion];
}

- (void)selectMultiplePhotosInViewController:(nonnull UIViewController *)viewController completion:(nullable void (^)(NSArray<UIImage *> * _Nullable images))completion {
    self.imagesBlock = completion;
    BayPhotosViewController *photosViewController = [[BayPhotosViewController alloc] init];
    [photosViewController setDelegate:self];
    [photosViewController setSupportMultiple:YES];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:photosViewController];
    if (viewController.navigationController != nil) {
        self.navigationController = [[viewController.navigationController.class alloc] initWithRootViewController:photosViewController];
    }
    [viewController presentViewController:self.navigationController animated:YES completion:nil];
}

#pragma mark - BayPhotosViewControllerDelegate
- (void)photosViewController:(BayPhotosViewController *)photosVC didSelectImage:(UIImage *)image {
    __weak BayPhotoService *weakSelf = self;
    [photosVC dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.needToCrop) {
            BayImageCropViewController *cropViewController = [[BayImageCropViewController alloc] initWithImage:image cropRatio:weakSelf.ratio];
            [cropViewController setDelegate:weakSelf];
            [weakSelf.viewController presentViewController:cropViewController animated:YES completion:nil];
            weakSelf.needToCrop = NO;
        } else {
            weakSelf.singleImageBlock ? weakSelf.singleImageBlock(image) : nil;
            weakSelf.singleImageBlock = nil;
        }
    }];
}

- (void)photosViewController:(BayPhotosViewController *)photosVC didSelectImages:(NSArray<UIImage *> *)image {
    [photosVC dismissViewControllerAnimated:YES completion:^{
        self.imagesBlock ? self.imagesBlock(image) : nil;
        self.imagesBlock = nil;
    }];
}

#pragma mark - BayImageCropViewControllerDelegate
- (void)imageCropViewController:(BayImageCropViewController *)cropViewController didCropImage:(UIImage *)image {
    [cropViewController dismissViewControllerAnimated:YES completion:^{
        self.singleImageBlock ? self.singleImageBlock(image) : nil;
        self.singleImageBlock = nil;
    }];
}

@end
