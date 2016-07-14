//
//  GUITabPagerViewController.m
//  GUITabPagerViewController
//
//  Created by Guilherme Araújo on 26/02/15.
//  Copyright (c) 2015 Guilherme Araújo. All rights reserved.
//

#import "GUITabPagerViewController.h"
#import "UIScrollViewMonitor.h"
#import "GUITabScrollView.h"

@interface UIView (ParentViewControllerEx)
- (UIViewController *)parentViewController;
- (id) traverseResponderChainForUIViewController;
@end

@implementation UIView (ParentViewControllerEx)
- (UIViewController *)parentViewController
{
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}
- (id) traverseResponderChainForUIViewController {
    
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}
@end

@implementation GUITabContainerTabieView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    //    NSLog(@"\n---%@\n+++%@", gestureRecognizer.view.class, otherGestureRecognizer.view.class);
    if ([gestureRecognizer.view isMemberOfClass:[GUITabContainerTabieView class]] && (([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]] && [[[otherGestureRecognizer.view parentViewController] parentViewController] isKindOfClass:[UIPageViewController class]]))) {
        return YES;
    }
    return NO;
}


@end


@interface GUITabPagerViewController () <GUITabScrollDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewMonitorDelegate> {
    BOOL _hasModifiedContentInsetFlag;
}

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) UIScrollView <GUITabScrollViewObject> *header;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) NSMutableArray <GUITabViewControllerObject> *viewControllers;
@property (nonatomic, strong) GUITabContainerTabieView *tableView;
@property (nonatomic, strong) UIScrollViewMonitor *scrollViewMonitor;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, assign) CGPoint lastContentOffset;
@property (nonatomic, assign) CGPoint lastSubViewContentOffset;
@property (nonatomic, assign) UIEdgeInsets lastContentInset;

@end

@implementation GUITabPagerViewController


