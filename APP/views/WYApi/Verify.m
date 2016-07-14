//
//  Verify.m
//  wenYao-store
//
//  Created by caojing on 15/8/19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "Verify.h"

@implementation Verify

/**
 *  验证码验证
 */
+ (void)GetVerifyWithParams:(InputVerifyModelR *)param
                     success:(void (^)(id))success
                     failure:(void(^)(HttpException * e))failure{
//    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:GetVerifyCode params:[param dictionaryModel] success:^(id responseObj) {
        
        InputVerifyModel *model = [InputVerifyModel parse:responseObj];
        
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
}


+ (void)PostVerifyWithParams:(ConVerifyModelR *)param
                     success:(void (^)(id))success
                     failure:(void(^)(HttpException * e))failure{

    [[HttpClient sharedInstance] post:PostVerifyCode params:[param dictionaryModel] success:^(id responseObj) {
        
        VerifyModel *model = [VerifyModel parse:responseObj];
        
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];

}



+ (void)PostVerifyProductWithParams:(ProductVerifyModelR *)param
                     success:(void (^)(id))success
                     failure:(void(^)(HttpException * e))failure{
    
    [[HttpClient sharedInstance] post:PostVerifyProduct params:[param dictionaryModel] success:^(id responseObj) {
        
        VerifyModel *model = [VerifyModel parse:responseObj];
        
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
