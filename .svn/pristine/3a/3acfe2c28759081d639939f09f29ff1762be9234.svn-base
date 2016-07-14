//
//  PieChartView.h
//  PieDemo
//
//  Created by YYX on 15/11/25.
//  Copyright © 2015年 chenpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PieChartView;

// 数据源
@protocol PieChartViewDataSource <NSObject>
@required
- (NSUInteger)numberOfSlicesInPieChart:(PieChartView *)pieChart;
- (CGFloat)pieChart:(PieChartView *)pieChart valueForSliceAtIndex:(NSUInteger)index;
@optional
- (UIColor *)pieChart:(PieChartView *)pieChart colorForSliceAtIndex:(NSUInteger)index;
@end

// 代理
@protocol PieChartViewDelegate <NSObject>
@optional
- (void)pieChart:(PieChartView *)pieChart willSelectSliceAtIndex:(NSUInteger)index;
- (void)pieChart:(PieChartView *)pieChart didSelectSliceAtIndex:(NSUInteger)index;
- (void)pieChart:(PieChartView *)pieChart willDeselectSliceAtIndex:(NSUInteger)index;
- (void)pieChart:(PieChartView *)pieChart didDeselectSliceAtIndex:(NSUInteger)index;
@end

@interface PieChartView : UIView

@property (assign, nonatomic) id <PieChartViewDataSource> dataSource;
@property (assign, nonatomic) id <PieChartViewDelegate> delegate;
@property (assign, nonatomic) CGFloat startPieAngle;
@property (assign, nonatomic) CGFloat animationSpeed;
@property (assign, nonatomic) CGPoint pieCenter;
@property (assign, nonatomic) CGFloat pieRadius;
@property (assign, nonatomic) BOOL showLabel;
@property (strong, nonatomic) UIFont *labelFont;
@property (assign, nonatomic) CGFloat labelRadius;
@property (assign, nonatomic) CGFloat selectedSliceStroke;
@property (assign, nonatomic) CGFloat selectedSliceOffsetRadius;
@property (assign, nonatomic) BOOL showPercentage;
- (id)initWithFrame:(CGRect)frame Center:(CGPoint)center Radius:(CGFloat)radius;
- (void)reloadData;
- (void)setPieBackgroundColor:(UIColor *)color;
@end
