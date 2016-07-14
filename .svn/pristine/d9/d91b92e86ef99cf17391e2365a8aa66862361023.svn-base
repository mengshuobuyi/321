//
//  IndentOders.m
//  wenYao-store
//
//  Created by qw_imac on 16/1/15.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "IndentOders.h"

@implementation IndentOders
//请求订单列表
+(void)queryOrders:(QueryShopOrdersR *)params success:(void(^)(OrderListModel *responseModel))success failure:(void(^)(HttpException *e))failure {
    [[HttpClient sharedInstance]get:QueryOrdersList params:[params dictionaryModel] success:^(id responseObj) {
        NSMutableArray *keyArr = [NSMutableArray array];
        [keyArr addObject:NSStringFromClass([MicroMallShopOrderVO class])];
        [keyArr addObject:NSStringFromClass([MicroMallOrderDetailVO class])];
        
        NSMutableArray *valueArr = [NSMutableArray array];
        [valueArr addObject:@"list"];
        [valueArr addObject:@"microMallOrderDetailVOs"];
        OrderListModel *listModel = [OrderListModel parse:responseObj ClassArr:keyArr Elements:valueArr];
        
        if (success) {
            success(listModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];

}
//订单操作
+(void)operateShopOrder:(OperateShopOrder *)params success:(void(^)(OperateShopOrderModel *model))success failure:(void(^)(HttpException *e))failure{
    HttpClientMgr.progressEnabled = YES;
    [[HttpClient sharedInstance]post:OperateOrders params:[params dictionaryModel] success:^(id responseObj) {
        OperateShopOrderModel *model = [OperateShopOrderModel parse:responseObj];
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

//查询快递公司
+(void)queryLC:(QueryLCR *)params success:(void(^)(LCModel *model))success failure:(void(^)(HttpException *e))failure{
    [[HttpClient sharedInstance]get:QueryPostList params:[params dictionaryModel] success:^(id responseObj) {
        LCModel *model = [LCModel parse:responseObj Elements:[ExpressCompanyVO class] forAttribute:@"list"];
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];

}

//填写物流
+(void)fillLogistics:(FillLogisticsR *)params success:(void(^)(FillLogisticsModel *model))success failure:(void(^)(HttpException *e))failure {
    [[HttpClient sharedInstance]post:FillPostDetail params:[params dictionaryModel] success:^(id responseObj) {
        FillLogisticsModel *model = [FillLogisticsModel parse:responseObj];
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];

}

//订单详情
+(void)queryShopOrderDetail:(QueryShopOrdersDetailR *)params success:(void(^)(ShopOrderDetailVO *model))success failure:(void(^)(HttpException *e))failure {
    [[HttpClient sharedInstance]get:QueryShopOrderDetailInfo params:[params dictionaryModel] success:^(id responseObj) {
//        ShopOrderDetailVO *modelList = [ShopOrderDetailVO parse:responseObj Elements:[ShopMicroMallOrderDetailVO class] forAttribute:@"microMallOrderDetailVOs"];
        NSMutableArray *keyArr = [NSMutableArray array];
        [keyArr addObject:NSStringFromClass([ShopMicroMallOrderDetailVO class])];
        [keyArr addObject:NSStringFromClass([OrderComboVo class])];
        [keyArr addObject:NSStringFromClass([ShopMicroMallOrderDetailVO class])];
        [keyArr addObject:NSStringFromClass([ShopMicroMallOrderDetailVO class])];
        NSMutableArray *valueArr = [NSMutableArray array];
        [valueArr addObject:@"microMallOrderDetailVOs"];
        [valueArr addObject:@"orderComboVOs"];
        [valueArr addObject:@"redemptionPro"];
        [valueArr addObject:@"microMallOrderDetailVOs"];
        ShopOrderDetailVO *modelList = [ShopOrderDetailVO parse:responseObj ClassArr:keyArr Elements:valueArr];
        if (success) {
            success(modelList);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

//查询拒单理由
+(void)queryRefuseReasons:(QueryCancelReasons *)params success:(void(^)(CancelReasonModel *model))success failure:(void(^)(HttpException *e))failure {
    [[HttpClient sharedInstance]get:QueryRefuseReasonInfo params:[params dictionaryModel] success:^(id responseObj) {
        CancelReasonModel *modelList = [CancelReasonModel parse:responseObj];
        if (success) {
            success(modelList);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

//查询业绩订单列表
+(void)queryPerformanceOrders:(QueryPerformanceOrderListR *)params success:(void(^)(PerformanceOrdersVO *model))success failure:(void(^)(HttpException *e))failure {
    [[HttpClient sharedInstance]get:QueryPerformanceList params:[params dictionaryModel] success:^(id responseObj) {
        NSMutableArray *keyArr = [NSMutableArray array];
        [keyArr addObject:NSStringFromClass([MicroMallShopOrderVO class])];
        [keyArr addObject:NSStringFromClass([ShopMicroMallOrderDetailVO class])];
        
        NSMutableArray *valueArr = [NSMutableArray array];
        [valueArr addObject:@"microMallShopOrderVOs"];
        [valueArr addObject:@"microMallOrderDetailVOs"];
        PerformanceOrdersVO *modelList = [PerformanceOrdersVO parse:responseObj ClassArr:keyArr Elements:valueArr];
        
        if (success) {
            success(modelList);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}
@end
