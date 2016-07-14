//
//  ManageTableViewCell.h
//  wenyao-store
//
//  Created by caojing on 15/1/19.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWBaseTableCell.h"
@interface FirstCoupnTableViewCell : QWBaseTableCell

@property (weak, nonatomic) IBOutlet QWLabel *couponValue;  // 使用价值
@property (weak, nonatomic) IBOutlet QWLabel *ifelse; // 使用条件
@property (weak, nonatomic) IBOutlet QWLabel *dateIn; // 使用时间
@property (weak, nonatomic) IBOutlet UIImageView *emptyImage;  // 已领完

@property (weak, nonatomic) IBOutlet UIImageView *overImage; // 已过期

@property (weak, nonatomic) IBOutlet UIView *viewContent;

@property (weak, nonatomic) IBOutlet UILabel *couponRemark;  // 券备
@property (weak, nonatomic) IBOutlet QWLabel *source;  // 来源
@property (weak, nonatomic) IBOutlet UILabel *couponTagText; //  标签
@property (weak, nonatomic) IBOutlet QWLabel *consumediscount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewTop;

- (void)setCoupnCell:(id)data;

- (void)setCoupnDetailCell:(id)data;

-(void)setCoupnOtherDetailCell:(id)data;

- (void)setCouponStatisticsCell:(id)data overDure:(NSString *)overDure;
@end


