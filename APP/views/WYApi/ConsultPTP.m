//
//  ConsultPTP.m
//  APP
//
//  Created by carret on 15/6/4.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "ConsultPTP.h"

@implementation ConsultPTP

+ (void)getByCustomer:(GetByCustomerModelR *)param
                                success:(void (^)(PharSessionDetailList *responModel))succsee
                                failure:(void (^)(HttpException *e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:GetByCustomer params:[param dictionaryModel] success:^(id responseObj) {
        PharSessionDetailList *listModel = [PharSessionDetailList parse:responseObj Elements:[SessionDetailVo class] forAttribute:@"details"];
        if (succsee) {
            succsee(listModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)pollBySessionId:(PollBySessionidModelR *)param
                                success:(void (^)(PharSessionDetailList *responModel))succsee
                                failure:(void (^)(HttpException *e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] getWithoutProgress:PollBySessionId params:[param dictionaryModel] success:^(id responseObj) {
        PharSessionDetailList *listModel = [PharSessionDetailList parse:responseObj Elements:[SessionDetailVo class] forAttribute:@"details"];
        if (succsee) {
            succsee(listModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)ptpMessagetCreate:(PTPCreate *)param
                success:(void (^)(DetailCreateResult *responModel))succsee
                failure:(void (^)(HttpException *e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] post:PTPDetailCreate params:[param dictionaryModel] success:^(id responseObj) {
        DetailCreateResult *listModel = [DetailCreateResult parse:responseObj ];
        if (succsee) {
            succsee(listModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)ptpMessagetRead:(PTPRead *)param
                success:(void (^)(ApiBody *responModel))succsee
                failure:(void (^)(HttpException *e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] put:PTPDetailRead params:[param dictionaryModel] success:^(id responseObj) {
        ApiBody *listModel = [ApiBody parse:responseObj ];
        if (succsee) {
            succsee(listModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)ptpMessagetRemove:(PTPRemove *)param
                success:(void (^)(ApiBody *responModel))succsee
                failure:(void (^)(HttpException *e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] put:PTPDetailRemove params:[param dictionaryModel] success:^(id responseObj) {
        ApiBody *listModel = [ApiBody parse:responseObj  ];
        if (succsee) {
            succsee(listModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)ptpCheckTimeoutWithParams:(PTP24Check *)param
                          success:(void (^)(id))success
                          failure:(void (^)(HttpException *))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:CheckTimeout params:[param dictionaryModel] success:^(id obj) {
        BaseAPIModel *model = [BaseAPIModel parse:obj];
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        NSLog(@"%@",e);
        if (failure) {
            failure(e);
        }
    }];
}

//会话置顶
+ (void)ptpTopByPharWithParams:(PTPTopByPharModelR *)param
                       success:(void (^)(id))success
                       failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] put:PTPTopByPhar params:[param dictionaryModel] success:^(id obj) {
        BaseAPIModel *model = [BaseAPIModel parse:obj];
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        NSLog(@"%@",e);
        if (failure) {
            failure(e);
        }
    }];
}



//会同时删除该会话下所有聊天记录（针对药师）
+ (void)ptpRemoveByPharWithParams:(PTPRemoveByPharModelR *)param
                          success:(void (^)(id))success
                          failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] put:PTPRemoveByPhar params:[param dictionaryModel] success:^(id obj) {
        BaseAPIModel *model = [BaseAPIModel parse:obj];
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        NSLog(@"%@",e);
        if (failure) {
            failure(e);
        }
    }];
}


+ (void)ptpPharGetAllWithParams:(GetAllByPharModelR *)param
                          success:(void (^)(id))success
                          failure:(void (^)(HttpException *))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] getWithoutProgress:PTPPharGetAll params:[param dictionaryModel] success:^(id obj) {
        if (success) {
            success(obj);
        }
    } failure:^(HttpException *e) {
        NSLog(@"%@",e);
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)ptpPharPollWithLastTimestamp:(NSString*)lastTimestamp token:(NSString *)token
                        success:(void (^)(id))success
                        failure:(void (^)(HttpException *))failure
{
       HttpClientMgr.progressEnabled = NO;
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    if (token) {
        dd[@"token"]=token;
    }
    if (lastTimestamp && lastTimestamp.length>0) {
        dd[@"lastTimestamp"]=lastTimestamp;
    }
    else dd[@"lastTimestamp"]=@"0";
    
    [[HttpClient sharedInstance] getWithoutProgress:PTPPharPoll params:dd success:^(id obj) {
        if (success) {
            success(obj);
        }
    } failure:^(HttpException *e) {
        NSLog(@"%@",e);
        if (failure) {
            failure(e);
        }
    }];
}

@end
