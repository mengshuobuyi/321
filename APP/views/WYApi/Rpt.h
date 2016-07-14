//
//  Rpt.h
//  wenYao-store
//
//  Created by Yang Yuexia on 15/12/9.
//  Copyright © 2015年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
@class RptModelR;

@interface Rpt : NSObject

/**
 *  商家营销方案统计列表
 *
 */

+(void)rptMktgByGroupWithParams:(NSDictionary *)param
                        success:(void (^)(id))success
                        failure:(void (^)(HttpException *e))failure;

/**
 *  商家营销方案统计详情
 *
 */

+(void)rptMktgByIdWithParams:(NSDictionary *)param
                     success:(void (^)(id))success
                     failure:(void (^)(HttpException *e))failure;


/**
 *  用户行为统计
 *
 */

+(void)RptOperateSaveLogWithParams:(RptModelR *)param
                           success:(void (^)(id))success
                           failure:(void (^)(HttpException *e))failure;


@end
