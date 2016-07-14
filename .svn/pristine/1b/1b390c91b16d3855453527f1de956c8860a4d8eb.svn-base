//
//  ClientOrderListCell.m
//  wenYao-store
//
//  Created by PerryChen on 5/16/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "ClientOrderListCell.h"

@implementation ClientOrderListCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)UIGlobal
{
    self.lblOrderStatus.textColor = RGBHex(qwColor6);
    self.lblOrderNum.textColor = RGBHex(qwColor6);
    self.lblOrderDate.textColor = RGBHex(qwColor8);
    
    self.lblOrderStatus.font = fontSystem(kFontS1);
    self.lblOrderNum.font = fontSystem(kFontS5);
    self.lblOrderDate.font = fontSystem(kFontS5);
}

- (void)setCell:(CustomerOrderVoModel *)data
{
    self.lblOrderDate.text = [NSString stringWithFormat:@"下单时间: %@",data.createStr];
    self.lblOrderNum.text = [NSString stringWithFormat:@"订单号: %@",data.orderCode];
    NSDictionary *placeHolderAttrs = @{NSForegroundColorAttributeName: RGBHex(qwColor6),NSFontAttributeName: fontSystem(kFontS5)};
    NSDictionary *priceAttrs = @{NSForegroundColorAttributeName: RGBHex(qwColor3),NSFontAttributeName: fontSystem(kFontS3)};
    NSMutableAttributedString *strContent = [[NSMutableAttributedString alloc] initWithString:@""];
    NSAttributedString *strPlaceHolder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"总计: "] attributes:placeHolderAttrs];
    NSAttributedString *strPrice = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", data.finalAmount] attributes:priceAttrs];
    [strContent appendAttributedString:strPlaceHolder];
    [strContent appendAttributedString:strPrice];
    self.lblOrderPrice.attributedText = strContent;
    switch ([data.orderStatus intValue]) {
        case 1:
            self.lblOrderStatus.text = @"待接单";
            break;
        case 2:
            self.lblOrderStatus.text = @"待配送";
            break;
        case 3:
            self.lblOrderStatus.text = @"配送中";
            break;
        case 5:
            self.lblOrderStatus.text = @"已拒绝";
            break;
        case 6:
            self.lblOrderStatus.text = @"待取货";
            break;
        case 8:
            self.lblOrderStatus.text = @"已取消";
            break;
        case 9:
            self.lblOrderStatus.text = @"已完成";
            break;
        default:
            break;
    }
}

@end
