//
//  Pharmacy.m
//  wenYao-store
//
//  Created by qwfy0006 on 15/4/1.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "Pharmacy.h"

@implementation Pharmacy

+ (void)QueryStoreWithParams:(NSDictionary *)param
                     success:(void (^)(id))success
                     failure:(void (^)(HttpException *e))failure
{
    [[HttpClient sharedInstance] get:SearchShop params:param success:^(id responseObj) {
        
        //        if ([responseObj[@"apiStatus"] intValue] == 0) {
        //
        //        }
        QueryStorePage *page = [QueryStorePage parse:responseObj Elements:[QueryStoreModel class] forAttribute:@"list"];
        if (success) {
            success(page);
        }
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)QueryAreaWithParams:(NSDictionary *)param
                    success:(void (^)(id))success
                    failure:(void (^)(HttpException *e))failure
{
    [[HttpClient sharedInstance] get:LoginAreaList params:param success:^(id responseObj) {
        
        QueryAreaPage *page = [QueryAreaPage parse:responseObj Elements:[QueryAreaModel class] forAttribute:@"list"];
        if (success) {
            success(page);
        }


        
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
}

@end
