//
//  Tips.m
//  wenYao-store
//
//  Created by caojing on 15/8/22.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "Tips.h"

@implementation Tips


//上传小票的列表
+ (void)GetAllTipsWithParams:(TipsListModelR *)param
                     success:(void (^)(id))success
                     failure:(void(^)(HttpException * e))failure{
    HttpClientMgr.progressEnabled=YES;
    [[HttpClient sharedInstance] get:GetAllTips params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];


}

//获取小票的详细内容
+ (void)GetTipsDeatilWithParams:(TipsDetailModelR *)param
                     success:(void (^)(id))success
                     failure:(void(^)(HttpException * e))failure{
    HttpClientMgr.progressEnabled=YES;
    [[HttpClient sharedInstance] get:GetTipDeatil params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
    
    
}

//上传小票的详细内容
+ (void)UpTipsDeatilWithParams:(UpTipModelR *)param
                        success:(void (^)(id))success
                        failure:(void(^)(HttpException * e))failure{
    HttpClientMgr.progressEnabled=YES;
    [[HttpClient sharedInstance] post:PostUpTipDeatil params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
    
    
}



//新订单上传小票的保存操作
+ (void)SaveUpTipsDeatilWithParams:(SaveUpTipModelR *)param
                       success:(void (^)(id))success
                       failure:(void(^)(HttpException * e))failure{
    HttpClientMgr.progressEnabled=YES;
    [[HttpClient sharedInstance] post:PostSaveTipDeatil params:[param dictionaryModel] success:^(id responseObj) {
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
