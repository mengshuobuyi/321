//
//  InternalPackageCell.m
//  wenYao-store
//
//  Created by PerryChen on 7/13/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "InternalPackageCell.h"
#import "ProductInfoView.h"
#import "InternalProductModel.h"
@implementation InternalPackageCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setCell:(id)data
{
    InternalPackageDrugListModel *model = (InternalPackageDrugListModel *)data;
    self.lblDiscountContent.text = [NSString stringWithFormat:@"套餐价￥%@，已减￥%@",model.price,model.reduce];
    
    if (model.druglist.count <= 0) {
        return;
    }
    UIView *previousView = nil;
    NSLayoutConstraint *constraintImgTop = nil;
    NSLayoutConstraint *constraintImgLeading = nil;
    NSLayoutConstraint *constraintImgTrailing = nil;
    for (int i = 0; i < model.druglist.count; i++) {
        InternalPackageDrugModel *modelD = model.druglist[i];
        NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"ProductInfoView"
                                                          owner:self
                                                        options:nil];
        ProductInfoView *viewInfoTemp = [nibViews objectAtIndex: 0];
        [viewInfoTemp setView:modelD];
        [viewInfoTemp.proImg setImageWithURL:[NSURL URLWithString:modelD.imgUrl] placeholderImage:[UIImage imageNamed:@"news_placeholder"]];
        NSDictionary *nameAttrs = @{NSForegroundColorAttributeName: RGBHex(qwColor6),
                                    NSFontAttributeName: [UIFont systemFontOfSize:kFontS1]};
        NSDictionary *countAttrs = @{NSForegroundColorAttributeName: RGBHex(qwColor7),
                                     NSFontAttributeName: [UIFont systemFontOfSize:kFontS4]};
        NSMutableAttributedString *strContent = [[NSMutableAttributedString alloc] initWithString:@""];
        NSAttributedString *strName = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",modelD.name] attributes:nameAttrs];
        NSAttributedString *strCount = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"*%@",modelD.count] attributes:countAttrs];
        [strContent appendAttributedString:strName];
        [strContent appendAttributedString:strCount];
        
        viewInfoTemp.proTitle.attributedText = strContent;
        viewInfoTemp.proDes.text = modelD.spec;
        viewInfoTemp.frame = CGRectMake(0, 0, APP_W, 81.0f);
        viewInfoTemp.translatesAutoresizingMaskIntoConstraints = NO;
        [viewInfoTemp addConstraint:[NSLayoutConstraint constraintWithItem:viewInfoTemp attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:81.0f]];
        if (!previousView) {
            constraintImgTop = [NSLayoutConstraint constraintWithItem:viewInfoTemp attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.viewContainer attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        } else {
            constraintImgTop = [NSLayoutConstraint constraintWithItem:viewInfoTemp attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        }
        constraintImgLeading = [NSLayoutConstraint constraintWithItem:viewInfoTemp attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.viewContainer attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0];
        constraintImgTrailing = [NSLayoutConstraint constraintWithItem:viewInfoTemp attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.viewContainer attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0];

        [self.viewContainer addSubview:viewInfoTemp];
        [self.viewContainer addConstraints:@[constraintImgTop,constraintImgLeading,constraintImgTrailing]];
        previousView = viewInfoTemp;
    }
    [self.viewContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.viewContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    [self.viewContainer setNeedsLayout];
//    [self.viewContainer layoutIfNeeded];
    [self setNeedsLayout];
//    [self layoutIfNeeded];
}

@end
