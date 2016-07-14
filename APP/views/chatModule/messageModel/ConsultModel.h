//
//  ConsultModel.h
//  APP
//
//  Created by chenzhipeng on 5/5/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import "BaseAPIModel.h"
#import "BasePrivateModel.h"
@interface ConsultModel : BaseAPIModel

@end

@interface ConsultCustomerListModel : BaseAPIModel
@property (nonatomic, strong) NSArray   *consults;
@property (nonatomic, strong) NSString  *lastTimestamp;         //更新时间
@end


@interface ConsultCustomerModel : ConsultModel
@property (nonatomic, strong) NSString *consultId;
@property (nonatomic, strong) NSString *consultTitle;
@property (nonatomic, strong) NSString *consultCreateTime;
@property (nonatomic, strong) NSString *consultFormatCreateTime;
@property (nonatomic, strong) NSString *consultFormatShowTime;
@property (nonatomic, strong) NSString *consultStatus;      // 消息状态
@property (nonatomic, strong) NSString *consultMessage;
@property (nonatomic, strong) NSString *consultLatestTime;
@property (nonatomic, strong) NSString *pharAvatarUrl;
@property (nonatomic, strong) NSString *pharShortName;
@property (nonatomic, strong) NSString *pharPassport;
@property (nonatomic, strong) NSString *pharType;           // 2是明星商家
@property (nonatomic, strong) NSString *unreadCounts;
@property (nonatomic, strong) NSString *systemUnreadCounts;
@property (nonatomic, strong) NSString *isSpred;
@property (nonatomic, strong) NSString *spreadMessage;
@property (nonatomic, strong) NSString *consultType;        // 咨询类型：1群发、2指定

@end

@interface CustomerConsultVoModel : BasePrivateModel
@property (nonatomic, strong) NSString *consultId;
@property (nonatomic, strong) NSString *consultTitle;
@property (nonatomic, strong) NSString *consultCreateTime;
@property (nonatomic, strong) NSString *consultFormatCreateTime;
@property (nonatomic, strong) NSString *consultFormatShowTime;
@property (nonatomic, strong) NSString *consultStatus;      // 消息状态
@property (nonatomic, strong) NSString *consultMessage;
@property (nonatomic, strong) NSString *consultLatestTime;
@property (nonatomic, strong) NSString *pharAvatarUrl;
@property (nonatomic, strong) NSString *pharShortName;
@property (nonatomic, strong) NSString *pharPassport;
@property (nonatomic, strong) NSString *pharType;           // 2是明星商家
@property (nonatomic, strong) NSString *unreadCounts;
@property (nonatomic, strong) NSString *systemUnreadCounts;
@property (nonatomic, strong) NSString *isSpred;
@property (nonatomic, strong) NSString *spreadMessage;
@property (nonatomic, strong) NSString *consultType;        // 咨询类型：1群发、2指定
@property (nonatomic, strong) NSString *consultShowTitle;   // 用于消息盒子的显示标题
@end


@interface ContentJson : BaseModel

@property (nonatomic, strong) NSString *actId;
@property (nonatomic, strong) NSString *actImgUrl;
@property (nonatomic, strong) NSString *actTitle;
@property (nonatomic, strong) NSString *actContent;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *lon;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSString *spec;
@property (nonatomic, strong) NSString *branchId;
@property (nonatomic, strong) NSString *branchProId;

@property (nonatomic, strong) NSString *speText;
@property (nonatomic, strong) NSString *speUrl;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *platform;

//优惠药品
@property (nonatomic, strong) NSString *pmtLabe;
@property (nonatomic, strong) NSString *pmtId;

//优惠券
@property (nonatomic, strong) NSString *couponId;
@property (nonatomic, strong) NSString *groupId;
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong) NSString *couponValue;
@property (nonatomic, strong) NSString *couponTag;
@property (nonatomic, strong) NSString *begin;
@property (nonatomic, strong) NSString *end;
@property (nonatomic, strong) NSString *scope;
@property (nonatomic, strong) NSString *top;
//优惠活动
@property (nonatomic, strong) NSString *branchLogo;//商户图片

