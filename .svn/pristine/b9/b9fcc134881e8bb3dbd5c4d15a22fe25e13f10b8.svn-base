//
//  MemberMarket.h
//  wenYao-store
//
//  Created by PerryChen on 5/11/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemberMarketModelR.h"
#import "HttpClient.h"
#import "CoupnModel.h"
#import "ActivityModel.h"
#import "WechatActivityModel.h"
#import "MemberMarketModel.h"
@interface MemberMarket : NSObject
/**
 *  3.2 选择列表：券
 */
+(void)queryCouponTicketList:(MarketQueryTicketModelR *)params
                     success:(void(^)(MktgCouponListVo *responseModel))success
                     failure:(void(^)(HttpException *e))failure;

/**
 *  3.2 选择列表：活动
 */
+(void)queryProductList:(MarketQueryProductModelR *)params
                success:(void(^)(MktgActListVo *responseModel))success
                failure:(void(^)(HttpException *e))failure;

/**
 *  3.2 选择列表：海报
 */
+(void)queryBrochureList:(MarketQueryBrochureModelR *)params
                 success:(void(^)(MktgDmListVo *responseModel))success
                 failure:(void(^)(HttpException *e))failure;

/**
 *  3.2 检查积分
 */
+(void)queryMktgCheck:(MarketCheckMarkModelR *)params
              success:(void(^)(MemberCheckVo *responseModel))success
              failure:(void(^)(HttpException *e))failure;

/**
 *  3.2 会员首页查询慢病标签
 */
+(void)queryCustomerNcds:(MarketMemberNcdsModelR *)params
                 success:(void(^)(MemberNcdListVo *responseModel))success
                 failure:(void(^)(HttpException *e))failure;

/**
 *  3.2 查询慢病标签分组
 */
+(void)queryMktgNcds:(MarketMemberNcdsModelR *)params
             success:(void(^)(MemberNcdListVo *responseModel))success
             failure:(void(^)(HttpException *e))failure;

/**
 *  3.2 提交活动集
 */
+(void)postMktgSubmitAct:(MarketMemberSubmitModelR *)params
                 success:(void(^)(MemberMarketModel *responseModel))success
                 failure:(void(^)(HttpException *e))failure;

/**
 *  3.2 提交券
 */
+(void)postMktgSubmitCoupon:(MarketMemberSubmitModelR *)params
                    success:(void(^)(MemberMarketModel *responseModel))success
                    failure:(void(^)(HttpException *e))failure;

/**
 *  3.2 提交海报
 */
+(void)postMktgSubmitDm:(MarketMemberSubmitModelR *)params
                success:(void(^)(MemberMarketModel *responseModel))success
                failure:(void(^)(HttpException *e))failure;

/**
 *  3.2 获取会员列表
 */
+(void)queryCustomerNcdList:(MemberQueryByNcdModelR *)params
                    success:(void(^)(MemberNcdCustomerListVo *responseModel))success
                    failure:(void(^)(HttpException *e))failure;
@end
