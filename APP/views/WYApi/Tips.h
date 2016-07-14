//
//  Tips.h
//  wenYao-store
//
//  Created by caojing on 15/8/22.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "HttpClient.h"
#import "TipsModel.h"
#import "TipsModelR.h"
@interface Tips : NSObject

//上传小票的列表
+ (void)GetAllTipsWithParams:(TipsListModelR *)param
                       success:(void (^)(id))success
                       failure:(void(^)(HttpException * e))failure;


//小票的详细内容
+ (void)GetTipsDeatilWithParams:(TipsDetailModelR *)param
                        success:(void (^)(id))success
                        failure:(void(^)(HttpException * e))failure;

//上传小票
+ (void)UpTipsDeatilWithParams:(UpTipModelR *)param
                       success:(void (^)(id))success
                       failure:(void(^)(HttpException * e))failure;

//新订单上传小票的保存操作
+ (void)SaveUpTipsDeatilWithParams:(SaveUpTipModelR *)param
                           success:(void (^)(id))success
                           failure:(void(^)(HttpException * e))failure;

@end