@end

@interface CustomerConsultDetailList : BaseAPIModel

@property (strong, nonatomic) NSArray  *details;
@property (strong, nonatomic) NSString *serverTime;
@property (strong, nonatomic) NSString *consultCreateTime;
@property (strong, nonatomic) NSString *consultType;
@property (strong, nonatomic) NSString *consultStatus;
@property (strong, nonatomic) NSString *consultRaceTime;
@property (strong, nonatomic) NSString *consultRemainTime;
@property (strong, nonatomic) NSString *consultMessage;
@property (strong, nonatomic) NSString *spreadMessage;
@property (strong, nonatomic) NSString *detailId;
@property (strong, nonatomic) NSString *consultId;
@property (strong, nonatomic) NSString *branchId;
@property (strong, nonatomic) NSString *customerIndex;
@property (strong, nonatomic) NSString *pharAvatarUrl;
@property (strong, nonatomic) NSString *pharShortName;
@property (strong, nonatomic) NSString *isSpred;

@end

@interface ConsultDetail : BaseModel

@property (strong, nonatomic) NSString *detailId;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *contentJson;
@property (strong, nonatomic) NSString *contentType;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *readStatus;

@end

@interface ConsultDetailCreateModel : BaseAPIModel

@property (nonatomic, strong) NSString *detailId;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *UUID;
@end

@interface ConsultDetailCustomerDetailListModel : ConsultModel

@property (nonatomic ,assign) int consultType;
@property (nonatomic ,strong) NSArray *details;
@property (nonatomic ,strong) NSString *pharAvatarUrl;
@property (nonatomic ,assign) double serverTime;

@end

@interface ConsultDetailCustomerDetailModel : BaseModel

@property (nonatomic ,strong) NSString *contentJson;
@property (nonatomic ,strong) NSString *contentType;
@property (nonatomic ,assign) double createTime;
@property (nonatomic ,assign) long int detailId;
@property (nonatomic ,strong) NSString *readStatus;
@property (nonatomic ,strong) NSString *type;

@end

@interface PharConsultDetail : BaseAPIModel

@property (strong, nonatomic) NSArray  *details;
@property (strong, nonatomic) NSString *serverTime;
@property (strong, nonatomic) NSString *consultCreateTime;
@property (strong, nonatomic) NSString *consultType;
@property (strong, nonatomic) NSString *consultStatus;
@property (strong, nonatomic) NSString *consultRaceTime;
@property (strong, nonatomic) NSString *consultRemainTime;
@property (strong, nonatomic) NSString *consultMessage;
@property (strong, nonatomic) NSString *spreadMessage;
@property (strong, nonatomic) NSString *detailId;
@property (strong, nonatomic) NSString *consultId;
@property (strong, nonatomic) NSString *branchId;
@property (strong, nonatomic) NSString *customerIndex;
@property (strong, nonatomic) NSString *pharAvatarUrl;
@property (strong, nonatomic) NSString *pharShortName;
@property (strong, nonatomic) NSString *isSpred;

@end



//@interface ConsultDetailCustomerDetailListModel : ConsultModel
//
//@property (nonatomic ,assign) int consultType;
//@property (nonatomic ,strong) NSArray *details;
//@property (nonatomic ,strong) NSString *pharAvatarUrl;
//@property (nonatomic ,assign) double serverTime;
//
//@end
//
//@interface ConsultDetailCustomerDetailModel : BaseModel
//
//@property (nonatomic ,strong) NSString *contentJson;
//@property (nonatomic ,strong) NSString *contentType;
//@property (nonatomic ,assign) double createTime;
//@property (nonatomic ,assign) long int detailId;
//@property (nonatomic ,strong) NSString *readStatus;
//@property (nonatomic ,strong) NSString *type;
//
//@end

///////////////



@interface ConsultCloseModel : BasePrivateModel

