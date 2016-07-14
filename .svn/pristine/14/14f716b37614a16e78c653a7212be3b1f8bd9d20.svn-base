//
//  Consult.m
//  wenYao-store
//
//  Created by garfield on 15/5/4.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "Consult.h"
#import "BaseAPIModel.h"
#import "CouponModel.h"

@implementation Consult


//问题已关闭
+ (void)consultClosedtWithParams:(ConsultCloseModelR *)param
                         success:(void(^)(id obj))success
                         failure:(void(^)(HttpException * e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:ConsultClosed params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            NSArray *array = [ConsultConsultingModel parseArray:responseObj[@"consults"]];
            success(array);

           
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

//抢而伟答放弃接口
+ (void)consultConsultingGiveUpParams:(ConsultReplyFirstgModelR *)param
                              success:(void(^)(BaseAPIModel *model))success
                              failure:(void(^)(HttpException * e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] put:ConsultGiveUpByPhar params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            BaseAPIModel *model = [BaseAPIModel parse:responseObj];
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}



//全量获取解答列表
+ (void)consultConsultingWithParams:(ConsultCloseModelR *)param
                            success:(void(^)(id obj))success
                            failure:(void(^)(HttpException * e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:ConsultConsulting params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
//            NSLog(@"----%@",responseObj);
            NSArray *array = [ConsultConsultingModel parseArray:responseObj[@"consults"]];
            success(array);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

//增量获取解答列表
+ (void)consultConsultingnewDetailWithParams:(ConsultnNewDetailModelR *)param
                            success:(void(^)(id obj))success
                            failure:(void(^)(HttpException * e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] getWithoutProgress:ConsultConsultingnewDetail params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            ConsultConsultingModellist *listModel = [ConsultConsultingModellist parse:responseObj Elements:[ConsultConsultingModel class] forAttribute:@"consults"];
            if (success) {
                success(listModel);
            }
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}


//待抢答
+ (void)consultRacingWithParams:(ConsultCloseModelR *)param
                        success:(void(^)(id obj))success
                        failure:(void(^)(HttpException * e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:ConsultRacing params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            NSArray *array = [ConsultConsultingModel parseArray:responseObj[@"consults"]];
            success(array);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)consultCreateWithParams:(ConsultCloseModelR *)param
                        success:(void(^)(id obj))success
                        failure:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] post:ConsultCreate params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)consultCustomerWithParams:(ConsultCloseModelR *)param
                          success:(void(^)(id obj))success
                          failure:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] get:ConsultCustomer params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)consultIgnoreWithParams:(ConsultReplyFirstgModelR *)param
                        success:(void(^)(BaseAPIModel *model))success
                        failure:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] put:ConsultIgnore params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            BaseAPIModel *model = [BaseAPIModel parse:responseObj];
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}


//聊天过程中第二次及以后每次回复
+ (void)consultDetailCreateWithParams2:(ConsultDetailCreateModelR *)param
                              success:(void(^)(id obj))success
                              failure:(void(^)(HttpException * e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] post:ConsultDetailCreate params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            ConsultDetailCreateModel *detailCreateModel = [ConsultDetailCreateModel parse:responseObj];
            success(detailCreateModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)checkStatusByPharWhenGettingDetailFromRacing:(ConsultReplyFirstgModelR *)param
                                             success:(void(^)(id obj))success
                                             failure:(void(^)(HttpException * e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:CheckStatusByPharWhenGettingDetailFromRacing params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            BaseAPIModel *model = [BaseAPIModel parse:responseObj];
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}


//聊天过程中第一次回复
+ (void)consultDetailCreateFirstWithParams:(ConsultDetailCreateModelR *)param
                              success:(void(^)(id obj))success
                              failure:(void(^)(HttpException * e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] post:ConsultConsultingFirst params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            ConsultDetailCreateModel *detailCreateModel = [ConsultDetailCreateModel parse:responseObj];
            success(detailCreateModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

//设置为已读
+ (void)updateConsultItemRead:(ConsultItemReadModelR *)param
                      success:(void (^)(ConsultModel *responModel))success
                      failure:(void (^)(HttpException *e))failure
{
    [HttpClient sharedInstance].progressEnabled=YES;
    [[HttpClient sharedInstance] put:ConsultCustomerItemRead params:[param dictionaryModel] success:^(id responseObj) {
        ConsultModel *model = (ConsultModel *)responseObj;
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}



+ (void)consultDetailCustomertWithParams:(ConsultCloseModelR *)param
                                 success:(void(^)(id obj))success
                                 failure:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] get:ConsultDetailCustomer params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

//全量详情
+ (void)consultDetailPharWithParams:(ConsultReplyFirstgModelR *)param
                            success:(void(^)(PharConsultDetail *model))success
                            failure:(void(^)(HttpException * e))failure
{
    [HttpClient sharedInstance].progressEnabled = NO;
    [[HttpClient sharedInstance] get:ConsultDetailPhar params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            PharConsultDetail *consultDetail = [PharConsultDetail parse:responseObj Elements:[ConsultDetail class] forAttribute:@"details"];
            success(consultDetail);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

//增量详情
+ (void)consultDetailPharPollWithParams:(ConsultReplyFirstgModelR *)param
                                success:(void(^)(id obj))success
                                failure:(void(^)(HttpException * e))failure
{
    [HttpClient sharedInstance].progressEnabled = NO;
    [[HttpClient sharedInstance] getWithoutProgress:ConsultDetailPharPoll params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            PharConsultDetail *consultDetail = [PharConsultDetail parse:responseObj Elements:[ConsultDetail class] forAttribute:@"details"];
            success(consultDetail);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)consultDetailReceiveWithParams:(ConsultCloseModelR *)param
                               success:(void(^)(id obj))success
                               failure:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] put:ConsultDetailReceive params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}


+ (void)consultDetailRemoveWithParams:(ConsultDetailRemoveModelR *)param
                              success:(void(^)(id obj))success
                              failure:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] put:ConsultDetailRemove params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)consultRacedWithParams:(ConsultCloseModelR *)param
                       success:(void(^)(id obj))success
                       failure:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] get:ConsultIdRaced params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)consultReplyFirstWithParams:(ConsultReplyFirstgModelR *)param
                            success:(void(^)(id obj))success
                            failure:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] put:ConsultReplyFirst params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            BaseAPIModel *model = [BaseAPIModel parse:responseObj];
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)consultSpCreateWithParams:(ConsultCloseModelR *)param
                          success:(void(^)(id obj))success
                          failure:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] post:ConsultSpCreate params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}


