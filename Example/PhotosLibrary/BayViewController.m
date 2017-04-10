//
//  BayViewController.m
//  PhotosLibrary
//
//  Created by icell.vip@gmail.com on 04/09/2017.
//  Copyright (c) 2017 icell.vip@gmail.com. All rights reserved.
//

#import "BayViewController.h"

#import <PhotosLibrary/BayPhotoService.h>

@interface BayViewController ()

@property (strong, nonatomic) BayPhotoService *photoService;

@end

@implementation BayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)selectImage:(UIButton *)sender {
    [self.photoService selectSinglePhotoInViewController:self.navigationController completion:^(UIImage * _Nullable image) {
        
    }];
}

- (IBAction)selectImages:(id)sender {
    [self.photoService selectMultiplePhotosInViewController:self.navigationController completion:^(NSArray<UIImage *> * _Nullable images) {
        
    }];
}

- (IBAction)cropImage:(UIButton *)sender {
    [self.photoService selectSinglePhotoInViewController:self.navigationController needCropWithCropRatio:1.0 completion:^(UIImage * _Nullable image) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BayPhotoService *)photoService {
    if (!_photoService) {
        _photoService = [[BayPhotoService alloc] init];
    }
    return _photoService;
}

@end
