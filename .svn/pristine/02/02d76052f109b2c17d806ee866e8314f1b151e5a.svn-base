//
//  Map.h
//  wenYao-store
//
//  Created by Meng on 15/3/30.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"

@interface Map : NSObject

/**
 *  @brief 3.5.43	获取省市区列表
 *
 *  @param code:省、市编码 字符，获取省列表时该参数为空
 */
+ (void)getAreaListWithCode:(NSString *)code
                    success:(void(^)(id DFModel))success
                    failure:(void(^)(HttpException *e))failure;


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
                     failure:(void(^)(HttpException *e))failure;


/**
 *  @brief 3.5.49	更新商家经纬度
 *
 *   updateBranchLat
 */

+ (void)updateBranchLatWithParam:(id)param
                         success:(void(^)(id responseObj))success
                         failure:(void(^)(HttpException *e))failure;


@end
