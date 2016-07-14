//
//  GUITabPagerViewController.h
//  GUITabPagerViewController
//
//  Created by Guilherme Araújo on 26/02/15.
//  Copyright (c) 2015 Guilherme Araújo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWBaseVC.h"

@protocol GUITabPagerDataSource;
@protocol GUITabPagerDelegate;
@protocol GUITabViewControllerObject;
@protocol GUITabScrollViewObject;
@class GUITabScrollView;
@class GUITabPagerViewController;

@interface GUITabContainerTabieView : UITableView
@end

@interface GUITabPagerViewController : QWBaseVC <UIScrollViewDelegate>

@property (weak, nonatomic) id<GUITabPagerDataSource> dataSource;
@property (weak, nonatomic) id<GUITabPagerDelegate> delegate;
@property (nonatomic, strong, readonly) GUITabContainerTabieView *tableView;
@property (nonatomic, assign) BOOL allowSwipeInTabBarSelectedTransition; // default NO

- (void)reloadData;
- (NSInteger)selectedIndex;

- (NSArray <GUITabViewControllerObject> *)viewControllerArray;
- (UIViewController *)viewControllerAtIndex:(NSInteger)index;

- (void)selectTabbarIndex:(NSInteger)index;
- (void)selectTabbarIndex:(NSInteger)index animation:(BOOL)animation;
@end



/* 数据源方法 */
@protocol GUITabPagerDataSource <NSObject>
- (NSInteger)numberOfViewControllers;
- (UIViewController <GUITabViewControllerObject>*)viewControllerForIndex:(NSInteger)index;
// 提供scrollBar
- (UIScrollView <GUITabScrollViewObject> *)tabScrollView;
// 提供headerView
- (UIView *)tabPagerHeaderView;
@optional
// 下拉刷新调整inset，让sectionHeader能吸附在顶部。试验方法
- (BOOL)hasModifiedContentInset;
@end

/* 代理方法 */
@protocol GUITabPagerDelegate <NSObject>

@optional
- (void)tabPager:(GUITabPagerViewController *)tabPager willTransitionToTabAtIndex:(NSInteger)index;
- (void)tabPager:(GUITabPagerViewController *)tabPager didTransitionToTabAtIndex:(NSInteger)index;

@end

/* 子控制器 可选协议 */
@protocol GUITabViewControllerObject <NSObject>
@optional
// 子VC返回自己的scrollView。不实现则默认为子VC的view
- (UIScrollView *)contentScrollView;
@end

/* scrollBar 代理方法 */
@protocol GUITabScrollDelegate <NSObject>
@required
- (void)tabScrollView:(GUITabScrollView *)tabScrollView didSelectTabAtIndex:(NSInteger)index;

@end

/* scrollBar 需遵守的协议 */
@protocol GUITabScrollViewObject <NSObject> // impl customed scrollbar
@required
- (void)animateToTabAtIndex:(NSInteger)index;
- (void)animateToTabAtIndex:(NSInteger)index animated:(BOOL)animated;

- (id<GUITabScrollDelegate>)tabScrollDelegate;
- (void)setTabScrollDelegate:(id<GUITabScrollDelegate>)tabScrollDelegate;

@end



