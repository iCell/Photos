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

@property (strong, nonatomic) UINavigationController *navigationController;
@property (assign, nonatomic) BOOL needToCrop;
@property (assign, nonatomic) CGFloat ratio;
@property (copy, nonatomic) void (^singleImageBlock)(UIImage *);
@property (copy, nonatomic) void (^imagesBlock)(NSArray<UIImage *> *);

@end

@implementation BayPhotoService

- (void)selectSinglePhotoInViewController:(UIViewController *)viewController completion:(void (^)(UIImage *image))completion {
    self.singleImageBlock = completion;
    
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

#pragma mark - BayPhotosViewControllerDelegate
- (void)photosViewController:(BayPhotosViewController *)photosVC didSelectImage:(UIImage *)image {
    if (self.needToCrop) {
        BayImageCropViewController *cropViewController = [[BayImageCropViewController alloc] initWithImage:image cropRatio:self.ratio];
        [cropViewController setDelegate:self];
        [self.navigationController pushViewController:cropViewController animated:YES];
        self.needToCrop = NO;
    } else {
        self.singleImageBlock ? self.singleImageBlock(image) : nil;
        self.singleImageBlock = nil;
    }
}

#pragma mark - BayImageCropViewControllerDelegate
- (void)imageCropViewController:(BayImageCropViewController *)cropViewController didCropImage:(UIImage *)image {
    self.singleImageBlock ? self.singleImageBlock(image) : nil;
    self.singleImageBlock = nil;
}

@end
