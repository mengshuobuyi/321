//
//  Verify.h
//  wenYao-store
//
//  Created by caojing on 15/8/19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VerifyModel.h"
#import "VerifyModelR.h"
#import "HttpClient.h"
@interface Verify : NSObject

/**
 *  验证码验证
 */
+ (void)GetVerifyWithParams:(InputVerifyModelR *)param
                        success:(void (^)(id))success
                        failure:(void(^)(HttpException * e))failure;


/**
 *  确认订单
 */
+ (void)PostVerifyWithParams:(ConVerifyModelR *)param
                    success:(void (^)(id))success
                    failure:(void(^)(HttpException * e))failure;


+ (void)PostVerifyProductWithParams:(ProductVerifyModelR *)param
                            success:(void (^)(id))success
                            failure:(void(^)(HttpException * e))failure;

@end
