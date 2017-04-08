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

@end

@protocol BayPhotosViewControllerDelegate <NSObject>

@optional
- (void)photosViewController:(nonnull BayPhotosViewController *)photosVC didSelectImage:(nullable UIImage *)image;

@end
