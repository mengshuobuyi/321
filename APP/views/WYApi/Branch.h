//
//  Branch.h
//  wenYao-store
//
//  Created by YYX on 15/7/7.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "BranchModel.h"
#import "BranchModelR.h"

@interface Branch : NSObject

/**
 *  获取修改支付宝账号时的手机号
 *
 */
+ (void)getChangeAliPayAccountWithParams:(NSDictionary *)param
                                 success:(void(^)(id obj))success
                                 failure:(void(^)(HttpException * e))failure;

/**
 *  获取软件使用人的基本信息
 *
 */
+ (void)getSoftwareuserPhoneNumberWithParams:(NSDictionary *)param
                                     success:(void(^)(id obj))success
                                     failure:(void(^)(HttpException * e))failure;

/**
 *  更新软件使用人的基本信息
 *
 */
+ (void)UpdateSoftwareuserInfoWithParams:(NSDictionary *)param
                                 success:(void(^)(id obj))success
                                 failure:(void(^)(HttpException * e))failure;


/**
 *  普通注册
 *
 */
+ (void)PassportBranchRegisterWithParams:(NSDictionary *)param
                                 success:(void(^)(id obj))success
                                 failure:(void(^)(HttpException * e))failure;

/**
 *  重置密码
 *
 */
+ (void)PassportBranchPasswordRenewWithParams:(NSDictionary *)param
                                      success:(void(^)(id obj))success
                                      failure:(void(^)(HttpException * e))failure;

/**
 *  通过手机号获得账号
 *
 */
+ (void)PassportBranchGetAccountByMobileWithParams:(NSDictionary *)param
                                           success:(void(^)(id obj))success
                                           failure:(void(^)(HttpException * e))failure;

/**
 *  获取省市区列表
 *
 */
+ (void)BranchInfoQueryAreaWithParams:(NSDictionary *)param
                              success:(void(^)(id obj))success
                              failure:(void(^)(HttpException * e))failure;

/**
 *  连锁机构 认证
 *
 */
+ (void)PassportBranchLinkageReserveWithParams:(NSDictionary *)param
                              success:(void(^)(id obj))success
                              failure:(void(^)(HttpException * e))failure;

/**
 *  认证 提交基本审核信息
 *
 */
+ (void)BranchApproveInfoSubmitWithParams:(NSDictionary *)param
                                  success:(void(^)(id obj))success
                                  failure:(void(^)(HttpException * e))failure;

/**
 *  认证 批量上传证照
 *
 */
+ (void)BranchApproveLicenseSubmitWithParams:(NSDictionary *)param
                                     success:(void(^)(id obj))success
                                     failure:(void(^)(HttpException * e))failure;

/**
 *  获取提交的最新审核信息
 *
 */
+ (void)BranchApproveWithParams:(NSDictionary *)param
                        success:(void(^)(id obj))success
                        failure:(void(^)(HttpException * e))failure;

/**
 *  获取本店二维码
 *
 */
+ (void)GetSymbolWithParams:(BranchGetSymbolModelR *)param
                    success:(void(^)(BranchSymbolVo *obj))success
                    failure:(void(^)(HttpException * e))failure;


/**
 *  新的评价
 *
 */
+ (void)BranchAppraiseMmallWithParams:(NSDictionary *)param
                              success:(void(^)(id obj))success
                              failure:(void(^)(HttpException * e))failure;

/**
 *  老的评价
 *
 */
+ (void)BranchAppraiseNormalWithParams:(NSDictionary *)param
                               success:(void(^)(id obj))success
                               failure:(void(^)(HttpException * e))failure;

/**
 *  获取配送方式
 *
 */
+ (void)BranchGetBranchPostTipsWithParams:(NSDictionary *)param
                                  success:(void(^)(id obj))success
                                  failure:(void(^)(HttpException * e))failure;

/**
 *  获取接单电话
 *
 */
+ (void)BranchQueryOrderLinksWithParams:(NSDictionary *)param
                                success:(void(^)(id obj))success
                               failure:(void(^)(HttpException * e))failure;

/**
 *  更新接单电话
 *
 */
+ (void)BranchUpdateOrderLinksWithParams:(NSDictionary *)param
                               success:(void(^)(id obj))success
                               failure:(void(^)(HttpException * e))failure;


/**
 *  积分排行列表
 *
 */
+ (void)BranchScoreRankWithParams:(NSDictionary *)param
                          success:(void(^)(id obj))success
                          failure:(void(^)(HttpException * e))failure;
/**
 *  积分排行详情
 *
 */
+ (void)BranchScoreEmpRankWithParams:(NSDictionary *)param
                             success:(void(^)(id obj))success
                             failure:(void(^)(HttpException * e))failure;

@end
