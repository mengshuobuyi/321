//
//  DFAssetsHelper.m
//  DFace
//
//  Created by kabda on 7/1/14.
//
//

#import "DFAssetsHelper.h"

@implementation DFAssetsHelper

+ (DFAssetsHelper *)sharedInstance
{
    static DFAssetsHelper *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[DFAssetsHelper alloc] init];
        [_sharedInstance initAsset];
    });
    
    return _sharedInstance;
}

- (void)initAsset
{
    if (!self.assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
        NSString *strVersion = [[UIDevice alloc] systemVersion];
        if ([strVersion compare:@"5"] >= 0) {
            [_assetsLibrary writeImageToSavedPhotosAlbum:nil metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
                
            }];
        }
    }
}

- (void)setCameraRollAtFirst
{
    for (int index = 0; index < _assetGroups.count; index++) {
        ALAssetsGroup *group = _assetGroups[index];
        if ([group isKindOfClass:[ALAssetsGroup class]] && [[group valueForProperty:@"ALAssetsGroupPropertyType"] intValue] == ALAssetsGroupSavedPhotos && index > 0) {
            [_assetGroups exchangeObjectAtIndex:index withObjectAtIndex:0];
            return;
        }
    }
}

- (void)getGroupList:(void (^)(NSArray *))result
{
    [self initAsset];
    
    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        if (group == nil) {
            if (_bReverse) {
                _assetGroups = [[NSMutableArray alloc] initWithArray:[[_assetGroups reverseObjectEnumerator] allObjects]];
            }
            [self setCameraRollAtFirst];
            result(_assetGroups);
            return;
        }
        [_assetGroups addObject:group];
    };
    
    void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
        NSLog(@"Error : %@", [error description]);
    };
    
    _assetGroups = [[NSMutableArray alloc] init];
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                  usingBlock:assetGroupEnumerator
                                failureBlock:assetGroupEnumberatorFailure];
}

- (void)getPhotoListOfGroup:(ALAssetsGroup *)alGroup result:(void (^)(NSArray *))result
{
    [self initAsset];
    
    _assetPhotos = [[NSMutableArray alloc] init];
    [alGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    [alGroup enumerateAssetsUsingBlock:^(ALAsset *alPhoto, NSUInteger index, BOOL *stop) {
        if(alPhoto == nil) {
            if (_bReverse) {
                _assetPhotos = [[NSMutableArray alloc] initWithArray:[[_assetPhotos reverseObjectEnumerator] allObjects]];
            }
            result(_assetPhotos);
            return;
        }
        DFSelectablePhoto *dfPhoto = [[DFSelectablePhoto alloc]init];
        dfPhoto.asset = alPhoto;
        dfPhoto.selected = NO;
        [_assetPhotos insertObject:dfPhoto atIndex:0];
    }];
}

- (void)getPhotoListOfGroupByIndex:(NSInteger)nGroupIndex result:(void (^)(NSArray *))result
{
    [self getPhotoListOfGroup:_assetGroups[nGroupIndex] result:^(NSArray *aResult) {
        result(_assetPhotos);
    }];
}

- (void)getSavedPhotoList:(void (^)(NSArray *))result error:(void (^)(NSError *))error
{
    [self initAsset];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
            if ([[group valueForProperty:@"ALAssetsGroupPropertyType"] intValue] == ALAssetsGroupSavedPhotos) {
                [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                [group enumerateAssetsUsingBlock:^(ALAsset *alPhoto, NSUInteger index, BOOL *stop) {
                    if(alPhoto == nil) {
                        if (_bReverse) {
                            _assetPhotos = [[NSMutableArray alloc] initWithArray:[[_assetPhotos reverseObjectEnumerator] allObjects]];
                        }
                        result(_assetPhotos);
                        return;
                    }
                    DFSelectablePhoto *dfPhoto = [[DFSelectablePhoto alloc]init];
                    dfPhoto.asset = alPhoto;
                    dfPhoto.selected = NO;
                    [_assetPhotos addObject:dfPhoto];
                }];
            }
        };
        
        void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *err) {
            NSLog(@"Error : %@", [err description]);
            error(err);
        };
        
        _assetPhotos = [[NSMutableArray alloc] init];
        [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                      usingBlock:assetGroupEnumerator
                                    failureBlock:assetGroupEnumberatorFailure];
    });
}

