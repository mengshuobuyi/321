//
//  ChatViewController.h
//  APP
//
//  Created by carret on 15/5/21.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseVC.h"
#import "ConsultDoctorModel.h"
//#import "DrugModel.h"
#import "CouponModel.h"
#import "MessageCenter.h"

#import "ImDoingViewController.h"
#import "DoingDetailViewController.h"

#import "IMAlertCoupon.h"
#import "IMAlertCouponMedicine.h"
#import "IMAlertActivity.h"
typedef enum Enum_SendConsult{
    Enum_SendConsult_Common = 0,    //普通点对点
    Enum_SendConsult_Drug   = 1,                   //商品咨询
    Enum_SendConsult_Coupn = 2,                           //优惠活动咨询
}SendConsult;

extern BOOL const allowsSendFace;//是否支持发送表情
extern BOOL const allowsSendVoice;//是否支持发送声音
extern BOOL const allowsSendMultiMedia;//是否支持发送多媒体
extern BOOL const allowsPanToDismissKeyboard;//是否允许手势关闭键盘，默认是允许
extern BOOL const shouldPreventAutoScrolling;

@interface ChatViewController : QWBaseVC

//@property (nonatomic, strong) ConsultInfoModel  *consultInfo;
@property (nonatomic, assign) SendConsult       sendConsultType;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) CouponDetailModel *coupnDetailModel;
@property (nonatomic ,strong) NSString *messageSender;
//@property (nonatomic ,strong) DrugDetailModel *drugDetailModel;
@property (nonatomic ,copy)   NSString *branchId;
@property (nonatomic ,copy) NSString *branchName;
//@property (nonatomic ,strong) PharMsgModel *pharMsgModel;

@property (nonatomic ,copy)NSString *sessionID;
@property (nonatomic ,strong) NSString *proId;
/**
 *  消息的类型
 */

@property (nonatomic, assign) MessageShowType  showType;
@property (nonatomic, assign) IMType        chatType;   //聊天类型

@property (nonatomic ,strong) PharSessionVo *customerSessionVo;
/**
 *  隐藏键盘
 */
- (void)hiddenKeyboard;
- (void)reloadData;
@end
