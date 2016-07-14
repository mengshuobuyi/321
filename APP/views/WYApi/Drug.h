//
//  Drug.h
//  wenYao-store
//
//  Created by caojing on 15/8/20.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "DrugModel.h"
#import "DrugModelR.h"
@interface Drug : NSObject

//优惠商品搜索
+(void)getsearchCoupnKeywordsWithParam:(id)model
                               Success:(void (^)(id))success
                               failure:(void (^)(HttpException *))failure;

//优惠商品搜索扫描
+(void)scansearchCoupnKeywordsWithParam:(id)model
                                Success:(void (^)(id))success
                                failure:(void (^)(HttpException *))failure;

//验证码从药品库搜索
+ (void)queryProductByKeywordWithParam:(QueryProductByKeywordModelR *)params
                               Success:(void(^)(id DFUserModel))success
                               failure:(void(^)(HttpException * e))failure;

/**
 *  快速自查3.3.1	搜索关键字联想(OK)
 */
+ (void)getsearchKeywordsWithParam:(id)model
                           Success:(void(^)(id DFUserModel))success
                           failure:(void(^)(HttpException * e))failure;



+(void)queryDiseasekwidWithParam:(id)param
                         success:(void (^)(id))success
                         failure:(void (^)(HttpException *))failure;


+(void)querySpmkwidWithParam:(id)param
                     success:(void (^)(id))success
                     failure:(void (^)(HttpException *))failure;


//3.3.40	根据关键字ID获取商品列表
+ (void)queryProductByKwIdWithParam:(id)model
                            Success:(void(^)(id DFUserModel))success
                            failure:(void(^)(HttpException * e))failure;

//根据症状关联的可能的疾病
+ (void)queryAssociationDiseaseWithParams:(PossibleDiseaseR *)param
                                  success:(void (^)(id))success
                                  failure:(void (^)(HttpException *))failure;


+ (void)DiseaseDetailIosWithParam:(id)params
                          success:(void(^)(id DFUserModel))success
                          failure:(void(^)(HttpException *e))failure;


+(void)drugqueryProductDetailWithParam:(id)model
                               Success:(void (^)(id DFModel))success
                               failure:(void (^)(HttpException *e))failure;


/**
 *     专家咨询 药品搜索
 *
 */
+ (void)ProductQueryProductByKwNameWithParams:(NSDictionary *)param
                                      success:(void(^)(id DFUserModel))success
                                      failure:(void(^)(HttpException * e))failure;

/**
 *     专家咨询 扫码搜索
 *
 */
+ (void)ProductQueryProductByBarCodeWithParams:(NSDictionary *)param
                                       success:(void(^)(id DFUserModel))success
                                       failure:(void(^)(HttpException * e))failure;

/**
 *     本店咨询 药品搜索
 *
 */
+ (void)MmallByNameWithParams:(NSDictionary *)param
                      success:(void(^)(id DFUserModel))success
                      failure:(void(^)(HttpException * e))failure;

/**
 *     本店咨询 扫码搜索
 *
 */
+ (void)MmallByBarcodeWithParams:(NSDictionary *)param
                         success:(void(^)(id DFUserModel))success
                         failure:(void(^)(HttpException * e))failure;

/**
 *     快捷发送药品（联想词）
 *
 */
+ (void)QwShitSearchWithParams:(NSDictionary *)param
                       success:(void(^)(id DFUserModel))success
                       failure:(void(^)(HttpException * e))failure;


@end
