//
//  Store.h
//  APP
//
//  Created by qwfy0006 on 15/3/17.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "StoreModelR.h"
#import "StoreModel.h"
#import "EmployeeModel.h"
#import "AESUtil.h"
@interface Store : NSObject

/**
 *  快捷注册（根据序列号）
 *
 */
+ (void)QueryStoreCodeWithParams:(StoreCodeModelR *)param
                         success:(void (^)(id))success
                         failure:(void (^)(HttpException *))failure;


/**
 *  快捷注册 (获取商家)
 *
 */
+ (void)GetBranchGroupWithParams:(BranchGroupModelR *)param
                         success:(void (^)(id))success
                         failure:(void (^)(HttpException *))failure;


/**
 *  快捷注册 (最后一步)
 *
 */
+ (void)RegisterWithParams:(RegisterModelR *)param
                   success:(void (^)(id))success
                   failure:(void (^)(HttpException *))failure;




/**
 *  商家账号登录
 *
 */
+ (void)loginWithParam:(LoginModelR *)param
                success:(void (^)(id))success
                failure:(void(^)(HttpException * e))failure;



/**
 *  查询机构详细信息  含审核中状态值
 *
 */
+ (void)GetBranhBranchInfoWithGroupId:(NSString *)groupId
                              success:(void (^)(id responseObj))success
                              failure:(void (^)(HttpException *e))failure;


/**
 *  查询机构详细信息
 *
 */
+ (void)GetBranhGroupDetailWithGroupId:(NSString *)groupId
                               success:(void (^)(id responseObj))success
                               failure:(void (^)(HttpException *e))failure;

/**
 *  商家修改密码
 *
 */
+ (void)UpdatePasswordWithParams:(NSDictionary *)param
                         success:(void (^)(id))success
                         failure:(void (^)(HttpException *e))failure;

/**
 *  商家用户登出
 *
 */
+ (void)LogoutWithParams:(LogoutModelR *)param
                 success:(void (^)(id))success
                 failure:(void (^)(HttpException *e))failure;



/**
 *  3.5.39	查询机构所有待审信息
 *
 *  @return
 */

+ (void)QueryBranchApproveWithGroupId:(NSString *)groupId
                              success:(void(^)(id responseObj))success
                              failure:(void(^)(HttpException *e))failure;


/**
 *  @brief 3.5.20	查询机构执照
 *
 *  @return
 */

+ (void)QueryCertifiWithGroupId:(NSString *)groupId
                        success:(void(^)(id responseObj))success
                        failure:(void(^)(HttpException *e))failure;

/**
 *  @brief 3.5.21	查询待审核机构执照
 *
 */
+ (void)QueryCertifiApproveWithGroupId:(NSString *)groupId
                               success:(void(^)(id responseObj))success
                               failure:(void(^)(HttpException *e))failure;


/**
 *  检测手机号是否已经被注册
 *
 */
+ (void)MobileValidWithParams:(MobileValidModelR *)param
                      success:(void (^)(id))success
                      failure:(void (^)(HttpException *))failure;

/**
 *  获取商家账号昵称
 *
 */
+ (void)FetchLoginNameByPhoneWithParams:(NSDictionary *)param
                                success:(void (^)(id))success
                                failure:(void (^)(HttpException *))failure;
/**
 *  商家重置密码
 *
 */
+ (void)ResetPasswordWithParams:(NSDictionary *)param
                        success:(void (^)(id))success
                        failure:(void (^)(HttpException *))failure;

/**
 *  药店段信息完善性检测
 *
 */
+ (void)StoreInfoCheckWithParams:(NSDictionary *)param
                         success:(void (^)(id))success
                         failure:(void (^)(HttpException *))failure;


/**
 *  药店标签
 *
 */
+ (void)SearchTagQueryWithParams:(NSDictionary *)param
                         success:(void (^)(id responseObj))success
                         failure:(void (^)(HttpException *e))failure;


/**
 *  商家注册保存机构信息
 *
 */
+ (void)SaveBranchWithParams:(SaveBranchModelR *)param
                     success:(void (^)(id))success
                     failure:(void (^)(HttpException *))failure;

/**
 *  商家注册信息修改
 *
 */
+ (void)UpdateRegisterWithParams:(NSDictionary *)param
                         success:(void (^)(id))success
                         failure:(void (^)(HttpException *))failure;

/**
 *  查询机构执照
 *
 */
+ (void)QueryCertifiWithParams:(NSDictionary *)param
                       success:(void (^)(id))success
                       failure:(void (^)(HttpException *))failure;

/**
 *  修改机构类型
 *
 */
