//
//  DFMultiPhotoSelectorIOS5ViewController.h
//  DFace
//
//  Created by kabda on 8/4/14.
//
//

#import <UIKit/UIKit.h>
#import "DFAssetsHelper.H"

@class DFMultiPhotoSelectorIOS5ViewController;
@protocol DFMultiPhotoSelectorIOS5ViewControllerDelegate <NSObject>
- (void)multiPhotoSelectorIOS5DidCanceled:(DFMultiPhotoSelectorIOS5ViewController *)selector;
- (void)multiPhotoSelectorIOS5:(DFMultiPhotoSelectorIOS5ViewController *)selector didSelectedPhotos:(NSArray *)photos;
@end

@interface DFMultiPhotoSelectorIOS5ViewController : UIViewController
@property (nonatomic, weak) id<DFMultiPhotoSelectorIOS5ViewControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger column; // 每行显示的图片数量, 默认:4;
@property (nonatomic, assign) NSInteger maxAllowedSelectedCount; //允许选择的最大图片数量, 默认:4, 不限制: < 0;

@end
