//
//  ManageTableViewCell.m
//  wenyao-store
//
//  Created by chenpeng on 15/1/19.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import "FirstCoupnTableViewCell.h"
#import "Tips.h"
#import "Coupn.h"
#import "UIImageView+WebCache.h"
#import "SellStatistics.h"
@implementation FirstCoupnTableViewCell

- (void)awakeFromNib {

     self.ifelse.adjustsFontSizeToFitWidth = YES;
    
    self.couponValue.adjustsFontSizeToFitWidth = YES;
}


+ (CGFloat)getCellHeight:(id)data{
    return 117.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)UIGlobal{
    self.separatorLine.hidden=YES;
}

#pragma mark ---- 我的订单 ----

-(void)setCell:(id)data{
    [super setCell:data];
    NSDictionary *model=(NSDictionary *)data;
    // 来源
    if([model[@"source"] intValue]==1){
        self.source.text=[NSString stringWithFormat:@"来源：全维"];
    }else if([model[@"source"] intValue]==2){
        self.source.text=[NSString stringWithFormat:@"来源：商家"];
    }else{
        self.source.text=[NSString stringWithFormat:@"来源：未知"];
    }
    // 使用时间
    self.dateIn.text = [NSString stringWithFormat:@"%@",model[@"tradeTime"]];

    // 使用条件
    self.ifelse.text=[NSString stringWithFormat:@"%@",model[@"tag"]];
    
    // 券备
    if (model[@"couponRemark"] && ![model[@"couponRemark"] isEqualToString:@""]) {
        self.couponRemark.text = model[@"couponRemark"];
        if(self.couponRemark.text.length>10) {
            self.couponRemark.text = [model[@"couponRemark"] substringToIndex:10];
        } else {
            self.couponRemark.text = model[@"couponRemark"];
        }
    }else{
        self.couponRemark.text = @"";
    }
    
    self.consumediscount.hidden = YES;
    
    // 右侧标签
    //1.通用2.慢病3.全部4.礼品券5.商品券 6折扣券 7 优惠商品券
    self.couponTagText.text = model[@"newTag"];//订单有问题
    if ([model[@"scope"] integerValue] == 7 || [model[@"scope"] integerValue] == 8){
        [self setUIScope:model[@"scope"] withValue:model[@"priceInfo"]];
    }else{
        [self setUIScope:model[@"scope"] withValue:model[@"couponValue"]];
    }
}

#pragma mark ---- 优惠券 列表页 ----

-(void)setCoupnCell:(id)data
{
    [super setCell:data];
    BranchCouponVo *model=(BranchCouponVo *)data;
    self.source.text=[NSString stringWithFormat:@"来源：%@",model.source==nil?@"未知":model.source];
    
    // 使用条件
    self.ifelse.text=[NSString stringWithFormat:@"%@",model.couponTag];

    if(model.empty){
     self.emptyImage.hidden=NO;
    }else{
     self.emptyImage.hidden=YES;
    }

    // 券备
    if (model.couponRemark && ![model.couponRemark isEqualToString:@""]) {
        self.couponRemark.text = model.couponRemark;
        if(model.couponRemark.length>10) {
            self.couponRemark.text = [model.couponRemark substringToIndex:10];
        } else {
            self.couponRemark.text = model.couponRemark;
        }
    }else{
        self.couponRemark.text = @"";
    }
    
    // 使用时间
    NSString *str;
    if ([model.status intValue] == 0) {
        str = @"  (未到使用期)";
    }else{
        str = @"";
    }
    self.dateIn.text=[NSString stringWithFormat:@"%@-%@%@",model.begin,model.end,str];
    self.consumediscount.hidden = YES;
    // 右侧标签
    //1.通用2.慢病3.全部4.礼品券5.商品券 6折扣券 7 优惠商品券
    self.couponTagText.text = model.tag;
    if ([model.scope integerValue] == 7||[model.scope integerValue] == 8){
        [self setUIScope:model.scope withValue:model.priceInfo];
    }else{
        [self setUIScope:model.scope withValue:model.couponValue];
    }
}

#pragma mark ---- 优惠券详情页 ----

-(void)setCoupnDetailCell:(id)data
{
    [super setCell:data];
    BranchCouponVo *model=(BranchCouponVo *)data;

    self.source.text=[NSString stringWithFormat:@"来源：%@",model.source==nil?@"未知":model.source];
    
    // 使用条件
    self.ifelse.text=[NSString stringWithFormat:@"%@",model.couponTag];

    // 券备
    if (model.couponRemark && ![model.couponRemark isEqualToString:@""]) {
        self.couponRemark.text = model.couponRemark;
        if(model.couponRemark.length>10) {
            self.couponRemark.text = [model.couponRemark substringToIndex:10];
        } else {
            self.couponRemark.text = model.couponRemark;
        }
    }else{
        self.couponRemark.text = @"";
    }
    
    // 使用时间
    NSString *str;
    if ([model.status intValue] == 0) {
        str = @"  (未到使用期)";
    }else{
        str = @"";
    }
    self.dateIn.text=[NSString stringWithFormat:@"%@-%@%@",model.begin,model.end,str];
    self.consumediscount.hidden = YES;
    
    // 右侧标签
    //1.通用2.慢病3.全部4.礼品券5.商品券 6折扣券 7 优惠商品券
    self.couponTagText.text = model.tag;
    if ([model.scope integerValue] == 7||[model.scope integerValue] == 8){
        [self setUIScope:model.scope withValue:model.priceInfo];
    }else{
        [self setUIScope:model.scope withValue:model.couponValue];
    }}