+ (void)UpdateBranchGroupTypeWithParams:(NSDictionary *)param
                                success:(void (^)(id))success
                                failure:(void (^)(HttpException *))failure;

/**
 *  更新商家爱状态带待审核
 *
 */
+ (void)UpdateBranchStatusWithParams:(NSDictionary *)param
                             success:(void (^)(id))success
                             failure:(void (^)(HttpException *))failure;

/**
 *  保存药师信息
 *
 */
+ (void)SavePharmacistWithParams:(NSDictionary *)param
                         success:(void (^)(id))success
                         failure:(void (^)(HttpException *))failure;

/**
 *  保存机构执照
 *
 */
+ (void)SavecerfitiWithParams:(NSDictionary *)param
                      success:(void (^)(id))success
                      failure:(void (^)(HttpException *))failure;
/**
 *  更新商家机构信息
 */
+ (void)UpdateBranchWithParams:(NSDictionary *)param
                       success:(void(^)(id responseObj))success
                       failure:(void(^)(HttpException *e))failure;

/**
 *  3.5.23	修改机构执照(OK)
 */
+ (void)updateCertifiWithParams:(id)param
                        success:(void(^)(id responseObj))success
                        failure:(void(^)(HttpException *e))failure;

/**
 *  3.5.28	修改药师信息(OK)
 */
+ (void)updatePharmacistWithParams:(NSDictionary *)param
                           success:(void(^)(id responseObj))success
                           failure:(void(^)(HttpException *e))failure;


/**
 *  @brief 查询药店药师信息
 *
 *   queryPharmacist
 */

+ (void)queryPharmacistWithGroupId:(NSString *)groupId
                           success:(void(^)(id responseObj))success
                           failure:(void(^)(HttpException *e))failure;


/**
 *  @brief 查询所有的药师信息 2.1.8新增接口
 *
 */
+ (void)queryPharmacistNewWithGroupId:(NSString *)groupId
                              success:(void(^)(id responseObj))success
                              failure:(void(^)(HttpException *e))failure;

/**
 *  @brief 查询药店药师审核信息
 *
 *   queryPharmacistApprove
 */

+ (void)queryPharmacistApproveWithGroupId:(NSString *)groupId
                                  success:(void(^)(id responseObj))success
                                  failure:(void(^)(HttpException *e))failure;

/**
 *  3.2.0 获取问药活动列表
 */
+ (void)getWenyaoActivityList:(WenyaoActivityListR*)param
                      success:(void(^)(ActNoticeListModel* actNoticeList))success
                         fail:(void(^)(HttpException *e))failure;

/**
 *  3.2.0 获取问药活动列表无菊花
 */
+ (void)getWenyaoActivityListWithoutProgress:(WenyaoActivityListR*)param
                                     success:(void(^)(ActNoticeListModel* actNoticeList))success
                                        fail:(void(^)(HttpException *e))failure;


//公告
+ (void)noticeWithParams:(NSDictionary *)param
                 success:(void(^)(NoticeModel* actNoticeList))success
                    fail:(void(^)(HttpException *e))failure;

//获取首页的banner和工业品
+ (void)configInfoQueryBanner:(ConfigInfoQueryModelR *)model
                      success:(void(^)(BannerInfoListModel* responseObj))success
                      failure:(void(^)(HttpException *e))failure;

/**
 *  3.2.0 培训详情
 */
+ (void)getTrainDetail:(GetTrainDetailR*)param
               success:(void(^)(TrainModel* trainModel))success
                  fail:(void(^)(HttpException *e))failure;


/**
 *  3.2.0 获取培训（生意经）列表
 */
+ (void)getTrainList:(GetTrainListR*)param
             success:(void(^)(TrainListModel* trainList))success
                fail:(void(^)(HttpException *e))failure;


/**
 *  3.2.0 获取培训（生意经）列表  无菊花
 */
+ (void)getTrainListWithoutProgress:(GetTrainListR*)param
                            success:(void(^)(TrainListModel* trainList))success
                               fail:(void(^)(HttpException *e))failure;


/**
 *  3.2.0 商品销售统计
 */
+ (void)getProductSales:(GetProductSalesR*)param
                success:(void(^)(ProductSalesListModel* productList))success
                   fail:(void(^)(HttpException *e))failure;

/**
 *  3.2.0 商品销售统计 店员信息
 */
+ (void)queryEmployees:(NSDictionary*)param
               success:(void(^)(EmployeeInfoModel* employeeInfoModel))success
                  fail:(void(^)(HttpException *e))failure;

/**
 *  3.2.0 店员签到
 */
+ (void)employeeSign:(NSDictionary*)param
             success:(void(^)(StoreUserSignModel* apiModel))success
                fail:(void(^)(HttpException *e))failure;


@end