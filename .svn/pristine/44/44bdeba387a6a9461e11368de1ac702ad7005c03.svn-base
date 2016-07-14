//
//  Statistics.h
//  wenYao-store
//
//  Created by caojing on 15/8/19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "SellStatisticsModel.h"
#import "SellStatisticsModelR.h"

@interface SellStatistics : NSObject

//优惠券消费列表
+ (void)GetCoupnSellWithParams:(QueryStatisticsModelR *)param
                     success:(void (^)(id))success
                     failure:(void(^)(HttpException * e))failure;


//优惠商品消费列表
+ (void)GetProductSellWithParams:(QueryStatisticsProductModelR *)param
                       success:(void (^)(id))success
                       failure:(void(^)(HttpException * e))failure;

//优惠商品消费二级列表
+ (void)GetPSSellWithParams:(QueryStatisticsPSModelR *)param
                         success:(void (^)(id))success
                         failure:(void(^)(HttpException * e))failure;

//优惠商品搜索
+ (void)GetSearchPSWithParams:(QuerySearchPSModelR *)param
                      success:(void (^)(id))success
                      failure:(void(^)(HttpException * e))failure;

@end
