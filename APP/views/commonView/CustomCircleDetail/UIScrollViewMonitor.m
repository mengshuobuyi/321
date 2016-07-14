//
//  UIScrollView+Monitor.m
//  GUITabPagerViewController
//
//  Created by  ChenTaiyu on 16/6/10.
//  Copyright © 2016年 Guilherme Araújo. All rights reserved.
//

#import "UIScrollViewMonitor.h"


@interface UIScrollViewMonitor ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSTimeInterval lastOffsetCaptureTimeStamp;
@property (nonatomic, assign) BOOL isObserving;
@property (nonatomic, assign) CGPoint speed;
@property (nonatomic, assign) BOOL isScrolling;
@property (nonatomic, weak) id <UIScrollViewMonitorDelegate> delegate;
@property (nonatomic, assign) BOOL isUP;
@property (nonatomic, assign) UIGestureRecognizerState panState;

@property (nonatomic, assign) BOOL isDragging_lastCapture;
@property (nonatomic, assign) BOOL isDecelerating_lastCapture;

@end

@implementation UIScrollViewMonitor {
//    NSHashTable *_listenerHashTable;
    BOOL _scrollViewDidScrollFlag;
    BOOL _scrollViewDidBeginDraggingFlag;
    BOOL _scrollViewDidMoveDraggingFlag;
    BOOL _scrollViewDidEndDraggingFlag;
    BOOL _scrollViewDidBeginDeceleratingFlag;
    BOOL _scrollViewDidEndDeceleratingFlag;
}

+ (instancetype)monitorWithScrollView:(UIScrollView *)scrollView delegate:(id<UIScrollViewMonitorDelegate>)delegate
{
    UIScrollViewMonitor *monitor = [[UIScrollViewMonitor alloc] init];
    monitor.scrollView = scrollView;
    monitor.isDecelerating_lastCapture = scrollView.isDecelerating;
    monitor.isDragging_lastCapture = scrollView.isDragging;
    [scrollView.panGestureRecognizer addTarget:monitor action:@selector(panGestureUpdated:)];
    monitor.delegate = delegate;
    [scrollView addObserver:monitor forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    return monitor;
}

- (void)dealloc
{
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)panGestureUpdated:(UIPanGestureRecognizer *)panGesture
{
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.isScrolling = YES;
            if (_scrollViewDidBeginDraggingFlag) {
                [self.delegate m_scrollViewDidBeginDragging:self.scrollView];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (!self.scrollView.decelerating) {
                self.isScrolling = NO;
            }
            if (_scrollViewDidEndDraggingFlag) {
                [self.delegate m_scrollViewDidEndDragging:self.scrollView];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
            self.isUP = [panGesture velocityInView:self.scrollView].y < 0;
            if (_scrollViewDidMoveDraggingFlag) {
                [self.delegate m_scrollViewDidMoveDragging:self.scrollView];
            }
        default:
            break;
    }
    self.panState = panGesture.state;
}

- (void)setIsScrolling:(BOOL)isScrolling
{
    _isScrolling = isScrolling;
    if (!isScrolling) {
        _speed = CGPointZero;
        _isDecelerating_lastCapture = NO;
    }
}

- (void)setDelegate:(id<UIScrollViewMonitorDelegate>)delegate
{
    _delegate = delegate;
    _scrollViewDidScrollFlag = [delegate respondsToSelector:@selector(m_scrollViewDidScroll:translationY:)];
    _scrollViewDidBeginDeceleratingFlag = [delegate respondsToSelector:@selector(m_scrollViewDidBeginDecelerating:)];
    _scrollViewDidBeginDraggingFlag = [delegate respondsToSelector:@selector(m_scrollViewDidBeginDragging:)];
    _scrollViewDidEndDeceleratingFlag = [delegate respondsToSelector:@selector(m_scrollViewDidEndDecelerating:)];
    _scrollViewDidEndDraggingFlag = [delegate respondsToSelector:@selector(m_scrollViewDidEndDragging:)];
    _scrollViewDidMoveDraggingFlag = [delegate respondsToSelector:@selector(m_scrollViewDidMoveDragging:)];
}

const NSTimeInterval kSpeedCalcTimeThreshold = 0.01;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    UIScrollView *scrollView = object;
    if ([keyPath  isEqualToString: @"contentOffset"]) {
        NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
        if (!_isObserving) {
            _isObserving = YES;
            _lastOffsetCaptureTimeStamp = currentTime;
        }
        CGPoint newOffset = [change[@"new"] CGPointValue];
        CGPoint oldOffset = [change[@"old"] CGPointValue];
        CGFloat translationY = newOffset.y - oldOffset.y;
        
        if (!self.isScrolling) {
            _lastOffsetCaptureTimeStamp = currentTime;
        }
        NSTimeInterval timeDiff = currentTime - _lastOffsetCaptureTimeStamp;
        if (timeDiff > kSpeedCalcTimeThreshold) {
            [self calculateSpeedYWithLastOffset:oldOffset newOffset:newOffset timeDiff:timeDiff];
//            NSLog(@"%f, %f, %f", timeDiff, translationY, _speed.y);
        }
        _lastOffsetCaptureTimeStamp = currentTime;

        if (translationY != 0) {
            self.isScrolling = YES;
            if (timeDiff > kSpeedCalcTimeThreshold && !scrollView.isTracking) {
                self.isUP = newOffset.y > oldOffset.y;
//                NSLog(@"%@", self.isUP?@"++up":@"--up");
            }
            if (_scrollViewDidScrollFlag) {
                [self.delegate m_scrollViewDidScroll:scrollView translationY:newOffset.y - oldOffset.y];
            }
            if (!self.isDecelerating_lastCapture && scrollView.isDecelerating) {
                if (_scrollViewDidBeginDeceleratingFlag) {
                    [self.delegate m_scrollViewDidBeginDecelerating:scrollView];
                }
            }
            self.isDecelerating_lastCapture = scrollView.isDecelerating;
        } else {
            //  not scrolling
            if (!scrollView.isDragging) {
                self.isScrolling = NO;
                if (_scrollViewDidEndDeceleratingFlag) {
                    [self.delegate m_scrollViewDidEndDecelerating:scrollView];
                }
            } else {
//                self.isScrolling = scrollView.isTracking;
                self.isScrolling = YES;
            }
        }
    }
}

- (void)calculateSpeedYWithLastOffset:(CGPoint)lastOffset newOffset:(CGPoint)newOffset timeDiff:(NSTimeInterval)timeDiff
{
    CGFloat distanceY = newOffset.y - lastOffset.y;
    CGFloat scrollSpeedY = fabs(distanceY / timeDiff);
    CGFloat distanceX = newOffset.x - lastOffset.x;
    CGFloat scrollSpeedX = fabs(distanceX / timeDiff);
    _speed = (CGPoint){scrollSpeedX, scrollSpeedY};
}


@end
