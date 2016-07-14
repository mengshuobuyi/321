//
//  RefCode.m
//  wenYao-store
//
//  Created by PerryChen on 3/23/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "RefCode.h"

@implementation RefCode

/**
 *  获取REF分享URL
 */
+(void)queryRefCode:(RefCodeModelR *)params success:(void(^)(RefCodeModel *responseModel))success failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance] get:GetRefCode params:[params dictionaryModel] success:^(id responseObj) {
        RefCodeModel *model = [RefCodeModel parse:responseObj];
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
