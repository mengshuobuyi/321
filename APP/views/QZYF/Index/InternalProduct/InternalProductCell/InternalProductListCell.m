//
//  InternalProductListCell.m
//  wenYao-store
//
//  Created by PerryChen on 3/9/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "InternalProductListCell.h"
#import "InternalProductModel.h"
@implementation InternalProductListCell
@dynamic delegate;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)actionEdit:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(editStackAction:)]) {
        [self.delegate editStackAction:self.tag];
    }
}
- (void)setCell:(id)data
{
    [super setCell:data];
    InternalProductModel *model = (InternalProductModel *)data;
    self.productSoldOutLbl.text = @"";
    self.productStackLbl.text = [NSString stringWithFormat:@"库存%@",model.stock];
    self.productNameLbl.text = model.name;
    self.productSpecLbl.text = model.spec;
    self.productPriceLbl.text = [NSString stringWithFormat:@"￥ %@",model.price];
    [self.productImgView setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"img_goods_default"]];

    self.productPlaceHolderImgView.hidden = YES;
    if ([model.status intValue] == 2) {
        // 上架
    } else {
        // 下架
        self.productPlaceHolderImgView.hidden = NO;
    }
    
}

- (void)UIGlobal
{
    self.productNameLbl.font = fontSystem(kFontS4);
    self.productSpecLbl.font = fontSystem(kFontS5);
    self.productPriceLbl.font = fontSystem(kFontS1);
    self.productSoldOutLbl.font = fontSystem(kFontS6);
    self.productStackLbl.font = fontSystem(kFontS9);
    
    self.productNameLbl.textColor = RGBHex(qwGcolor6);
    self.productSpecLbl.textColor = RGBHex(qwGcolor8);
    self.productPriceLbl.textColor = RGBHex(qwMcolor3);
    self.productSoldOutLbl.textColor = RGBHex(qwMcolor3);
    self.productStackLbl.textColor = RGBHex(qwGcolor8);
}

@end
