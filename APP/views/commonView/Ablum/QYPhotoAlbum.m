//
//  QYPhotoAlbum.m
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

#import "QYPhotoAlbum.h"
#import "QYImage.h"

static int instanceNum = 0;

@interface QYPhotoAlbum ()
<UIAlertViewDelegate>
{
    ALAssetsLibrary *assetsLibrary;
    NSMutableArray *arrData;
    
    QYAblumPhotoBlock fullPhotoBlock;
    NSMutableArray *arrAssetList, *arrBlockList;
    dispatch_queue_t queuePhotoAlbum;

    float waitTime;
    int memorySize;
}
@end

@implementation QYPhotoAlbum
@synthesize isOpening=_isOpening;
+ (instancetype)instance{
    static id sharedInstance;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - init
- (id)init
{
    if (self == [super init]) {
        assetsLibrary=[[ALAssetsLibrary alloc] init];
        NSString *queueID = [NSString stringWithFormat:@"Queue_PhotoAlbum_%d", instanceNum++];
        queuePhotoAlbum = dispatch_queue_create([queueID UTF8String], NULL);
        fullPhotoBlock=nil;
        arrAssetList=[[NSMutableArray alloc]init];
        arrBlockList=[[NSMutableArray alloc]init];
        waitTime=0;
        _isOpening=NO;

        [self checkPhysicalMemory];
        return self;
    }
    return nil;
}
- (void)checkPhysicalMemory{
    if ([NSProcessInfo processInfo].physicalMemory<1000000000) {
        memorySize=500;
    }
    else memorySize=1000;
}

- (void)clean{
    [arrData removeAllObjects];
    arrData=nil;
}

//异步串行队列
- (void)invokeAsyncQueueBlock:(id (^)())block success:(void (^)(id obj))success
{
    dispatch_async(queuePhotoAlbum, ^(void) {
        id retVal = nil;
        if (block) {
            retVal = block();
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               if (success) {
                                   success(retVal);
                               }
                           });
        }
    });
}

- (void)getSavedPhotosBlock:(QYAssetsListBlock)resultBlock failure:(void(^)(NSError *error))failure{

    if (!arrData) {
        arrData = [[NSMutableArray alloc] initWithCapacity:0];
    } else {
        [arrData removeAllObjects];
    }
    
    //遍历相册组内照片
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [arrData insertObject:result atIndex:0];
        }
        else {
            
        }
    };
    
    //group获取方法，类似dictory，最后nil结尾，所以nil的时候调用reload
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            //只显示Photo(allPhotos),只显示Video(allVideos)，或显示全部(allAssets)
            ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
            [group setAssetsFilter:onlyPhotosFilter];
            [group enumerateAssetsUsingBlock:assetsEnumerationBlock];
        } else {
            if (resultBlock) {
                resultBlock(arrData);
            }
        }
    };
    
    //获取失败
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        if (failure) {
            failure(error);
        }

    };
    
    //查询saved组
    NSUInteger groupTypes = ALAssetsGroupSavedPhotos;
    [assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
}

- (void)getSavedPhotosOldFirstBlock:(QYAssetsListBlock)resultBlock failure:(void(^)(NSError *error))failure{
    if (!arrData) {
        arrData = [[NSMutableArray alloc] initWithCapacity:0];
    } else {
        [arrData removeAllObjects];
    }
    
    //遍历相册组内照片
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [arrData addObject:result];
        }
        else {
            
        }
    };
    
    //group获取方法，类似dictory，最后nil结尾，所以nil的时候调用reload
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            //只显示Photo(allPhotos),只显示Video(allVideos)，或显示全部(allAssets)
            ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
            [group setAssetsFilter:onlyPhotosFilter];
            [group enumerateAssetsUsingBlock:assetsEnumerationBlock];
        } else {
            if (resultBlock) {
                resultBlock(arrData);
            }
        }
    };
    
    //获取失败
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        if (failure) {
            failure(error);
        }
        
    };
    
    //查询saved组
    NSUInteger groupTypes = ALAssetsGroupSavedPhotos;
    [assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
}

