//
//  ManageTableViewCell.m
//  wenyao-store
//
//  Created by caojing on 15/1/19.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import "SuitProductTableViewCell.h"
#import "Coupn.h"
#import "UIImageView+WebCache.h"
#import "Drug.h"
@implementation SuitProductTableViewCell

- (void)awakeFromNib {

}

+ (CGFloat)getCellHeight:(id)data{
    
    return 87.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)UIGlobal{
    [super UIGlobal];
}

-(void)setCell:(id)data{
    [super setCell:data];
    CouponProductVo *branchclass=(CouponProductVo *)data;
    [self.productLogo setImageWithURL:[NSURL URLWithString:branchclass.productLogo] placeholderImage:[UIImage imageNamed:@"img_goods_default"] options:SDWebImageRetryFailed|SDWebImageContinueInBackground];
}

-(void)setSearchCell:(id)data{
    [super setCell:data];
    QueryProductByKeywordModel *branchclass=(QueryProductByKeywordModel *)data;
    [self.productLogo setImageWithURL:[NSURL URLWithString:branchclass.imgUrl] placeholderImage:[UIImage imageNamed:@"img_goods_default"] options:SDWebImageRetryFailed|SDWebImageContinueInBackground];
    self.productName.text=branchclass.proName;
}

@end
