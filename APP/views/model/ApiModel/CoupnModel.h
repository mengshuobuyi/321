//
//  StatiticsModel.h
//  wenYao-store
//
//  Created by caojing on 15/8/19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseModel.h"
#import "BaseAPIModel.h"
@interface CoupnModel : BaseAPIModel
@property (strong, nonatomic) NSString          *page;          //当前页数（分页使用）
@property (strong, nonatomic) NSString          *pageSize;          //每页显示数据条数（分页使用，不使用分页时候可以传入0
@property (strong, nonatomic) NSString          *pageSum;
@property (strong, nonatomic) NSString          *totalRecords;
@property (strong, nonatomic) NSArray           *list;
@end
@interface TagFilterList : BaseModel

@property (strong, nonatomic) NSArray *list;

@end

@interface TagFilterVo : BaseModel

@property (strong, nonatomic) NSString *tagCode;
@property (strong, nonatomic) NSString *tagName;

@end

@interface BranchCouponArrayVo : BaseAPIModel

@property(nonatomic,strong)NSNumber *page;
@property(nonatomic,strong)NSNumber *pageSize;
@property(nonatomic,strong)NSString *groupId;
@property(nonatomic,strong)NSString *groupName;
@property(nonatomic,strong)NSArray  *coupons;


@end

@interface BranchCouponVo : BaseAPIModel
@property(nonatomic,strong)NSString *couponId;
@property(nonatomic,strong)NSString *couponValue;
@property(nonatomic,strong)NSString *couponTag;
@property(nonatomic,strong)NSString *groupId;
@property(nonatomic,strong)NSString *groupName;
@property(nonatomic,strong)NSString *begin;
@property(nonatomic,strong)NSString *end;
@property(nonatomic,assign)BOOL chronic;
@property(nonatomic,strong)NSString *source;
@property(nonatomic,strong)NSString *orderId;
@property(nonatomic)int limitConsume;
@property(nonatomic,strong)NSString *scope;//1.通用2.慢病3.全部4.礼品券5.商品券
@property(nonatomic,strong) NSString *desc;
@property(nonatomic,strong)NSString *giftImgUrl;
@property(nonatomic,strong)NSString *status;//0.待开始，1.待使用，2.快过期，3.已使用，4.已过期
@property(nonatomic,strong)NSString *top;
@property(nonatomic,assign)BOOL empty;
@property(nonatomic,strong)NSString *couponTitle;
@property(nonatomic,strong)NSString *tag;
@property(nonatomic,strong)NSString *priceInfo;
@property(nonatomic,assign)BOOL onlySupportOnlineTrading;
@property(nonatomic,strong)NSString *couponRemark;//优惠券备注
@property(nonatomic,assign)NSInteger suitableProductCounts;
//1.通用代金券，2.慢病专享代金券，4.礼品券

@end


@interface CouponProductArrayVo : BaseAPIModel
@property(nonatomic,strong)NSString *suitableProductCount;
@property(nonatomic,strong)NSArray *suitableProducts;
@end

@interface CouponProductVo : BaseAPIModel
@property(nonatomic,strong)NSString *productId;
@property(nonatomic,strong)NSString *productName;
@property(nonatomic,strong)NSString *productLogo;
@property(nonatomic,strong)NSString *spec;
@property(nonatomic,strong)NSString *factory;

@property(nonatomic)int quantity;
@property(nonatomic)BOOL isSelect;
@end

@interface CouponScanProductVo : BaseAPIModel
@property(nonatomic,strong)NSString *productId;
@property(nonatomic,strong)NSString *productName;
@property(nonatomic,strong)NSString *productLogo;
@property(nonatomic,strong)NSString *spec;
@property(nonatomic,strong)NSString *factory;

@property(nonatomic)int quantity;
@property(nonatomic)BOOL isSelect;
@end



@interface JsonVo : BaseModel
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *spec;
@property(nonatomic,strong)NSString *factory;
@property(nonatomic,strong)NSString *imgUrl;
@property(nonatomic)int quantity;
@end

@interface DrugVo : BaseAPIModel
@property(nonatomic,strong)NSString *proId;
@property(nonatomic,strong)NSString *proName;
@property(nonatomic,strong)NSString *pid;
@property(nonatomic,strong)NSString *label;
@property(nonatomic,strong)NSString *spec;
@property(nonatomic,strong)NSString *signCode;
@property(nonatomic,strong)NSString *factoryName;
@property(nonatomic,strong)NSString *imgUrl;
@property(nonatomic,strong)NSString *source;
@property(nonatomic,assign)BOOL gift;
@property(nonatomic,assign)BOOL discount;
@property(nonatomic,assign)BOOL voucher;
@property(nonatomic,assign)BOOL special;
@property(nonatomic,strong)NSString *beginDate;
@property(nonatomic,strong)NSString *endDate;
@property(nonatomic,assign)BOOL multiPromotionl;
@end

@interface MktgCouponListVo : BaseAPIModel
@property (nonatomic, strong) NSArray *coupons; // 券待选择列表
@end

@interface OnlineBaseCouponDetailVo : BaseAPIModel

@property(nonatomic,strong)NSString *couponId;  //券ID,
@property(nonatomic,strong)NSString *couponValue;   //券值,
@property(nonatomic,strong)NSString *couponTag; //券标签,
@property(nonatomic,strong)NSString *groupId;   //所属商家ID,
@property(nonatomic,strong)NSString *groupName;     //所属商家名称。简称已做处理,
@property(nonatomic,strong)NSString *begin;     //有效期：开始时间,
@property(nonatomic,strong)NSString *end;      //有效期：结束时间,
@property(nonatomic,strong)NSString *chronic;   //是否慢病专享,
@property(nonatomic,strong)NSString *source;   //来源。0.全部，1.全维 2.商家,
@property(nonatomic,strong)NSString *scope;    //券类型。1.通用代金券，2.慢病专享代金券，4.礼品券，5.商品券,
@property(nonatomic,strong)NSString *status;    //状态：0.待开始，1.待使用，2.快过期，3.已使用，4.已过期,
@property(nonatomic,strong)NSString *giftImgUrl;    //优惠券图片地址。礼品券专用,
@property(nonatomic,assign)BOOL top;   //是否置顶。（疯抢）,
@property(nonatomic,assign)BOOL frozen;    //是否冻结,
@property(nonatomic,strong)NSString *desc;  //优惠券描述,
@property(nonatomic,strong)NSString *couponTitle;   //优惠券标题,
@property(nonatomic,strong)NSString *couponRemark;  //优惠券备注,
@property(nonatomic,strong)NSString *couponNumLimit;    //剩余领取次数,
@property(nonatomic,strong)NSString *suitableProductCount;  //适用商品数量,
@property(nonatomic,strong)NSString *suitableBranchCount;   //适用分店数量,
@property(nonatomic,assign)BOOL empty; //是否已领完
@property(nonatomic,assign)BOOL canEmpShare; //是否可以分享
@property(nonatomic,strong)NSString *tag; //是否可以分享
@property(nonatomic,strong)NSString *priceInfo; // 价值信息。仅3.0及之后的优惠商品券取本字段


@end


@interface RecordListModel : BaseModel
@property(nonatomic,strong)NSArray *logs;
@end


@interface RecordModel : BaseModel
@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,strong)NSString *intro;
@end


@interface CouponConditionVoListModel : BaseAPIModel
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *conditions;
@end


