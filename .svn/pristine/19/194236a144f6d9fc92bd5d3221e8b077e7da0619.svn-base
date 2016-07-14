//
//  Bmmall.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/7/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "Bmmall.h"
#import "BranchModel.h"
#import "SBJson.h"

@implementation Bmmall

/**
 *    获取门店配送方式
 *
 */
+ (void)BmmallDeliveryModeWithParams:(NSDictionary *)param
                             success:(void(^)(id obj))success
                             failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:BmmallDeliveryMode params:param success:^(id responseObj) {
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
 *    编辑配送方式 到店取货
 *
 */
+ (void)BmmallDeliveryOnsiteWithParams:(NSDictionary *)param
                               success:(void(^)(id obj))success
                               failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr post:BmmallDeliveryOnsite params:param success:^(id responseObj) {
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
 *    编辑配送方式 送货上门
 *
 */
+ (void)BmmallDeliveryHomeWithParams:(NSMutableDictionary *)param
                        deliveryData:(NSArray *)deliveryArray
                             success:(void(^)(id obj))success
                             failure:(void(^)(HttpException * e))failure;
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:deliveryArray];
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    postDict[@"postJson"] = [NSMutableArray array];
    NSMutableArray* mycontentArray = postDict[@"postJson"];
    for (DeliveryModel* model in array) {
        [mycontentArray addObject:[model dictionaryModel]];
    }
    param[@"deliveryMode"] = [postDict JSONRepresentation];
    
    [HttpClientMgr post:BmmallDeliveryHome params:param success:^(id responseObj) {
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
 *    编辑配送方式 同城快递
 *
 */
+ (void)BmmallDeliveryExpressWithParams:(NSDictionary *)param
                                success:(void(^)(id obj))success
                                failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr post:BmmallDeliveryExpress params:param success:^(id responseObj) {
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
 *    获取门店支付方式
 *
 */
+ (void)BmmallPayModeWithParams:(NSDictionary *)param
                        success:(void(^)(id obj))success
                        failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:BmmallPayMode params:param success:^(id responseObj) {
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
 *    门店取消配送方式
 *
 */
+ (void)BmmallDeliveryCancelWithParams:(NSDictionary *)param
                               success:(void(^)(id obj))success
                               failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr post:BmmallDeliveryCancel params:param success:^(id responseObj) {
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
