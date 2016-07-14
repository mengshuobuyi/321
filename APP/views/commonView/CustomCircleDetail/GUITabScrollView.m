//
//  GUITabScrollView.m
//  GUITabPagerViewController
//
//  Created by Guilherme Araújo on 26/02/15.
//  Copyright (c) 2015 Guilherme Araújo. All rights reserved.
//

#import "GUITabScrollView.h"
#import "GUITabLabel.h"

#define MAP(a, b, c) MIN(MAX(a, b), c)

@interface GUITabScrollView ()

- (void)_initTabbatAtIndex:(NSInteger)index;

@property (strong, nonatomic) NSArray <GUITabViewSelectionObject> *tabViews;
@property (strong, nonatomic) NSLayoutConstraint *tabIndicatorDisplacement;
@property (strong, nonatomic) NSLayoutConstraint *tabIndicatorWidth;
@property (nonatomic, assign) NSInteger currIndex;

@end

@implementation GUITabScrollView

const NSInteger kGUITabScrollViewTagOffset = 10086;

#pragma mark - Initialize Methods

- (instancetype)initWithFrame:(CGRect)frame
                     tabViews:(NSArray <GUITabViewSelectionObject> *)tabViews
                 tabBarHeight:(CGFloat)height
           tabIndicatorHeight:(CGFloat)indicatorHeight
              seperatorHeight:(CGFloat)seperatorHeight
            tabIndicatorColor:(UIColor *)indicatorColor
               seperatorColor:(UIColor *)seperatorColor
              backgroundColor:(UIColor *)backgroundColor
             selectedTabIndex:(NSInteger)index
               centerSepColor:(UIColor *)centerSepColor
{
    self = [self initWithFrame:frame tabViews:tabViews tabBarHeight:height tabIndicatorHeight:indicatorHeight seperatorHeight:seperatorHeight tabIndicatorColor:indicatorColor seperatorColor:seperatorColor backgroundColor:backgroundColor centerSepColor:centerSepColor];
    if (self) {
        NSInteger tabIndex = 0;
        if (index > 0 && index < tabViews.count) {
            tabIndex = index;
        }
        [self _initTabbatAtIndex:tabIndex];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                     tabViews:(NSArray <GUITabViewSelectionObject> *)tabViews
                 tabBarHeight:(CGFloat)height
           tabIndicatorHeight:(CGFloat)indicatorHeight
              seperatorHeight:(CGFloat)seperatorHeight
            tabIndicatorColor:(UIColor *)indicatorColor
               seperatorColor:(UIColor *)seperatorColor
              backgroundColor:(UIColor *)backgroundColor
               centerSepColor:(UIColor *)centerSepColor
{
  self = [super initWithFrame:frame];
  
  if (self) {
    [self setShowsHorizontalScrollIndicator:NO];
    [self setBounces:NO];
    
    [self setTabViews:tabViews];
    
    CGFloat width = 10;
    
    for (UIView *view in tabViews) {
      width += view.frame.size.width + 10;
    }
    
    [self setContentSize:CGSizeMake(MAX(width, self.frame.size.width), height)];
    
    CGFloat widthDifference = MAX(0, self.frame.size.width * 1.0f - width);
    
    UIView *contentView = [UIView new];
    [contentView setFrame:CGRectMake(0, 0, MAX(width, self.frame.size.width), height)];
    [contentView setBackgroundColor:backgroundColor];
    [contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:contentView];
    
    NSMutableString *VFL = [NSMutableString stringWithString:@"H:|"];
    NSMutableDictionary *views = [NSMutableDictionary dictionary];
    int index = 0;
    
    
    for (UIView *tab in tabViews) {
      [contentView addSubview:tab];
      [tab setTranslatesAutoresizingMaskIntoConstraints:NO];
      [VFL appendFormat:@"-%f-[T%d(%f)]", index ? 10.0f : 10.0 + widthDifference / 2, index, tab.frame.size.width];
      [views setObject:tab forKey:[NSString stringWithFormat:@"T%d", index]];
      
      [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[T]-2-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:@{@"T": tab}]];
      [tab setTag:index + kGUITabScrollViewTagOffset];
      [tab setUserInteractionEnabled:YES];
      [tab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabTapHandler:)]];
      
      index++;
    }
    
    [VFL appendString:[NSString stringWithFormat:@"-%f-|", 10.0f + widthDifference / 2]];
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:VFL
                                                                        options:0
                                                                        metrics:nil
                                                                          views:views]];
    
    UIView *bottomLine = [UIView new];
    [bottomLine setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView addSubview:bottomLine];
    [bottomLine setBackgroundColor:seperatorColor];
    [bottomLine setBackgroundColor:RGBHex(qwColor10)];
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[S]-0-|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:@{@"S": bottomLine}]];
    
      NSString *seperatorVFL = [NSString stringWithFormat:@"V:|-height-[S(%f)]-0-|", seperatorHeight];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:seperatorVFL
                                                                        options:0
                                                                        metrics:@{@"height": @(height - seperatorHeight)}
                                                                          views:@{@"S": bottomLine}]];
    UIView *tabIndicator = [UIView new];
    [tabIndicator setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView addSubview:tabIndicator];
    [tabIndicator setBackgroundColor:indicatorColor];
    
    [self setTabIndicatorDisplacement:[NSLayoutConstraint constraintWithItem:tabIndicator
                                                                   attribute:NSLayoutAttributeLeading
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:contentView
                                                                   attribute:NSLayoutAttributeLeading
                                                                  multiplier:1.0f
                                                                    constant:widthDifference / 2 + 5]];
    
    [self setTabIndicatorWidth:[NSLayoutConstraint constraintWithItem:tabIndicator
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:0
                                                           multiplier:1.0f
                                                             constant:[tabViews[0] frame].size.width + 10]];
    
      NSString *indicatorVFL = [NSString stringWithFormat:@"V:[S(%f)]-0-|", indicatorHeight];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:indicatorVFL
                                                                        options:0
                                                                        metrics:nil
                                                                          views:@{@"S": tabIndicator}]];
    
    [contentView addConstraints:@[[self tabIndicatorDisplacement], [self tabIndicatorWidth]]];
      
      UIView *line = [[UIView alloc] initWithFrame:CGRectMake(APP_W/2, 10, 0.5, 25)];
      line.backgroundColor = centerSepColor;
      [contentView addSubview:line];
  }
  
  return self;
}

