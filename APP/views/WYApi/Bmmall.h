//
//  Bmmall.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/7/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"

#define BmmallDeliveryMode               @"h5/bmmall/deliveryMode"                          //获取门店配送方式
#define BmmallDeliveryOnsite             @"h5/bmmall/deliveryOnsite"                        //编辑配送方式 到店取货
#define BmmallDeliveryHome               @"h5/bmmall/deliveryHome"                          //编辑配送方式 送货上门
#define BmmallDeliveryExpress            @"h5/bmmall/deliveryExpress"                       //编辑配送方式 同城快递
#define BmmallPayMode                    @"h5/bmmall/payMode"                               //获取门店支付方式

@interface Bmmall : NSObject


/**
 *    获取门店配送方式
 *
 */
+ (void)BmmallDeliveryModeWithParams:(NSDictionary *)param
                             success:(void(^)(id obj))success
                             failure:(void(^)(HttpException * e))failure;

/**
 *    编辑配送方式 到店取货
 *
 */
+ (void)BmmallDeliveryOnsiteWithParams:(NSDictionary *)param
                               success:(void(^)(id obj))success
                               failure:(void(^)(HttpException * e))failure;

/**
 *    编辑配送方式 送货上门
 *
 */
+ (void)BmmallDeliveryHomeWithParams:(NSMutableDictionary *)param
                        deliveryData:(NSArray *)deliveryArray
                             success:(void(^)(id obj))success
                             failure:(void(^)(HttpException * e))failure;

/**
 *    编辑配送方式 同城快递
 *
 */
+ (void)BmmallDeliveryExpressWithParams:(NSDictionary *)param
                                success:(void(^)(id obj))success
                                failure:(void(^)(HttpException * e))failure;

/**
 *    获取门店支付方式
 *
 */
+ (void)BmmallPayModeWithParams:(NSDictionary *)param
                        success:(void(^)(id obj))success
                        failure:(void(^)(HttpException * e))failure;


/**
 *    门店取消配送方式
 *
 */
+ (void)BmmallDeliveryCancelWithParams:(NSDictionary *)param
                               success:(void(^)(id obj))success
                               failure:(void(^)(HttpException * e))failure;




@end
