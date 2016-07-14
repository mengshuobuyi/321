//
//  DFAssetsHelper.h
//  DFace
//
//  Created by kabda on 7/1/14.
//
//

#import "DFSelectablePhoto.h"

#define AssetsHelper    [DFAssetsHelper sharedInstance]

#define ASSET_PHOTO_THUMBNAIL           0
#define ASSET_PHOTO_ASPECT_THUMBNAIL    1
#define ASSET_PHOTO_SCREEN_SIZE         2
#define ASSET_PHOTO_FULL_RESOLUTION     3

@interface DFAssetsHelper : NSObject
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *assetPhotos;
@property (nonatomic, strong) NSMutableArray *assetGroups;
@property (nonatomic, strong) NSMutableArray *selectedPhotos;

@property (readwrite) BOOL bReverse;

+ (DFAssetsHelper *)sharedInstance;

- (void)initAsset;

- (void)getGroupList:(void (^)(NSArray *))result;
- (void)getPhotoListOfGroup:(ALAssetsGroup *)alGroup result:(void (^)(NSArray *))result;
- (void)getPhotoListOfGroupByIndex:(NSInteger)nGroupIndex result:(void (^)(NSArray *))result;
- (void)getSavedPhotoList:(void (^)(NSArray *))result error:(void (^)(NSError *))error;

- (NSInteger)getGroupCount;
- (NSInteger)getPhotoCountOfCurrentGroup;
- (NSDictionary *)getGroupInfo:(NSInteger)nIndex;

- (void)clearData;

- (UIImage *)getCroppedImage:(NSURL *)urlImage;

- (UIImage *)getImageAtIndex:(NSInteger)nIndex type:(NSInteger)nType;
- (ALAsset *)getAssetAtIndex:(NSInteger)nIndex;
- (DFSelectablePhoto *)getPhotoAtIndex:(NSInteger)nIndex;
- (UIImage *)getImageFromPhoto:(DFSelectablePhoto *)photo wityType:(NSInteger)nType;
- (ALAssetsGroup *)getGroupAtIndex:(NSInteger)nIndex;

- (void)markPhotoSelectedAtIndex:(NSInteger)nIndex;
- (void)markPhotoUnSelectedAtIndex:(NSInteger)nIndex;
- (void)markPhoto:(DFSelectablePhoto *)photo selected:(BOOL)selected;
- (ALAsset *)getSelectedAssetAtIndex:(NSInteger)nIndex;
- (DFSelectablePhoto *)getSelectedPhotoAtIndex:(NSInteger)nIndex;
- (UIImage *)getSelectedImageAtIndex:(NSInteger)nIndex type:(NSInteger)nType;
- (NSInteger)getSelectedPhotosCount;
- (NSInteger)indexOfSelectedPhoto:(DFSelectablePhoto *)photo;
- (void)clearSelectedPhotos;

//兼容ios5
- (NSArray *)getPhotosByRange:(NSRange)range;
@end
