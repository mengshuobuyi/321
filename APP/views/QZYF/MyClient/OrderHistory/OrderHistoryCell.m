//
//  OrderHistoryCell.m
//  wenYao-store
//
//  Created by YYX on 15/10/29.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "OrderHistoryCell.h"


@implementation OrderHistoryCell

- (void)UIGlobal
{
    [super UIGlobal];
    
    self.orderType.layer.cornerRadius = 2.0;
    self.orderType.layer.masksToBounds = YES;
    
    self.selectedBackgroundView=[[UIView alloc]initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor=RGBHex(qwColor10);
}

- (void)configureData:(ClientHistoryOrder *)order
{
    self.orderNumber.text = order.orderId;
    self.orderName.text = order.customerName;
    self.orderTime.text = order.orderTime;
    
    if ([order.type isEqualToString:@"Q"]) {
        self.orderType.text = @"优惠券";
        self.orderType.backgroundColor = RGBHex(qwColor3);
    }else if ([order.type isEqualToString:@"P"]){
        self.orderType.text = @"优惠商品";
        self.orderType.backgroundColor = RGBHex(qwColor15);
    }
}

@end
