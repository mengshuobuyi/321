//
//  Rpt.m
//  wenYao-store
//
//  Created by Yang Yuexia on 15/12/9.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "Rpt.h"
#import "RptModelR.h"

@implementation Rpt

/**
 *  商家营销方案统计列表
 *
 */

+(void)rptMktgByGroupWithParams:(NSDictionary *)param
                        success:(void (^)(id))success
                        failure:(void (^)(HttpException *e))failure
{
    [HttpClientMgr get:RptMktgByGroup params:param success:^(id responseObj) {
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
 *  商家营销方案统计详情
 *
 */

+(void)rptMktgByIdWithParams:(NSDictionary *)param
                     success:(void (^)(id))success
                     failure:(void (^)(HttpException *e))failure
{
    [HttpClientMgr get:RptMktgById params:param success:^(id responseObj) {
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
 *  用户行为统计
 *
 */

+(void)RptOperateSaveLogWithParams:(RptModelR *)param
                           success:(void (^)(id))success
                           failure:(void (^)(HttpException *e))failure
{
    [HttpClientMgr post:RptOperateSaveLog params:[param dictionaryModel]success:^(id responseObj) {
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