@property (nonatomic, strong) NSString      *consultId;
@property (nonatomic, strong) NSString      *consultTitle;
@property (nonatomic, strong) NSString      *consultCreateTime;
@property (nonatomic, strong) NSString      *customerAvatarUrl;
@property (nonatomic, strong) NSString      *customerRemark;
@property (nonatomic, strong) NSString      *customerNick;
@property (nonatomic, strong) NSString      *customerMobile;
@property (nonatomic, strong) NSString      *customerIndex;
@property (nonatomic, strong) NSString      *customerDistance;
@end


@interface ConsultConsultingModellist : BaseAPIModel
@property (nonatomic, strong) NSArray   *consults;
@property (nonatomic, strong) NSString  *lastTimestamp;         //更新时间
@end


@interface ConsultConsultingModel : BasePrivateModel

@property (nonatomic, strong) NSString      *consultId;
@property (nonatomic, strong) NSString      *consultTitle;
@property (nonatomic, strong) NSString      *consultCreateTime;
@property (nonatomic, strong) NSString      *consultLatestTime;
@property (nonatomic, strong) NSString      *customerAvatarUrl;
@property (nonatomic, strong) NSString      *customerIndex;
@property (nonatomic, strong) NSString      *customerDistance;
@property (nonatomic, strong) NSString      *unreadCounts;
@property (nonatomic, strong) NSString      *consultStatus;         //1等待药师回复、2药师已回复、3问题已过期、4问题已关闭、5问题抢而未答,
@property (nonatomic, strong) NSString      *customerPassport;
@property (nonatomic, strong) NSString      *consultFormatShowTime;


@end

@interface ConsultCreateModel : BasePrivateModel

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imgUrls;
@property (nonatomic, strong) NSString *lon;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *location;

@end


@interface ConsultDetailCustomerModel : BasePrivateModel

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *point;
@property (nonatomic, strong) NSString *view;
@property (nonatomic, strong) NSString *consultId;

@end

@interface ConsultDetailPharModel : BasePrivateModel

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *point;
@property (nonatomic, strong) NSString *view;
@property (nonatomic, strong) NSString *consultId;

@end

@interface ConsultDetailReceiveModel : BasePrivateModel

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *consultId;
@property (nonatomic, strong) NSString *detailIds;

@end

@interface ConsultDetailRemoveModel : BasePrivateModel

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *consultId;

@end

@interface ConsultRacingModel : BasePrivateModel

@property (nonatomic, strong) NSString      *consultId;
@property (nonatomic, strong) NSString      *consultTitle;
@property (nonatomic, strong) NSString      *consultCreateTime;
@property (nonatomic, strong) NSString      *customerAvatarUrl;
@property (nonatomic, strong) NSString      *customerRemark;
@property (nonatomic, strong) NSString      *customerNick;
@property (nonatomic, strong) NSString      *customerMobile;
@property (nonatomic, strong) NSString      *customerIndex;
@property (nonatomic, strong) NSString      *customerDistance;

@end

@interface ConsultReplyFirstgModel : BasePrivateModel

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *consultId;

@end

@interface ConsultSpCreateModel : BasePrivateModel

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imgUrls;
@property (nonatomic, strong) NSString *lon;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *branchId;

@end



@interface SendConsultMap : BaseModel

@property (nonatomic, strong) NSString   *consultId;
@property (nonatomic, strong) NSString   *sendStatus;

@end



@interface ConsultHistoryPage : BaseAPIModel

@property (strong, nonatomic) NSArray *list;

@end

@interface ConsultHistoryModel : BaseAPIModel

@property (strong, nonatomic) NSString *consultId;
@property (strong, nonatomic) NSString *consultTitle;
@property (strong, nonatomic) NSString *consultCreateTime;
@property (strong, nonatomic) NSString *consultFormatShowTime;
@property (strong, nonatomic) NSString *consultLatestTime;
@property (strong, nonatomic) NSString *customerDistance;
@property (strong, nonatomic) NSString *consultStatus;
@property (strong, nonatomic) NSString *customerAvatarUrl;
@property (strong, nonatomic) NSString *customerIndex;
@property (strong, nonatomic) NSString *customerPassport;
@property (strong, nonatomic) NSString *unreadCounts;

@end