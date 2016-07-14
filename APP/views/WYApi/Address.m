//
//  Address.m
//  wenYao-store
//
//  Created by qw_imac on 16/5/16.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "Address.h"

@implementation Address
+(void)getAddressList:(RecieveAddressModelR *)params success:(void(^)(EmpAddressListVo *responseModel))success failure:(void(^)(HttpException *e))failure {
    [[HttpClient sharedInstance] get:GetRecieveAddressList params:[params dictionaryModel] success:^(id responseObj) {
        EmpAddressListVo *modelList = [EmpAddressListVo parse:responseObj Elements:[EmpAddressVo class] forAttribute:@"address"];
        if (success) {
            success(modelList);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+(void)editAddress:(RecieveAddressEditR *)params success:(void (^)(EmpAddressVo *responseModel))success failure:(void (^)(HttpException *))failure {
    [[HttpClient sharedInstance] post:EditRecieveAddress params:[params dictionaryModel] success:^(id responseObj) {
        EmpAddressVo *model = [EmpAddressVo parse:responseObj];
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+(void)removeAddress:(RemoveRecieveAddressR *)params success:(void (^)(RemoveAddressVo *responseModel))success failure:(void (^)(HttpException *))failure {
    [[HttpClient sharedInstance] post:RemoveRecieveAddress params:[params dictionaryModel] success:^(id responseObj) {
        RemoveAddressVo *model = [RemoveAddressVo parse:responseObj];
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
