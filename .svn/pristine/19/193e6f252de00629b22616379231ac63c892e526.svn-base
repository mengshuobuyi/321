//
//  Pharmacy.h
//  wenYao-store
//
//  Created by qwfy0006 on 15/4/1.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "PharmacyModel.h"

@interface Pharmacy : NSObject

/**
 *  条件查询药店
 *
 */
+ (void)QueryStoreWithParams:(NSDictionary *)param
                     success:(void (^)(id))success
                     failure:(void (^)(HttpException *e))failure;

/**
 *  获取省市区列表
 *
 */
+ (void)QueryAreaWithParams:(NSDictionary *)param
                    success:(void (^)(id))success
                    failure:(void (^)(HttpException *e))failure;

@end
