//
//  QWYSViewController.h
//  wenYao-store
//
//  Created by YYX on 15/8/11.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseVC.h"
#import "ConsultDoctorModel.h"
#import "CouponModel.h"
#import "MessageCenter.h"
#import "PTPMessageCenter.h"
#import "ExpandAnimateButton.h"

//typedef NS_ENUM(NSInteger, QWYSInputViewStyle) {
//    // 分两种,一种是iOS6样式的，一种是iOS7样式的
//    
//    QWYSInputViewStyleQuasiphysical,
//    QWYSInputViewStyleFlat
//};
extern BOOL const QWYSXPallowsSendFace;//是否支持发送表情
extern BOOL const QWYSXPallowsSendVoice;//是否支持发送声音
extern BOOL const QWYSXPallowsSendMultiMedia;//是否支持发送多媒体
extern BOOL const QWYSXPallowsPanToDismissKeyboard;//是否允许手势关闭键盘，默认是允许
extern BOOL const XPshouldPreventAutoScrolling;

@interface QWYSViewController : QWBaseVC

@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) CouponDetailModel *coupnDetailModel;
@property (nonatomic ,strong) NSString *messageSender;

@property (nonatomic ,copy)   NSString *branchId;
@property (nonatomic ,copy) NSString *branchName;

@property (nonatomic, strong) UIView                      *headerHintView;
//@property (nonatomic, assign) BOOL mustAnswer;
//@property (nonatomic, assign) QWYSInputViewStyle inputViewStyle;
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
