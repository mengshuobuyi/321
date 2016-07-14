//
//  Map.m
//  wenYao-store
//
//  Created by Meng on 15/3/30.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "Map.h"
#import "MapModel.h"

@implementation Map

+ (void)getAreaListWithCode:(NSString *)code success:(void (^)(id))success failure:(void (^)(HttpException *))failure
{
    NSDictionary *setting;
    
    if (!StrIsEmpty(StrFromObj(code))) {
        setting = @{@"code":StrFromObj(code)};
    }
    [[HttpClient sharedInstance] get:Branch_queryAreaList params:setting success:^(id responseObj) {
        
        QueryAreaListModel *queryModel = [QueryAreaListModel parse:responseObj Elements:[AreaListModel class]forAttribute:@"list"];
        if (success) {
            success(queryModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}



/**
 *  @brief 3.8.2	获取省市区的编码
 *
 *  @param 1) city:市编码，字符，必填项
 *
 *  @param 2) province：省编码，字符 ,必填项
 *
 *  @param 3) county : 区(县) 编码，字符
 */
+ (void)getAreaCodeWithParam:(id)param
                     success:(void(^)(id DFModel))success
                     failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance] get:Branch_getAreaCode params:[param dictionaryModel] success:^(id responseObj) {
        
        AreaCodeModel *model = [AreaCodeModel parse:responseObj];
        if (success) {
            success(model);
        }
        
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *  @brief 3.5.49	更新商家经纬度
 *
 *   updateBranchLat
 */

+ (void)updateBranchLatWithParam:(id)param
                         success:(void(^)(id responseObj))success
                         failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance] put:updateBranchLat params:[param dictionaryModel] success:^(id responseObj) {
        
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
