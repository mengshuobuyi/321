//
//  UIScrollView+Monitor.h
//  GUITabPagerViewController
//
//  Created by  ChenTaiyu on 16/6/10.
//  Copyright © 2016年 Guilherme Araújo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIScrollViewMonitorDelegate <NSObject>

@optional
- (void)m_scrollViewDidScroll:(UIScrollView *)scrollView translationY:(CGFloat)translationY;

- (void)m_scrollViewDidBeginDragging:(UIScrollView *)scrollView;
- (void)m_scrollViewDidMoveDragging:(UIScrollView *)scrollView;
- (void)m_scrollViewDidEndDragging:(UIScrollView *)scrollView;

- (void)m_scrollViewDidBeginDecelerating:(UIScrollView *)scrollView;
- (void)m_scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

/*
- (void)m_scrollViewDidBeginTracking:(UIScrollView *)scrollView;
- (void)m_scrollViewDidEndTracking:(UIScrollView *)scrollView;
*/
@end

@interface UIScrollViewMonitor : NSObject

+ (instancetype)monitorWithScrollView:(UIScrollView *)scrollView delegate:(id<UIScrollViewMonitorDelegate>)delegate;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, assign, readonly) CGPoint speed;
@property (nonatomic, assign, readonly) BOOL isScrolling;
@property (nonatomic, assign, readonly) BOOL isUP;
@property (nonatomic, assign, readonly) UIGestureRecognizerState panState;

@end