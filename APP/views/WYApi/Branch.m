//
//  Branch.m
//  wenYao-store
//
//  Created by YYX on 15/7/7.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "Branch.h"
#import "EmployeeModel.h"
#import "BranchModel.h"
#import "OrganInfoEditModel.h"

@implementation Branch

+ (void)getChangeAliPayAccountWithParams:(NSDictionary *)param
                                 success:(void(^)(id obj))success
                                 failure:(void(^)(HttpException * e))failure;
{
    HttpClientMgr.progressEnabled = NO;
    
    [HttpClientMgr get:GetChangeAliPayPhoneNumber params:param success:^(id responseObj) {
        
        if (success) {
            success(responseObj);
        }
        
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
        
    }];
    
}

+ (void)GetSymbolWithParams:(BranchGetSymbolModelR *)param
                    success:(void(^)(BranchSymbolVo *obj))success
                    failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:BranchInfoGetSymbol params:[param dictionaryModel] success:^(id responseObj) {
        
        if ([responseObj[@"apiStatus"] integerValue] == 0) {
            BranchSymbolVo *model = [BranchSymbolVo parse:responseObj];
            if (success) {
                success(model);
            }
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
    
}


+ (void)getSoftwareuserPhoneNumberWithParams:(NSDictionary *)param
                                     success:(void(^)(id obj))success
                                     failure:(void(^)(HttpException * e))failure
{
    HttpClientMgr.progressEnabled = NO;
    
    [HttpClientMgr get:EmployeeGetInfo params:param success:^(id responseObj) {
        
        if ([responseObj[@"apiStatus"] integerValue] == 0) {
            EmployeeInfoModel *model = [EmployeeInfoModel parse:responseObj];
            if (success) {
                success(model);
            }
        }

    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)UpdateSoftwareuserInfoWithParams:(NSDictionary *)param
                                 success:(void(^)(id obj))success
                                 failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr put:UpdateEmployeeInfo params:param success:^(id responseObj) {
        
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
 *  普通注册
 *
 */
+ (void)PassportBranchRegisterWithParams:(NSDictionary *)param
                                 success:(void(^)(id obj))success
                                 failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr post:PassportBranchRegisterComplete params:param success:^(id responseObj) {
        
        if (success) {
            success(responseObj);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)PassportBranchPasswordRenewWithParams:(NSDictionary *)param
                                      success:(void(^)(id obj))success
                                      failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:PassportBranchPasswordRenew params:param success:^(id responseObj) {
        
        if (success) {
            success(responseObj);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)PassportBranchGetAccountByMobileWithParams:(NSDictionary *)param
                                           success:(void(^)(id obj))success
                                           failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:PassportBranchGetAccountByMobile params:param success:^(id responseObj) {
        
        if (success) {
            success(responseObj);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)BranchInfoQueryAreaWithParams:(NSDictionary *)param
                              success:(void(^)(id obj))success
                              failure:(void(^)(HttpException * e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [HttpClientMgr get:BranchInfoQueryArea params:param success:^(id responseObj) {
        
        if ([responseObj[@"apiStatus"] integerValue] == 0) {
            NSArray *arr = [ProvinceAndCityModel parseArray:responseObj[@"list"]];
            if (success) {
                success(arr);
            }
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)PassportBranchLinkageReserveWithParams:(NSDictionary *)param
                                       success:(void(^)(id obj))success
                                       failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr post:PassportBranchLinkageReserve params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)BranchApproveInfoSubmitWithParams:(NSDictionary *)param
                                  success:(void(^)(id obj))success
                                  failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr post:BranchApproveInfoSubmit params:param success:^(id responseObj) {
        
        if (success) {
            success(responseObj);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}


+ (void)BranchApproveLicenseSubmitWithParams:(NSDictionary *)param
                                     success:(void(^)(id obj))success
                                     failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr post:BranchApproveLicenseSubmit params:param success:^(id responseObj) {
        
        if (success) {
            success(responseObj);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)BranchApproveWithParams:(NSDictionary *)param
                        success:(void(^)(id obj))success
                        failure:(void(^)(HttpException * e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [HttpClientMgr get:BranchApprove params:param success:^(id responseObj) {
        
            OrganInfoEditModel *model = [OrganInfoEditModel parse:responseObj];
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
 *  新的评价
 *
 */
+ (void)BranchAppraiseMmallWithParams:(NSDictionary *)param
                              success:(void(^)(id obj))success
                              failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:BranchAppraiseMmall params:param success:^(id responseObj) {
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
 *  老的评价
 *
 */
+ (void)BranchAppraiseNormalWithParams:(NSDictionary *)param
                               success:(void(^)(id obj))success
                               failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:BranchAppraiseNormal params:param success:^(id responseObj) {
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
 *  获取配送方式
 *
 */
+ (void)BranchGetBranchPostTipsWithParams:(NSDictionary *)param
                                  success:(void(^)(id obj))success
                                  failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:BranchGetBranchPostTips params:param success:^(id responseObj) {
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
 *  获取接单电话
 *
 */
+ (void)BranchQueryOrderLinksWithParams:(NSDictionary *)param
                                success:(void(^)(id obj))success
                                failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:BranchQueryOrderLinks params:param success:^(id responseObj) {
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
 *  更新接单电话
 *
 */
+ (void)BranchUpdateOrderLinksWithParams:(NSDictionary *)param
                                 success:(void(^)(id obj))success
                                 failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr post:BranchUpdateOrderLinks params:param success:^(id responseObj) {
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
 *  积分排行列表
 *
 */
+ (void)BranchScoreRankWithParams:(NSDictionary *)param
                          success:(void(^)(id obj))success
                          failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:BranchScoreRank params:param success:^(id responseObj) {
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
 *  积分排行详情
 *
 */
+ (void)BranchScoreEmpRankWithParams:(NSDictionary *)param
                             success:(void(^)(id obj))success
                             failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:BranchScoreEmpRank params:param success:^(id responseObj) {
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
