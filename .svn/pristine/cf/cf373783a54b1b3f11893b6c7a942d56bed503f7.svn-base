//
//  ConsultCouponTableViewCell.m
//  APP
//
//  Created by 李坚 on 15/8/18.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "ConsultCouponTableViewCell.h"
#import "Activity.h"
#import "UIImageView+WebCache.h"
#import "QWGlobalManager.h"

@implementation ConsultCouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mainScrollView.frame = CGRectMake(0, 0, APP_W, self.mainScrollView.frame.size.height);
    self.mainScrollView.backgroundColor = [UIColor clearColor];
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setScrollView:(NSMutableArray *)array{
    
    float couponX = 15;
    dataArray = array;
    
    for(int i = 0;i<array.count;i++){
        BranchCouponVO *model=(BranchCouponVO*)array[i];
        if([model.scope intValue]==4||[model.scope intValue]==7){//礼品和优惠商品券
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CouponPresentView"owner:self options:nil];
            CouponPresentView *view = [nib objectAtIndex:0];
            if([model.scope intValue]==7){
                //券值
                view.coupnValue.text=model.priceInfo;
            }else{
                //券值
                view.coupnValue.text=[NSString stringWithFormat:@"价值%@元",model.couponValue];
            }
          
            
            //礼品图片
            [view.giftImage setImageWithURL:[NSURL URLWithString:model.giftImgUrl] placeholderImage:[UIImage imageNamed:@"img_gift_default"]];
            
            //券标签 满10元使用
            view.lableFlag.text=model.couponTag;
            
            //券右侧标签 根据券类型判断
            view.couponTag.text = model.tag;
            //是否领完
            if (model.over == YES) {
                view.overImage.hidden = NO;
            }else{
                view.overImage.hidden = YES;
            }
            
            view.frame = CGRectMake(couponX, 8, 133, 64);
            view.tag = i;
            view.delegate = self;
            couponX += 150;
            [self.mainScrollView addSubview:view];
        }else{
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CouponView"owner:self options:nil];
            CouponView *view = [nib objectAtIndex:0];
            
            //券标签
            view.lableFlag.text=model.couponTag;
            
            //券值
            
            if([model.scope intValue]==6){
                view.coupnValue.text = [NSString stringWithFormat:@"%@折",model.couponValue];
            }else{
                view.coupnValue.text = [NSString stringWithFormat:@"%@元",model.couponValue];
            }
            //券右侧标签
            view.couponTag.text = model.tag;
            
            //是否领完
            if (model.over == YES) {
                view.overImage.hidden = NO;
            }else{
                view.overImage.hidden = YES;
            }
            
            view.frame = CGRectMake(couponX, 8, 133, 64);
            view.tag = i;
            view.delegate = self;
            couponX += 150;
            [self.mainScrollView addSubview:view];
        }
        
    }
    self.mainScrollView.contentSize = CGSizeMake(couponX, 80);
    
}

- (void)didSelectedAtIndex:(NSInteger)index{
    
    if(self.delegate){
        [self.delegate didSelectedCouponView:dataArray[index]];
    }
}

@end
