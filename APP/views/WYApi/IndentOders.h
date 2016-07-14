//
//  IndentOders.h
//  wenYao-store
//
//  Created by qw_imac on 16/1/15.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QueryShopOrdersR.h"
#import "OrderListModel.h"
#import "HttpClient.h"
/*****************
 * 3.0订单相关
 *****************/
@interface IndentOders : NSObject
//请求订单列表
+(void)queryOrders:(QueryShopOrdersR *)params
           success:(void(^)(OrderListModel *responseModel))success
           failure:(void(^)(HttpException *e))failure;


//订单操作
+(void)operateShopOrder:(OperateShopOrder *)params
                success:(void(^)(OperateShopOrderModel *model))success
                failure:(void(^)(HttpException *e))failure;


//查询快递公司
+(void)queryLC:(QueryLCR *)params
       success:(void(^)(LCModel *model))success
       failure:(void(^)(HttpException *e))failure;


//填写物流
+(void)fillLogistics:(FillLogisticsR *)params
             success:(void(^)(FillLogisticsModel *model))success
             failure:(void(^)(HttpException *e))failure;


//订单详情
+(void)queryShopOrderDetail:(QueryShopOrdersDetailR *)params
                    success:(void(^)(ShopOrderDetailVO *model))success
                    failure:(void(^)(HttpException *e))failure;


//查询拒单理由
+(void)queryRefuseReasons:(QueryCancelReasons *)params
                  success:(void(^)(CancelReasonModel *model))success
                  failure:(void(^)(HttpException *e))failure;


//查询业绩订单
+(void)queryPerformanceOrders:(QueryPerformanceOrderListR *)params
                      success:(void(^)(PerformanceOrdersVO *model))success
                      failure:(void(^)(HttpException *e))failure;

@end
