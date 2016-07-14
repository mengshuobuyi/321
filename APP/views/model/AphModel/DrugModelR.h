//
//  DrugModelR.h
//  wenYao-store
//
//  Created by caojing on 15/8/20.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseModel.h"

@interface DrugModelR : BaseModel

@end

//我的用药
@interface QueryProductByKeywordModelR : BaseModel

@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSString *currPage;
@property (nonatomic, strong) NSString *pageSize;
@property (nonatomic, strong) NSString *type;
@property (nonatomic,strong)NSString *province;
@property (nonatomic,strong)NSString *city;

@end

//优惠商品活动搜索
@interface GetCoupnSearchKeywordR : BaseModel
@property (nonatomic,strong)NSString *keyword;
@property (nonatomic,strong)NSString *branchId;
@property (nonatomic,strong)NSString *currPage;
@property (nonatomic,strong)NSString *pageSize;
@end

@interface GetCoupnScanKeywordR : BaseModel
@property (nonatomic,strong)NSString *barCode;
@property (nonatomic,strong)NSString *branchId;
@end


@interface GetSearchKeywordsR : BaseModel
@property (nonatomic,strong)NSString *keyword;
@property (nonatomic,strong)NSString *type;//（0:商品, 1:疾病, 2:症状）
@property (nonatomic,strong)NSString *currPage;
@property (nonatomic,strong)NSString *pageSize;
@end

@interface DiseasekwidR : BaseModel
@property (nonatomic,strong)NSString *kwId;
@property (nonatomic,strong)NSString *currPage;
@property (nonatomic,strong)NSString *pageSize;

@end
@interface DiseaseSpmbykwidR : BaseModel

@property (nonatomic,strong)NSString *kwId;
@property (nonatomic,strong)NSString *currPage;
@property (nonatomic,strong)NSString *pageSize;
@end
//3.3.40	根据关键字ID获取商品列表
@interface productBykwIdR : BaseModel
@property (nonatomic,strong)NSString *kwId;
@property (nonatomic,strong)NSString *currPage;
@property (nonatomic,strong)NSString *pageSize;

@property (nonatomic,strong)NSString *branchId;//2.2做的修改
@property (nonatomic,strong)NSString *token;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *v;
@end
@interface DiseaseDetailIosR : BaseModel
@property (nonatomic,strong)NSString *diseaseId;

@end
@interface PossibleDiseaseR : BaseModel

@property (nonatomic,strong)NSString *spmCode;
@property (nonatomic,strong)NSString *currPage;
@property (nonatomic,strong)NSString *pageSize;
@end

/**
 *  3.3.12	疾病明细查询(ios)
 */
@interface diseaseDetaileIosR : BaseModel
@property (nonatomic,strong)NSString *diseaseId;//疾病ID
@property (nonatomic,strong)NSString *diseaseName;
@end

