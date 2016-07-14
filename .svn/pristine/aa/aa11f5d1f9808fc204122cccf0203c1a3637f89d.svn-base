//
//  ScanDrugTableViewCell.m
//  quanzhi
//
//  Created by xiezhenghong on 14-6-17.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "ScanDrugTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "PromotionModel.h"

@implementation ScanDrugTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCell:(id)data{

    [super setCell:data];
    
    ProductModel* product = data[0];
    
     [self.avatar setImageWithURL:[NSURL URLWithString:PORID_IMAGE(product.proId)]];
    
    self.titleLabel.text = product.proName;
    self.sepcLabel.text = product.spec;
    self.factoryLabel.text = product.factory;
    
    
}
-(void)UIGlobal{
    [super UIGlobal];
    
}
@end