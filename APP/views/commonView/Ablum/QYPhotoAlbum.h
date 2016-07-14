//
//  QYPhotoAlbum.h
//  PhotoInfo
//
//  Created by YAN Qingyang on 13-5-12.
//  Copyright (c) 2013年 YAN Qingyang. All rights reserved.
//  Version 0.1
//
// This code is distributed under the terms and conditions of the MIT license.

// Copyright (c) 2014 YAN Qingyang
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

//#import "QYImage.h"
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import <ImageIO/ImageIO.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Ex.h"

#define  PhotosAlbum [QYPhotoAlbum instance]

typedef void (^QYAssetsListBlock)(NSArray *arrAssets);
typedef void (^QYAblumGroupsBlock)(NSArray *arrGroups);
typedef void (^QYAblumPhotoBlock)(UIImage *fullResolutionImage);

@interface QYPhotoAlbum : NSObject
@property (assign) BOOL isOpening;

+ (instancetype)instance;
- (void)clean;
- (void)cleanPhotosQueue;
- (UIImage*)photoToMin:(UIImage*)photo;

//url获取图片
- (void)getFullImageByAsset:(ALAsset*)asset photoBlock:(QYAblumPhotoBlock)photoBlock failure:(void(^)(NSError *error))failure;
- (void)getFullImageByURL:(NSString*)assetUrl photoBlock:(QYAblumPhotoBlock)photoBlock assetBlock:(void(^)(ALAsset *asset))assetBlock failure:(void(^)(NSError *error))failure;
- (void)getFullImageByAssetList:(NSArray*)list photoBlock:(QYAblumPhotoBlock)photoBlock failure:(void(^)(NSError *error))failure;
- (void)getImagesByAssetList:(NSArray*)list photosBlock:(void(^)(NSArray* listPhotos))photosBlock failure:(void(^)(NSError *error))failure;

//保存
- (void)saveImageToSavePhoto:(UIImage*)image resultBlock:(void(^)(NSString *url, ALAsset *asset))resultBlock failure:(void(^)(NSError *error))failure;
////
- (void)getSavedPhotosBlock:(QYAssetsListBlock)resultBlock failure:(void(^)(NSError *error))failure;
- (void)getSavedPhotosOldFirstBlock:(QYAssetsListBlock)resultBlock failure:(void(^)(NSError *error))failure;

- (void)getPhotosGroupsBlock:(QYAblumGroupsBlock)resultBlock failure:(void(^)(NSError *error))failure;
- (void)getPhotoAssetsByGroup:(ALAssetsGroup *)group resultBlock:(QYAssetsListBlock)resultBlock;


#pragma mark - 检查设置状态
+ (BOOL)checkAlbumAuthorizationStatus;
+ (BOOL)checkCameraAuthorizationStatus;
@end
