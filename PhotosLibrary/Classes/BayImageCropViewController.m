//
//  BayImageCropViewController.m
//  Photos
//
//  Created by Xiaoyu Li on 08/04/2017.
//  Copyright © 2017 com.shanbay. All rights reserved.
//

/*
 *
 */
#import "BayImageCropViewController.h"
#import "UIImage+BayImageRotate.h"

@interface BayImageCropMaskView : UIView

@end

@implementation BayImageCropMaskView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [self.layer setBorderWidth:1.0f];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextSetLineWidth(context, 1.0);
    CGFloat widthInset = CGRectGetWidth(rect) / 3;
    CGFloat heightInset = CGRectGetHeight(rect) / 3;
    for (NSInteger i = 1; i < 3; i ++) {
        CGContextMoveToPoint(context, 0, heightInset * i);
        CGContextAddLineToPoint(context, CGRectGetWidth(rect), heightInset * i);
    }
    for (NSInteger i = 1; i < 3; i ++) {
        CGContextMoveToPoint(context, widthInset * i, 0);
        CGContextAddLineToPoint(context, widthInset * i, CGRectGetHeight(rect));
    }
    CGContextStrokePath(context);
}

@end

/*
 *
 */

CGFloat const kImageMaxScale = 3.0;

@interface BayImageCropViewController ()

@property (assign, nonatomic) CGFloat ratio;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UINavigationBar *navigationBar;
@property (strong, nonatomic) BayImageCropMaskView *cropView;

@property (assign, nonatomic) CGAffineTransform currentTransform;

@property (assign, nonatomic) CGFloat lastScale;
@property (assign, nonatomic) CGFloat currentScale;

@property (assign, nonatomic) CGRect originFrame;
@property (assign, nonatomic) CGRect lastFrame;
@property (assign, nonatomic) CGRect maxScaleFrame;

@property (assign, nonatomic) BOOL subviewFrameSetted;

@end

@implementation BayImageCropViewController

- (instancetype)initWithImage:(UIImage *)image cropRatio:(CGFloat)ratio {
    self = [super init];
    if (self) {
        _image = image;
        _ratio = ratio;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.cropView];
    [self.view addSubview:self.navigationBar];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[navigationBar]|" options:0 metrics:nil views:@{@"navigationBar": self.navigationBar}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[navigationBar]" options:0 metrics:nil views:@{@"navigationBar": self.navigationBar}]];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[cropView]|" options:0 metrics:nil views:@{@"cropView": self.cropView}]];
    [NSLayoutConstraint activateConstraints:@[[NSLayoutConstraint constraintWithItem:self.cropView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]]];
    [NSLayoutConstraint activateConstraints:@[[NSLayoutConstraint constraintWithItem:self.cropView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.cropView attribute:NSLayoutAttributeWidth multiplier:self.ratio constant:0]]];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.subviewFrameSetted == NO) {
        [self layoutImageFrame];
        self.subviewFrameSetted = YES;
    }
}

