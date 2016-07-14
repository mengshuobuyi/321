//
//  Statistics.h
//  wenYao-store
//
//  Created by caojing on 15/8/19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "CoupnModel.h"
#import "CoupnModelR.h"

@interface Coupn : NSObject

//本店优惠券列表
+ (void)GetAllCoupnParams:(CoupnListModelR *)param
                     success:(void (^)(id))success
                     failure:(void(^)(HttpException * e))failure;


+ (void)GetAllCoupnProductParams:(DrugListModelR *)param
                         success:(void (^)(id))success
                         failure:(void(^)(HttpException * e))failure;
//慢病优惠券的适用商品
+ (void)GetAllSuitableParams:(CoupnSuitModelR *)param
                     success:(void (^)(id))success
                     failure:(void(^)(HttpException * e))failure;

+ (void)queryTagWithParams:(TagModelR *)param
                      success:(void (^)(id))success
                      failure:(void(^)(HttpException * e))failure;

+ (void)queryGetonLineCoupnParams:(OnlineModelR *)param
                   success:(void (^)(id))success
                   failure:(void(^)(HttpException * e))failure;

/**
 *  送券
 *
 */

+(void)couponPresentPromotionWithParams:(NSDictionary *)param
                                success:(void (^)(id))success
                                failure:(void (^)(HttpException *e))failure;


/**
 *  赠送记录
 *
 */

+(void)couponPresentRecordWithParams:(RecordModelR *)param
                                success:(void (^)(id))success
                                failure:(void (^)(HttpException *e))failure;


//获取优惠细则
+(void)getCouponCondition:(CouponConditionModelR *)modelR success:(void (^)(id))success failure:(void (^)(HttpException *))failure;

@end
