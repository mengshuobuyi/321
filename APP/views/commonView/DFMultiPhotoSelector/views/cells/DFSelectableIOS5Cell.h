//
//  DFSelectableIOS5Cell.h
//  DFace
//
//  Created by kabda on 8/4/14.
//
//

#import <UIKit/UIKit.h>

@class DFSelectableIOS5Cell;
@protocol DFSelectableIOS5CellDelegate <NSObject>
- (void)selectablePhotoIOS5CellDidMarked:(DFSelectableIOS5Cell *)cell atSubIndex:(NSInteger)subIndex;
- (void)selectablePhotoIOS5CellDidUnMarked:(DFSelectableIOS5Cell *)cell atSubIndex:(NSInteger)subIndex;
- (void)selectablePhotoIOS5CellTappedToShowAllPhotos:(DFSelectableIOS5Cell *)cell atSubIndex:(NSInteger)subIndex;
@end

@interface DFSelectableIOS5Cell : UITableViewCell
@property (nonatomic, weak) id<DFSelectableIOS5CellDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *visiableViews;
- (void)clearData;
- (void)addImage:(UIImage *)image;
- (void)setSelectedIndex:(NSInteger)selectedIndex atSubIndex:(NSInteger)subIndex animated:(BOOL)animated;
@end

@class DFSelectableSubCell;
@protocol DFSelectableSubCellDelegate <NSObject>
- (void)selectableSubCellDidMarked:(DFSelectableSubCell *)cell;
- (void)selectableSubCellDidUnMarked:(DFSelectableSubCell *)cell;
- (void)selectableSubCellTappedToShowAllPhotos:(DFSelectableSubCell *)cell;
@end

@interface DFSelectableSubCell : UIView
@property (nonatomic, weak) id<DFSelectableSubCellDelegate> delegate;
@property (nonatomic, strong) UIImageView *showImageView;
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UIImageView *foregroundImageView;

@property (nonatomic, assign) NSInteger selectedIndex; //非选中状态 < 1;
@property (nonatomic, assign) BOOL needsAnimated;
@property (nonatomic, assign, getter = isSelectedMode) BOOL selectedMode;

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated;
@end
