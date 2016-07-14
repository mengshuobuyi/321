//
//  TipsModel.h
//  wenYao-store
//
//  Created by caojing on 15/8/22.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseModel.h"
#import "BaseAPIModel.h"
@interface TipsModel : BaseModel

@end

@interface OrderListVo : BaseAPIModel
@property(nonatomic,strong)NSArray  *noreceiptOrderList;    // 未上传小票订单列表
@property(nonatomic,strong)NSArray  *receiptOrderList;      // 已上传小票订单列表
@property(nonatomic,strong)NSNumber *totalOrderCount;       // 订单总数量
@property(nonatomic,strong)NSNumber *noreceiptOrderCount;   // 未上传小票数量
@property(nonatomic,strong)NSNumber *receiptOrderCount;     // 已上传小票数量
@end

@interface OrderVo : BaseModel
@property(nonatomic,strong)NSString *orderId;     // 订单号
@property(nonatomic,strong)NSNumber *source;      // 来源（1：全维 2：商家）
@property(nonatomic,strong)NSString *type;        // 类型（Q：优惠券 P：优惠商品）
@property(nonatomic,strong)NSString *scope;       // 券类型。1.通用代金券，2.慢病专享代金券，4.礼品券，5.商品券
@property(nonatomic,strong)NSString *tag;         // 标签
@property(nonatomic,strong)NSString *couponValue; // 优惠券值
@property(nonatomic,strong)NSString *groupName;   // 优惠券商家名称
@property(nonatomic,strong)NSString *proName;     // 优惠商品名称
@property(nonatomic,strong)NSString *spec;        // 优惠商品规格
@property(nonatomic,strong)NSString *signCode;    // 优惠商品显示控制码
@property(nonatomic,strong)NSString *factoryName; // 优惠商品厂家名称
@property(nonatomic,strong)NSString *imgUrl;      // 图片地址
@property(nonatomic,strong)NSString *beginTime;   // 有效期起始日期
@property(nonatomic,strong)NSString *endTime;     // 有效期结束日期
@property(nonatomic,strong)NSString *pid;
@property(nonatomic,strong)NSString *tradeTime;   // 交易日期
@property(nonatomic,strong)NSString *couponRemark;// 优惠券，券备注
@end


@interface OrderDetailVo : BaseAPIModel
@property(nonatomic,strong)NSString *username;
@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,strong)NSNumber *quantity;
@property(nonatomic,strong)NSNumber *totalPrice;
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString *tradeDate;
@property(nonatomic,strong)NSArray *productList;
@property(nonatomic,strong)NSString *pid;
@property(nonatomic,strong)NSString *couponId;
@end


@interface OrderDetailDrugVo : BaseModel
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSNumber *spec;
@property(nonatomic,strong)NSString *factory;
@property(nonatomic,strong)NSString *quantity;
@property(nonatomic,strong)NSString *imgUrl;
@end

