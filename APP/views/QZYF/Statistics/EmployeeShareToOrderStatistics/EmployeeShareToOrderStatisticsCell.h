//
//  EmployeeShareToOrderStatisticsCell.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/3/10.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseTableCell.h"

@interface EmployeeShareToOrderStatisticsCell : QWBaseTableCell

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;     //手机号
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;      //姓名
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;  //转化订单数

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phone_layout_top;


@end
