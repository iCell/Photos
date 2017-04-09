//
//  BayPhotosCell.m
//  Photos
//
//  Created by Xiaoyu Li on 07/04/2017.
//  Copyright © 2017 com.shanbay. All rights reserved.
//

#import "BayPhotosCell.h"

CGFloat const kPhotosCellBorderWidth = 1;

@interface BayCameraCell()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation BayCameraCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageview]|" options:0 metrics:nil views:@{@"imageview": self.imageView}]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageview]|" options:0 metrics:nil views:@{@"imageview": self.imageView}]];
    }
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_imageView setContentMode:UIViewContentModeCenter];
        [_imageView setClipsToBounds:YES];
        [_imageView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [_imageView.layer setBorderWidth:kPhotosCellBorderWidth];
        [_imageView setImage:[UIImage imageNamed:@"icon_camera" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil]];
    }
    return _imageView;
}

@end

@interface BayPhotosCell()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *maskView;
@property (strong, nonatomic) UIImageView *indicator;

@end

@implementation BayPhotosCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.maskView];
        [self.contentView addSubview:self.indicator];
        
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageview]|" options:0 metrics:nil views:@{@"imageview": self.imageView}]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageview]|" options:0 metrics:nil views:@{@"imageview": self.imageView}]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[maskview]-margin-|" options:0 metrics:@{@"margin": @(kPhotosCellBorderWidth)} views:@{@"maskview": self.maskView}]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[maskview]-margin-|" options:0 metrics:@{@"margin": @(kPhotosCellBorderWidth)} views:@{@"maskview": self.maskView}]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[indicator]-margin-|" options:0 metrics:@{@"margin": @(kPhotosCellBorderWidth)} views:@{@"indicator": self.indicator}]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[indicator]-margin-|" options:0 metrics:@{@"margin": @(kPhotosCellBorderWidth)} views:@{@"indicator": self.indicator}]];
    }
    return self;
}

- (void)setThumbnail:(UIImage *)thumbnail {
    _thumbnail = thumbnail;
    [self.imageView setImage:_thumbnail];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
//        [self.indicator setImage:[UIImage imageNamed:__LEGACY_CommonsI(@"icon_image_selected")]];
//        self.maskView.backgroundColor = [UIColor blackColor];
//        self.maskView.alpha = 0.3;
    } else {
//        [self.indicator setImage:[UIImage imageNamed:__LEGACY_CommonsI(@"icon_image_deselected")]];
//        self.maskView.backgroundColor = [UIColor clearColor];
//        self.maskView.alpha = 1;
    }
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        [_imageView setClipsToBounds:YES];
        [_imageView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [_imageView.layer setBorderWidth:kPhotosCellBorderWidth];
    }
    return _imageView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_maskView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_maskView setBackgroundColor:[UIColor clearColor]];
    }
    return _maskView;
}

- (UIImageView *)indicator {
    if (!_indicator) {
        _indicator = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_indicator setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_indicator setContentMode:UIViewContentModeBottomRight];
        [_indicator setBackgroundColor:[UIColor clearColor]];
    }
    return _indicator;
}

@end
