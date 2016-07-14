//
//  CouponPromotionTableViewCell.m
//  APP
//
//  Created by 李坚 on 15/8/25.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "CouponPromotionTableViewCell.h"

@implementation CouponPromotionTableViewCell

+ (CGFloat)getCellHeight:(id)data{
    
    return 81.0f;
}

- (void)awakeFromNib {
    // Initialization code
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, [CouponPromotionTableViewCell getCellHeight:nil] - 0.5, APP_W, 0.5)];
    line.backgroundColor = RGBHex(qwColor10);
    [self addSubview:line];
    
    
    self.gift.layer.masksToBounds = YES;
    self.gift.layer.cornerRadius = 5.0f;
    self.discount.layer.masksToBounds = YES;
    self.discount.layer.cornerRadius = 5.0f;
    self.voucher.layer.masksToBounds = YES;
    self.voucher.layer.cornerRadius = 5.0f;
    self.special.layer.masksToBounds = YES;
    self.special.layer.cornerRadius = 5.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