- (void)viewDidLoad {
  [super viewDidLoad];
  [self setEdgesForExtendedLayout:UIRectEdgeNone];

    self.tableView = [[GUITabContainerTabieView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = self.view.bounds.size.height - 44 - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height ;
    [self.view addSubview:self.tableView];
    
    [self.tableView.panGestureRecognizer addTarget:self action:@selector(tableViewPanGestureUpdate:)];
    self.tableView.scrollsToTop = NO;

  [self setPageViewController:[[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil]];
  
//  for (UIView *view in [[[self pageViewController] view] subviews]) {
//    if ([view isKindOfClass:[UIScrollView class]]) {
//      [(UIScrollView *)view setCanCancelContentTouches:YES];
//      [(UIScrollView *)view setDelaysContentTouches:NO];
//    }
//  }
  [[self pageViewController] setDataSource:self];
  [[self pageViewController] setDelegate:self];

//  [self addChildViewController:self.pageViewController];
//  [self.view addSubview:self.pageViewController.view];
//  [self.pageViewController didMoveToParentViewController:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  [self reloadTabs];
    [self selectTabbarIndex:self.selectedIndex];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)setDataSource:(id<GUITabPagerDataSource>)dataSource
{
    _hasModifiedContentInsetFlag = [dataSource respondsToSelector:@selector(hasModifiedContentInset)];
    _dataSource = dataSource;
}


#pragma mark - scrollView delegate & panGesture

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    if (scrollView == self.tableView) {
//        BOOL isBouncingTop = scrollView.contentOffset.y < 0;

        if (scrollView.contentOffset.y > self.tableView.tableHeaderView.frame.size.height) {
            scrollView.contentOffset = CGPointMake(0, self.tableView.tableHeaderView.frame.size.height);
        } else {
        }
        
        
        if (_hasModifiedContentInsetFlag) {
            BOOL needAdjustInset = [self.dataSource hasModifiedContentInset];
            if (needAdjustInset) {
                CGFloat insetTop = MAX(scrollView.contentInset.top, _lastContentInset.top);
                if (insetTop > 0) {
                    if (scrollView.contentOffset.y + insetTop > self.tableView.tableHeaderView.frame.size.height) {
                        if (scrollView.contentInset.top > 0) {
                            _lastContentInset = scrollView.contentInset;
                            scrollView.contentInset = UIEdgeInsetsZero;
                        }
                    } else {
                        if (_lastContentInset.top > 0) {
                            scrollView.contentInset = _lastContentInset;
                        }
                    }
                }
            } else {
                //            scrollView.contentInset = UIEdgeInsetsZero;
            }
        }

        UIScrollView *observedScrollView = _scrollViewMonitor.scrollView;
        
        if (!observedScrollView.isTracking) {
            if (!scrollView.isTracking) {
                if (scrollView.contentOffset.y <= 0) {
                    if ([self canPullTopToBounce]) {
                        scrollView.bounces = YES;
                    }
                } else {
                    if (observedScrollView.isDecelerating) {
                        scrollView.bounces = observedScrollView.contentOffset.y <= 0;
                    }
                }
            } else {
                // tableview is dragging.. dealed in panGesture method
                // cuz didScroll may not be called
            }
        } else {
            // dealed in panGesture method
            // top bouncing
        }
        


        BOOL isDown = scrollView.contentOffset.y < _lastContentOffset.y;
        
        CGFloat headerHeight = CGRectGetHeight(self.tableView.tableHeaderView.frame);
        
//        NSLog(@"%f, %@, %f, %@, %@", _lastContentOffset.y, isDown?@"+++down":@"---down", contentScrollView.contentOffset.y, self.scrollViewMonitor.isScrolling?@"+++scrolling":@"---scrolling", contentScrollView.isDragging ? @"+++Dragging":@"---Dragging");
        if (self.header.panGestureRecognizer.state == UIGestureRecognizerStateFailed) {
            // can drag header vertically
            observedScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        } else {
            // fixed header postion
            if (_lastContentOffset.y >= headerHeight - 5.0f && isDown) {
                BOOL contentScollViewInMove = self.scrollViewMonitor.isScrolling || observedScrollView.isTracking;
                if (observedScrollView.contentOffset.y > 0 && contentScollViewInMove) {
                    scrollView.contentOffset = CGPointMake(0, headerHeight);
                }
            }
        }
        _lastContentOffset = scrollView.contentOffset;
    }
}

- (BOOL)canPullTopToBounce
{
    UIScrollView *contentScrollView = self.scrollViewMonitor.scrollView;
    return  contentScrollView.contentOffset.y <=0 || !contentScrollView.isDragging || (contentScrollView.isDecelerating && self.scrollViewMonitor.speed.y < 100.0f);
}

- (void)tableViewPanGestureUpdate:(UIGestureRecognizer *)panGesture
{
    UIScrollView *contentScrollView = self.scrollViewMonitor.scrollView;
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (!contentScrollView.isTracking) {
                contentScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (!contentScrollView.isTracking) {
                if (!self.tableView.bounces) {
                    self.tableView.bounces = YES;
                }
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (!contentScrollView.isDragging) {
                contentScrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
//        [self addChildViewController:self.pageViewController];
        self.pageViewController.view.frame = cell.contentView.bounds;
        [cell.contentView addSubview:self.pageViewController.view];
//        [self.pageViewController didMoveToParentViewController:self];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.header.frame.size.height;
}

#pragma mark - Page View Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
  NSUInteger pageIndex = [[self viewControllers] indexOfObject:viewController];
  return pageIndex > 0 ? [self viewControllers][pageIndex - 1]: nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
  NSUInteger pageIndex = [[self viewControllers] indexOfObject:viewController];
  return pageIndex < [[self viewControllers] count] - 1 ? [self viewControllers][pageIndex + 1]: nil;
}

#pragma mark - Page View Delegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
  NSInteger index = [[self viewControllers] indexOfObject:pendingViewControllers[0]];
//  [[self header] animateToTabAtIndex:index];
  
  if ([[self delegate] respondsToSelector:@selector(tabPager:willTransitionToTabAtIndex:)]) {
    [[self delegate] tabPager:self willTransitionToTabAtIndex:index];
  }
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
  [self setSelectedIndex:[[self viewControllers] indexOfObject:[[self pageViewController] viewControllers][0]]];
  [[self header] animateToTabAtIndex:[self selectedIndex]];
  
  if ([[self delegate] respondsToSelector:@selector(tabPager:didTransitionToTabAtIndex:)]) {
    [[self delegate] tabPager:self didTransitionToTabAtIndex:[self selectedIndex]];
  }
}

#pragma mark - Tab Scroll View Delegate

- (void)tabScrollView:(GUITabScrollView *)tabScrollView didSelectTabAtIndex:(NSInteger)index {
  if (index != [self selectedIndex]) {
    if ([[self delegate] respondsToSelector:@selector(tabPager:willTransitionToTabAtIndex:)]) {
      [[self delegate] tabPager:self willTransitionToTabAtIndex:index];
    }
    
      self.pageViewController.view.userInteractionEnabled = self.allowSwipeInTabBarSelectedTransition;
    [[self pageViewController]  setViewControllers:@[[self viewControllers][index]]
                                         direction:(index > [self selectedIndex]) ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse
                                          animated:YES
                                        completion:^(BOOL finished) {
                                            self.pageViewController.view.userInteractionEnabled = YES;
                                          [self setSelectedIndex:index];
                                          
                                          if ([[self delegate] respondsToSelector:@selector(tabPager:didTransitionToTabAtIndex:)]) {
                                            [[self delegate] tabPager:self didTransitionToTabAtIndex:[self selectedIndex]];
                                          }
                                        }];
  }
}

#pragma mark - Reload Methods

- (void)reloadData {
    if ([self.dataSource respondsToSelector:@selector(tabPagerHeaderView)]) {
        self.tableView.tableHeaderView = [self.dataSource tabPagerHeaderView];
    }
    
  [self setViewControllers:[NSMutableArray array]];
  
  for (int i = 0; i < [[self dataSource] numberOfViewControllers]; i++) {
    UIViewController <GUITabViewControllerObject> *viewController;
     
    if ((viewController = [[self dataSource] viewControllerForIndex:i]) != nil) {
      [[self viewControllers] addObject:viewController];
        [viewController contentScrollView].scrollsToTop = NO;
    }
  }
    
  [self reloadTabs];
    
  CGRect frame = [[self view] frame];
  CGFloat headerHeight = CGRectGetHeight(self.header.frame);
  frame.origin.y = headerHeight;
  frame.size.height -= headerHeight;
  
  [[[self pageViewController] view] setFrame:frame];
  
  [self.pageViewController setViewControllers:@[[self viewControllers][0]]
                                    direction:UIPageViewControllerNavigationDirectionReverse
                                     animated:NO
                                   completion:nil];
  [self setSelectedIndex:0];
  [self selectTabbarIndex:0];
}

- (void)reloadTabs {
  if ([[self dataSource] numberOfViewControllers] == 0)
    return; 
    
  if ([self header]) {
    [[self header] removeFromSuperview];
  }
    
    self.header = [self.dataSource tabScrollView];
    if ([self.header conformsToProtocol:@protocol(GUITabScrollViewObject)] && [self.header isKindOfClass:[UIScrollView class]]) {
        self.header.tabScrollDelegate = self;
        self.header.scrollsToTop = NO;
//        [self.header.panGestureRecognizer addTarget:self action:@selector(tabScrollViewPanGestureUpdate:)];
    } else {
        NSLog(@"%@:%s, ERROR: [dataSource -tabScrollView] invalid tabScrollView", NSStringFromClass(self.class), __func__);
    }

    // refresh section header
  [self.tableView reloadData];
}

#pragma mark - UIScrollViewMonitor delegate

- (void)m_scrollViewDidScroll:(UIScrollView *)scrollView translationY:(CGFloat)translationY
{
    CGFloat headerHeight = CGRectGetHeight(self.tableView.tableHeaderView.frame);
    BOOL isUp = self.scrollViewMonitor.isUP;
    BOOL isHeaderShown = self.tableView.contentOffset.y < headerHeight;
    CGFloat translationAbs = fabs(translationY);
    if (isUp)
    {
        if (isHeaderShown) {
            if (scrollView.contentOffset.y <= translationAbs) {
                scrollView.contentOffset = CGPointZero;
            } else {
                scrollView.contentOffset = _lastSubViewContentOffset;
            }
        }
    } else {
        if (scrollView.contentOffset.y > 0) {
//            if ((scrollView.isDecelerating && scrollView.contentOffset.y > 5.0) || scrollView.isTracking ) {
//                self.tableView.bounces = NO;
//            }
            if (isHeaderShown && self.tableView.contentOffset.y > 0) {
                scrollView.contentOffset = _lastSubViewContentOffset;
            }
        } else {
            scrollView.contentOffset = CGPointZero;
        }
    }
    _lastSubViewContentOffset = scrollView.contentOffset;
}

- (void)m_scrollViewDidBeginDragging:(UIScrollView *)scrollView
{
    scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
}

- (void)m_scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
}

- (void)m_scrollViewDidMoveDragging:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 0) {
        if (_hasModifiedContentInsetFlag) {
            if ([self.dataSource hasModifiedContentInset]) {
                if (self.tableView.contentInset.top > 0) {
                    UIEdgeInsets inset = self.tableView.contentInset;
                    self.tableView.bounces = NO;
                    self.tableView.contentInset  = inset;
                } else {
                    self.tableView.bounces = NO;
                }
            } else {
                self.tableView.bounces = NO;
            }
        } else {
            self.tableView.bounces = NO;
        }
    } else {
        self.tableView.bounces = YES;
    }
}

