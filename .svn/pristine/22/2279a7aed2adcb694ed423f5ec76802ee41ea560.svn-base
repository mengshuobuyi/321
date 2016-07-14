//
//  ActivityModel.h
//  wenYao-store
//
//  Created by caojing on 15/4/1.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseModel.h"
#import "BaseAPIModel.h"


@interface ActivityModel : BaseAPIModel
@property(strong,nonatomic)NSString *activityId;
@end


//add by lijian 2.2.0
@interface BranchActivityVo : BaseAPIModel

@property(strong,nonatomic)NSString *activityId;
@property(strong,nonatomic)NSString *actityType;
@property(strong,nonatomic)NSString *title;
@property(strong,nonatomic)NSString *sortTime;

@end

/**
 *  3.6.6	新营销活动列表
 */
@interface QueryActivityList : BaseAPIModel
@property(strong,nonatomic)NSString *page;
@property(strong,nonatomic)NSString *pageSize;
@property(strong,nonatomic)NSString *pageSum;
@property(strong,nonatomic)NSString *totalRecords;
@property(strong,nonatomic)NSArray  *list;
@end

@interface MktgDmListVo : BaseAPIModel
@property (nonatomic, strong) NSArray *dms;
@end

//营销活动的详情
@interface QueryActivityInfo : BaseModel
@property(strong,nonatomic)NSString *id;
@property(strong,nonatomic)NSString *activityId;
@property(strong,nonatomic)NSString *groupId;
@property(strong,nonatomic)NSString *title;
@property(strong,nonatomic)NSString *imgUrl;
@property(strong,nonatomic)NSString *content;
@property(strong,nonatomic)NSString *publishTime;
@property(strong,nonatomic)NSArray  *imgs;
@property(strong,nonatomic)NSString *source;
@property(strong,nonatomic)NSString *startDate;
@property(strong,nonatomic)NSString *endDate;
@property(strong,nonatomic)NSString *deleted;
@property(strong,nonatomic)NSString *expired;
@property(strong,nonatomic)UIImage  *imageSrc;
@property(strong,nonatomic)NSString *createTime;
@property(strong,nonatomic)NSString *type;      //
@property(strong,nonatomic)NSString *begin;
@property(strong,nonatomic)NSString *end;
@property(strong,nonatomic)NSString *publish;

@end

//营销活动图片的展示

@interface QueryActivityImage : BaseAPIModel
@property(strong,nonatomic)NSString  *normalImg;
@property(strong,nonatomic)NSString  *sort;
@end


/**
 *  3.6.4	删除门店活动
 */
@interface DeleteActivitys : BaseAPIModel
@property(nonatomic,strong)NSString *result;
@property(nonatomic,strong)NSString *msg;
@end

//优惠活动列表
@interface BranchPromotionListModel : BaseAPIModel

@property(strong,nonatomic)NSString *page;
@property(strong,nonatomic)NSString *pageSize;
@property(strong,nonatomic)NSString *pageSum;
@property(strong,nonatomic)NSString *totalRecords;
@property(strong,nonatomic)NSArray  *list;

@end

@interface BranchPromotionModel : BaseAPIModel

@property (nonatomic ,strong) NSString *desc;
@property (nonatomic ,strong) NSString *id;
@property (nonatomic ,strong) NSString *imgUrl;
@property (nonatomic ,strong) NSString *status;
@property (nonatomic ,strong) NSString *title;
@property (nonatomic ,strong) NSString *pushStatus;

@end
//-------新的优惠活动-------
@interface BranchNewPromotionModel : BaseModel

@property (nonatomic ,strong) NSString *desc;
@property (nonatomic ,strong) NSString *packPromotionId;
@property (nonatomic ,strong) NSString *title;
@property (nonatomic ,strong) NSString *imgUrl;

@end


@interface PackPromotionDetailVO : BaseAPIModel

@property (nonatomic ,strong) NSString *packPromotionId;
@property (nonatomic ,strong) NSString *desc;
@property (nonatomic ,strong) NSString *title;
@property (nonatomic ,strong) NSString *imgUrl;
@property (nonatomic ,strong) NSNumber *status;
@property (nonatomic ,strong) NSArray *coupons;

@end

@interface BranchPromotionProVO : BaseModel

@property (nonatomic ,strong) NSString *productId;
@property (nonatomic ,strong) NSString *proCode;
@property (nonatomic ,strong) NSString *proName;
@property (nonatomic ,strong) NSString *spec;
@property (nonatomic ,strong) NSString *factory;
@property (nonatomic ,strong) NSString *label;
@property (nonatomic ,strong) NSString *imgUrl;
@property (nonatomic ,strong) NSNumber *type;
@property (nonatomic ,strong) NSString *promotionId;
@property (nonatomic ,strong) NSString *source;
@property (nonatomic ,strong) NSString *startDate;
@property (nonatomic ,strong) NSString *endDate;

@end

@interface BranchCouponVO : BaseModel

@property (nonatomic ,strong) NSString *couponId; //领用券ID
@property (nonatomic ,strong) NSString *couponValue; //券值
@property (nonatomic ,strong) NSString *couponTag; //券标签
@property (nonatomic ,strong) NSString *groupName; //商家名称,
@property (nonatomic ,strong) NSString *groupId; //商家ID
@property (nonatomic ,assign) BOOL      chronic; //是否慢病专享
@property (nonatomic ,assign) BOOL      over; //券是否领取完
@property (nonatomic ,strong) NSString *source; //来源 -- 该字段商户端才使用,
@property (nonatomic ,strong) NSString *startDate; //开始时间,
@property (nonatomic ,strong) NSString *endDate; //结束时间
@property (nonatomic ,assign) BOOL pick; //是否领取过
@property (nonatomic ,strong) NSString *myCouponId; //领用券ID
@property (nonatomic ,strong) NSString *scope; //券类型。1.通用代金券，2.慢病专享代金券，4.礼品券，5.商品券,
@property (nonatomic ,strong) NSString *giftImgUrl; //礼品券图片Url
@property (nonatomic ,strong) NSString *couponRemark; //优惠券备注
@property (nonatomic ,strong) NSString *tag; //优惠券备注
@property(nonatomic,strong)NSString *priceInfo;

@end

