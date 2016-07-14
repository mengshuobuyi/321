//
//  DoorDeliveryCell.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/5/6.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "DoorDeliveryCell.h"
#import "BranchModel.h"

@implementation DoorDeliveryCell

+ (CGFloat)getCellHeight:(id)data
{
    ShippingMethodModel *model = (ShippingMethodModel *)data;
    
    if (model.deliveryFreeFee && model.deliveryFreeFee > 0)
    {
        //有免费配送
        return 215+24*(model.deliveryMode.count-3);
        
    }else
    {
        //没有免费配送
        return 215 + 24*(model.deliveryMode.count-4);
    }
    return 1;
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
    
    //配送时间
    self.timeLabel.text = [NSString stringWithFormat:@"%@—%@",model.deliveryBegin,model.deliveryEnd];;
    
    //起送价
    self.sendPriceLabel.text = [NSString stringWithFormat:@"订单满 %.1f 元",model.deliveryLimitFee];
    
    if (model.deliveryFreeFee && model.deliveryFreeFee > 0)
    {
        //有免费配送
        
        self.freePriceTip.hidden = NO;
        self.freePriceLabel.hidden = NO;
        self.freePriceLabel.text = [NSString stringWithFormat:@"订单满 %.1f 元",model.deliveryFreeFee];
        
        //范围 10 公里；运费 5 元
        
        if (model.deliveryMode.count == 0)
        {
            self.sendRuleTip.hidden = YES;
            self.sendRuleOne.hidden = YES;
            self.sendRuleTwo.hidden = YES;
            self.sendRuleThree.hidden = YES;
            self.freeOne_layout_top.constant = 104;
            self.freeTwo_layout_top.constant = 104;
            
        }else if (model.deliveryMode.count == 1)
        {
            self.sendRuleTip.hidden = NO;
            self.sendRuleOne.hidden = NO;
            self.sendRuleTwo.hidden = YES;
            self.sendRuleThree.hidden = YES;
            self.sendRuleOne.text = model.deliveryMode[0];
            self.freeOne_layout_top.constant = 129;
            self.freeTwo_layout_top.constant = 129;
            
        }else if (model.deliveryMode.count == 2)
        {
            self.sendRuleTip.hidden = NO;
            self.sendRuleOne.hidden = NO;
            self.sendRuleTwo.hidden = NO;
            self.sendRuleThree.hidden = YES;
            self.sendRuleOne.text = model.deliveryMode[0];
            self.sendRuleTwo.text = model.deliveryMode[1];
            self.freeOne_layout_top.constant = 153;
            self.freeTwo_layout_top.constant = 153;
            
        }else if (model.deliveryMode.count == 3)
        {
            self.sendRuleTip.hidden = NO;
            self.sendRuleOne.hidden = NO;
            self.sendRuleTwo.hidden = NO;
            self.sendRuleThree.hidden = NO;
            self.sendRuleOne.text = model.deliveryMode[0];
            self.sendRuleTwo.text = model.deliveryMode[1];
            self.sendRuleThree.text = model.deliveryMode[2];
            self.freeOne_layout_top.constant = 177;
            self.freeTwo_layout_top.constant = 177;
        }
        
    }else
    {
        
        //没有免费配送
        
        self.freePriceTip.hidden = YES;
        self.freePriceLabel.hidden = YES;
        
        if (model.deliveryMode.count == 0)
        {
            self.sendRuleTip.hidden = YES;
            self.sendRuleOne.hidden = YES;
            self.sendRuleTwo.hidden = YES;
            self.sendRuleThree.hidden = YES;
            
        }else if (model.deliveryMode.count == 1)
        {
            self.sendRuleTip.hidden = NO;
            self.sendRuleOne.hidden = NO;
            self.sendRuleTwo.hidden = YES;
            self.sendRuleThree.hidden = YES;
            self.sendRuleOne.text = model.deliveryMode[0];
            
        }else if (model.deliveryMode.count == 2)
        {
            self.sendRuleTip.hidden = NO;
            self.sendRuleOne.hidden = NO;
            self.sendRuleTwo.hidden = NO;
            self.sendRuleThree.hidden = YES;
            self.sendRuleOne.text = model.deliveryMode[0];
            self.sendRuleTwo.text = model.deliveryMode[1];
            
        }else if (model.deliveryMode.count == 3)
        {
            self.sendRuleTip.hidden = NO;
            self.sendRuleOne.hidden = NO;
            self.sendRuleTwo.hidden = NO;
            self.sendRuleThree.hidden = NO;
            self.sendRuleOne.text = model.deliveryMode[0];
            self.sendRuleTwo.text = model.deliveryMode[1];
            self.sendRuleThree.text = model.deliveryMode[2];
        }
    }
    
}

- (IBAction)editDoorDeliveryAction:(id)sender
{
    QWButton *btn = (QWButton *)sender;
    NSIndexPath * row = (NSIndexPath *)btn.obj;
    
    if (self.doorDeliveryCellDelegate && [self.doorDeliveryCellDelegate respondsToSelector:@selector(editDoorDeliveryAction:)]) {
        [self.doorDeliveryCellDelegate editDoorDeliveryAction:row];
    }
}
@end
