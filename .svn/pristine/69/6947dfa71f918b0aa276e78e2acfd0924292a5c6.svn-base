//
//  StatisticsModelR.h
//  wenYao-store
//
//  Created by caojing on 15/8/19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseModel.h"

@interface CoupnModelR : BaseModel

@end


@interface CoupnListModelR : BaseModel
@property(nonatomic,strong)NSString *token;  //商户登录令牌
@property(nonatomic,strong)NSNumber *scope;  //券类型。0.全部，1.通用代金券，2.慢病专享代金券，3.全部代金券，4.礼品券，5.商品券, 6.折扣券, 7.优惠商品券, 8.兑换券
@property(nonatomic,strong)NSString *source; //来源。0.全部，1.全维 2.商家
@property(nonatomic,strong)NSString *pickStatus; //领用状态。0.全部（暂无需求），1.可领用 2.已领完
@property(nonatomic,strong)NSNumber *page;
@property(nonatomic,strong)NSNumber *pageSize;
@property(nonatomic,strong)NSString *all; //是否全量。若为全量，则不分页，系统将忽略页码及单页查询数量
@property(nonatomic,strong)NSString *city;
@property(nonatomic,assign)BOOL forMessageSend; //是否用于IM聊天发送
@end

@interface DrugListModelR : BaseModel
@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSNumber *toolType;
@property(nonatomic,strong)NSNumber *source;
@property(nonatomic,strong)NSNumber *page;
@property(nonatomic,strong)NSNumber *pageSize;
@property(nonatomic,strong)NSString *tagCode;
@property(nonatomic,assign)BOOL forMessageSend;
@end

@interface CoupnSuitModelR : BaseModel
@property(nonatomic,strong)NSString *couponId;
@end

@interface TagModelR : BaseModel
@property(nonatomic,strong)NSString *token;
@end

@interface OnlineModelR : BaseModel
@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSString *couponId;
@property(nonatomic,strong)NSString *city;
@end


@interface RecordModelR : BaseModel
@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSString *page;
@property(nonatomic,strong)NSString *pageSize;
@end


@interface CouponConditionModelR : BaseModel
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *id;
@end

