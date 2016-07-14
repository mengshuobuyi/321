//
//  CouponPromotionTableViewCell.h
//  APP
//
//  Created by 李坚 on 15/8/25.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWBaseCell.h"

@interface CouponPromotionTableViewCell : QWBaseCell

@property (weak, nonatomic) IBOutlet UIImageView *ImagUrl;
@property (weak, nonatomic) IBOutlet UILabel *proName;
@property (weak, nonatomic) IBOutlet UILabel *spec;
@property (weak, nonatomic) IBOutlet UILabel *factoryName;
@property (weak, nonatomic) IBOutlet UIImageView *discount;
@property (weak, nonatomic) IBOutlet UIImageView *special;
@property (weak, nonatomic) IBOutlet UIImageView *voucher;
@property (weak, nonatomic) IBOutlet UIImageView *gift;
@property (weak, nonatomic) IBOutlet UILabel *label;

+ (CGFloat)getCellHeight:(id)data;

@end
