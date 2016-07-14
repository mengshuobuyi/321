//
//  InternalProductListCell.m
//  wenYao-store
//
//  Created by PerryChen on 3/9/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "InternalProductListCell.h"
#import "QWGlobalManager.h"
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

- (IBAction)actionReco:(UIButton *)sender {
    self.viewEditContent.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(editCateAction:)]) {
        [self.delegate editRecoAction:self.tag];
    }
}

- (IBAction)actionStock:(UIButton *)sender {
    self.viewEditContent.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(editStackAction:)]) {
        [self.delegate editStackAction:self.tag];
    }
}

- (IBAction)actionCategory:(UIButton *)sender {
    self.viewEditContent.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(editCateAction:)]) {
        [self.delegate editCateAction:self.tag];
    }
}

- (IBAction)actionEdit:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(editViewAction:)]) {
        [self.delegate editViewAction:self.tag];
    }
}

- (void)setCell:(id)data
{
    [super setCell:data];
    InternalProductModel *model = (InternalProductModel *)data;
    self.productNameLbl.text = model.name;
    self.productSpecLbl.text = model.spec;
    if (self.intProType == 1) {
        self.viewEditStock.hidden = YES;
        self.productStockBtn.enabled = NO;
        self.viewEditContent.hidden = YES;
        self.productStackLbl.hidden = YES;
        self.productPriceLbl.hidden = YES;
    } else {
        self.productStackLbl.hidden = NO;
        self.productPriceLbl.hidden = NO;
        self.productStackLbl.text = [NSString stringWithFormat:@"库存%@",model.stock];
        self.productPriceLbl.text = [NSString stringWithFormat:@"￥ %@",model.price];
    }

    [self.productImgView setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"img_goods_default"]];
    if ([model.isRecommend boolValue]) {
        self.lblRecoContent.text = @"取消推荐";
    } else {
        self.lblRecoContent.text = @"推荐";
    }
    self.productPlaceHolderImgView.hidden = YES;
    if ([model.status intValue] == 2) {
        // 上架
    } else {
        // 下架
    }
    self.viewEditContent.hidden = YES;
    if (model.isShowEditView) {
        self.viewEditContent.hidden = NO;
    }
    if ([model.stock intValue] == 0) {
        self.productPlaceHolderImgView.hidden = NO;
    } else {
        self.productPlaceHolderImgView.hidden = YES;
    }
    if ([model.empScore intValue] == 0) {
        self.productTipImgView.hidden = YES;
        self.productTipLabel.hidden = YES;
        self.productLimitLabel.hidden = YES;
    } else {
        self.productTipImgView.hidden = NO;
        self.productTipLabel.hidden = NO;
        self.productTipLabel.text = [NSString stringWithFormat:@"销售送%@积分",model.empScore];
        if (model.empScoreLimit.length == 0) {
            self.constraintImgTipHeight.constant = 15.0f;
            self.productLimitLabel.hidden = YES;
        } else {
            self.constraintImgTipHeight.constant = 30.0f;
            self.productLimitLabel.hidden = NO;
            self.productLimitLabel.text = [NSString stringWithFormat:@"%@",model.empScoreLimit];
        }
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
    if (!AUTHORITY_ROOT) {  // 店员隐藏编辑按钮
        self.viewEditStock.hidden = YES;
        self.productStockBtn.enabled = NO;
        self.viewEditContent.hidden = YES;
    }
}

- (void)UIGlobal
{
    self.productNameLbl.font = fontSystem(kFontS1);
    self.productSpecLbl.font = fontSystem(kFontS5);
    self.productPriceLbl.font = fontSystem(kFontS3);
    self.productStackLbl.font = fontSystem(kFontS5);
    self.productTipLabel.font = fontSystem(kFontS5);
    self.productLimitLabel.font = fontSystem(kFontS5);
    
    self.productNameLbl.textColor = RGBHex(qwColor6);
    self.productSpecLbl.textColor = RGBHex(qwColor8);
    self.productPriceLbl.textColor = RGBHex(qwColor3);
    self.productStackLbl.textColor = RGBHex(qwColor8);
    self.productTipLabel.textColor = RGBHex(qwColor4);
    self.productLimitLabel.textColor = RGBHex(qwColor4);
}

@end
