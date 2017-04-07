//
//  BayPhotosReusableView.m
//  Photos
//
//  Created by Xiaoyu Li on 07/04/2017.
//  Copyright © 2017 com.shanbay. All rights reserved.
//

#import "BayPhotosReusableView.h"

@interface BayPhotosReusableView()

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation BayPhotosReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        _titleLabel.textColor = [UIColor lightTextColor];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_titleLabel];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[title]|" options:0 metrics:nil views:@{@"title": _titleLabel}]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[title]|" options:0 metrics:nil views:@{@"title": _titleLabel}]];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(self.titleLabel.intrinsicContentSize.width + 8, self.titleLabel.intrinsicContentSize.height);
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.titleLabel setText:nil];
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    [self.titleLabel setFont:_titleFont];
    [self invalidateIntrinsicContentSize];
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    [self.titleLabel setTextColor:_titleColor];
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    [self.titleLabel setText:_title];
    [self invalidateIntrinsicContentSize];
}

@end