#pragma mark - Public Methods

- (UIView *)viewWithTag:(NSInteger)tag
{
    return [super viewWithTag:tag + kGUITabScrollViewTagOffset];
}

- (void)changeTabState:(NSInteger)index
{
    UIView <GUITabViewSelectionObject> *tabView = (id) [self viewWithTag:self.currIndex];
    // try
    @try {
        [tabView  setSelected:NO];
    }
    @catch (NSException *exception) {
    }
    tabView = (id) [self viewWithTag:index];
    @try {
        [tabView  setSelected:YES];
    }
    @catch (NSException *exception) {
    }
    self.currIndex = index;
}

- (void)animateToTabAtIndex:(NSInteger)index {
    [self animateToTabAtIndex:index animated:YES];
}

- (void)animateToTabAtIndex:(NSInteger)index animated:(BOOL)animated {
    [self changeTabState:index];
    
    CGFloat animatedDuration = 0.4f;
    if (!animated) {
        animatedDuration = 0.0f;
    }
    
    CGFloat x = [[self tabViews][0] frame].origin.x - 5;
    
    for (int i = 0; i < index; i++) {
        x += [[self tabViews][i] frame].size.width + 10;
    }
    
    CGFloat w = [[self tabViews][index] frame].size.width + 10;
    [UIView animateWithDuration:animatedDuration
                     animations:^{
                         CGFloat p = x - (self.frame.size.width - w) / 2;
                         CGFloat min = 0;
                         CGFloat max = MAX(0, self.contentSize.width - self.frame.size.width);
                         
                         [self setContentOffset:CGPointMake(MAP(p, min, max), 0)];
                         [[self tabIndicatorDisplacement] setConstant:x];
                         [[self tabIndicatorWidth] setConstant:w];
                         [self layoutIfNeeded];
                     }];
}

