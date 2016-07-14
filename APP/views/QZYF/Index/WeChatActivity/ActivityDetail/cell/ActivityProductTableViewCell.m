//
//  ActivityProductTableViewCell.m
//  wenYao-store
//
//  Created by qw_imac on 16/3/9.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ActivityProductTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation ActivityCellModel

@end
@implementation ActivityProductTableViewCell

-(void)setCell:(ActivityCellModel *)model {
    [self.proImg setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"药品默认图片"]];
    self.name.text = model.name;
    switch (model.cellType) {
        case ActivityTypeCombo:
            self.caseOneView.hidden = NO;
            self.rushView.hidden = YES;
            self.purView.hidden = YES;
            self.priceOne.text = [NSString stringWithFormat:@"¥%@",model.price];
            self.amount.text = [NSString stringWithFormat:@"x%@件",model.quantity];
            break;
        case ActivityTypePromotion:
            self.caseOneView.hidden = NO;
            self.rushView.hidden = YES;
            self.purView.hidden = YES;
            self.priceOne.text = [NSString stringWithFormat:@"¥%@",model.price];
            self.amount.hidden = YES;
            break;
        case ActivityTypeRepd:
            self.caseOneView.hidden = NO;
            self.rushView.hidden = YES;
            self.purView.hidden = YES;
            self.priceOne.text = [NSString stringWithFormat:@"¥%@",model.price];
            break;
        case ActivityTypeRush:
            self.caseOneView.hidden = YES;
            self.rushView.hidden = NO;
            self.purView.hidden = NO;
            self.rushPrice.text = [NSString stringWithFormat:@"原价:¥%@",model.price];
            self.discountPrice.text = [NSString stringWithFormat:@"¥%@",model.rushPrice];
            self.storeAmount.text = [NSString stringWithFormat:@"抢购库存:%@件",model.rushStock];
            self.rushNumber.text = [NSString stringWithFormat:@"%@",model.useQuantity];
            break;
    }
}
@end
