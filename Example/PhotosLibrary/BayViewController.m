//
//  BayViewController.m
//  PhotosLibrary
//
//  Created by icell.vip@gmail.com on 04/09/2017.
//  Copyright (c) 2017 icell.vip@gmail.com. All rights reserved.
//

#import "BayViewController.h"

#import <PhotosLibrary/BayPhotosViewController.h>
#import <PhotosLibrary/BayImageCropViewController.h>

@interface BayViewController () <BayPhotosViewControllerDelegate, BayImageCropViewControllerDelegate>

@end

@implementation BayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)selectImage:(UIButton *)sender {
    BayPhotosViewController *photosViewController = [[BayPhotosViewController alloc] init];
    [photosViewController setDelegate:self];
    [self.navigationController pushViewController:photosViewController animated:YES];
}

- (IBAction)selectImages:(id)sender {
    BayPhotosViewController *photosViewController = [[BayPhotosViewController alloc] init];
    [photosViewController setDelegate:self];
    [photosViewController setSupportMultiple:YES];
    [photosViewController setMaxSelect:4];
    [self.navigationController pushViewController:photosViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BayPhotosViewControllerDelegate
- (void)photosViewController:(BayPhotosViewController *)photosVC didSelectImage:(UIImage *)image {
    [self.navigationController popViewControllerAnimated:YES];
    BayImageCropViewController *cropViewController = [[BayImageCropViewController alloc] initWithImage:image cropRatio:1];
    [cropViewController setDelegate:self];
    [self.navigationController pushViewController:cropViewController animated:YES];
}

- (void)photosViewController:(BayPhotosViewController *)photosVC didSelectImages:(NSArray<UIImage *> *)images {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelSelectImageInPhotosViewController:(BayPhotosViewController *)photosVC {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - BayImageCropViewControllerDelegate
- (void)cancelCropImageInViewController:(BayImageCropViewController *)cropViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imageCropViewController:(BayImageCropViewController *)cropViewController didCropImage:(UIImage *)image {
    
}

@end
