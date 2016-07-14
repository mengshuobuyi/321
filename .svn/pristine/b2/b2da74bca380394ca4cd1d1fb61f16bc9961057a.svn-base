//
//  Customer.h
//  APP
//
//  Created by chenzhipeng on 3/25/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "CustomerModelR.h"
#import "MyCustomerBaseModel.h"
@interface Customer : NSObject

+ (void)QueryCustomerWithParams:(CustomerQueryIndexModelR *)param
                        success:(void (^)(id obj))success
                        failure:(void(^)(HttpException * e))failure;


+ (void)DeleteCustomerWithParams:(CustomerDeleteModelR *)param
                         success:(void (^)(id obj))success
                         failure:(void(^)(HttpException * e))failure;


+ (void)QueryCustomerInfoWithParams:(CustomerDetailInfoModelR *)param
                            success:(void (^)(id obj))success
                             failue:(void(^)(HttpException * e))failure;


+ (void)QueryCustomerDrugWithParams:(CustomerDrugModelR *)param
                            success:(void (^)(id obj))success
                             failue:(void(^)(HttpException * e))failure;


+ (void)QueryCustomerAppriseWithParams:(CustomerAppriseModelR *)param
                               success:(void (^)(id obj))success
                                failue:(void(^)(HttpException * e))failure;


+ (void)QueryCustomerTagsWithParams:(CustomerTagsModelR *)param
                            success:(void (^)(id obj))success
                             failue:(void(^)(HttpException * e))failure;


+ (void)UpdateCustomerTagsWithParams:(CustomerUpdateTagsModelR *)param
                             success:(void (^)(id obj))success
                              failue:(void(^)(HttpException * e))failure;


+ (void)RemoveCustomerTagsWithParams:(CustomerRemoveTagsModelR *)param
                             success:(void (^)(id obj))success
                              failue:(void(^)(HttpException * e))failure;


+ (void)AddCustomerTagWithParams:(CustomerAddTagModelR *)param
                         success:(void (^)(id obj))success
                          failue:(void(^)(HttpException * e))failure;
/**
 *  客户详情 各种count
 *
 */
+ (void)CustomerCountListWithParams:(NSDictionary *)param
                            success:(void (^)(id obj))success
                             failue:(void(^)(HttpException * e))failure;

/**
 *  新建客户分组
 */

+ (void)CustomerGroupCreateWithParams:(NSDictionary *)param
                              success:(void (^)(id obj))success
                               failue:(void(^)(HttpException * e))failure;
/**
 *  获取客户分组列表
 */

+ (void)CustomerGroupListWithParams:(NSDictionary *)param
                            success:(void (^)(id obj))success
                             failue:(void(^)(HttpException * e))failure;

/**
 *  更新客户分组名称
 */

+ (void)CustomerGroupUpdateWithParams:(NSDictionary *)param
                            success:(void (^)(id obj))success
                             failue:(void(^)(HttpException * e))failure;

/**
 *  删除客户分组
 */

+ (void)CustomerGroupRemoveWithParams:(NSDictionary *)param
                              success:(void (^)(id obj))success
                               failue:(void(^)(HttpException * e))failure;

/**
 *  批量添加客户
 */

+ (void)CustomerGroupCustAddWithParams:(NSDictionary *)param
                               success:(void (^)(id obj))success
                                failue:(void(^)(HttpException * e))failure;

/**
 *  批量删除客户
 */

+ (void)CustomerGroupCustRemoveWithParams:(NSDictionary *)param
                                  success:(void (^)(id obj))success
                                   failue:(void(^)(HttpException * e))failure;

/**
 *  获取分组内客户列表
 */

+ (void)CustomerGroupCustListWithParams:(NSDictionary *)param
                                success:(void (^)(id obj))success
                                 failue:(void(^)(HttpException * e))failure;

/**
 *  3.2 获取会员微商订单列表
 */
+(void)queryCustomerOrderListWithParams:(CustomerOrderListModelR *)params
                                success:(void(^)(CustomerOrdersVoModel *responseModel))success
                                failure:(void(^)(HttpException *e))failure;



@end
