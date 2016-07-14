//
//  Appraise.m
//  APP
//
//  Created by caojing on 15-3-19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "Appraise.h"

@implementation Appraise


/**
 *  药店评价列表
 */
+ (void)QueryAppraiseWithParams:(QueryAppraiseModelR *)param
                        success:(void (^)(id))success
                        failure:(void(^)(HttpException * e))failure{

    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:GetAppraise params:[param dictionaryModel] success:^(id responseObj) {
        
        AppraiseModel *model = [AppraiseModel parse:responseObj Elements:[QueryAppraiseModel class] forAttribute:@"list"];
        
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];




}


@end
