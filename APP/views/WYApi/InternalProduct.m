//
//  InternalProduct.m
//  wenYao-store
//
//  Created by PerryChen on 3/16/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "InternalProduct.h"

@implementation InternalProduct
/**
 *  请求所有的本店商品列表
 */
+(void)queryInternalProducts:(InternalProductModelR *)params success:(void(^)(InternalProductListModel *responseModel))success failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance]get:QueryInternalProductList params:[params dictionaryModel] success:^(id responseObj) {
        InternalProductListModel *list=[InternalProductListModel parse:responseObj Elements:[InternalProductModel class] forAttribute:@"list"];
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
 *  请求本店商品类别列表
 */
+(void)queryInternalCates:(InternalProductCateModelR *)params success:(void(^)(InternalProductCateListModel *responseModel))success failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance]get:QueryInternalProductCateList params:[params dictionaryModel] success:^(id responseObj) {
        InternalProductCateListModel *list=[InternalProductCateListModel parse:responseObj Elements:[InternalProductCateModel class] forAttribute:@"list"];
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
 *  获取商品类别列表
 */
+(void)queryProductCatesWithCount:(InternalProductCateModelR *)params success:(void(^)(InternalProductCateListModel *responseModel))success failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance]get:QueryInternalCatesWithCount params:[params dictionaryModel] success:^(id responseObj) {
        InternalProductCateListModel *list=[InternalProductCateListModel parse:responseObj Elements:[InternalProductCateModel class] forAttribute:@"categories"];
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
 *  根据商品请求类别列表
 */
+(void)queryCatesWithPro:(InternalCateWithProModelR *)params success:(void(^)(InternalProductCateListModel *responseModel))success failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance]get:QueryInternalCatesWithPro params:[params dictionaryModel] success:^(id responseObj) {
        InternalProductCateListModel *list=[InternalProductCateListModel parse:responseObj Elements:[InternalProductCateModel class] forAttribute:@"categories"];
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
 *  修改本店商品库存
 */
+(void)changeStock:(InternalProductStockModelR *)params success:(void(^)(BaseAPIModel *responseModel))success failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance] post:UpdateInternalProductStock params:[params dictionaryModel] success:^(id responseObj) {
        BaseAPIModel *model = [BaseAPIModel parse:responseObj];
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
 *  获取本店商品详情
 */
+(void)queryInternalProductDetail:(InternalProductDetailModelR *)params success:(void(^)(InternalProductModel *responseModel))success failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance]get:QueryInternalProductDetail params:[params dictionaryModel] success:^(id responseObj) {
        InternalProductModel *list=[InternalProductModel parse:responseObj Elements:[InternalProductCateModel class] forAttribute:@"productCategories"];
//        InternalProductModel *model = [InternalProductModel parse:responseObj];
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
 *  修改本店商品状态
 */
+(void)changeStatus:(InternalProductStatusModelR *)params success:(void(^)(BaseAPIModel *responseModel))success failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance] post:UpdateInternalProductStatus params:[params dictionaryModel] success:^(id responseObj) {
        BaseAPIModel *model = [BaseAPIModel parse:responseObj];
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
 *  获取本店商品搜索结果
 */
+(void)queryInternalProductSearch:(InternalProductSearchModelR *)params success:(void(^)(InternalProductListModel *responseModel))success failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance]get:SearchInternalProductList params:[params dictionaryModel] success:^(id responseObj) {
        InternalProductListModel *list=[InternalProductListModel parse:responseObj Elements:[InternalProductModel class] forAttribute:@"list"];
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
 *  根据条形码查询商品
 */
+(void)queryQwProduct:(InternalProductQueryQwProductModelR *)params success:(void(^)(InternalProductQueryQwProductListModel *responseModel))success failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance]get:QueryQwProduct params:[params dictionaryModel] success:^(id responseObj) {
        InternalProductQueryQwProductListModel *list=[InternalProductQueryQwProductListModel parse:responseObj Elements:[InternalProductQueryProductModel class] forAttribute:@"products"];
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
 *  提交商品
 */
+(void)submitProduct:(InternalProductReleaseGoodsModelR *)params success:(void(^)(InternalProductSubmitModel *responseModel))success failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance] post:ReleaseGood params:[params dictionaryModel] success:^(id responseObj) {
        InternalProductSubmitModel *model = [InternalProductSubmitModel parse:responseObj];
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
 *  推荐商品
 */
+(void)postRecoProduct:(InternalProRecoModelR *)params success:(void(^)(BaseAPIModel *responseModel))success failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance] post:RecoProducts params:[params dictionaryModel] success:^(id responseObj) {
        BaseAPIModel *model = [BaseAPIModel parse:responseObj];
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
 *  取消推荐商品
 */
+(void)postCancelRecoProduct:(InternalProRecoModelR *)params success:(void(^)(BaseAPIModel *responseModel))success failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance] post:CancelRecoProducts params:[params dictionaryModel] success:^(id responseObj) {
        BaseAPIModel *model = [BaseAPIModel parse:responseObj];
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
 *  请求所有的本店商品套餐列表
 */
+(void)queryInternalProductPackage:(InternalProductPackageModelR *)params success:(void(^)(InternalPackageListModel *responseModel))success failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance]get:QueryInternalProductPackage params:[params dictionaryModel] success:^(id responseObj) {
        NSMutableArray *keyArr = [NSMutableArray array];
        [keyArr addObject:NSStringFromClass([InternalPackageDrugListModel class])];
        [keyArr addObject:NSStringFromClass([InternalPackageDrugModel class])];
        
        NSMutableArray *valueArr = [NSMutableArray array];
        [valueArr addObject:@"list"];
        [valueArr addObject:@"druglist"];
        InternalPackageListModel *listModel = [InternalPackageListModel parse:responseObj ClassArr:keyArr Elements:valueArr];
        
        if (success) {
            success(listModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *  修改商品分类
 */
+(void)postMergeCates:(InternalMergeCateModelR *)params success:(void(^)(BaseAPIModel *responseModel))success failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance] post:MergeCates params:[params dictionaryModel] success:^(id responseObj) {
        BaseAPIModel *model = [BaseAPIModel parse:responseObj];
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}
@end