#pragma mark ---- 第二种 优惠券详情页 ----

-(void)setCoupnOtherDetailCell:(id)data
{
    [super setCell:data];
    OnlineBaseCouponDetailVo *model=(OnlineBaseCouponDetailVo *)data;
    
    self.source.text=[NSString stringWithFormat:@"来源：%@",model.source==nil?@"未知":model.source];
    
    // 使用条件
    self.ifelse.text=[NSString stringWithFormat:@"%@",model.couponTag];

    // 券备
    if (model.couponRemark && ![model.couponRemark isEqualToString:@""]) {
        self.couponRemark.text = model.couponRemark;
        if(model.couponRemark.length>10) {
            self.couponRemark.text = [model.couponRemark substringToIndex:10];
        } else {
            self.couponRemark.text = model.couponRemark;
        }
    }else{
        self.couponRemark.text = @"";
    }
    
    // 使用时间
    NSString *str;
    if ([model.status intValue] == 0) {
        str = @"  (未到使用期)";
    }else{
        str = @"";
    }
    self.dateIn.text=[NSString stringWithFormat:@"%@-%@%@",model.begin,model.end,str];
    self.consumediscount.hidden = YES;
    
    // 右侧标签
    //1.通用2.慢病3.全部4.礼品券5.商品券 6折扣券 7 优惠商品券
    self.couponTagText.text = model.tag;
    
    if ([model.scope integerValue] == 7||[model.scope integerValue] == 8){
        [self setUIScope:model.scope withValue:model.priceInfo];
    }else{
        [self setUIScope:model.scope withValue:model.couponValue];
    }
    
    self.overImage.hidden = YES;
    self.emptyImage.hidden = YES;
    if (model.empty == YES) {
        self.emptyImage.hidden = NO;
    }else{
        self.emptyImage.hidden = YES;
    }
}


#pragma mark ---- 优惠券消费统计 ----

- (void)setCouponStatisticsCell:(id)data overDure:(NSString *)overDure
{
    [super setCell:data];
    StatisticsCoupnModel *model=(StatisticsCoupnModel*)data;

    if([model.source intValue]==1){
        self.source.text=[NSString stringWithFormat:@"来源：全维"];
    }else{
        self.source.text=[NSString stringWithFormat:@"来源：商家"];
    }
    if(model.end){
        self.dateIn.text=[NSString stringWithFormat:@"%@-%@",model.begin,model.end];
    }
    
    if(model.couponTag){
        self.ifelse.text=[NSString stringWithFormat:@"%@",model.couponTag];
    }
    self.consumediscount.hidden = NO;
    self.consumediscount.text=[NSString stringWithFormat:@"门店消费%@张,共优惠%@元",model.consume,model.discount];
    

    // 券备
    if (model.couponRemark && ![model.couponRemark isEqualToString:@""]) {
        self.couponRemark.text = model.couponRemark;
        if(model.couponRemark.length>10) {
            self.couponRemark.text = [model.couponRemark substringToIndex:10];
        } else {
            self.couponRemark.text = model.couponRemark;
        }
    }else{
        self.couponRemark.text = @"";
    }
    
    // 1未过期 2已过期
    if([overDure isEqualToString:@"2"]){
//        self.emptyImage.hidden=NO;
        self.overImage.hidden = NO;
    }else{
//        self.emptyImage.hidden=YES;
        self.overImage.hidden = YES;
    }
    
    // 右侧标签
    //1.通用2.慢病3.全部4.礼品券5.商品券 6折扣券 7 优惠商品券
    
    self.couponTagText.text=model.tag;
    if ([model.scope integerValue] == 7 ||[model.scope integerValue] == 8){
        [self setUIScope:model.scope withValue:model.priceInfo];
    }else{
        [self setUIScope:model.scope withValue:model.couponValue];
    }
}



-(void)setUIScope:(NSString *)scope withValue:(NSString *)value{
    //1.通用2.慢病3.全部4.礼品券5.商品券 6折扣券 7 优惠商品券
    if ([scope integerValue] == 6) {
        self.couponValue.text = [NSString stringWithFormat:@"%@折",value];
    }else{
        if([scope integerValue] == 7 ||[scope integerValue] == 8){
            self.couponValue.text=value;
            self.ifelse.hidden=YES;
        }else{
            self.couponValue.text = [NSString stringWithFormat:@"%@元",value];
        }
    
    }
}



@end
