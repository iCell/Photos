//
//  BayPhotosViewController.h
//  Photos
//
//  Created by Xiaoyu Li on 07/04/2017.
//  Copyright © 2017 com.shanbay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BayPhotosViewControllerDelegate;

@interface BayPhotosViewController : UIViewController

@property (weak, nonatomic, nullable) id<BayPhotosViewControllerDelegate> delegate;
@property (assign, nonatomic) BOOL supportMultiple;
@property (assign, nonatomic) NSInteger maxSelect;

@end

@protocol BayPhotosViewControllerDelegate <NSObject>

@optional
- (void)photosViewController:(nonnull BayPhotosViewController *)photosVC didSelectImage:(nullable UIImage *)image;
- (void)photosViewController:(nonnull BayPhotosViewController *)photosVC didSelectImages:(nonnull NSArray<UIImage *> *)image;

@end
