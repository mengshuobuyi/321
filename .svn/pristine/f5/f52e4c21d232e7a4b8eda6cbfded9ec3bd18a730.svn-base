//
//  DFSelectablePhotoCell.h
//  DFace
//
//  Created by kabda on 7/21/14.
//
//

#import <UIKit/UIKit.h>


@class DFSelectablePhotoCell;
@protocol DFSelectablePhotoCellDelegate <NSObject>
- (void)selectablePhotoCellDidMarked:(DFSelectablePhotoCell *)cell;
- (void)selectablePhotoCellDidUnMarked:(DFSelectablePhotoCell *)cell;
- (void)selectablePhotoCellTappedToShowAllPhotos:(DFSelectablePhotoCell *)cell;
@end

@interface DFSelectablePhotoCell : UICollectionViewCell
@property (nonatomic, weak) id<DFSelectablePhotoCellDelegate> delegate;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign, getter = isSelectedMode) BOOL selectedMode;
@property (nonatomic, assign) NSInteger selectedIndex; //非选中状态 < 1;

- (void)setImage:(UIImage *)image;
- (void)setImage:(UIImage *)image animated:(BOOL)animated;
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated;
@end

@interface DFSelectedMarkView : UIView
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UIImageView *foregroundImageView;

@property (nonatomic, assign, getter = isSelectedMode) BOOL selectedMode;
@property (nonatomic, assign) BOOL needsAnimated;
@end
