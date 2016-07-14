//
//  WechatActivityModel.h
//  wenYao-store
//
//  Created by qw_imac on 16/3/18.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "BaseAPIModel.h"

@interface WechatActivityModel : BaseAPIModel
@property (nonatomic,strong) NSArray *resultList;
@end

@interface MktgActListVo : BaseAPIModel
@property (nonatomic, strong) NSArray *acts;
@end

@interface MicroMallActivityVO : BaseModel
@property (nonatomic,strong) NSString *actId; //活动ID,
@property (nonatomic,strong) NSString *title; //活动标题,
@property (nonatomic,strong) NSString *imgUrl; //图片:套餐取默认,
@property (nonatomic,strong) NSString *date; //时间,
@property (nonatomic,strong) NSString *status;//活动状态:2.审核中 3.审核通过 7.下架,
@property (nonatomic,strong) NSString *type; // 活动类型 1.优惠活动 2.抢购 3.套餐 4.换购
@property (nonatomic,assign) BOOL isSelected; // 是否被选择
@end

@interface BusinessComboVO : BaseAPIModel
@property (nonatomic,strong) NSString *actId;//ID
@property (nonatomic,strong) NSString *title;//标题,
@property (nonatomic,strong) NSString *desc;// 描述,
@property (nonatomic,strong) NSString *price;// 价格,
@property (nonatomic,strong) NSString *source;// 来源,
@property (nonatomic,strong) NSString *date;// 时间,
@property (nonatomic,strong) NSString *status;//套餐状态,
@property (nonatomic,strong) NSString *actType;// 类型1.优惠活动 2.抢购 3.套餐 4.换购,
@property (nonatomic,strong) NSArray *list;// 药品集合
@end

@interface BusinessComboProductVO : BaseModel
@property (nonatomic,strong) NSString *proId;//商品ID,
@property (nonatomic,strong) NSString *name;//名称,
@property (nonatomic,strong) NSString *imgUrl;//图片,
@property (nonatomic,strong) NSString *price;//价格,
@property (nonatomic,strong) NSString *quantity;//数量
@end

@interface BusinessPromotionVO : BaseAPIModel
@property (nonatomic,strong) NSString *actId;//ID,
@property (nonatomic,strong) NSString *actType;//类型1.优惠活动 2.抢购 3.套餐 4.换购,
@property (nonatomic,strong) NSString *title ;//标题,
@property (nonatomic,strong) NSString *desc;//描述,
@property (nonatomic,strong) NSString *source;//来源,
@property (nonatomic,strong) NSString *date;//时间,
@property (nonatomic,strong) NSString *status ;//状态,
@property (nonatomic,strong) NSString *activityType;// 活动类型:1:买赠, 2:折扣, 3:立减, 4:特价,
@property (nonatomic,strong) NSString *promotionStock ;//优惠库存,
@property (nonatomic,strong) NSString *useQuantity;//使用量,
@property (nonatomic,strong) NSArray *list;//药品集合
@end

@interface BusinessPromotionProductVO : BaseModel
@property (nonatomic,strong) NSString *proId;//商品ID,
@property (nonatomic,strong) NSString *name;//名称,
@property (nonatomic,strong) NSString *imgUrl;//图片,
@property (nonatomic,strong) NSString *price;//价格,
@end

@interface BusinessRedpVO : BaseAPIModel
@property (nonatomic,strong) NSString *actId;//ID,
@property (nonatomic,strong) NSString *actType;//类型1.优惠活动 2.抢购 3.套餐 4.换购,
@property (nonatomic,strong) NSString *title;//标题,
@property (nonatomic,strong) NSString *desc;//描述,
@property (nonatomic,strong) NSString *source;//来源,
@property (nonatomic,strong) NSString *date;//时间,
@property (nonatomic,strong) NSString *status;//状态,
@property (nonatomic,strong) NSString *proId;//商品ID,
@property (nonatomic,strong) NSString *proPrice;//价格,
@property (nonatomic,strong) NSString *proName;//
@property (nonatomic,strong) NSString *proImgUrl;//
@property (nonatomic,strong) NSArray *list;
@end

@interface BusinessRedpProductVO : BaseModel
@property (nonatomic,strong) NSString *proId;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *imgUrl;
@end

@interface BusinessRushVO : BaseAPIModel
@property (nonatomic,strong) NSString *actId;//ID,
@property (nonatomic,strong) NSString *actType;//类型1.优惠活动 2.抢购 3.套餐 4.换购,
@property (nonatomic,strong) NSString *title;//标题,
@property (nonatomic,strong) NSString *source;//来源,
@property (nonatomic,strong) NSString *date;//时间,
@property (nonatomic,strong) NSString *status;//状态,
@property (nonatomic,strong) NSArray *list;//抢购集合
@end

@interface BusinessRushProductVO : BaseModel
@property (nonatomic,strong) NSString *proId;//商品ID,
@property (nonatomic,strong) NSString *name;//名称,
@property (nonatomic,strong) NSString *imgUrl;//图片,
@property (nonatomic,strong) NSString *price;//价格,
@property (nonatomic,strong) NSString *rushPrice;//抢购价,
@property (nonatomic,strong) NSString *rushStock;//抢购库存,
@property (nonatomic,strong) NSString *useQuantity;//抢购使用量
@end

@interface UpdateActivityModel : BaseAPIModel

@end