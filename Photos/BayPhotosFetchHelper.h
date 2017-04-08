//
//  BayPhotosFetchHelper.h
//  Photos
//
//  Created by Xiaoyu Li on 08/04/2017.
//  Copyright © 2017 com.shanbay. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Photos;

typedef NS_ENUM(NSInteger, BayPhotoCollectionSection) {
    BayPhotoCollectionSectionAllPhoto,
    BayPhotoCollectionSectionSmartAlbum,
    BayPhotoCollectionSectionUserCollections
};

@protocol BayPhotosFetcherHelperDelegate;

@interface BayPhotosFetchHelper : NSObject

@property (weak, nonatomic) id<BayPhotosFetcherHelperDelegate> delegate;

- (void)registerCollectionsChange;
- (void)unregisterCollectionsChange;

@end

@protocol BayPhotosFetcherHelperDelegate <NSObject>

- (void)didFetchAllPhotos:(PHFetchResult<PHAsset *> *)allPhotos;

@end
