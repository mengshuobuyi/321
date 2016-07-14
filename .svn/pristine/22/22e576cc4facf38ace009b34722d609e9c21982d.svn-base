//
//  MARStatisticsDateView.h
//  wenYao-store
//
//  Created by Martin.Liu on 16/5/13.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConstraintsUtility.h"
@protocol MARStatisticsDateViewDelegate;

@interface MARStatisticsDateView : UIView
@property (nonatomic, readonly) NSDate* startDate;
@property (nonatomic, readonly) NSDate* endDate;
@property (nonatomic, readonly) NSString* startDateString;
@property (nonatomic, readonly) NSString* endDateString;
@property (nonatomic, strong) NSString* topTipString;   // 默认 “请选择起始日期查询”
@property (nonatomic, strong) NSString* topTipString2;  // 默认 “(时间区间不能超过30天)”
@property (nonatomic, assign) id<MARStatisticsDateViewDelegate> delegate;
@end

@protocol MARStatisticsDateViewDelegate <NSObject>

// 点击查询按钮的代理方法
- (void)marDateView:(MARStatisticsDateView*)dateView didClickQueryBtnStartDate:(NSDate*)startDate endDate:(NSDate*)endDate;
@optional
// 确认选择开始时间的代理方法
- (void)marDateView:(MARStatisticsDateView*)dateView didSelectStartDate:(NSDate*)startDate;
// 确认选择结束时间的代理方法
- (void)marDateView:(MARStatisticsDateView*)dateView didSelectEndDate:(NSDate*)endDate;
// 开始选择时间的代理方法
- (void)marDateViewBecomResponder:(MARStatisticsDateView*)dateView;
// 确认选择时间的代理方法
- (void)marDateViewResignResponder:(MARStatisticsDateView*)dataView;
@end
