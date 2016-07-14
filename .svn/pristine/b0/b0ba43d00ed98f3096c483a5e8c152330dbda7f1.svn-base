//
//  Mbr.h
//  APP
//
//  Created by qwfy0006 on 15/3/19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "StoreModelR.h"
#import "StoreModel.h"

@interface Mbr : NSObject


/**
 *  发送手机验证码
 *
 */
+ (void)SendVerifyCodeWithParam:(SendVerifyCodeModelR *)param
                        success:(void (^)(id responseObj))success
                        failure:(void (^)(HttpException *e))failure;

/**
 *  验证当前账号token是否有效
 *
 */
+ (void)tokenValidWithParams:(NSDictionary *)param
                     success:(void(^)(id obj))success
                     failure:(void(^)(HttpException * e))failure;

/**
 *  根据用户账号获取用户信息
 *  
 */
+ (void)QueryInfoByIdsWithParam:(NSDictionary *)param
                        success:(void (^)(id))success
                        failure:(void (^)(HttpException *))failure;

/**
 *  3.5.9	校验手机验证码(OK)
 *
 */
+ (void)ValidVerifyCodeWithParam:(ValidVerifyCodeModelR *)param
                         success:(void (^)(id responseObj))success
                         failure:(void (^)(HttpException *e))failure;
/**
 *  @brief 3.5.40	校验手机号是否已经被注册(OK)
 */
+ (void)MobileValidWithMobile:(NSString *)mobile
                      success:(void (^)(id responseObj))success
                      failure:(void (^)(HttpException *e))failure;

/**
 *  专家登录
 *
 */
+ (void)MbrUserExpertLoginWithParam:(NSDictionary *)param
                            success:(void (^)(id))success
                            failure:(void (^)(HttpException *))failure;

+ (void)logoutWithParams:(NSDictionary *)param
                 success:(void(^)(id DFUserModel))success
                 failure:(void(^)(HttpException * e))failure;

/**
 *  验证图片验证码
 *
 */
+ (void)MbrCodeSendCodeByImageVerifyWithParams:(NSDictionary *)param
                                       success:(void(^)(id DFUserModel))success
                                       failure:(void(^)(HttpException * e))failure;

/**
 *  验证图片验证码
 *
 */
+ (void)MbrCodeValidVerifyCodeOnly4checkWithParams:(NSDictionary *)param
                                           success:(void(^)(id DFUserModel))success
                                           failure:(void(^)(HttpException * e))failure;




/**
 *  专家用户名密码登录
 *
 */
+ (void)MbrExpertLoginWithParams:(NSDictionary *)param
                         success:(void(^)(id DFUserModel))success
                         failure:(void(^)(HttpException * e))failure;


/**
 *  专家注册
 *
 */
+ (void)MbrExpertRegisterWithParams:(NSDictionary *)param
                            success:(void(^)(id DFUserModel))success
                            failure:(void(^)(HttpException * e))failure;

/**
 *  专家重置密码
 *
 */
+ (void)MbrExpertResetPasswordWithParams:(NSDictionary *)param
                                 success:(void(^)(id DFUserModel))success
                                 failure:(void(^)(HttpException * e))failure;

/**
 *  专家设置新密码／修改密码
 *
 */
+ (void)MbrExpertUpdatePasswordWithParams:(NSDictionary *)param
                                  success:(void(^)(id DFUserModel))success
                                  failure:(void(^)(HttpException * e))failure;

/**
 *  检测专家是否已存在
 *
 */
+ (void)MbrExpertRegisterValidWithParams:(NSDictionary *)param
                                 success:(void(^)(id DFUserModel))success
                                 failure:(void(^)(HttpException * e))failure;

/**
 *  3.2.0 推荐人列表
 */
+ (void)queryMyRecommends:(NSDictionary*)param
                  success:(void(^)(MyRecommendListModel* myRecommendList))success
                  failure:(void(^)(HttpException * e))failure;

/**
 *  3.2.1 查询推荐顾客预定商品
 */
+ (void)queryRecommendBookProduct:(BookProductR*)param
                          success:(void(^)(BookProductListModel* bookProductList))success
                          failure:(void(^)(HttpException * e))failure;

/**
 *  本店信息的药师列表
 */
+ (void)MbrExpertQueryExpertByBranchIdWithParams:(NSDictionary*)param
                                         success:(void(^)(id DFUserModel))success
                                         failure:(void(^)(HttpException * e))failure;

/**
 *  3.2.0 客服电话
 */
+ (void)getServiceTelSuccess:(void(^)(ServiceTelModel* serviceTelModel))success
                     failure:(void(^)(HttpException * e))failure;

/**
 *  设置专家上下线
 */
+ (void)MbrExpertUpdateOnlineFlagWithParams:(NSDictionary*)param
                                    success:(void(^)(id DFUserModel))success
                                    failure:(void(^)(HttpException * e))failure;

@end