- (void)getPhotosGroupsBlock:(QYAblumGroupsBlock)resultBlock failure:(void(^)(NSError *error))failure{
//    if (!assetsLibrary) {
//        assetsLibrary = [[ALAssetsLibrary alloc] init];
//    }
    
    if (!arrData) {
        arrData = [[NSMutableArray alloc] initWithCapacity:0];
    } else {
        [arrData removeAllObjects];
    }
    
    //group获取方法，类似dictory，最后nil结尾，所以nil的时候调用reload
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        //NSLog(@"ALAssetsLibraryGroups:%@",group);
        if (group) {
            ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
            [group setAssetsFilter:onlyPhotosFilter];
            
            ALAssetsGroupType assetType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
            //把相机胶卷列第一行
            if (assetType==ALAssetsGroupSavedPhotos) {
                [arrData insertObject:group atIndex:0];
            }
            else if(group.numberOfAssets>0)
                [arrData addObject:group];
            
        } else {
            if (resultBlock) {
                resultBlock(arrData);
            }
        }
    };
    
    //获取失败
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        if (failure) {
            failure(error);
        }
    };
    
    //查询组
    NSUInteger groupTypes =  ALAssetsGroupSavedPhotos | ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces;//ALAssetsGroupLibrary
    [assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
}

-(void)getPhotoAssetsByGroup:(ALAssetsGroup *)group resultBlock:(QYAssetsListBlock)resultBlock
{
    if (!arrData) {
        arrData = [[NSMutableArray alloc] initWithCapacity:0];
    } else {
        [arrData removeAllObjects];
    }

    ALAssetsGroupEnumerationResultsBlock groupEnumerAtion =^(ALAsset *result,NSUInteger index, BOOL *stop)
    {
        if (result!=NULL)
        {
            if ([[result valueForProperty:ALAssetPropertyType]isEqualToString:ALAssetTypePhoto])
            {
                [arrData addObject:result];
            }
        }
        else
        {
            resultBlock(arrData);
        }
        
    };
    [group enumerateAssetsUsingBlock:groupEnumerAtion];
}

- (void)getPhotosByGroup:(ALAssetsGroup*)group resultBlock:(QYAssetsListBlock)resultBlock failure:(void(^)(NSError *error))failure{

    if (!arrData) {
        arrData = [[NSMutableArray alloc] initWithCapacity:0];
    } else {
        [arrData removeAllObjects];
    }
    
    //遍历相册组内照片
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [arrData insertObject:result atIndex:0];
        }
        else {
            
        }
    };
    
    //group获取方法，类似dictory，最后nil结尾，所以nil的时候调用reload
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            //只显示Photo(allPhotos),只显示Video(allVideos)，或显示全部(allAssets)
            ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
            [group setAssetsFilter:onlyPhotosFilter];
            [group enumerateAssetsUsingBlock:assetsEnumerationBlock];
        } else {
            if (resultBlock) {
                resultBlock(arrData);
            }
        }
    };
    
    //获取失败
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        if (failure) {
            failure(error);
        }
        
    };
    
    //查询saved组
    NSUInteger groupTypes = ALAssetsGroupSavedPhotos;
    [assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
}



//- (UIImage *)getScreenImageByAsset:(ALAsset*)asset{
//    //获取原图
//    UIImage *fullResolutionImage;
//    @autoreleasepool {
////        ALAssetRepresentation *rep = [asset defaultRepresentation];
//        
//        fullResolutionImage = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
//        //[UIImage imageWithCGImage:rep.fullScreenImage scale:[rep scale] orientation:UIImageOrientationUp];
//    }
//    return fullResolutionImage;
//}

//- (UIImage *)getFull ImageByAsset:(ALAsset*)asset limitBite:(NSInteger)limitBite{
//    //获取图
//    UIImage *fullResolutionImage;
//    @autoreleasepool {
//        ALAssetRepresentation *rep = [asset defaultRepresentation];
//        float scale=rep.scale;
//        
//        if (limitBite > 0 && rep.size > limitBite) {
//            scale=(float)rep.size/(float)limitBite;
//        }
//        
//        fullResolutionImage = [UIImage imageWithCGImage:rep.fullResolutionImage scale:scale orientation:(UIImageOrientation)rep.orientation];
//        //        DebugLog(@"%lld:%d->%f,%@",rep.size,limitBite,scale,NSStringFromCGSize(fullResolutionImage.size));
//    }
//    return fullResolutionImage;
//}

