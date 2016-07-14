
//
//  Order.h
//  APP
//
//  Created by chenpeng on 15/3/19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseModel.h"
#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "OrderMedelR.h"
#import "OrderModel.h"

@interface Order : BaseModel

+ (void)queryRecommendProductByClassWithParam:(HealthyScenarioDrugModelR *)params
                                      success:(void(^)(id))success
                                      failure:(void(^)(HttpException *e))failure;


+ (void)QuerySpmInfoListWithParams:(SpmListModelR *)param
                           success:(void (^)(id))success
                           failure:(void (^)(HttpException *))failure;


+ (void)QuerySpmInfoListByBodyWithParams:(SpmListByBodyModelR *)param
                                 success:(void (^)(id))success
                                 failure:(void (^)(HttpException *))failure;


+(void)queryspminfoDetailProductListWithParam:(spminfoDetailR  *)model
                                      Success:(void (^)(id))success
                                      failure:(void (^)(HttpException *))failure;


+ (void)queryProductByClassWithParam:(QueryProductByClassModelR *)model
                             Success:(void (^)(id))success
                             failure:(void (^)(HttpException *))failure;


+ (void)fetchProFactoryByClassWithParam:(id)model
                                Success:(void (^)(id))success
                                failure:(void (^)(HttpException *))failure;


+(void)queryDiseaseFormulaProductListWithParam:(id)model
                                       Success:(void (^)(id))success
                                       failure:(void (^)(HttpException *))failure;


+(void)queryDiseaseProductListWithParam:(id)model
                                Success:(void (^)(id))success
                                failure:(void (^)(HttpException *))failure;


+(void)queryFactoryProductListWithParam:(id)model
                                Success:(void (^)(id))success
                                failure:(void (^)(HttpException *))failure;


+(void)querypharmacyProductListWithParam:(id)model
                                 Success:(void (^)(id))success
                                 failure:(void (^)(HttpException *))failure;

+(void)promotionCompleteWithParam:(id)model
                          Success:(void (^)(id))success
                          failure:(void (^)(HttpException *))failure;


+(void)fixRecieptWithParam:(id)model
                   Success:(void (^)(id))success
                   failure:(void (^)(HttpException *))failure;


/**
 *  客户历史订单查询
 *
 */

+(void)orderQueryCustomerOrdersByBranchWithParams:(NSDictionary *)param
                                          success:(void (^)(id))success
                                          failure:(void (^)(HttpException *e))failure;

/**
 *  客户历史订单详情
 *
 */

+(void)orderGetOrderDetailWithParams:(NSDictionary *)param
                             success:(void (^)(id))success
                             failure:(void (^)(HttpException *e))failure;


/**
 *  兑换商品列表
 *
 */

+(void)mallOrderByBranchWithParams:(NSDictionary *)param
                           success:(void (^)(id))success
                           failure:(void (^)(HttpException *e))failure;

/**
 *  输入验证码积分完成订单
 *
 */

+(void)mallOrderCompleteWithParams:(NSDictionary *)param
                           success:(void (^)(id))success
                           failure:(void (^)(HttpException *e))failure;

//p2p 全量拉取订单通知消息列表
+ (void)getAllOrderNotiList:(OrderNotiListModelR *)param
                    success:(void (^)(OrderMessageArrayVo *responModel))succsee
                    failure:(void (^)(HttpException *e))failure;

/**
 *  增量轮询订单通知列表
 *
 */
+ (void)getNewOrderNotiList:(OrderNewNotiListModelR *)param
                    success:(void (^)(OrderMessageArrayVo *responModel))succsee
                    failure:(void (^)(HttpException *e))failure;

+ (void)setOrderNotiReadWithMessageId:(NSString *)strMsgId;

+ (void)setOrderNotiReadWithMessageId:(NSString *)messageID
                              success:(void (^)(BaseAPIModel *))success
                              failure:(void (^)(HttpException *))failure;


+ (void)removeByCustomer:(RemoveByCustomerOrderR *)param
                 success:(void (^)(id responModel))success
                 failure:(void (^)(HttpException *e))failure;

+(void)queryThreeWithParam:(id)model
                   Success:(void (^)(id))success
                   failure:(void (^)(HttpException *))failure;


/**
 *  获取所有未处理订单的数量
 *
 *  @param param
 *  @param succsee
 *  @param failure 
 */
+ (void)getAllNewOrderCount:(OrderNewCountModelR *)param
                    success:(void (^)(OrderNewCountModel *responModel))succsee
                    failure:(void (^)(HttpException *e))failure;
/**
 *  员工分享转化订单统计
 *
 */
+(void)BmmallQueryShareOrderWithParams:(NSDictionary *)param
                               success:(void (^)(id))success
                               failure:(void (^)(HttpException *e))failure;

@end
