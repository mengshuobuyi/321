//
//  DFSelectorBar.h
//  DFace
//
//  Created by kabda on 7/23/14.
//
//

#import <UIKit/UIKit.h>

@class DFSelectorBar;
@protocol DFSelectorBarDelegate <NSObject>
- (void)complete;
@end

@interface DFSelectorBar : UIView
@property (nonatomic, strong) UIButton *completeButton;
@property (nonatomic, weak) id<DFSelectorBarDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedPhotosCount;
- (void)setSelectedPhotosCount:(NSInteger)selectedPhotosCount animated:(BOOL)animated;
@end
