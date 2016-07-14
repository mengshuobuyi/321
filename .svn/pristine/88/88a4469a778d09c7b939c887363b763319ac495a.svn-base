//
//  Statistics.m
//  wenYao-store
//
//  Created by caojing on 15/8/19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "Coupn.h"

@implementation Coupn


/**
 *  优惠券列表
 */
+ (void)GetAllCoupnParams:(CoupnListModelR *)param
                     success:(void (^)(id))success
                     failure:(void(^)(HttpException * e))failure{
    //    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:GetAllCoupn params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *  优惠券适用商品
 */
+ (void)GetAllSuitableParams:(CoupnSuitModelR *)param
                  success:(void (^)(id))success
                  failure:(void(^)(HttpException * e))failure{
    [[HttpClient sharedInstance] get:GetAllSuitable params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
}




/**
 *  优惠商品列表
 */
+ (void)GetAllCoupnProductParams:(DrugListModelR *)param
                  success:(void (^)(id))success
                  failure:(void(^)(HttpException * e))failure{
    //    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:GetAllCoupnProduct params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
}

//标签搜索
+ (void)queryTagWithParams:(TagModelR *)param
                         success:(void (^)(id))success
                         failure:(void(^)(HttpException * e))failure{
    //    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:GetTag params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)queryGetonLineCoupnParams:(OnlineModelR *)param
                   success:(void (^)(id))success
                   failure:(void(^)(HttpException * e))failure{
    [[HttpClient sharedInstance] get:GetonLineCoupn params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
}

+(void)couponPresentPromotionWithParams:(NSDictionary *)param
                                success:(void (^)(id))success
                                failure:(void (^)(HttpException *e))failure
{
    [HttpClientMgr post:CouponPresentPromotion params:param success:^(id responseObj) {
        
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}


/**
 *  赠送记录
 *
 */

+(void)couponPresentRecordWithParams:(RecordModelR *)param
                             success:(void (^)(id))success
                             failure:(void (^)(HttpException *e))failure{
    [HttpClientMgr get:GetRecord params:[param dictionaryModel] success:^(id responseObj) {
        
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}


//获取优惠细则
+(void)getCouponCondition:(CouponConditionModelR *)modelR success:(void (^)(id))success failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] get:GetCouponCondition params:[modelR dictionaryModel] success:^(id responseObj) {
        
        CouponConditionVoListModel *coupon = [CouponConditionVoListModel parse:responseObj Elements:[NSString class] forAttribute:@"conditions"];
        if (success) {
            success(coupon);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

@end
