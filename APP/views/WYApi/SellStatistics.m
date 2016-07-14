//
//  Statistics.m
//  wenYao-store
//
//  Created by caojing on 15/8/19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "SellStatistics.h"

@implementation SellStatistics


/**
 *  优惠券消费列表
 */
+ (void)GetCoupnSellWithParams:(QueryStatisticsModelR *)param
                     success:(void (^)(id))success
                     failure:(void(^)(HttpException * e))failure{
    //    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:GetQueryCoupnSell params:[param dictionaryModel] success:^(id responseObj) {
        
        NSMutableArray *keyArray = [NSMutableArray array];
        [keyArray addObject:NSStringFromClass([StatisticsCoupnModel class])];
        [keyArray addObject:NSStringFromClass([StatisticsCoupnModel class])];
        
        NSMutableArray *valueArray = [NSMutableArray array];
        [valueArray addObject:@"coupons"];
        [valueArray addObject:@"overdueCoupons"];
        
        StatisticsCoupnListModel *scenarionList = [StatisticsCoupnListModel parse:responseObj ClassArr:keyArray Elements:valueArray];
        
        if (success) {
            success(scenarionList);
        }
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
  
    
}


/**
 *  优惠商品消费列表
 */
+ (void)GetProductSellWithParams:(QueryStatisticsProductModelR *)param
                       success:(void (^)(id))success
                       failure:(void(^)(HttpException * e))failure{
    //    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:GetQueryProductSell params:[param dictionaryModel] success:^(id responseObj) {
        
        NSMutableArray *keyArray = [NSMutableArray array];
        [keyArray addObject:NSStringFromClass([RptProductVo class])];
        
        NSMutableArray *valueArray = [NSMutableArray array];
        [valueArray addObject:@"products"];
        
        RptProductArrayVo *scenarionList = [RptProductArrayVo parse:responseObj ClassArr:keyArray Elements:valueArray];
        
        if (success) {
            success(scenarionList);
        }
        
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
    
    
}


+ (void)GetPSSellWithParams:(QueryStatisticsPSModelR *)param
                    success:(void (^)(id))success
                    failure:(void(^)(HttpException * e))failure{

    [[HttpClient sharedInstance] get:GetQueryProductSecond params:[param dictionaryModel] success:^(id responseObj) {
        
        NSMutableArray *keyArray = [NSMutableArray array];
        [keyArray addObject:NSStringFromClass([RptPromotionVo class])];
        [keyArray addObject:NSStringFromClass([RptPromotionVo class])];
        
        NSMutableArray *valueArray = [NSMutableArray array];
        [valueArray addObject:@"rpts"];
        [valueArray addObject:@"overdueRpts"];
        
        RptPromotionArrayVo *scenarionList = [RptPromotionArrayVo parse:responseObj ClassArr:keyArray Elements:valueArray];
        
        if (success) {
            success(scenarionList);
        }
        
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];

}



+ (void)GetSearchPSWithParams:(QuerySearchPSModelR *)param
                    success:(void (^)(id))success
                    failure:(void(^)(HttpException * e))failure{
    
    [[HttpClient sharedInstance] get:GetQueryProductByName params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
        
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
    
}


@end