+ (void)consultStatisticsWithParam:(NSDictionary *)param
                           success:(void (^)(id))success
                           failure:(void (^)(HttpException *))failure
{
    [HttpClientMgr put:ConsultStatistics params:param success:^(id responseObj) {
        
        ConsultStatisticsModel *model = [ConsultStatisticsModel parse:responseObj];
        if (success) {
            success(model);
        }
        
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)CustomerQueryConsultListWithParam:(NSDictionary *)param
                                  success:(void (^)(id))success
                                  failure:(void (^)(HttpException *))failure
{
    [HttpClientMgr get:CustomerQueryConsultList params:param success:^(id responseObj) {
        
        ConsultHistoryPage *page = [ConsultHistoryPage parse:responseObj Elements:[ConsultHistoryModel class] forAttribute:@"list"];
        if (success) {
            success(page);
        }
        
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)consultItemReadWithParam:(ConsultDetailReceiveModelR *)param
                         success:(void(^)(id obj))success
                         failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr setProgressEnabled:NO];
    [HttpClientMgr get:ConsultItemReaded params:[param dictionaryModel] success:^(id responseObj) {
        ConsultMode *modelReceived = [ConsultMode parse:responseObj];
        if (success) {
            success(modelReceived);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)updateNotiNumberWithNum:(NSInteger)num token:(NSString *)token
                          success:(void(^)(id ResModel))success
                          failure:(void (^)(HttpException *e))failure
{
//    [HttpClient sharedInstance].progressEnabled = YES;
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    if (token) {
        dd[@"token"]=token;
    }
    if (num>0) {
        dd[@"num"]=StrFromInt(num);
    }
    else dd[@"num"]=@"0";
    
    [[HttpClient sharedInstance] putWithoutProgress:ConsultSetUnreadNum params:dd success:^(id responseObj) {
        if(success){
            ConsultModel *consultDetail = [ConsultModel parse:responseObj];
            success(consultDetail);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

//最近时间内的互动统计信息

+ (void)consultStatisticsByRecentWithParam:(NSDictionary *)param
                                   success:(void (^)(id))success
                                   failure:(void (^)(HttpException *))failure
{
    [HttpClientMgr put:StatisticsByRecent params:param success:^(id responseObj) {
        
        ConsultStatisticsModel *model = [ConsultStatisticsModel parse:responseObj];
        if (success) {
            success(model);
        }
        
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
}

//根据日期获得统计信息

+ (void)consultStatisticsByDateWithParam:(NSDictionary *)param
                                 success:(void (^)(id))success
                                 failure:(void (^)(HttpException *))failure
{
    [HttpClientMgr put:StatisticsByDate params:param success:^(id responseObj) {
        
        ConsultStatisticsModel *model = [ConsultStatisticsModel parse:responseObj];
        if (success) {
            success(model);
        }
        
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
}


//优惠详情
+ (void)queryCoupnDetailWithParam:(NSDictionary *)params success:(void(^)(id))success failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance] get:GetPromotionDetail params:params success:^(id responseObj) {
        
        NSMutableArray *keyArray = [NSMutableArray array];
        [keyArray addObject:NSStringFromClass([ProductsModel class])];
        
        NSMutableArray *valueArray = [NSMutableArray array];
        [valueArray addObject:@"products"];
        
        CouponDetailModel *coupon = [CouponDetailModel parse:responseObj ClassArr:keyArray Elements:valueArray];
        
        if (success) {
            success(coupon);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}



@end
