//
//  InternalProduct.h
//  wenYao-store
//
//  Created by PerryChen on 3/16/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InternalProductModelR.h"
#import "InternalProductModel.h"
#import "HttpClient.h"
/**
 *  3.1 本店商品api
 */
@interface InternalProduct : NSObject

/**
 *  请求所有的本店商品列表
 */
+(void)queryInternalProducts:(InternalProductModelR *)params
                     success:(void(^)(InternalProductListModel *responseModel))success
                     failure:(void(^)(HttpException *e))failure;

/**
 *  请求本店商品类别列表
 */
+(void)queryInternalCates:(InternalProductCateModelR *)params
                  success:(void(^)(InternalProductCateListModel *responseModel))success
                  failure:(void(^)(HttpException *e))failure;

/**
 *  修改本店商品库存
 */
+(void)changeStock:(InternalProductStockModelR *)params
           success:(void(^)(BaseAPIModel *responseModel))success
           failure:(void(^)(HttpException *e))failure;

/**
 *  获取本店商品详情
 */
+(void)queryInternalProductDetail:(InternalProductDetailModelR *)params
                          success:(void(^)(InternalProductModel *responseModel))success
                          failure:(void(^)(HttpException *e))failure;

/**
 *  修改本店商品状态
 */
+(void)changeStatus:(InternalProductStatusModelR *)params
            success:(void(^)(BaseAPIModel *responseModel))success
            failure:(void(^)(HttpException *e))failure;

/**
 *  获取本店商品搜索结果
 */
+(void)queryInternalProductSearch:(InternalProductSearchModelR *)params
                          success:(void(^)(InternalProductListModel *responseModel))success
                          failure:(void(^)(HttpException *e))failure;

/**
 *  根据条形码查询商品
 */
+(void)queryQwProduct:(InternalProductQueryQwProductModelR *)params
              success:(void(^)(InternalProductQueryQwProductListModel *responseModel))success
              failure:(void(^)(HttpException *e))failure;

/**
 *  提交商品
 */
+(void)submitProduct:(InternalProductReleaseGoodsModelR *)params
             success:(void(^)(InternalProductSubmitModel *responseModel))success
             failure:(void(^)(HttpException *e))failure;

/**
 *  根据商品请求类别列表
 */
+(void)queryCatesWithPro:(InternalCateWithProModelR *)params success:(void(^)(InternalProductCateListModel *responseModel))success failure:(void(^)(HttpException *e))failure;

/**
 *  获取商品类别列表
 */
+(void)queryProductCatesWithCount:(InternalProductCateModelR *)params success:(void(^)(InternalProductCateListModel *responseModel))success failure:(void(^)(HttpException *e))failure;

/**
 *  推荐商品
 */
+(void)postRecoProduct:(InternalProRecoModelR *)params success:(void(^)(BaseAPIModel *responseModel))success failure:(void(^)(HttpException *e))failure;

/**
 *  取消推荐商品
 */
+(void)postCancelRecoProduct:(InternalProRecoModelR *)params success:(void(^)(BaseAPIModel *responseModel))success failure:(void(^)(HttpException *e))failure;

/**
 *  请求所有的本店商品套餐列表
 */
+(void)queryInternalProductPackage:(InternalProductPackageModelR *)params success:(void(^)(InternalPackageListModel *responseModel))success failure:(void(^)(HttpException *e))failure;

/**
 *  修改商品分类
 */
+(void)postMergeCates:(InternalMergeCateModelR *)params success:(void(^)(BaseAPIModel *responseModel))success failure:(void(^)(HttpException *e))failure;
@end
