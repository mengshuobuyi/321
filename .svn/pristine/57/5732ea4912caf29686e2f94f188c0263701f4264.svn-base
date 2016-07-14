//
//  ChatManagerDefs.h
//  APP
//
//  Created by carret on 15/5/21.
//  Copyright (c) 2015年 carret. All rights reserved.
//

//#ifndef APP_ChatManagerDefs_h
//#define APP_ChatManagerDefs_h
 
/*!
 @enum
 @brief 聊天类型
 @constant MessageMediaTypeText 1 文本类型
 @constant MessageMediaTypePhoto 2 图片类型
 @constant MessageMediaTypeStarStore 3 药店端发起的评价
 @constant MessageMediaTypeQuitout  4 账号退出
 @constant MessageMediaTypeActivity 5 营销活动
 @constant MessageMediaTypeStarClient 6 客户端对药店端发起的评价进行评论
 @constant MessageMediaTypeAutoSubscription 7 慢病订阅（全维药师）
 @constant MessageMediaTypeDrugGuide 8 用药指导 （全维药师）
 @constant MessageMediaTypePurchaseMedicine 9 购药（全维药师）
 @constant MessageMediaTypeLocation 10 位置类型
 @constant MessageMediaTypeVoice 11 语音类型
 @constant MessageMediaTypeEmotion 12 表情（转成文本形式发送）
 @constant MessageMediaTypeLocalPosition 13 位置 ,框架自带的
 @constant MessageMediaTypeSpreadHint 14 消息扩散，没人回自动发送一段消息
 有待更新，有的解释是预留的
 */
typedef NS_ENUM(NSInteger, MessageBodyType) {
    MessageMediaTypeText = 1,
    MessageMediaTypePhoto = 2,
    MessageMediaTypeStarStore = 3,//暂时不用
    MessageMediaTypeQuitout = 4,//暂时不用
    MessageMediaTypeActivity = 5,
    MessageMediaTypeStarClient = 6,//暂时不用
    MessageMediaTypeAutoSubscription = 7,
    MessageMediaTypeDrugGuide = 8,
    MessageMediaTypePurchaseMedicine = 9,
    MessageMediaTypeLocation = 10,
    MessageMediaTypeVoice = 11,
    MessageMediaTypeEmotion = 12,//暂时不用
    MessageMediaTypeLocalPosition = 13,//暂时不用
    MessageMediaTypeSpreadHint = 14,
    
    MessageMediaTypeMedicine = 15,                          //发送普通药品
    MessageMediaTypeMedicineSpecialOffers = 16,             //发送优惠活动
    MessageMediaTypeMedicineShowOnce = 17,                  //药品链接
    MessageMediaTypeMedicineSpecialOffersShowOnce = 18,     //优惠活动链接
    MessageMediaTypeHeader = 19,                    //药师回答仅供参考，具体用药请以医生处方为准
    MessageMediaTypeLine = 20,                      //药师为您服务
    MessageMediaTypeFooter = 21,                    //其他药师咨询
    MessageMediaTypePhone = 22,                     //拨打药房电话
    MessageMediaTypeCoupon = 23,                     //优惠券
    MessageMediaTypeMedicineCoupon=24,          //优惠商品
    MessageMediaTypeStoreMedicine = 25,                          //发送普通药品
};

/*!
 @enum
 @brief 聊天消息发送状态
 @constant eMessageDeliveryState_Pending 待发送
 @constant eMessageDeliveryState_Delivering 正在发送
 @constant eMessageDeliveryState_Delivered 已发送, 成功
 @constant eMessageDeliveryState_Failure 已发送, 失败
 */
typedef NS_ENUM(NSInteger, MessageDeliveryState) {
    MessageDeliveryState_Pending = 0,
    MessageDeliveryState_Delivering,
    MessageDeliveryState_Delivered,
    MessageDeliveryState_Failure
};

typedef NS_ENUM(NSInteger, MessageFileState) {
    MessageFileState_Pending = 0,
    MessageFileState_Downloading,
    MessageFileState_Downloaded,
    MessageFileState_Failure,   //3
};
/*!
 @brief 消息回执类型
 @constant eReceiptTypeRequest   回执请求
 @constant eReceiptTypeResponse  回执响应
 */
//typedef NS_ENUM(NSInteger, ReceiptType){
//    ReceiptTypeRequest  = 0,
//    ReceiptTypeResponse,
//};
//#endif

/*!
 @brief 消息类型
 @constant
 @constant
 */
typedef NS_ENUM(NSInteger,MessageDeliveryType) {
    MessageTypeSending = 0,
    MessageTypeReceiving
};