- (void)getFullImageByURL:(NSString*)assetUrl photo:(void(^)(UIImage *thumbnail, UIImage *fullResolutionImage))photo failure:(void(^)(NSError *error))failure{
    [assetsLibrary assetForURL:[NSURL URLWithString:assetUrl] resultBlock:^(ALAsset *asset){
        @autoreleasepool {
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            
            UIImage *fullResolutionImage = [UIImage imageWithCGImage:[rep fullResolutionImage] scale:[rep scale] orientation:(UIImageOrientation)rep.orientation];
            //            [fullResolutionImage imageByScalingToMinSize]
            photo([UIImage imageWithCGImage:asset.thumbnail],fullResolutionImage);
        }
    }  failureBlock:failure];
}

//- (void)getFull ImageByAsset:(ALAsset*)asset photo:(void(^)(UIImage *fullResolutionImage))photo failure:(void(^)(NSError *error))failure{
//    @autoreleasepool {
//        ALAssetRepresentation *rep = [asset defaultRepresentation];
//        UIImage *fullResolutionImage = [UIImage imageWithCGImage:[rep fullResolutionImage] scale:[rep scale] orientation:(UIImageOrientation)rep.orientation];
//        photo(fullResolutionImage);
//    }
//}
- (void)getFullImageByURL:(NSString*)assetUrl photoBlock:(QYAblumPhotoBlock)photoBlock assetBlock:(void(^)(ALAsset *asset))assetBlock failure:(void(^)(NSError *error))failure{
    
    [assetsLibrary assetForURL:[NSURL URLWithString:assetUrl] resultBlock:^(ALAsset *asset){
        
        assetBlock(asset);

        if (photoBlock) {
            [arrBlockList addObject:photoBlock];
        }
        
        if (asset != nil) {
            [arrAssetList addObject:asset];
        }
        
        [self photosQueue];
    }  failureBlock:failure];
}

- (void)getFullImageByAsset:(ALAsset*)asset photoBlock:(QYAblumPhotoBlock)photoBlock failure:(void(^)(NSError *error))failure{    
    if (photoBlock && asset) {
        [arrBlockList addObject:photoBlock];
        [arrAssetList addObject:asset];
    }
    
    
    [self photosQueue];
}

- (void)getFullImageByAssetList:(NSArray*)list photoBlock:(QYAblumPhotoBlock)photoBlock failure:(void(^)(NSError *error))failure{
    [self cleanPhotosQueue];
   
    fullPhotoBlock = photoBlock;
    if (list.count) {
        [arrAssetList addObjectsFromArray:list];
    }
    [self photosQueue];
}

- (void)getImagesByAssetList:(NSArray*)list photosBlock:(void(^)(NSArray* listPhotos))photosBlock failure:(void(^)(NSError *error))failure{
    [self cleanPhotosQueue];
    NSMutableArray *tmp=[[NSMutableArray alloc] initWithCapacity:list.count];
    
    __weak typeof (self) weakSelf = self;
    fullPhotoBlock = ^(UIImage *fullResolutionImage){
        [tmp addObject:[weakSelf photoToMin:fullResolutionImage]];
        if (tmp.count==list.count) {
            if (photosBlock) {
                photosBlock(tmp);
            }
        }
    };
    if (list.count) {
        [arrAssetList addObjectsFromArray:list];
    }
    
    [self photosQueue];
}


- (UIImage *)getFullImageByAsset:(ALAsset*)asset{
    //获取原图
    UIImage *fullResolutionImage;
    
    @autoreleasepool {
        ALAssetRepresentation *rep = [asset defaultRepresentation];
//        DebugLog(@"AAAAAAAAAAAAAAAAA %lld",rep.size);
        CGImageRef imgc=[rep fullResolutionImage];
//        DebugLog(@"+++++++++++++++++");
        fullResolutionImage = [UIImage imageWithCGImage:imgc scale:[rep scale] orientation:(UIImageOrientation)rep.orientation];
//        DebugLog(@"VVVVVVVVVVVVVVVVV %@",NSStringFromCGSize(fullResolutionImage.size));
    }
    
    return fullResolutionImage;
}