- (void)tabTapHandler:(UITapGestureRecognizer *)gestureRecognizer {
  if ([[self tabScrollDelegate] respondsToSelector:@selector(tabScrollView:didSelectTabAtIndex:)]) {
    NSInteger index = [[gestureRecognizer view] tag] - kGUITabScrollViewTagOffset;
    [[self tabScrollDelegate] tabScrollView:self didSelectTabAtIndex:index];
    [self animateToTabAtIndex:index];
  }
}

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
{
    return [self initWithFrame:(CGRect)frame
                     tabTitles:(NSArray <NSString *> *)tabTitles
                  tabBarHeight:(CGFloat)height
            tabIndicatorHeight:(CGFloat)indicatorHeight
               seperatorHeight:(CGFloat)seperatorHeight
             tabIndicatorColor:(UIColor *)indicatorColor
                seperatorColor:(UIColor *)seperatorColor
               backgroundColor:(UIColor *)backgroundColor
              selectedTabIndex:(NSInteger)index
                centerSepColor:centerSepColor
                    scrollable:YES];
}

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
                   scrollable:(BOOL)scrollable
{
    if (!tabTitles.count) {
        NSLog(@"%@:%s \nERROR: 0 tabTitle ", NSStringFromClass(self.class), __func__);
        return nil;
    }
    NSMutableArray *tabViews = [NSMutableArray array];
    CGFloat widthSum = 10.0;
    for (NSString *tabTitle in tabTitles) {
        GUITabLabel *label = [GUITabLabel new];
        [label setText:tabTitle];
        CGRect frame = [label frame];
        frame.size.width = MAX(frame.size.width + 20, 85);
        [label setFrame:frame];
        [tabViews addObject:label];
        widthSum = widthSum + frame.size.width + 10.0;
    }
    CGFloat appW = [UIScreen mainScreen].applicationFrame.size.width;
    if (widthSum <= appW || scrollable == NO) {
        for (UIView *view in tabViews) {
            CGRect frame = view.frame;
            frame.size.width = (appW - 10.0 * tabViews.count - 10.0 ) /tabViews.count;
            view.frame = frame;
        }
    }
    return [self initWithFrame:frame tabViews:[tabViews copy] tabBarHeight:height tabIndicatorHeight:indicatorHeight seperatorHeight:seperatorHeight tabIndicatorColor:indicatorColor seperatorColor:seperatorColor backgroundColor:backgroundColor selectedTabIndex:index centerSepColor:centerSepColor];
//    return [self initWithFrame:frame tabViews:(id)tabViews tabBarHeight:CGRectGetHeight(frame) tabIndicatorHeight:4.0f seperatorHeight:1.0f tabIndicatorColor:[UIColor redColor] seperatorColor:[UIColor lightGrayColor] backgroundColor:[UIColor whiteColor] selectedTabIndex:index];
   
}

#pragma mark - Private Methods

- (void)_initTabbatAtIndex:(NSInteger)index {
    CGFloat x = [[self tabViews][0] frame].origin.x - 5;
    
    for (int i = 0; i < index; i++) {
        x += [[self tabViews][i] frame].size.width + 10;
    }
    
    CGFloat w = [[self tabViews][index] frame].size.width + 10;
    
    CGFloat p = x - (self.frame.size.width - w) / 2;
    CGFloat min = 0;
    CGFloat max = MAX(0, self.contentSize.width - self.frame.size.width);
    
    [self setContentOffset:CGPointMake(MAP(p, min, max), 0)];
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation == UIDeviceOrientationLandscapeLeft ||
        orientation == UIDeviceOrientationLandscapeRight) {
        x = x + (w/2);
    }
    
    [[self tabIndicatorDisplacement] setConstant:x];
    [[self tabIndicatorWidth] setConstant:w];
    [self layoutIfNeeded];
}


@end
