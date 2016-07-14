//
//  CityExpressCell.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/5/6.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "CityExpressCell.h"
#import "BranchModel.h"

@implementation CityExpressCell

+ (CGFloat)getCellHeight:(id)data
{
    ShippingMethodModel *model = (ShippingMethodModel *)data;
    
    if (model.expressFreeFee && model.expressFreeFee>0)
    {
        return 145;
    }else
    {
        return 145-25;
    }
}

- (void)UIGlobal
{
    [super UIGlobal];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.separatorLine.hidden = YES;
}

- (void)setCell:(id)data
{
    [super setCell:data];
    
    ShippingMethodModel *model = (ShippingMethodModel *)data;
        
    //发货时间
    self.timeLabel.text = [NSString stringWithFormat:@"%@前下单，当天发货",model.expressTime];
    
    //有快递费
    self.EMSLabel.text = [NSString stringWithFormat:@"快递费 %.1f 元",model.expressFee];
    
    //包邮（可有可无）
    if (model.expressFreeFee && model.expressFreeFee>0)
    {
        self.EMSOne_layout_top.constant = 106;
        self.EMSTwo_layout_top.constant = 106;
        self.freeTipLabel.hidden = NO;
        self.freeTipLabel.text = @"包      邮：";
        self.freePostLabel.hidden = NO;
        self.freePostLabel.text = [NSString stringWithFormat:@"订单满 %.1f 元",model.expressFreeFee];
        
    }else
    {
        self.EMSOne_layout_top.constant = 81;
        self.EMSTwo_layout_top.constant = 81;
        self.freeTipLabel.hidden = YES;
        self.freePostLabel.hidden = YES;
    }
}

- (IBAction)editCityExpressAction:(id)sender
{
    QWButton *btn = (QWButton *)sender;
    NSIndexPath * row = (NSIndexPath *)btn.obj;
    
    if (self.cityExpressCellDelegate && [self.cityExpressCellDelegate respondsToSelector:@selector(editCityExpressAction:)]) {
        [self.cityExpressCellDelegate editCityExpressAction:row];
    }
}

@end
