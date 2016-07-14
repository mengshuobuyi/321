//
//  GUITabScrollView.h
//  GUITabPagerViewController
//
//  Created by Guilherme Araújo on 26/02/15.
//  Copyright (c) 2015 Guilherme Araújo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GUITabPagerViewController.h"

@protocol GUITabScrollDelegate;
@protocol GUITabScrollDataSource;
@protocol GUITabViewSelectionObject;

@interface GUITabScrollView : UIScrollView <GUITabScrollViewObject>

@property (weak, nonatomic) id<GUITabScrollDelegate> tabScrollDelegate;

// designate initializer for tabViews
- (instancetype)initWithFrame:(CGRect)frame
                     tabViews:(NSArray <GUITabViewSelectionObject> *)tabViews
                 tabBarHeight:(CGFloat)height
           tabIndicatorHeight:(CGFloat)indicatorHeight
              seperatorHeight:(CGFloat)seperatorHeight
            tabIndicatorColor:(UIColor *)indicatorColor
               seperatorColor:(UIColor *)seperatorColor
              backgroundColor:(UIColor *)backgroundColor
             selectedTabIndex:(NSInteger)index
               centerSepColor:(UIColor *)centerSepColor;

// designate initializer for tabTitles
- (instancetype)initWithFrame:(CGRect)frame
                    tabTitles:(NSArray <NSString *> *)tabTitles
                 tabBarHeight:(CGFloat)height
           tabIndicatorHeight:(CGFloat)indicatorHeight
              seperatorHeight:(CGFloat)seperatorHeight
            tabIndicatorColor:(UIColor *)indicatorColor
               seperatorColor:(UIColor *)seperatorColor
              backgroundColor:(UIColor *)backgroundColor
             selectedTabIndex:(NSInteger)index
               centerSepColor:(UIColor *)centerSepColor
                   scrollable:(BOOL)scrollable;

// scrollable = YES
- (instancetype)initWithFrame:(CGRect)frame
                    tabTitles:(NSArray <NSString *> *)tabTitles
                 tabBarHeight:(CGFloat)height
           tabIndicatorHeight:(CGFloat)indicatorHeight
              seperatorHeight:(CGFloat)seperatorHeight
            tabIndicatorColor:(UIColor *)indicatorColor
               seperatorColor:(UIColor *)seperatorColor
              backgroundColor:(UIColor *)backgroundColor
             selectedTabIndex:(NSInteger)index
               centerSepColor:(UIColor *)centerSepColor;

// index = 0
- (instancetype)initWithFrame:(CGRect)frame
                     tabViews:(NSArray <GUITabViewSelectionObject> *)tabViews
                 tabBarHeight:(CGFloat)height
           tabIndicatorHeight:(CGFloat)indicatorHeight
              seperatorHeight:(CGFloat)seperatorHeight
            tabIndicatorColor:(UIColor *)indicatorColor
               seperatorColor:(UIColor *)seperatorColor
              backgroundColor:(UIColor *)backgroundColor
               centerSepColor:(UIColor *)centerSepColor;

@end


@protocol GUITabViewSelectionObject <NSObject>

@optional
- (void)setSelected:(BOOL)selected;

@end
