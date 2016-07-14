//
//  InternalProductModelR.h
//  wenYao-store
//
//  Created by PerryChen on 3/16/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "BaseModel.h"
/**
 *  本店商品列表
 */
@interface InternalProductModelR : BaseModel
@property (nonatomic, strong) NSString *token;
@property (nonatomic, assign) NSInteger currPage;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSString *classifyId;
@property (nonatomic, strong) NSString *status;         //0.全部2.上架3.下架4.库存为0
@property (nonatomic, strong) NSString *flagTotal;
@property (nonatomic, strong) NSString *flagClass;
@end

/**
 *  本店商品分类
 */
@interface InternalProductCateModelR : BaseModel
@property (nonatomic, strong) NSString *token;
@end

/**
 *  根据本店商品获取cate
 */
@interface InternalCateWithProModelR : BaseModel
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *branchProId;
@end

/**
 *  合并商品分类
 */
@interface InternalMergeCateModelR : BaseModel
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *branchProId;
@property (nonatomic, strong) NSString *branchCategories;
@end

/**
 *  本店商品修改库存
 */
@interface InternalProductStockModelR : BaseModel
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *proId;
@property (nonatomic, assign) NSInteger stock;
@end

/**
 *  获取本店商品详情
 */
@interface InternalProductDetailModelR : BaseModel
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *proId;
@end

/**
 *  本店商品修改状态
 */
@interface InternalProductStatusModelR : BaseModel
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *proId;
@property (nonatomic, strong) NSString *status;
@end

/**
 *  本店商品搜索
 */
@interface InternalProductSearchModelR : BaseModel
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *keyWord;
@property (nonatomic, strong) NSString *barcode;
@end

/**
 *  发布商品根据条形码搜索
 */
@interface InternalProductQueryQwProductModelR : BaseModel
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *barcode;
@end

@interface InternalProRecoModelR : BaseModel
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *branchProId;
@end

/**
 *  发布商品
 */
@interface InternalProductReleaseGoodsModelR : BaseModel
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *proCode;
@property (nonatomic, strong) NSString *recommendedCategory;
@property (nonatomic, strong) NSString *classId;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *store;
@end

/**
 *  优惠套餐
 */
@interface InternalProductPackageModelR : BaseModel
@property (nonatomic, strong) NSString *branchId;
@end