- (void)layoutImageFrame {
    [self.imageView setFrame:CGRectMake(0, 0, self.image.size.width * [self adjustImageScale], self.image.size.height * [self adjustImageScale])];
    [self.imageView setCenter:self.view.center];
    
    self.originFrame = self.imageView.frame;
    self.lastFrame = self.imageView.frame;
    
    CGSize maxScaledSize = CGSizeMake(CGRectGetWidth(self.originFrame) * kImageMaxScale, CGRectGetHeight(self.originFrame) * kImageMaxScale);
    CGPoint maxScaledOrigin = CGPointMake((CGRectGetWidth(self.originFrame) - maxScaledSize.width) / 2, CGRectGetMinY(self.originFrame) - (maxScaledSize.height - CGRectGetHeight(self.originFrame)) / 2);
    self.maxScaleFrame = CGRectMake(maxScaledOrigin.x, maxScaledOrigin.y, maxScaledSize.width, maxScaledSize.height);
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
    [UIView animateWithDuration:0.25 animations:^{
        
    }];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (CGFloat)adjustImageScale {
    CGRect scrollViewFrame = [UIScreen mainScreen].bounds;
    CGFloat widthScale = CGRectGetWidth(scrollViewFrame) / self.image.size.width;
    CGFloat heightScale = CGRectGetHeight(scrollViewFrame) / self.image.size.height;
    CGFloat scale = MIN(widthScale, heightScale);
    return scale;
}

- (UIImage *)croppedImage {
    if (self.image == nil) {
        return nil;
    }
    
    CGRect croppedFrame = self.cropView.frame;
    CGFloat scale = CGRectGetWidth(self.lastFrame) / self.image.size.width;
    CGFloat scaleX = (CGRectGetMinX(croppedFrame) - CGRectGetMinX(self.lastFrame)) / scale;
    CGFloat scaleY = (CGRectGetMinY(croppedFrame) - CGRectGetMinY(self.lastFrame)) / scale;
    CGFloat scaleWidth = CGRectGetWidth(croppedFrame) / scale;
    CGFloat scaleHeight = CGRectGetHeight(croppedFrame) / scale;
    
    if (CGRectGetWidth(self.lastFrame) < CGRectGetWidth(croppedFrame)) {
        CGFloat width = self.image.size.width;
        CGFloat height = width * (CGRectGetHeight(croppedFrame) / CGRectGetWidth(croppedFrame));
        scaleX = 0;
        scaleY += (scaleHeight - height) / 2;
        scaleWidth = width;
        scaleHeight = height;
    }
    if (CGRectGetHeight(self.lastFrame) < CGRectGetHeight(croppedFrame)) {
        CGFloat height = self.image.size.height;
        CGFloat width = height * (CGRectGetWidth(croppedFrame) / CGRectGetHeight(croppedFrame));
        scaleX += (scaleWidth - width) / 2;
        scaleY = 0;
        scaleWidth = width;
        scaleHeight = height;
    }
    
    CGRect scaleRect = CGRectMake(scaleX, scaleY, scaleWidth, scaleHeight);
    CGImageRef cropImageRef = CGImageCreateWithImageInRect(self.image.CGImage, scaleRect);
    UIGraphicsBeginImageContext(scaleRect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, scaleRect, cropImageRef);
    UIImage *cropImage = [UIImage imageWithCGImage:cropImageRef];
    CGImageRelease(cropImageRef);
    UIGraphicsEndImageContext();
    
    return cropImage;
}

- (void)backAction {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)rotateAction {
    self.image = [self.image bay_rotateByDegree:90];
    [self.imageView setImage:self.image];
    [self layoutImageFrame];
}

- (void)cropAction {
    UIImage *croppedImage = [self croppedImage];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(imageCropViewController:didCropImage:)]) {
            [self.delegate imageCropViewController:self didCropImage:croppedImage];
        }
    }];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    if ([panGesture state] == UIGestureRecognizerStateBegan || [panGesture state] == UIGestureRecognizerStateChanged) {
        CGRect cropFrame = self.cropView.frame;
        
        CGFloat absCenterX = CGRectGetMinX(cropFrame) + CGRectGetWidth(cropFrame) / 2;
        CGFloat absCenterY = CGRectGetMinY(cropFrame) + CGRectGetHeight(cropFrame) / 2;
        CGFloat scaleRatio = CGRectGetWidth(self.imageView.frame) / CGRectGetWidth(cropFrame);
        CGFloat acceleratorX = 1 - ABS(absCenterX - self.imageView.center.x) / (scaleRatio * absCenterX);
        CGFloat acceleratorY = 1 - ABS(absCenterY - self.imageView.center.y) / (scaleRatio * absCenterY);
        CGPoint translation = [panGesture translationInView:self.view];
        [self.imageView setCenter:(CGPoint){self.imageView.center.x + translation.x * acceleratorX, self.imageView.center.y + translation.y * acceleratorY}];
        [panGesture setTranslation:CGPointZero inView:self.view];
    } else {
        CGRect imageViewFrame = [self limitBorderFrameWithFrame:self.imageView.frame];
        [UIView animateWithDuration:0.25 animations:^{
            self.imageView.frame = imageViewFrame;
        } completion:^(BOOL finished) {
            self.lastFrame = imageViewFrame;
        }];
    }
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchGesture {
    if (pinchGesture.state == UIGestureRecognizerStateEnded || pinchGesture.state == UIGestureRecognizerStateCancelled) {
        CGRect imageViewFrame = [self limitScaleFrameWithFrame:self.imageView.frame];
        [UIView animateWithDuration:0.25 animations:^{
            [self.imageView setFrame:imageViewFrame];
        } completion:^(BOOL finished) {
            self.lastFrame = imageViewFrame;
        }];
        return;
    }
    [self.imageView setTransform:CGAffineTransformScale(self.imageView.transform, pinchGesture.scale, pinchGesture.scale)];
    pinchGesture.scale = 1.0;
}