#pragma mark - Assitant Methods

- (void)observePresentedVCScroll
{
    UIScrollView *scrollView = [self scrollViewForViewContollerAtIndex:_selectedIndex];
    if (scrollView) {
        self.lastSubViewContentOffset = scrollView.contentOffset;
        self.scrollViewMonitor = [UIScrollViewMonitor monitorWithScrollView:scrollView delegate:self];
    } else {
        NSLog(@"%@:%s. Error: tabViewController not provide scrollView", NSStringFromClass(self.class), __func__);
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (!self.scrollViewMonitor || _selectedIndex != selectedIndex) {
        [self scrollViewForViewContollerAtIndex:_selectedIndex].scrollsToTop = NO;
        _selectedIndex = selectedIndex;
        [self scrollViewForViewContollerAtIndex:_selectedIndex].scrollsToTop = YES;
        [self observePresentedVCScroll];
    }
}

- (UIScrollView *)scrollViewForViewContollerAtIndex:(NSInteger)index
{
    
    UIScrollView *scrollView = nil;
    if ([self.viewControllers[self.selectedIndex] respondsToSelector:@selector(contentScrollView)]) {
        scrollView = [self.viewControllers[_selectedIndex] contentScrollView];
    }
    if (!scrollView) {
        UIView *view = [self.viewControllers[_selectedIndex] view];
        if ([view isKindOfClass:[UIScrollView class]]) {
            scrollView = (UIScrollView *)view;
        }
    }
    return scrollView;
}

#pragma mark - Public Methods

- (void)selectTabbarIndex:(NSInteger)index {
  [self selectTabbarIndex:index animation:NO];
}

- (void)selectTabbarIndex:(NSInteger)index animation:(BOOL)animation {
  [self.pageViewController setViewControllers:@[[self viewControllers][index]]
                                    direction:UIPageViewControllerNavigationDirectionReverse
                                     animated:animation
                                   completion:nil];
  [[self header] animateToTabAtIndex:index animated:animation];

    if (index != self.selectedIndex) {
        
    }
  [self setSelectedIndex:index];
}

- (NSArray *)viewControllerArray
{
    return [self.viewControllers copy];
}

- (UIViewController *)viewControllerAtIndex:(NSInteger)index
{
    if (index > -1 && index < self.viewControllers.count) {
        return self.viewControllers[index];
    } else {
        return nil;
    }
}

@end
