//
//  Order.m
//  APP
//
//  Created by chenpeng on 15/3/19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "Order.h"
@implementation Order

//+(void)DelreceiptWithParams:(id)param success:(void (^)(id))success failure:(void (^)(HttpException *))failure{
//    [[HttpClient sharedInstance] put:Delreceipt params:[param dictionaryModel] success:^(id responseObj) {
//        Delreceipts *branch=[Delreceipts parse:responseObj];
//        if (success) {
//            success(branch);
//        }
//        
//    } failure:^(HttpException *e) {
//        
//        if (failure) {
//            failure(e);
//        }
//    }];
//}





//+(void)promotionScanWithParms:(id)mode success:(void (^)(id))success failure:(void (^)(HttpException *))failure{
//    [HttpClientMgr post:PromotionScan params:mode success:^(id responseObj) {
//        CouponEnjoyModel *enjoy = [CouponEnjoyModel parse:responseObj];
//        
//        if (success) {
//            success(enjoy);
//        }
//    } failure:^(HttpException *e) {
//        if (failure) {
//            failure(e);
//        }
//    }];
//}



#pragma 健康方案的药品列表
+ (void)queryRecommendProductByClassWithParam:(HealthyScenarioDrugModelR *)params success:(void(^)(id))success failure:(void(^)(HttpException *e))failure
{
    
    [HttpClientMgr post:QueryRecommendProductByClass params:[params dictionaryModel] success:^(id responseObj) {
        
        NSMutableArray *keyArray = [NSMutableArray array];
        [keyArray addObject:NSStringFromClass([HealthyScenarioDrugModel class])];
        
        NSMutableArray *valueArray = [NSMutableArray array];
        [valueArray addObject:@"list"];
        
        HealthyScenarioListModel *scenarionList = [HealthyScenarioListModel parse:responseObj ClassArr:keyArray Elements:valueArray];
        
        
        if (success) {
            success(scenarionList);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}
+ (void)QuerySpmInfoListWithParams:(SpmListModelR *)param
                           success:(void (^)(id))success
                           failure:(void (^)(HttpException *))failure
{
    
    [[HttpClient sharedInstance] get:NW_spmList
                               params:nil
                              success:^(id resultObj) {
                                  
                                  NSArray *modelArray = [SpmListPage parse:resultObj Elements:[SpmListModel class]];
                                  if (success) {
                                      success(modelArray);
                                  }
                              }
                              failure:^(HttpException *e) {
                                  if (failure) {
                                      failure(e);
                                  }
                              }];
    
}
+ (void)QuerySpmInfoListByBodyWithParams:(SpmListByBodyModelR *)param
                                 success:(void (^)(id))success
                                 failure:(void (^)(HttpException *))failure
{
    NSString *url = [NSString stringWithFormat:@"%@?bodyCode=%@&sex=%@&population=%@",NW_querySpmInfoListByBody,param.bodyCode,param.sex,param.population];
    
    [[HttpClient sharedInstance] get:url
                               params:nil
                              success:^(id responseObj) {
                                  
                                  SpmListByBodyPage *page = [SpmListByBodyPage parse:responseObj Elements:[SpmListModel class]];
                                  NSLog(@"model=====%@",page);
                                  if (success) {
                                      success(page);
                                  }
                                  
                              }
                              failure:^(HttpException *e) {
                                  if (failure) {
                                      failure(e);
                                  }
                              }];
}
+(void)queryspminfoDetailProductListWithParam:(spminfoDetailR *)mm Success:(void (^)(id))success failure:(void (^)(HttpException *))failure{
    [[HttpClient sharedInstance] get:NW_spmInfoDetail
                              params:[mm dictionaryModel]
                             success:^(id responseObj) {
        spminfoDetail *searchkey=[spminfoDetail parse:responseObj Elements:[spminfoDetailPropertiesModel class] forAttribute:@"properties"];
        
        if (success) {
            success(searchkey);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}
+ (void)queryProductByClassWithParam:(QueryProductByClassModelR *)model
                             Success:(void (^)(id))success
                             failure:(void (^)(HttpException *))failure
{
    NSString *url = [NSString stringWithFormat:@"%@?classId=%@&currPage=%@&pageSize=%@",QueryProductByClass,model.classId,model.currPage,model.pageSize];
    
    [[HttpClient sharedInstance] get:url params:nil success:^(id responseObj) {
        
        QueryProductClassModel *queryProductClassModel = [QueryProductClassModel parse:responseObj Elements:[QueryProductByClassItemModel class]];
        
        
        //        NSLog(@"responseObj===>%@",responseObj);
        
        //        mbrUser *body=[mbrUser parse:responseObj ];
        if (success) {
            success(queryProductClassModel);
        }
    } failure:^(HttpException *e) {
        NSLog(@"%@",e);
        if (failure) {
            failure(e);
        }
    }];
}
+ (void)fetchProFactoryByClassWithParam:(QueryProductByClassModelR *)model
                                Success:(void (^)(id))success
                                failure:(void (^)(HttpException *))failure
{
    NSString *url = [NSString stringWithFormat:@"%@?classId=%@&currPage=%@&pageSize=%@",FetchProFactoryByClass,model.classId,model.currPage,model.pageSize];
    
    [[HttpClient sharedInstance] get:url params:nil success:^(id responseObj) {
        
        QueryProductClassModel *queryProductClassModel = [QueryProductClassModel parse:responseObj Elements:[FetchProFactoryByClassModel class]];
        
        if (success) {
            success(queryProductClassModel);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}
//3.3.15	疾病组方配方用药查询(OK)
+(void)queryDiseaseFormulaProductListWithParam:(id)model Success:(void (^)(id))success failure:(void (^)(HttpException *))failure{
    
    [[HttpClient sharedInstance] get:NW_queryDiseaseFormulaProductList params:[model dictionaryModel] success:^(id responseObj) {
        DiseaseFormulaPruduct *searchkey=[DiseaseFormulaPruduct parse:responseObj Elements:[DiseaseFormulaPruductclass class] forAttribute:@"list"];
        
        if (success) {
            success(searchkey);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}
+(void)queryDiseaseProductListWithParam:(id)model Success:(void (^)(id))success failure:(void (^)(HttpException *))failure{
    [[HttpClient sharedInstance] get:NW_queryDiseaseProductList params:[model dictionaryModel] success:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            DiseaseProductList *searchkey=[DiseaseProductList parse:responseObj Elements:[DiseaseProductListclass class] forAttribute:@"list"];
            
            if (success) {
                success(searchkey);
            }
        }
        
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}



//3个的治疗用药
+(void)queryThreeWithParam:(id)model Success:(void (^)(id))success failure:(void (^)(HttpException *))failure{
    
    [[HttpClient sharedInstance] get:NW_queryDiseaseProductList params:[model dictionaryModel] success:^(id responseObj) {
        DiseaseFormulaPruduct *s = [DiseaseFormulaPruduct parse:responseObj Elements:[DiseaseFormulaPruductclass class] forAttribute:@"list"];
        if (success) {
            success(s);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}


+(void)queryFactoryProductListWithParam:(FactoryProductListnameR *)model Success:(void (^)(id))success failure:(void (^)(HttpException *))failure{
    
    NSString *url = [NSString stringWithFormat:@"%@?factoryCode=%@&currPage=%@&pageSize=%@",NW_queryFactoryProductList,model.factoryCode,model.currPage,model.pageSize];
    
    [[HttpClient sharedInstance] get:url params:nil success:^(id responseObj) {
        FactoryProductListname *searchkey=[FactoryProductListname parse:responseObj];
        
        if (success) {
            success(searchkey);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}
+(void)querypharmacyProductListWithParam:(pharmacyProductR *)model Success:(void (^)(id))success failure:(void (^)(HttpException *))failure{
    
    NSString *url = [NSString stringWithFormat:@"%@?groupId=%@&currPage=%@&pageSize=%@",NW_fetchSellWellProducts,model.groupId,model.currPage,model.pageSize];
    
    [[HttpClient sharedInstance] get:url params:nil success:^(id responseObj) {
        pharmacyProduct *searchkey=[pharmacyProduct parse:responseObj];
        
        if (success) {
            success(searchkey);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}
+(void)promotionCompleteWithParam:(id)model Success:(void (^)(id))success failure:(void (^)(HttpException *))failure{
    [[HttpClient sharedInstance] post:PromotionComplete params:[model dictionaryModel] success:^(id responseObj) {
        
        PromoteComplete *complete = [PromoteComplete parse:responseObj];
        if (success) {
            success(complete);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}
+(void)fixRecieptWithParam:(id)model Success:(void (^)(id))success failure:(void (^)(HttpException *))failure{
    [[HttpClient sharedInstance] put:Fixreceipt params:model success:^(id responseObj) {
        
        if (success) {
            success(responseObj);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *  客户历史订单查询
 *
 */

+(void)orderQueryCustomerOrdersByBranchWithParams:(NSDictionary *)param
                                          success:(void (^)(id))success
                                          failure:(void (^)(HttpException *e))failure
{
    [HttpClientMgr get:OrderQueryCustomerOrdersByBranch params:param success:^(id responseObj) {
        
        ClientHistoryOrderList *orders = [ClientHistoryOrderList parse:responseObj Elements:[ClientHistoryOrder class] forAttribute:@"orders"];
        if (success) {
            success(orders);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *  客户历史订单详情
 *
 */

+(void)orderGetOrderDetailWithParams:(NSDictionary *)param
                             success:(void (^)(id))success
                             failure:(void (^)(HttpException *e))failure
{
    [HttpClientMgr get:OrderGetOrderDetail params:param success:^(id responseObj) {
        
        HistoryOrderDetail *detail = [HistoryOrderDetail parse:responseObj];
        if (success) {
            success(detail);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *  兑换商品列表
 *
 */

+(void)mallOrderByBranchWithParams:(NSDictionary *)param
                           success:(void (^)(id))success
                           failure:(void (^)(HttpException *e))failure
{
    [HttpClientMgr get:MallOrderByBranch params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+(void)mallOrderCompleteWithParams:(NSDictionary *)param
                           success:(void (^)(id))success
                           failure:(void (^)(HttpException *e))failure
{
    [HttpClientMgr get:MallOrderComplete params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

//p2p 全量拉取订单通知消息列表
+ (void)getAllOrderNotiList:(OrderNotiListModelR *)param
                    success:(void (^)(OrderMessageArrayVo *responModel))succsee
                    failure:(void (^)(HttpException *e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:MsgBoxListOrderNotiList params:[param dictionaryModel] success:^(id responseObj) {
        OrderMessageArrayVo *listModel = [OrderMessageArrayVo parse:responseObj Elements:[OrderMessageVo class] forAttribute:@"messages"];
        if (succsee) {
            succsee(listModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

// 增量轮询
+ (void)getNewOrderNotiList:(OrderNewNotiListModelR *)param
                    success:(void (^)(OrderMessageArrayVo *responModel))succsee
                    failure:(void (^)(HttpException *e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:MsgBoxListOrderNewList params:[param dictionaryModel] success:^(id responseObj) {
        OrderMessageArrayVo *listModel = [OrderMessageArrayVo parse:responseObj Elements:[OrderMessageVo class] forAttribute:@"messages"];
        if (succsee) {
            succsee(listModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)setOrderNotiReadWithMessageId:(NSString *)strMsgId
{
    OrderNotiReadR *modelR = [OrderNotiReadR new];
    modelR.messageId = strMsgId;
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] post:OrderNotiMsgRead params:[modelR dictionaryModel] success:^(id responseObj) {
        
    } failure:^(HttpException *e) {
        
    }];
}

+ (void)setOrderNotiReadWithMessageId:(NSString *)messageID success:(void (^)(BaseAPIModel *))success failure:(void (^)(HttpException *))failure
{
    OrderNotiReadR *modelR = [OrderNotiReadR new];
    modelR.messageId = messageID;
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] post:OrderNotiMsgRead params:[modelR dictionaryModel] success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}


+ (void)removeByCustomer:(RemoveByCustomerOrderR *)param
                 success:(void (^)(id responModel))success
                 failure:(void (^)(HttpException *e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] put:OrderNotiRemoveItem params:[param dictionaryModel] success:^(id responseObj) {
        
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *  获取所有未处理订单的数量
 *
 *  @param param
 *  @param succsee
 *  @param failure
 */
+ (void)getAllNewOrderCount:(OrderNewCountModelR *)param
                    success:(void (^)(OrderNewCountModel *responModel))succsee
                    failure:(void (^)(HttpException *e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] getWithoutProgress:OrderGetNew params:[param dictionaryModel] success:^(id responseObj) {
        OrderNewCountModel *model = [OrderNewCountModel parse:responseObj];
        if (succsee) {
            succsee(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *  员工分享转化订单统计
 *
 */
+(void)BmmallQueryShareOrderWithParams:(NSDictionary *)param
                               success:(void (^)(id))success
                               failure:(void (^)(HttpException *e))failure
{
    [HttpClientMgr get:BmmallQueryShareOrder params:param success:^(id responseObj) {
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
