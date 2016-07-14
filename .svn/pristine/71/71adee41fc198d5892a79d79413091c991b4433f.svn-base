//
//  WebDirectModel.h
//  APP
//
//  Created by PerryChen on 8/21/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import "BaseModel.h"
#import "WebDirectMacro.h"
#import "MapInfoModel.h"

@interface WebDirectParamsModel : BaseModel
@property (nonatomic, strong) NSString *id;                 // H5 跳转所需要的id
@property (nonatomic, strong) NSString *type;               // 优惠细则所在页面类型
@property (nonatomic, strong) NSString *token;              // token
@property (nonatomic, strong) NSString *actId;              // 优惠商品 送券ID
@property (nonatomic, strong) NSString *diseaseName;        // 跳转本地的疾病页面的疾病名称
@property (nonatomic, strong) NSString *zufangId;           // 跳转药品列表的组方ID
@end

@interface WebDirectModel : BaseModel

@property (nonatomic, strong) NSString *jumpType;           // 界面跳转类型 1 是跳转本地。 2是跳转H5
@property (nonatomic, strong) NSString *pageType;           // H5跳转本地的界面类型
@property (nonatomic, strong) NSString *title;              // H5页面的标题
@property (nonatomic, strong) NSString *url;                // 跳转H5的URL
@property (nonatomic, strong) NSString *progressbar;        // 是否显示进度条
@property (nonatomic, strong) WebDirectParamsModel *params; // H5返回的参数Model

@end

// 本地跳转统计详情页面，所需要的model
@interface WebStatisticsModel : BaseModel
@property (nonatomic, strong) NSString *couponID;           // 优惠券id
@property (nonatomic, strong) NSString *begin;              // 统计开始时间
@property (nonatomic, strong) NSString *status;             // 统计的状态
@end

// 本地跳转优惠细则详情页面，所需要的优惠券model
@interface WebCouponConditionModel : BaseModel
@property (nonatomic, strong) NSString *couponId;           // 优惠券id
@property (nonatomic, strong) NSString *type;               // 优惠细则类型
@end

// 本地跳转H5的药品详情页面，所需要的药品信息model
@interface WebDrugDetailModel : BaseModel
@property (nonatomic, strong) MapInfoModel *modelMap;
@property (nonatomic, strong) NSString *showDrug;       // 1展示药品促销标签
@property (nonatomic, strong) NSString *proDrugID;      // 药品ID
@property (nonatomic, strong) NSString *promotionID;    // 促销ID
@end

// 本地跳转H5的症状详情页面，所需要的症状详情model
@interface WebSymptomDetailModel : BaseModel
@property (nonatomic, strong) NSString *symptomId;
@end

// 本地跳转H5的疾病详情页面，所需要的疾病信息model
@interface WebDiseaseDetailModel : BaseModel
@property (nonatomic, strong) NSString *diseaseId;
@end

// 本地跳转H5的历史订单详情页面，所需要的order Model
@interface WebOrderDetailModel : BaseModel
@property (nonatomic, strong) NSString *orderId;           // 订单id
@end

// 本地跳转问答详情所需要的Model
@interface WebAnswerModel : BaseModel
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@end

// 本地跳转H5的培训问卷页面
@interface WebQuestionnaireDetailModel : BaseModel
@property (nonatomic, strong) NSString *trainingId;
@property (nonatomic, strong) NSString *channel;        // 从列表进入传0
@end

// 本地跳转H5的页面, 所需要的信息Model
@interface WebDirectLocalModel : WebDirectModel
@property (nonatomic, assign) LocalShareType typeShare;         // 本地跳转H5的分享页面类型
@property (nonatomic, assign) WebLocalType typeLocalWeb;        // 本地跳转H5的界面类型
@property (nonatomic, strong) WebCouponConditionModel *modelCondition;  // 优惠详情的model
@property (nonatomic, strong) WebDrugDetailModel *modelDrug;    // 药品详情的model
@property (nonatomic, strong) WebQuestionnaireDetailModel *modelQuestionnaire; // 问卷详情model
@property (nonatomic, strong) WebDiseaseDetailModel *modelDisease;      // 疾病详情的Model
@property (nonatomic, strong) WebSymptomDetailModel *modelSymptom;      // 症状详情的Model

@property (nonatomic, strong) WebStatisticsModel *modelStatis;  // 统计详情的model
@property (nonatomic, strong) WebOrderDetailModel *modelOrder;  // 订单详情的model
@property (nonatomic, assign) WebTitleType typeTitle;           // 设置导航栏的右上角逻辑
@property (nonatomic, strong) WebAnswerModel *modelAnswer;              // 问答详情Model
@end

// H5调用原生代码所需要的参数的model。包含分享，电话，弹框等
@interface WebPluginParamsModel : BaseModel
@property (nonatomic, strong) NSString *shareType;              // h5分享类型
@property (nonatomic, strong) NSString *title;                  // h5替换的标题
@property (nonatomic, strong) NSString *img_url;                // h5分享的图片URL
@property (nonatomic, strong) NSString *content;                // h5分享的内容
@property (nonatomic, strong) NSString *objId;                  // h5分享的类型id
@end

// H5调用原生代码所需要的model
@interface WebPluginModel : BaseModel
@property (nonatomic, strong) NSString *type;                   // 1：title替换  2：打电话   3：分享   4：提示框
@property (nonatomic, strong) NSString *url;                    // h5分享的链接
@property (nonatomic, strong) NSString *message;                // 打电话的电话号码和提示框的信息
@property (nonatomic, strong) WebPluginParamsModel *params;     // h5 回调参数model
@end

