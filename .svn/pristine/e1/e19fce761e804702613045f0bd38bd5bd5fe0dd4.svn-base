//
//  ManageTableViewCell.m
//  wenyao-store
//
//  Created by chenpeng on 15/1/19.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import "ThreeCoupnTableViewCell.h"
#import "Tips.h"
#import "Coupn.h"
#import "SellStatistics.h"
#import "UIImageView+WebCache.h"
@implementation ThreeCoupnTableViewCell

- (void)awakeFromNib {

    self.ifelse.adjustsFontSizeToFitWidth = YES;
    self.gift.layer.cornerRadius = 35.0f;
    self.gift.layer.masksToBounds = YES;
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

-(void)setCell:(id)data{
    [super setCell:data];
    NSDictionary *model=(NSDictionary *)data;
    if([model[@"source"] intValue]==1){
        self.source.text=[NSString stringWithFormat:@"来源：全维"];
    }else if([model[@"source"] intValue]==2){
        self.source.text=[NSString stringWithFormat:@"来源：商家"];
    }else{
        self.source.text=[NSString stringWithFormat:@"来源：未知"];
    }
    self.dateIn.text = [NSString stringWithFormat:@"%@",model[@"tradeTime"]];
    self.ifelse.text=[NSString stringWithFormat:@"%@",model[@"tag"]];
    [self.gift setImageWithURL:[NSURL URLWithString:model[@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"img_gift_default"]];
    
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
    [self setUpCouponCale:self.coupnCale.text];
    
    // 右侧标签
    //1.通用2.慢病3.全部4.礼品券5.商品券

     self.couponTagText.text = model[@"newTag"];
        if([model[@"scope"] integerValue] == 7||[model[@"scope"] integerValue] == 8){
            self.youhuiCons.constant=15.0f;
            self.ifelse.hidden=YES;
            self.coupnCale.text=model[@"priceInfo"];
        }else{
            self.youhuiCons.constant=10.0f;
            self.ifelse.hidden=NO;
            if([model[@"scope"] integerValue] == 6){
            self.coupnCale.text=[NSString stringWithFormat:@"优惠%@折",model[@"couponValue"]];
            }else{
            self.coupnCale.text=[NSString stringWithFormat:@"价值%@元",model[@"couponValue"]];
            }

        }
}

- (void)setUpCouponCale:(NSString *)couponCale
{
    CGSize size;
    size = [couponCale sizeWithFont:fontSystem(kFontS2) constrainedToSize:CGSizeMake(APP_W-217, CGFLOAT_MAX)];
    self.couponCaleWidthConstraint.constant = size.width+3.0;
}

//列表页
-(void)setCoupnCell:(id)data
{
    [super setCell:data];
    BranchCouponVo *model=(BranchCouponVo *)data;
    self.source.text=[NSString stringWithFormat:@"来源：%@",model.source==nil?@"未知":model.source];
    
    [self setUpCouponCale:self.coupnCale.text];
    
    self.ifelse.text=[NSString stringWithFormat:@"%@",model.couponTag];
    [self.gift setImageWithURL:[NSURL URLWithString:model.giftImgUrl] placeholderImage:[UIImage imageNamed:@"img_gift_default"]];
    
    if(model.empty){//已领完
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
    
    // 预热
    NSString *str;
    if ([model.status intValue] == 0) {
        str = @"  (未到使用期)";
    }else{
        str = @"";
    }
    
    self.dateIn.text=[NSString stringWithFormat:@"%@-%@%@",model.begin,model.end,str];

    self.consumediscount.hidden = YES;
    
    // 右侧标签
    //1.通用2.慢病3.全部4.礼品券5.商品券
    self.couponTagText.text=model.tag;
    if([model.scope integerValue] == 7 ||[model.scope integerValue] == 8){
        self.coupnCale.text=model.priceInfo;
        self.youhuiCons.constant=15.0f;
        self.ifelse.hidden=YES;
    }else{
        if([model.scope integerValue] == 6){
        self.coupnCale.text=[NSString stringWithFormat:@"优惠%@折",model.couponValue];
        }else{
        self.coupnCale.text=[NSString stringWithFormat:@"价值%@元",model.couponValue];
        }
        self.youhuiCons.constant=10.0f;
        self.ifelse.hidden=NO;
    }
}

// 详情页
-(void)setCoupnDetailCell:(id)data
{
    [super setCell:data];
    BranchCouponVo *model=(BranchCouponVo *)data;

    self.source.text=[NSString stringWithFormat:@"来源：%@",model.source==nil?@"未知":model.source];
    
    [self setUpCouponCale:self.coupnCale.text];
    
    self.ifelse.text=[NSString stringWithFormat:@"%@",model.couponTag];
    [self.gift setImageWithURL:[NSURL URLWithString:model.giftImgUrl] placeholderImage:[UIImage imageNamed:@"img_gift_default"]];
    
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
    
    // 预热
    NSString *str;
    if ([model.status intValue] == 0) {
        str = @"  (未到使用期)";
    }else{
        str = @"";
    }
    self.dateIn.text=[NSString stringWithFormat:@"%@-%@%@",model.begin,model.end,str];
    self.consumediscount.hidden = YES;
    
    // 右侧标签
    //1.通用2.慢病3.全部4.礼品券5.商品券

    self.couponTagText.text=model.tag;
    if([model.scope integerValue] == 7 ||[model.scope integerValue] == 8){
        self.coupnCale.text=model.priceInfo;
        self.youhuiCons.constant=15.0f;
        self.ifelse.hidden=YES;
    }else{
        if([model.scope integerValue] == 6){
            self.coupnCale.text=[NSString stringWithFormat:@"优惠%@折",model.couponValue];
        }else{
            self.coupnCale.text=[NSString stringWithFormat:@"价值%@元",model.couponValue];
        }
        self.youhuiCons.constant=10.0f;
        self.ifelse.hidden=NO;
    }
}

// 第二种详情页
-(void)setCoupnOtherDetailCell:(id)data
{
    [super setCell:data];
    OnlineBaseCouponDetailVo *model=(OnlineBaseCouponDetailVo *)data;
    
    self.source.text=[NSString stringWithFormat:@"来源：%@",model.source==nil?@"未知":model.source];
    [self setUpCouponCale:self.coupnCale.text];
    
    self.ifelse.text=[NSString stringWithFormat:@"%@",model.couponTag];
    [self.gift setImageWithURL:[NSURL URLWithString:model.giftImgUrl] placeholderImage:[UIImage imageNamed:@"img_gift_default"]];

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
    
    // 预热
    NSString *str;
    if ([model.status intValue] == 0) {
        str = @"  (未到使用期)";
    }else{
        str = @"";
    }
    self.dateIn.text=[NSString stringWithFormat:@"%@-%@%@",model.begin,model.end,str];
    self.consumediscount.hidden = YES;
    
    // 右侧标签
    //1.通用2.慢病3.全部4.礼品券5.商品券

    self.couponTagText.text=model.tag;
    if([model.scope integerValue] == 7 ||[model.scope integerValue] == 8){
        self.coupnCale.text=model.priceInfo;
        self.youhuiCons.constant=15.0f;
        self.ifelse.hidden=YES;
    }else{
        if([model.scope integerValue] == 6){
            self.coupnCale.text=[NSString stringWithFormat:@"优惠%@折",model.couponValue];
        }else{
            self.coupnCale.text=[NSString stringWithFormat:@"价值%@元",model.couponValue];
        }
        self.youhuiCons.constant=10.0f;
        self.ifelse.hidden=NO;
    }
    self.overImage.hidden = YES;
    self.emptyImage.hidden = YES;
    if (model.empty == YES) {
        self.emptyImage.hidden = NO;
    }else{
        self.emptyImage.hidden = YES;
    }
    
}


// 优惠券消费统计
- (void)setCouponStatisticsCell:(id)data overDure:(NSString *)overDure
{
    [super setCell:data];
    StatisticsCoupnModel *model=(StatisticsCoupnModel*)data;
    
    if([model.source intValue]==1){
        self.source.text=[NSString stringWithFormat:@"来源：全维"];
    }else{
        self.source.text=[NSString stringWithFormat:@"来源：商家"];
    }
    
    [self setUpCouponCale:self.coupnCale.text];
    
    if(model.end){
        self.dateIn.text=[NSString stringWithFormat:@"%@-%@",model.begin,model.end];
    }
    
    if(model.couponTag){
        self.ifelse.text=[NSString stringWithFormat:@"%@",model.couponTag];
    }
    self.consumediscount.hidden = NO;
    self.consumediscount.text=[NSString stringWithFormat:@"门店消费%@张,礼品赠送数量%@",model.consume,model.gift];
    [self.gift setImageWithURL:[NSURL URLWithString:model.giftImgUrl] placeholderImage:[UIImage imageNamed:@"img_gift_default"]];
    
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
        self.overImage.hidden=YES;
    }
    
    // 右侧标签
    //1.通用2.慢病3.全部4.礼品券5.商品券
    self.couponTagText.text=model.tag;
    if([model.scope integerValue] == 7 ||[model.scope integerValue] == 8){
        self.coupnCale.text=model.priceInfo;
        self.youhuiCons.constant=15.0f;
        self.ifelse.hidden=YES;
    }else{
        if([model.scope integerValue] == 6){
            self.coupnCale.text=[NSString stringWithFormat:@"优惠%@折",model.couponValue];
        }else{
            self.coupnCale.text=[NSString stringWithFormat:@"价值%@元",model.couponValue];
        }
        self.youhuiCons.constant=10.0f;
        self.ifelse.hidden=NO;
    }
}


@end
