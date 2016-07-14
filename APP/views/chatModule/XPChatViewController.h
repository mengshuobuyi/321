//
//  XPChatViewController.h
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
#import "PTPMessageCenter.h"
#import "ExpandAnimateButton.h"

#import "ImDoingViewController.h"
#import "DoingDetailViewController.h"

#import "IMAlertCoupon.h"
#import "IMAlertCouponMedicine.h"
#import "IMAlertActivity.h"
typedef NS_ENUM(NSInteger, InputViewStyle) {
    // 分两种,一种是iOS6样式的，一种是iOS7样式的
   
    InputViewStyleQuasiphysical,
  InputViewStyleFlat
};
extern BOOL const XPallowsSendFace;//是否支持发送表情
extern BOOL const XPallowsSendVoice;//是否支持发送声音
extern BOOL const XPallowsSendMultiMedia;//是否支持发送多媒体
extern BOOL const XPallowsPanToDismissKeyboard;//是否允许手势关闭键盘，默认是允许
extern BOOL const XPshouldPreventAutoScrolling;

@interface XPChatViewController : QWBaseVC

//@property (nonatomic, strong) ConsultInfoModel  *consultInfo;
//@property (nonatomic, assign) SendConsult       sendConsultType;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) CouponDetailModel *coupnDetailModel;
@property (nonatomic ,strong) NSString *messageSender;
//@property (nonatomic ,strong) DrugDetailModel *drugDetailModel;
@property (nonatomic ,copy)   NSString *branchId;
@property (nonatomic ,copy) NSString *branchName;
//@property (nonatomic ,strong) PharMsgModel *pharMsgModel;
@property (nonatomic, strong) UIView                      *headerHintView;
@property (nonatomic, assign) BOOL mustAnswer;
@property (nonatomic, assign) InputViewStyle inputViewStyle;
@property (nonatomic, assign) MessageShowType  showType;
@property (nonatomic ,copy)NSString *sessionID;
@property (nonatomic ,strong) NSString *proId;
/**
 *  消息的类型
 */
@property (nonatomic, strong) ConsultConsultingModel  *consultingModel;
@property (nonatomic, assign) IMType        chatType;   //聊天类型
@property (nonatomic, strong) UILabel          *countDownLabel;
@property (nonatomic, strong) UIImageView      *alarmLogo;
@property (nonatomic ,strong) PharSessionVo *customerSessionVo;

@property (nonatomic, strong) ExpandAnimateButton         *animateButton;
/**
 *  隐藏键盘
 */
- (void)hiddenKeyboard;
- (void)reloadData;
@end
