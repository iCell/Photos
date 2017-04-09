//
//  UIImage+BayImageCrop.m
//  Photos
//
//  Created by Xiaoyu Li on 08/04/2017.
//  Copyright © 2017 com.shanbay. All rights reserved.
//

#import "UIImage+BayImageRotate.h"

@implementation UIImage (BayImageRotate)

- (UIImage *)bay_rotateByDegree:(CGFloat)degree {
    CGAffineTransform t = CGAffineTransformMakeRotation(degree * M_PI / 180);
    CGRect originalImageRect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGRect rotatedImageRect = CGRectApplyAffineTransform(originalImageRect, t);
    CGSize rotatedSize = rotatedImageRect.size;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, degree * M_PI / 180);
    
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
