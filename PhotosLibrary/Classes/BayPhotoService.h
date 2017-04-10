//
//  BayPhotoService.h
//  Pods
//
//  Created by Xiaoyu Li on 09/04/2017.
//
//

#import <Foundation/Foundation.h>

@interface BayPhotoService : NSObject

- (void)selectSinglePhotoInViewController:(nonnull UIViewController *)viewController completion:(nullable void (^)(UIImage * _Nullable image))completion;
- (void)selectSinglePhotoInViewController:(nonnull UIViewController *)viewController needCropWithCropRatio:(CGFloat)cropRatio completion:(nullable void (^)(UIImage * _Nullable image))completion;
- (void)selectMultiplePhotosInViewController:(nonnull UIViewController *)viewController completion:(nullable void (^)(NSArray<UIImage *> * _Nullable images))completion;

@end
