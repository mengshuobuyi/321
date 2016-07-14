//
//  PerformanceOrderTableViewCell.m
//  wenYao-store
//
//  Created by qw_imac on 16/5/6.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "PerformanceOrderTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation PerformanceOrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCell:(MicroMallShopOrderVO *)vo {
    _orderNum.text = [NSString stringWithFormat:@"订单编号：%@",vo.orderCode];
    _time.text = [NSString stringWithFormat:@"订单时间：%@",vo.createStr];
    _price.text = [NSString stringWithFormat:@"￥%@",vo.finalAmount];
    if ([vo.rewardScore integerValue] <= 0) {
        _alert2.hidden = NO;
        _alert1.hidden = YES;
    }else {
        _alert2.hidden = YES;
        _alert1.hidden = NO;
        _alert1.text = [NSString stringWithFormat:@"+%@积分",vo.rewardScore];
    }
    for (UIImageView *img in _imgs) {
        img.hidden = YES;
    }
    NSInteger total = vo.microMallOrderDetailVOs.count > 4?4:vo.microMallOrderDetailVOs.count;
    for (NSInteger index = 0; index < total; index++) {
        UIImageView *img = _imgs[index];
        img.hidden = NO;
        ShopMicroMallOrderDetailVO *voModel = vo.microMallOrderDetailVOs[index];
        [img setImageWithURL:[NSURL URLWithString:voModel.imgUrl] placeholderImage:[UIImage imageNamed:@"药品默认图片"]];
    }
}
@end
