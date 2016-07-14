//
//  StatiticsModel.h
//  wenYao-store
//
//  Created by caojing on 15/8/19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseModel.h"
#import "BaseAPIModel.h"
@interface SellStatisticsModel : BaseModel

@end

@interface StatisticsCoupnListModel : BaseAPIModel

@property(nonatomic,strong)NSArray *coupons;
@property(nonatomic,strong)NSArray *overdueCoupons;

@end


@interface StatisticsCoupnModel : BaseAPIModel

@property(nonatomic,strong)NSString *couponId;
@property(nonatomic,strong)NSString *couponValue;
@property(nonatomic,strong)NSString *couponTag;
@property(nonatomic,strong)NSString *groupId;
@property(nonatomic,strong)NSString *groupName;
@property(nonatomic,strong)NSString *begin;
@property(nonatomic,strong)NSString *end;
@property(nonatomic,assign)BOOL     chronic;
@property(nonatomic,strong)NSString *source;
@property(nonatomic,strong)NSNumber *consume;
@property(nonatomic,strong)NSNumber *discount;
@property(nonatomic,strong)NSString *gift;
@property(nonatomic,strong)NSString *scope;
@property(nonatomic,strong)NSString *giftImgUrl;
@property (nonatomic, strong) NSString *couponRemark;
@property(nonatomic,strong)NSString *tag;
@property(nonatomic,strong)NSString *priceInfo;
@end


@interface RptProductArrayVo : BaseAPIModel

@property(nonatomic,strong)NSArray *products;

@end


@interface RptProductVo : BaseModel

@property(nonatomic,strong)NSString *productId;
@property(nonatomic,strong)NSString *productName;
@property(nonatomic,strong)NSString *productLogo;
@property(nonatomic,strong)NSString *spec;
@property(nonatomic,strong)NSString *factory;
@property(nonatomic,strong)NSString *consume;
@property(nonatomic,strong)NSString *lable;

@end


@interface RptPromotionArrayVo : BaseAPIModel

@property(nonatomic,strong)NSString *productId;
@property(nonatomic,strong)NSString *productName;
@property(nonatomic,strong)NSString *productLogo;
@property(nonatomic,strong)NSString *spec;
@property(nonatomic,strong)NSString *factory;
@property(nonatomic,strong)NSArray *rpts;
@property(nonatomic,strong)NSArray *overdueRpts;

@end


@interface RptPromotionVo : BaseModel

@property(nonatomic,strong)NSNumber *consume;
@property(nonatomic,strong)NSString *label;
@property(nonatomic,strong)NSString *begin;
@property(nonatomic,strong)NSString *end;
@property(nonatomic,strong)NSString *pid;
@property(nonatomic,strong)NSNumber *source;

@end


