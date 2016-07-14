//
//  EmployeeShareToOrderStatisticsCell.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/3/10.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "EmployeeShareToOrderStatisticsCell.h"
#import "OrderModel.h"

@implementation EmployeeShareToOrderStatisticsCell

+ (CGFloat)getCellHeight:(id)data
{
    return 54;
}

- (void)setCell:(id)data
{
    [super setCell:data];
    
    ShareOrderListModel *model = (ShareOrderListModel *)data;
    
    if (StrIsEmpty(model.name))
    {
        self.nameLabel.hidden = YES;
        self.phoneLabel.text = model.mobile;
        self.nameLabel.text = model.name;
        self.orderNumLabel.text = [NSString stringWithFormat:@"%d",model.changeOrder];
        self.phone_layout_top.constant = 19;
    }else
    {
        self.nameLabel.hidden = NO;
        self.phoneLabel.text = model.mobile;
        self.nameLabel.text = model.name;
        self.orderNumLabel.text = [NSString stringWithFormat:@"%d",model.changeOrder];
        self.phone_layout_top.constant = 12;
    }
}

@end
