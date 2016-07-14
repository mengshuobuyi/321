//
//  Activity.h
//  wenYao-store
//
//  Created by caojing on 15/4/1.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "ActivityModel.h"
#import "ActivityModelR.h"
@interface Activity : NSObject

//营销活动的列表
+ (void)QueryActivityListWithParams:(id)param
                            success:(void (^)(id))success
                            failure:(void(^)(HttpException * e))failure;


+(void)QueryActivityCoupnListWithParams:(id)param
                                success:(void (^)(id))success
                                failure:(void (^)(HttpException *))failure;

//获取营销活动的详情
+ (void)GetActivityWithParams:(id)param
                      success:(void (^)(id))success
                      failure:(void(^)(HttpException * e))failure;


//营销活动的删除
+ (void)DeleteActivitWithParams:(id)param
                        success:(void (^)(id))success
                        failure:(void(^)(HttpException * e))failure;

//保存或者更新营销活动
+ (void)SaveOrUpdateActivityWithParams:(id)param
                               success:(void (^)(id))success
                               failure:(void(^)(HttpException * e))failure;

/**
 *  获取指定药店的优惠活动
 */
+ (void)getStoreBranchPromotion:(id)param
                        success:(void (^)(id))succsee
                        failure:(void (^)(HttpException *))failure;


/**
 *  获取指定药店的新的优惠活动
 */
+ (void)getNewStoreBranchPromotion:(id)param
                           success:(void (^)(id))succsee
                           failure:(void (^)(HttpException *))failure;

/**
 *  优惠活动的详情页
 */
+ (void)getPromotionDetail:(id)param
                   success:(void (^)(id))succsee
                   failure:(void (^)(HttpException *))failure;

/**
 *  优惠商品的列表
 */
+ (void)getPromotionProductListProduct:(id)param
                               success:(void (^)(id))succsee
                               failure:(void (^)(HttpException *))failure;


@end
