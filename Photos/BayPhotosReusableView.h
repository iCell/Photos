//
//  BayPhotosReusableView.h
//  Photos
//
//  Created by Xiaoyu Li on 07/04/2017.
//  Copyright © 2017 com.shanbay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BayPhotosReusableView : UICollectionReusableView

@property (strong, nonatomic) UIColor *titleColor;
@property (strong, nonatomic) UIFont *titleFont;
@property (copy, nonatomic) NSString *title;

@end
