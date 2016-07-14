//
//  Appraise.h
//  APP
//
//  Created by caojing on 15-3-19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "AppraiseModel.h"
#import "AppraiseModelR.h"

@interface Appraise : NSObject

/**
 *  药店评价列表
 */
+ (void)QueryAppraiseWithParams:(QueryAppraiseModelR *)param
                success:(void (^)(id))success
                failure:(void(^)(HttpException * e))failure;

@end
