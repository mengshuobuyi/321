//
//  DFMultiPhotoSelectorViewController.h
//  DFace
//
//  Created by kabda on 7/1/14.
//
//

#import "QWBaseVC.h"
#import "DFAssetsHelper.H"

@class DFMultiPhotoSelectorViewController;

@protocol DFMultiPhotoSelectorViewControllerDelegate <NSObject>
- (void)multiPhotoSelectorDidCanceled:(DFMultiPhotoSelectorViewController *)selector;
- (void)multiPhotoSelector:(DFMultiPhotoSelectorViewController *)selector didSelectedPhotos:(NSArray *)photos;
-(void)didChoosePhoto:(UIImage *)img;
@end

@interface DFMultiPhotoSelectorViewController : QWBaseVC
@property (nonatomic, weak) id<DFMultiPhotoSelectorViewControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger column; // 每行显示的图片数量, 默认:4;
@property (nonatomic, assign) NSInteger maxAllowedSelectedCount; //允许选择的最大图片数量, 默认:4, 不限制: < 0;
@end
