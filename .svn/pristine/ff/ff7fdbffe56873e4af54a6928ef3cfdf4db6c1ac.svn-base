//
//  Drug.m
//  wenYao-store
//
//  Created by caojing on 15/8/20.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "Drug.h"

@implementation Drug



//优惠商品搜索
+(void)getsearchCoupnKeywordsWithParam:(id)model Success:(void (^)(id))success failure:(void (^)(HttpException *))failure{
    
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:GetSearchProduct params:[model dictionaryModel] success:^(id responseObj) {
        GetSearchKeywordsModel *searchkey=[GetSearchKeywordsModel parse:responseObj Elements:[BranchSearchPromotionProVO class] forAttribute:@"list"];
        
        if (success) {
            success(searchkey);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)queryProductByKeywordWithParam:(QueryProductByKeywordModelR *)params
                               Success:(void(^)(id DFUserModel))success
                               failure:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] get:QueryProductByKeyword params:[params dictionaryModel] success:^(id responseObj) {
        
        NSArray *array = [QueryProductByKeywordModel parseArray:responseObj[@"list"]];
        if (success) {
            success(array);
        }
    } failure:^(HttpException *e) {
        DebugLog(@"%@",e);
        if (failure) {
            failure(e);
        }
    }];
}

+(void)scansearchCoupnKeywordsWithParam:(id)model Success:(void (^)(id))success failure:(void (^)(HttpException *))failure{
    
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:GetScanProduct params:[model dictionaryModel] success:^(id responseObj) {
        GetSearchKeywordsModel *searchkey=[GetSearchKeywordsModel parse:responseObj Elements:[BranchSearchPromotionProVO class] forAttribute:@"list"];
        
        if (success) {
            success(searchkey);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}


//全维搜索-----------------------

+(void)getsearchKeywordsWithParam:(id)model Success:(void (^)(id))success failure:(void (^)(HttpException *))failure{
    
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:GetSearchKeywords params:[model dictionaryModel] success:^(id responseObj) {
        GetSearchKeywordsModel *searchkey=[GetSearchKeywordsModel parse:responseObj Elements:[GetSearchKeywordsclassModel class] forAttribute:@"list"];
        
        if (success) {
            success(searchkey);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+(void)queryDiseasekwidWithParam:(id)param success:(void (^)(id))success failure:(void (^)(HttpException *))failure{
    
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:GetDiseaseBykwid
                              params:[param dictionaryModel]
                             success:^(id resultObj) {
             DiseaseSpmProductbykwid *kwid=[DiseaseSpmProductbykwid parse:resultObj Elements:[Diseaseclasskwid class] forAttribute:@"list"];
             if (success) {
                 success(kwid);
             }
                             }
                             failure:^(HttpException *e) {
                                 NSLog(@"%@",e);
                                 if (failure) {
                                     failure(e);
                                 }
                             }];
}


+(void)querySpmkwidWithParam:(id)param success:(void (^)(id))success failure:(void (^)(HttpException *))failure{
    [[HttpClient sharedInstance] get:GetSpmByKwId
                              params:[param dictionaryModel]
                             success:^(id resultObj) {
                                 DiseaseSpmProductbykwid *kwid=[DiseaseSpmProductbykwid parse:resultObj Elements:[Spmclasskwid class] forAttribute:@"list"];
                                 if (success) {
                                     success(kwid);
                                 }
                             }
                             failure:^(HttpException *e) {
                                 NSLog(@"%@",e);
                                 if (failure) {
                                     failure(e);
                                 }
                             }];
}


+(void)queryProductByKwIdWithParam:(id)model Success:(void (^)(id))success failure:(void (^)(HttpException *))failure{
    
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:GetProductByKwId params:[model dictionaryModel] success:^(id responseObj) {
        DiseaseSpmProductbykwid *searchkey=[DiseaseSpmProductbykwid parse:responseObj Elements:[productclassBykwId class] forAttribute:@"list"];
        
        if (success) {
            success(searchkey);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}


//根据症状关联的疾病

+ (void)queryAssociationDiseaseWithParams:(PossibleDiseaseR *)param
                                  success:(void (^)(id))success
                                  failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] get: QueryAssociationDisease
                              params:[param dictionaryModel]
                             success:^(id resultObj) {
                                 
                                 DiseaseClassPage *page = [DiseaseClassPage parse:resultObj Elements:[PossibleDisease class] forAttribute:@"list"];
                                 
                                 if (success) {
                                     success(page);
                                 }
                             }
                             failure:^(HttpException *e) {
                                 NSLog(@"%@",e);
                                 if (failure) {
                                     failure(e);
                                 }
                             }];
}


+(void)DiseaseDetailIosWithParam:(id)params success:(void (^)(id))success failure:(void (^)(HttpException *))failure{
    
    [[HttpClient sharedInstance] get:QW_queryDiseaseDetailIos params:[params dictionaryModel] success:^(id responseObj) {
        
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}



+(void)drugqueryProductDetailWithParam:(id)model Success:(void (^)(id))success failure:(void (^)(HttpException *))failure{
    [[HttpClient sharedInstance] get:QueryProductDetail params:model success:^(id responseObj) {
        
        
        if (success) {
            success(responseObj);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

//___________________________

/**
 *     专家咨询 药品搜索
 *
 */
+ (void)ProductQueryProductByKwNameWithParams:(NSDictionary *)param
                                      success:(void(^)(id DFUserModel))success
                                      failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:ProductQueryProductByKwName params:param success:^(id responseObj) {
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
 *     专家咨询 扫码搜索
 *
 */
+ (void)ProductQueryProductByBarCodeWithParams:(NSDictionary *)param
                                       success:(void(^)(id DFUserModel))success
                                       failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:ProductQueryProductByBarCode params:param success:^(id responseObj) {
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
 *     本店咨询 药品搜索
 *
 */
+ (void)MmallByNameWithParams:(NSDictionary *)param
                      success:(void(^)(id DFUserModel))success
                      failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:MmallByName params:param success:^(id responseObj) {
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
 *     本店咨询 扫码搜索
 *
 */
+ (void)MmallByBarcodeWithParams:(NSDictionary *)param
                         success:(void(^)(id DFUserModel))success
                         failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:MmallByBarcode params:param success:^(id responseObj) {
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
 *     快捷发送药品（联想词）
 *
 */
+ (void)QwShitSearchWithParams:(NSDictionary *)param
                       success:(void(^)(id DFUserModel))success
                       failure:(void(^)(HttpException * e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [HttpClientMgr get:FinderAssociate params:param success:^(id responseObj) {
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
