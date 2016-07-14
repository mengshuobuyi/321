//
//  ManageTableViewCell.m
//  wenyao-store
//
//  Created by caojing on 15/1/19.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import "SecondProductTableViewCell.h"
#import "Tips.h"
#import "Coupn.h"
#import "UIImageView+WebCache.h"
#import "Drug.h"
#import "Verify.h"
#import "Activity.h"
@implementation SecondProductTableViewCell

- (void)awakeFromNib {

}

+ (CGFloat)getCellHeight:(id)data{
    return 126.0f;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)UIGlobal{
//    [super UIGlobal];
    self.separatorLine.hidden=YES;
//    self.leftCon.constant=15;
//    self.rightCon.constant=15;

}
-(void)setCell:(id)data{
    [super setCell:data];
    NSDictionary *model=(NSDictionary *)data;
    if([model[@"source"] intValue]==1){
        self.source.text=[NSString stringWithFormat:@"来源：全维"];
    }else  if([model[@"source"] intValue]==2){
        self.source.text=[NSString stringWithFormat:@"来源：商家"];
    }else {
        self.source.text=[NSString stringWithFormat:@"来源：未知"];
    }
    self.dateIn.text = [NSString stringWithFormat:@"%@",model[@"tradeTime"]];
    self.ifelse.text=[NSString stringWithFormat:@"%@",model[@"tag"]];
    [self.productImage setImageWithURL:[NSURL URLWithString:model[@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"img_goods_default"] options:SDWebImageRetryFailed|SDWebImageContinueInBackground];
}


-(void)setProductCell:(id)data{
    [super setCell:data];
    DrugVo *drug=(DrugVo *)data;
    if([drug.source intValue]==1){
        self.source.text=[NSString stringWithFormat:@"来源：全维"];
    }else  if([drug.source intValue]==2){
        self.source.text=[NSString stringWithFormat:@"来源：商家"];
    }else {
        self.source.text=[NSString stringWithFormat:@"来源：未知"];
    }
    if(drug.endDate){
        self.dateIn.text=[NSString stringWithFormat:@"%@-%@",drug.beginDate,drug.endDate];
    }
    
    if(drug.label){
        self.ifelse.text=[NSString stringWithFormat:@"%@",drug.label];
    }
    [self.productImage setImageWithURL:[NSURL URLWithString:drug.imgUrl] placeholderImage:[UIImage imageNamed:@"img_goods_default"] options:SDWebImageRetryFailed|SDWebImageContinueInBackground];
}

-(void)setSearchProductCell:(id)data{

    BranchSearchPromotionProVO *drug=(BranchSearchPromotionProVO *)data;
    self.source.text=[NSString stringWithFormat:@"来源：%@",drug.source];
    if(drug.endDate){
        self.dateIn.text=[NSString stringWithFormat:@"%@-%@",drug.startDate,drug.endDate];
    }
    
    if(drug.lable){
        self.ifelse.text=[NSString stringWithFormat:@"%@",drug.lable];
    }
    [self.productImage setImageWithURL:[NSURL URLWithString:drug.imgUrl] placeholderImage:[UIImage imageNamed:@"img_goods_default"] options:SDWebImageRetryFailed|SDWebImageContinueInBackground];

    self.proName.text=drug.proName;
    self.spec.text=drug.spec;
    self.factoryName.text=drug.factory;
}
-(void)setVerifyProductCell:(id)data{

  OrderDrugVo *model=(OrderDrugVo *)data;
    if([model.source intValue]==1){
        self.source.text=[NSString stringWithFormat:@"来源：全维"];
    }else  if([model.source intValue]==2){
        self.source.text=[NSString stringWithFormat:@"来源：商家"];
    }else {
        self.source.text=[NSString stringWithFormat:@"来源：未知"];
    }
    if(model.endTime){
        self.dateIn.text=[NSString stringWithFormat:@"%@-%@",model.beginTime,model.endTime];
    }
    
    if(model.label){
        self.ifelse.text=[NSString stringWithFormat:@"%@",model.label];
    }
    [self.productImage setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"img_goods_default"] options:SDWebImageRetryFailed|SDWebImageContinueInBackground];
    self.proName.text=model.proName;
    self.spec.text=model.spec;
    self.factoryName.text=model.factory;
}



-(void)setAcitivyProductCell:(id)data{
    BranchPromotionProVO *model=(BranchPromotionProVO *)data;
    self.source.text=[NSString stringWithFormat:@"来源：%@",model.source];
    if(model.endDate){
        self.dateIn.text=[NSString stringWithFormat:@"%@-%@",model.startDate,model.endDate];
    }
    
    if(model.label){
        self.ifelse.text=[NSString stringWithFormat:@"%@",model.label];
    }
    [self.productImage setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"img_goods_default"] options:SDWebImageRetryFailed|SDWebImageContinueInBackground];
    self.proName.text=model.proName;
    self.spec.text=model.spec;
    self.factoryName.text=model.factory;

}


-(void)setPillCell:(id)data{
    self.contentView.backgroundColor=[UIColor whiteColor];
    self.footview.backgroundColor=RGBHex(qwColor11);
    self.leftCon.constant=0;
    self.rightCon.constant=0;
    productclassBykwId *model=(productclassBykwId *)data;
    self.source.text=[NSString stringWithFormat:@"来源：%@",model.source];
    if(model.endDate){
        self.dateIn.text=[NSString stringWithFormat:@"%@-%@",model.startDate,model.endDate];
    }
    
    if(model.label){
        self.ifelse.text=[NSString stringWithFormat:@"%@",model.label];
    }else{
        self.ifelse.hidden=YES;
    }
    [self.productImage setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"img_goods_default"] options:SDWebImageRetryFailed|SDWebImageContinueInBackground];
    self.proName.text=model.proName;
    self.spec.text=model.spec;
    self.factoryName.text=model.factory;
    
}

@end
