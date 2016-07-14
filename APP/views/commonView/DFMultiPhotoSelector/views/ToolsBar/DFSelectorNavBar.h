//
//  DFSelectorNavBar.h
//  DFace
//
//  Created by kabda on 7/24/14.
//
//

#import <UIKit/UIKit.h>

@class DFSelectorNavBar;
@protocol DFSelectorNavBarDelegate <NSObject>
- (void)back;
- (void)markSelected;
- (void)markUnSelected;
@end

@interface DFSelectorNavBar : UIView
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *actionButton;

@property (nonatomic, weak) id<DFSelectorNavBarDelegate> delegate;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger selectedIndex; //非选中状态 < 1;
@property (nonatomic, assign) BOOL needsAnimated;
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated;
@end
