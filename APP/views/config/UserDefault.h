/*!
 @header UserDefault.h
 @abstract 记录所有userdefault相关的常量名
 @author .
 @version 1.00 2015/03/06  (1.00)
 */

#ifndef USER_DEFAULT_H
#define USER_DEFAULT_H

#define USER_PERSON_INFO                    @"user_person_info"   //存储用户信息
//#define MSG_INFO                  @"MSG_INFO"
#define APP_USERNAME_KEY                    @"appusernamekey"//app用户名
#define LAST_LOCATION_CITY                  @"LAST_LOCATION_CITY"

#define LAST_LOCATION_PROVINCE              @"LAST_LOCATION_PROVINCE"

#define LAST_LOCATION_LONGITUDE             @"LAST_LOCATION_LONGITUDE"

#define LAST_LOCATION_LATITUDE              @"LAST_LOCATION_LATITUDE"

#define LAST_FORMAT_ADDRESS                 @"LAST_FORMAT_ADDRESS"

#define APP_LOGIN_STATUS                    @"apploginloginstatus"

#define kUserDefaultsCookie                 @"kUserDefaultsCookie"
#define kUserDefaultsIdLogin                @"kUserDefaultsIdLogin"

#define ONCE_LOADING                        @"once_loading"   //仅加载一次
#define kLocationAudition                   @"kLocationAudition"
//------cj------
#define          QUICK_COMPANY              @"quick_company"//机构信息

#define          QUICK_HASLATITUDE          @"quick_haslatitude" //经纬度

#define          QUICK_REGISTERACCOUNT              @"quick_registeraccount"  //手机号

#define          QUICK_INFO       [NSString stringWithFormat:@"%@/quickRegist", [QWUserDefault getStringBy:QUICK_REGISTERACCOUNT]]  //地址信息

//--------------

//------------------------------------------YYX-------------------------------------------
#define REGISTER_JG_AREAINFO       [NSString stringWithFormat:@"%@/areainfo",[QWUserDefault getStringBy:QUICK_REGISTERACCOUNT]]  //地址信息

#define REGISTER_JG_REGISTERID     [NSString stringWithFormat:@"%@/registerid",[QWUserDefault getStringBy:QUICK_REGISTERACCOUNT]]

#define REGISTER_JG_COMPANYINFO    [NSString stringWithFormat:@"%@/companyInfo",[QWUserDefault getStringBy:QUICK_REGISTERACCOUNT]]

#define REGISTER_JG_INSTITUTIONINFO   [NSString stringWithFormat:@"%@/institutionInfo",[QWUserDefault getStringBy:QUICK_REGISTERACCOUNT]]

#define REGISTER_JG_FINISHCOMPANYINFO   [NSString stringWithFormat:@"%@/finishcompanyinfo",[QWUserDefault getStringBy:QUICK_REGISTERACCOUNT]]

#define REGISTER_JG_FINISHUSERINFO    [NSString stringWithFormat:@"%@/finishuserinfo",[QWUserDefault getStringBy:QUICK_REGISTERACCOUNT]]

#define REGISTER_JG_USERINFO    [NSString stringWithFormat:@"%@/userinfo",[QWUserDefault getStringBy:QUICK_REGISTERACCOUNT]]

#define REGISTER_JG_MOBILE    [NSString stringWithFormat:@"%@/mobile",[QWUserDefault getStringBy:QUICK_REGISTERACCOUNT]]

#define REGISTER_JG_PAPOTHECARY   [NSString stringWithFormat:@"%@/papothecary",[QWUserDefault getStringBy:QUICK_REGISTERACCOUNT]]

#define REGISTER_JG_CORPORATION   [NSString stringWithFormat:@"%@/corporation",[QWUserDefault getStringBy:QUICK_REGISTERACCOUNT]]

#define REGISTER_JG_ACCOUNT    [NSString stringWithFormat:@"%@/account",[QWUserDefault getStringBy:QUICK_REGISTERACCOUNT]]

#define REGISTER_JG_FAILINFO    [NSString stringWithFormat:@"%@/failInfo",[QWUserDefault getStringBy:QUICK_REGISTERACCOUNT]]

#define kApplicationLastAliveDate           @"kApplicationLastAliveDate"

//------------------------------------------YQY-------------------------------------------


//------------------------------------------meng-------------------------------------------


//------------------------------------------meng-------------------------------------------

//---------- kDeviceToken --------------
#define kDeviceToken    @"kDeviceToken"

// ----- cty <<<
#define QWDEFAULT_CURRENT_USER_SETTINGS QWDEFAULT_USER_SETTINGS([QWGlobalManager sharedInstance].configure.passportId)
#define QWDEFAULT_USER_SETTINGS(name) [@"QWDEFAULT_USER_SETTINGS_"  stringByAppendingString:name]
#define QWDEFAULT_CURRENT_USER_ENHANCE_INFO QWDEFAULT_CREDIT_ENHANCE_INFO([QWGlobalManager sharedInstance].configure.passportId)
#define QWDEFAULT_CREDIT_ENHANCE_INFO(name)  [@"QWDEFAULT_CREDIT_ENHANCE_INFO_" stringByAppendingString:name]   
// 积分强化
#define QWDEFAULT_CREDIT_ONCE_ALERT_AVAILABLE  @"QWDEFAULT_CREDIT_ONCE_ALERT_AVAILABLE"
#define QWDEFAULT_CREDIT_DAILY_ALERT_AVALIABLE   @"QWDEFAULT_CREDIT_DAILY_ALERT_AVALIABLE"
#define QWDEFAULT_CREDIT_ONCE_ALERT_LASTTIMESTAMP  @"QWDEFAULT_CREDIT_ONCE_ALERT_LASTTIMESTAMP"
#define QWDEFAULT_CREDIT_DAILY_ALERT_LASTTIMESTAMP  @"QWDEFAULT_CREDIT_DAILY_ALERT_LASTTIMESTAMP"
#endif
// ----- cty >>>


