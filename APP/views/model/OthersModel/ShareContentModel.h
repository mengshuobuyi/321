//
//  ShareContentModel.h
//  APP
//
//  Created by PerryChen on 6/3/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import "BaseModel.h"
typedef enum {
    ShareTypeCoupon = 1,                 // 促销活动分享
    ShareTypeCouponProduct = 2,          // 优惠商品的分享
    ShareTypeCouponQuan = 3,             // 优惠券的分享
    ShareTypeChronicCouponQuan = 4,      // 慢病优惠券的分享
    ShareTypeStorePoster = 5,            // 门店海报的分享
    ShareTypeBranchLogoPreview = 6,      // 商家门店宣传预览的分享
    ShareTypePostDetail = 7,             // 分享帖子详情
    ShareTypeInternalProduct = 8,        // 分享本店商品
    ShareTypeMerchant = 9,               // 分享本店
    ShareTypeOuterLink=10,               // 分享外链
    
}UMengShareType;

typedef enum {
    SharePlatformSina = 0x00000001,
    SharePlatformQQ = 0x00000001 << 1,
    SharePlatformWechatSession = 0x00000001 << 2,
    SharePlatformWechatTimeline = 0x00000001 << 3,
}UMengSharePlatForm;

@interface ShareSaveLogModel : BaseModel
@property (nonatomic, strong) NSString *shareObj;           // 分享对象类型(1: 优惠券 2: 优惠商品 3: 商家优惠活动)
@property (nonatomic, strong) NSString *shareObjId;         // 分享对象ID
@property (nonatomic, strong) NSString *province;           // 省
@property (nonatomic, strong) NSString *city;               // 市
@property (nonatomic, strong) NSString *token;              // token
@property (nonatomic, strong) NSString *remark;             // remark
@end

@interface ShareContentModel : BaseModel
@property (nonatomic, assign) UMengShareType typeShare;     // 分享类型                   ###必须
@property (nonatomic, assign) UMengSharePlatForm platform;  // 分享平台                   ###必须
@property (nonatomic, strong) NSString *shareID;            // 分享的药房id, 症状ID等      ###必须
@property (nonatomic, strong) NSString *title;              // 分享的药方名称，症状名称等    ###必须
@property (nonatomic, strong) NSString *content;            // 资讯详情，其余可写nil
@property (nonatomic, strong) NSString *imgURL;             // 分享的图片URL
@property (nonatomic, strong) NSString *shareLink;          // 分享的点击后链接地址
@property (nonatomic, strong) ShareSaveLogModel *modelSavelog;      // 分享统计的Model
@end