- (NSInteger)getGroupCount
{
    return _assetGroups.count;
}

- (NSInteger)getPhotoCountOfCurrentGroup
{
    return _assetPhotos.count;
}

- (NSDictionary *)getGroupInfo:(NSInteger)nIndex
{
    return @{@"name" : [_assetGroups[nIndex] valueForProperty:ALAssetsGroupPropertyName],
             @"count" : @([_assetGroups[nIndex] numberOfAssets]),
             @"poster" : [UIImage imageWithCGImage:[_assetGroups[nIndex] posterImage]]};
}

- (void)clearData
{
	_assetGroups = nil;
	_assetPhotos = nil;
}

#pragma mark - utils
- (UIImage *)getCroppedImage:(NSURL *)urlImage
{
    __block UIImage *iImage = nil;
    __block BOOL bBusy = YES;
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset) {
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        NSString *strXMP = rep.metadata[@"AdjustmentXMP"];
        if (strXMP == nil || [strXMP isKindOfClass:[NSNull class]]) {
            CGImageRef iref = [rep fullResolutionImage];
            if (iref)
                iImage = [UIImage imageWithCGImage:iref scale:1.0 orientation:(UIImageOrientation)rep.orientation];
            else
                iImage = nil;
        } else {
            NSData *dXMP = [strXMP dataUsingEncoding:NSUTF8StringEncoding];
            
            CIImage *image = [CIImage imageWithCGImage:rep.fullResolutionImage];
            
            NSError *error = nil;
            NSArray *filterArray = [CIFilter filterArrayFromSerializedXMP:dXMP
                                                         inputImageExtent:image.extent
                                                                    error:&error];
            if (error) {
                NSLog(@"Error during CIFilter creation: %@", [error localizedDescription]);
            }
            
            for (CIFilter *filter in filterArray) {
                [filter setValue:image forKey:kCIInputImageKey];
                image = [filter outputImage];
            }
            
            iImage = [UIImage imageWithCIImage:image scale:1.0 orientation:(UIImageOrientation)rep.orientation];
        }
        
		bBusy = NO;
    };
    
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror) {
        NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
    };
    
    [_assetsLibrary assetForURL:urlImage
                    resultBlock:resultblock
                   failureBlock:failureblock];
    
	while (bBusy)
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    
    return iImage;
}

