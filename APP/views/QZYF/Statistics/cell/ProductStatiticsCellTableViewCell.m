//
//  CoupnStatiticsCellTableViewCell.m
//  wenYao-store
//
//  Created by caojing on 15/8/18.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "ProductStatiticsCellTableViewCell.h"
#import "SellStatistics.h"
@implementation ProductStatiticsCellTableViewCell

- (void)awakeFromNib {

}

+ (CGFloat)getCellHeight:(id)data
{
    return 145;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)UIGlobal{
    
}
-(void)setCell:(id)data
{
    [super setCell:data];
    RptProductVo *model=(RptProductVo*)data;
    self.consume.text=[NSString stringWithFormat:@"累计销售量为%@",model.consume];
}

@end