- (CGRect)limitScaleFrameWithFrame:(CGRect)frame {
    if (CGRectGetWidth(frame) < CGRectGetWidth(self.originFrame) || CGRectGetHeight(frame) < CGRectGetHeight(self.originFrame)) {
        frame = self.originFrame;
    }
    if (CGRectGetWidth(frame) > CGRectGetWidth(self.maxScaleFrame) || CGRectGetHeight(frame) > CGRectGetHeight(self.maxScaleFrame)) {
        frame = self.maxScaleFrame;
    }
    
    CGPoint originCenter = CGPointMake(CGRectGetMinX(frame) + CGRectGetWidth(frame) / 2, CGRectGetMinY(frame) + CGRectGetHeight(frame) / 2);
    frame.origin.x = originCenter.x - CGRectGetWidth(frame) / 2;
    frame.origin.y = originCenter.y - CGRectGetHeight(frame) / 2;
    
    return frame;
}

- (CGRect)limitBorderFrameWithFrame:(CGRect)frame {
    CGRect cropFrame = self.cropView.frame;
    
    if (CGRectGetMinX(frame) > CGRectGetMinX(cropFrame)) {
        frame.origin.x = CGRectGetMinX(cropFrame);
    }
    if (CGRectGetMaxX(frame) < CGRectGetWidth(cropFrame)) {
        frame.origin.x = CGRectGetWidth(cropFrame) - CGRectGetWidth(frame);
    }
    
    if (CGRectGetMinY(frame) > CGRectGetMinY(cropFrame)) {
        frame.origin.y = CGRectGetMinY(cropFrame);
    }
    if (CGRectGetMaxY(frame) < CGRectGetMaxY(cropFrame)) {
        frame.origin.y = CGRectGetMaxY(cropFrame) - CGRectGetHeight(frame);
    }
    
    if (CGRectGetWidth(self.imageView.frame) > CGRectGetHeight(self.imageView.frame) && CGRectGetHeight(frame) <= CGRectGetHeight(cropFrame)) {
        frame.origin.y = CGRectGetMinY(cropFrame) + (CGRectGetHeight(cropFrame) - CGRectGetHeight(frame)) / 2;
    }
    
    return frame;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:self.image];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_imageView setUserInteractionEnabled:YES];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
        [_imageView addGestureRecognizer:panGesture];
        [_imageView addGestureRecognizer:pinchGesture];
    }
    return _imageView;
}

- (BayImageCropMaskView *)cropView {
    if (!_cropView) {
        _cropView = [[BayImageCropMaskView alloc] init];
        [_cropView setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _cropView;
}

- (UINavigationBar *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[UINavigationBar alloc] init];
        [_navigationBar setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [_navigationBar setShadowImage:[UIImage new]];
        [_navigationBar setTranslucent:YES];
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backAction)];
        [cancelButton setTintColor:[UIColor whiteColor]];
        UIBarButtonItem *confirmButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cropAction)];
        [confirmButton setTintColor:[UIColor whiteColor]];
        UIBarButtonItem *rotateButton = [[UIBarButtonItem alloc] initWithTitle:@"Rotate" style:UIBarButtonItemStylePlain target:self action:@selector(rotateAction)];
        
        [rotateButton setTintColor:[UIColor whiteColor]];
        UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
        [navigationItem setLeftBarButtonItem:cancelButton];
        [navigationItem setRightBarButtonItems:@[confirmButton, rotateButton]];
        [_navigationBar pushNavigationItem:navigationItem animated:YES];
    }
    return _navigationBar;
}

@end
