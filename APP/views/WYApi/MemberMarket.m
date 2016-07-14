//
//  MemberMarket.m
//  wenYao-store
//
//  Created by PerryChen on 5/11/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "MemberMarket.h"

@implementation MemberMarket
/**
 *  3.2 选择列表：券
 */
+(void)queryCouponTicketList:(MarketQueryTicketModelR *)params success:(void(^)(MktgCouponListVo *responseModel))success failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance]get:MktgQueryCoupons params:[params dictionaryModel] success:^(id responseObj) {
        MktgCouponListVo *list=[MktgCouponListVo parse:responseObj Elements:[OnlineBaseCouponDetailVo class] forAttribute:@"coupons"];
        if (success) {
            success(list);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *  3.2 选择列表：活动
 */
+(void)queryProductList:(MarketQueryProductModelR *)params success:(void(^)(MktgActListVo *responseModel))success failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance]get:MktgQueryActs params:[params dictionaryModel] success:^(id responseObj) {
        MktgActListVo *list=[MktgActListVo parse:responseObj Elements:[MicroMallActivityVO class] forAttribute:@"acts"];
        if (success) {
            success(list);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];

}

/**
 *  3.2 选择列表：海报
 */
+(void)queryBrochureList:(MarketQueryBrochureModelR *)params success:(void(^)(MktgDmListVo *responseModel))success failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance]get:MktgQueryDms params:[params dictionaryModel] success:^(id responseObj) {
        MktgDmListVo *list=[MktgDmListVo parse:responseObj Elements:[QueryActivityInfo class] forAttribute:@"dms"];
        if (success) {
            success(list);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *  3.2 检查积分
 */
+(void)queryMktgCheck:(MarketCheckMarkModelR *)params success:(void(^)(MemberCheckVo *responseModel))success failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance]post:MktgCheck params:[params dictionaryModel] success:^(id responseObj) {
        MemberCheckVo *model = [MemberCheckVo parse:responseObj];
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
 *  3.2 会员首页查询慢病标签
 */
+(void)queryCustomerNcds:(MarketMemberNcdsModelR *)params success:(void(^)(MemberNcdListVo *responseModel))success failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance]get:CustomerQueryNcds params:[params dictionaryModel] success:^(id responseObj) {
        MemberNcdListVo *list = [MemberNcdListVo parse:responseObj Elements:[MemberNcdVo class] forAttribute:@"ncds"];
        if (success) {
            success(list);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *  3.2 查询慢病标签分组
 */
+(void)queryMktgNcds:(MarketMemberNcdsModelR *)params success:(void(^)(MemberNcdListVo *responseModel))success failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance]get:MktgQueryNcds params:[params dictionaryModel] success:^(id responseObj) {
        MemberNcdListVo *list = [MemberNcdListVo parse:responseObj Elements:[MemberNcdVo class] forAttribute:@"ncds"];
        if (success) {
            success(list);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *  3.2 提交活动集
 */
+(void)postMktgSubmitAct:(MarketMemberSubmitModelR *)params success:(void(^)(MemberMarketModel *responseModel))success failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance]post:MktgSubmitAct params:[params dictionaryModel] success:^(id responseObj) {
        MemberMarketModel *model = [MemberMarketModel parse:responseObj];
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
 *  3.2 提交券
 */
+(void)postMktgSubmitCoupon:(MarketMemberSubmitModelR *)params success:(void(^)(MemberMarketModel *responseModel))success failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance]post:MktgSubmitCoupon params:[params dictionaryModel] success:^(id responseObj) {
        MemberMarketModel *model = [MemberMarketModel parse:responseObj];
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
 *  3.2 提交海报
 */
+(void)postMktgSubmitDm:(MarketMemberSubmitModelR *)params success:(void(^)(MemberMarketModel *responseModel))success failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance]post:MktgSubmitDm params:[params dictionaryModel] success:^(id responseObj) {
        MemberMarketModel *model = [MemberMarketModel parse:responseObj];
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
 *  3.2 获取会员列表
 */
+(void)queryCustomerNcdList:(MemberQueryByNcdModelR *)params success:(void(^)(MemberNcdCustomerListVo *responseModel))success failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance]get:CustomerQueryByNcd params:[params dictionaryModel] success:^(id responseObj) {
        MemberNcdCustomerListVo *list = [MemberNcdCustomerListVo parse:responseObj Elements:[MemberNcdDetailVo class] forAttribute:@"customers"];
        if (success) {
            success(list);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}
@end
