//
//  BayImageCropViewController.h
//  Photos
//
//  Created by Xiaoyu Li on 08/04/2017.
//  Copyright © 2017 com.shanbay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BayImageCropViewControllerDelegate;

@interface BayImageCropViewController : UIViewController

@property (weak, nonatomic, nullable) id<BayImageCropViewControllerDelegate> delegate;

/*
 * ratio = image.height / image.width
 */
- (nonnull instancetype)initWithImage:(nullable UIImage *)image cropRatio:(CGFloat)ratio;

@end

@protocol BayImageCropViewControllerDelegate <NSObject>

- (void)imageCropViewController:(nonnull BayImageCropViewController *)cropViewController didCropImage:(nullable UIImage *)image;

@end
