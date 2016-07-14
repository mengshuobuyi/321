//
//  WechatActivity.h
//  wenYao-store
//
//  Created by qw_imac on 16/3/18.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WechatActivityR.h"
#import "WechatActivityModel.h"
#import "HttpClient.h"
@interface WechatActivity : NSObject
/**
 *  3.1 微商活动列表api
 */
+(void)queryWechatActivityList:(WechatActivityR *)params
                       success:(void(^)(WechatActivityModel *responseModel))success
                       failure:(void(^)(HttpException *e))failure;

/**
 *  3.1 微商活动套餐详情api
 */
+(void)queryActivityCombo:(ActivityComboR *)params
                  success:(void(^)(BusinessComboVO *responseModel))success
                  failure:(void(^)(HttpException *e))failure;

/**
 *  3.1 微商活动优惠活动详情api
 */
+(void)queryActivityPromotion:(ActivityPromotionR *)params
                      success:(void(^)(BusinessPromotionVO *responseModel))success
                      failure:(void(^)(HttpException *e))failure;

/**
 *  3.1 微商活动换购详情api
 */
+(void)queryActivityRepd:(ActivityRepdR *)params
                 success:(void(^)(BusinessRedpVO *responseModel))success
                 failure:(void(^)(HttpException *e))failure;

/**
 *  3.1 微商活动抢购详情api
 */
+(void)queryActivityRush:(ActivityRushR *)params
                 success:(void(^)(BusinessRushVO *responseModel))success
                 failure:(void(^)(HttpException *e))failure;

/**
 *  3.1 微商活动下架活动api
 */
+(void)updateActivity:(UpdateActivityR *)params
              success:(void(^)(UpdateActivityModel *responseModel))success
              failure:(void(^)(HttpException *e))failure;

@end