- (UIImage *)getImageFromAsset:(ALAsset *)asset type:(NSInteger)nType
{
    CGImageRef iRef = nil;
    
    if (nType == ASSET_PHOTO_THUMBNAIL) {
        iRef = [asset thumbnail];
    } else if (nType == ASSET_PHOTO_ASPECT_THUMBNAIL) {
        iRef = [asset aspectRatioThumbnail];
    } else if (nType == ASSET_PHOTO_SCREEN_SIZE) {
        iRef = [asset.defaultRepresentation fullScreenImage];
    } else if (nType == ASSET_PHOTO_FULL_RESOLUTION) {
        NSString *strXMP = asset.defaultRepresentation.metadata[@"AdjustmentXMP"];
        if (strXMP == nil || [strXMP isKindOfClass:[NSNull class]]) {
            iRef = [asset.defaultRepresentation fullResolutionImage];
            return [UIImage imageWithCGImage:iRef scale:1.0 orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
        } else {
            NSData *dXMP = [strXMP dataUsingEncoding:NSUTF8StringEncoding];
            
            CIImage *image = [CIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
            
            NSError *error = nil;
            NSArray *filterArray = [CIFilter filterArrayFromSerializedXMP:dXMP
                                                         inputImageExtent:image.extent
                                                                    error:&error];
            if (error) {
                NSLog(@"Error during CIFilter creation: %@", [error localizedDescription]);
            }
            
            for (CIFilter *filter in filterArray) {
                [filter setValue:image forKey:kCIInputImageKey];
                image = [filter outputImage];
            }
            
            UIImage *iImage = [UIImage imageWithCIImage:image scale:1.0 orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
            return iImage;
        }
    }
    
    return [UIImage imageWithCGImage:iRef];
}

- (UIImage *)getImageAtIndex:(NSInteger)nIndex type:(NSInteger)nType
{
    ALAsset *asset = [self getAssetAtIndex:nIndex];
    return [self getImageFromAsset:asset type:nType];
}

- (ALAsset *)getAssetAtIndex:(NSInteger)nIndex
{
    DFSelectablePhoto *dfPhoto = [self getPhotoAtIndex:nIndex];
    return dfPhoto.asset;
}

- (DFSelectablePhoto *)getPhotoAtIndex:(NSInteger)nIndex
{
    return (DFSelectablePhoto *)_assetPhotos[nIndex];
}

- (ALAssetsGroup *)getGroupAtIndex:(NSInteger)nIndex
{
    return _assetGroups[nIndex];
}

- (UIImage *)getImageFromPhoto:(DFSelectablePhoto *)photo wityType:(NSInteger)nType
{
    return [self getImageFromAsset:photo.asset type:nType];
}

#pragma mark - selector
- (void)markPhotoSelectedAtIndex:(NSInteger)nIndex
{
    if (!_selectedPhotos) {
        _selectedPhotos = [[NSMutableArray alloc]initWithCapacity:0];
    }
    DFSelectablePhoto *photo = [self getPhotoAtIndex:nIndex];
    [self markPhoto:photo selected:YES];
}

- (void)markPhotoUnSelectedAtIndex:(NSInteger)nIndex
{
    if (!_selectedPhotos || _selectedPhotos.count <= 0) {
        return;
    }
    DFSelectablePhoto *photo = [self getPhotoAtIndex:nIndex];
    [self markPhoto:photo selected:NO];
}

- (void)markPhoto:(DFSelectablePhoto *)photo selected:(BOOL)selected
{
    if (photo.isSelected == selected) {
        return;
    }
    photo.selected = selected;
    @synchronized (_selectedPhotos) {
        if (selected) {
            [_selectedPhotos addObject:photo];
        } else {
            [_selectedPhotos removeObjectIdenticalTo:photo];
        }
    }
}

- (ALAsset *)getSelectedAssetAtIndex:(NSInteger)nIndex
{
    DFSelectablePhoto *dfPhoto = [self getSelectedPhotoAtIndex:nIndex];
    return dfPhoto.asset;
}

- (DFSelectablePhoto *)getSelectedPhotoAtIndex:(NSInteger)nIndex
{
    @synchronized (_selectedPhotos) {
        return (DFSelectablePhoto *)_selectedPhotos[nIndex];
    }
}

- (UIImage *)getSelectedImageAtIndex:(NSInteger)nIndex type:(NSInteger)nType
{
    ALAsset *asset = [self getSelectedAssetAtIndex:nIndex];
    return [self getImageFromAsset:asset type:nType];
}

- (NSInteger)getSelectedPhotosCount
{
    @synchronized (_selectedPhotos) {
        return _selectedPhotos.count;
    }
}

- (NSInteger)indexOfSelectedPhoto:(DFSelectablePhoto *)photo
{
    @synchronized (_selectedPhotos) {
        if (!_selectedPhotos) {
            return NSNotFound;
        }
        return [_selectedPhotos indexOfObjectIdenticalTo:photo];
    }
}

- (void)clearSelectedPhotos
{
    @synchronized (_selectedPhotos) {
        _selectedPhotos = nil;
    }
}

- (NSArray *)getPhotosByRange:(NSRange)range
{
    NSInteger total = _assetPhotos.count;
    if (range.location >= total) {
        return nil;
    }
    if (range.location + range.length >= total) {
        range.length = total - range.location;
    }
    return [_assetPhotos subarrayWithRange:range];
}
@end
