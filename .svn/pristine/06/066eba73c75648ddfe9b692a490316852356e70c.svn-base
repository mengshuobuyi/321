//
//  CoupnStatiticsCellTableViewCell.m
//  wenYao-store
//
//  Created by caojing on 15/8/18.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "PSecondStatiticsCellTableViewCell.h"
#import "SellStatistics.h"
@implementation PSecondStatiticsCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

+ (CGFloat)getCellHeight:(id)data{
    
    return 160;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)UIGlobal{
//    [super UIGlobal];
    self.separatorLine.hidden=YES;

    
}
-(void)setCell:(id)data{
    [super setCell:data];
    RptPromotionVo *branchclass=(RptPromotionVo *)data;
    if([branchclass.source intValue]==1){
        self.source.text=[NSString stringWithFormat:@"来源：全维"];
    }else{
        self.source.text=[NSString stringWithFormat:@"来源：商家"];
    }
    if(branchclass.end){
        self.dateIn.text=[NSString stringWithFormat:@"%@-%@",branchclass.begin,branchclass.end];
    }
    
    if(branchclass.label){
        self.ifelse.text=[NSString stringWithFormat:@"%@",branchclass.label];
    }
     self.total.text=[NSString stringWithFormat:@"有效期内该商品的销售量%@",branchclass.consume];
}

@end
