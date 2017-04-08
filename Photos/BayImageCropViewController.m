//
//  BayImageCropViewController.m
//  Photos
//
//  Created by Xiaoyu Li on 08/04/2017.
//  Copyright © 2017 com.shanbay. All rights reserved.
//

#import "BayImageCropViewController.h"

@interface BayImageCropViewController ()

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation BayImageCropViewController

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _image = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageView];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics:nil views:@{@"imageView": self.imageView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:0 metrics:nil views:@{@"imageView": self.imageView}]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self.navigationController setNavigationBarHidden:!self.navigationController.isNavigationBarHidden animated:YES];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:self.image];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _imageView;
}

@end