#pragma mark - 图片处理
- (UIImage*)photoToMin:(UIImage*)photo{
    UIImage * image = photo;
    image = [image imageByScalingToMinSize];
    image = [UIImage scaleAndRotateImage:image];
    return image;
}
#pragma mark - 图片队列
- (UIImage *)photosQueue{
//    DebugLog(@"photosQueue 正在加载x%d: %f",arrAssetList.count,waitTime);
    if (arrAssetList.count>0) {
        if (waitTime>0) {
            return nil;
        }

        ALAsset *ass = [arrAssetList firstObject];
        QYAblumPhotoBlock block = nil;
        if (arrBlockList.count>0) {
            block = [arrBlockList firstObject];
        }
        
        long long sz=ass.defaultRepresentation.size;
        if (sz>10000000) {
            
            waitTime=(double)sz/10000000.0;
//            DebugLog(@"大数据: %f",waitTime);
        }
        else {
            waitTime=0.25f;
        }
        
        if (memorySize>500) {
            waitTime=0.1f;
        }
        
        UIImage *img=[self getFullImageByAsset:ass];
        
        if (block)
            block(img);
        else if(fullPhotoBlock){
            fullPhotoBlock(img);
        }
        
        [arrAssetList removeObject:ass];
        if (block) [arrBlockList removeObject:block];
        
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [self performSelector:@selector(startPhotosQueue) withObject:nil afterDelay:waitTime];
                       });
        
        return img;
    }
    return nil;
}

- (void)startPhotosQueue{

    waitTime=0.f;
    [self photosQueue];
}

- (void)cleanPhotosQueue{
    fullPhotoBlock=nil;
    
    [arrAssetList removeAllObjects];
    [arrBlockList removeAllObjects];
}

- (BOOL)isOpening{
    if (waitTime>0) {
        return YES;
    }
    return NO;
}

- (void)setIsOpening:(BOOL)isOpening{
    _isOpening=isOpening;
}


#pragma mark - 检查设置状态
+ (BOOL)checkAlbumAuthorizationStatus{
    BOOL auth=YES;
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    
    if(status == ALAuthorizationStatusNotDetermined){
        //请求访问相册
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (*stop) {
                
                return;
            }
            *stop = TRUE;
        } failureBlock:^(NSError *error) {
            
        }];
        return auth;
    }
    else if (status == ALAuthorizationStatusDenied) {
        auth=NO;
    }
//    else {
////        auth=NO;
//    }
    
    return auth;
}

+ (BOOL)checkCameraAuthorizationStatus{
    BOOL auth=YES;
    if (![[AVCaptureDevice  class] respondsToSelector:@selector(authorizationStatusForMediaType:)])
    {
        //Do something…
        
    }
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authStatus)
    {
        case AVAuthorizationStatusAuthorized:
        case AVAuthorizationStatusRestricted:
        {
            //Do something…
            break;
        }
        case AVAuthorizationStatusDenied:
        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"App name" message:@"Appname does not have access to your camera. To enable access, go to iPhone Settings > AppName and turn on Camera." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
            
            //设置里摄像头被关了
            auth=false;
            break;
        }
        case AVAuthorizationStatusNotDetermined:
        {
            // //请求访问
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
             {
                 if(granted)
                 {
                     dispatch_async(dispatch_get_main_queue(), ^
                                    {
                                        //Do something…
                                    });
                 }
                 else
                 {
                     dispatch_async(dispatch_get_main_queue(), ^
                                    {
                                        //Do something…
                                    });
                 }
             }];
            break;
        }
        default:
            break;
    }
    return auth;
}

#pragma mark -
#pragma mark - 保存到相册

- (void)saveImageToSavePhoto:(UIImage*)image resultBlock:(void(^)(NSString *url, ALAsset *asset))resultBlock failure:(void(^)(NSError *error))failure
{
    NSData *data=UIImageJPEGRepresentation(image, 1.0);
    [assetsLibrary writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        //error handling
        if (error!=nil) {
            if (failure)
                failure(error);
            return;
        }
        
        [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset){
            resultBlock(assetURL.absoluteString, asset);
        }  failureBlock:failure];
        
    }];
}

#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSLog(@"clickButtonAtIndex:%ld",(long)buttonIndex);
}
@end
