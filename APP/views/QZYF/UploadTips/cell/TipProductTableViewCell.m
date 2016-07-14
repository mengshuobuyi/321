//
//  ManageTableViewCell.m
//  wenyao-store
//
//  Created by caojing on 15/1/19.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import "TipProductTableViewCell.h"
#import "Tips.h"
#import "UIImageView+WebCache.h"
@implementation TipProductTableViewCell

- (void)awakeFromNib {

}
+ (CGFloat)getCellHeight:(id)data{
    
    return 85;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)UIGlobal{
    [super UIGlobal];
    
}
-(void)setCell:(id)data{
    [super setCell:data];
    OrderDetailDrugVo *model=(OrderDetailDrugVo *)data;
    [self.imgUrl setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"img_goods_default"] options:SDWebImageRetryFailed|SDWebImageContinueInBackground];
    self.quantity.text=[NSString stringWithFormat:@"x%@",model.quantity];
}
@end
