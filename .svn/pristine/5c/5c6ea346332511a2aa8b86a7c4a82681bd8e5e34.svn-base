//
//  Store.m
//  APP
//
//  Created by qwfy0006 on 15/3/17.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "Store.h"
#import "StoreModel.h"
#import "CheckModel.h"
#import "BranchModel.h"
#import "PharmacistModel.h"
#import "CertifiArrayModel.h"
#import "BranchModel.h"

@implementation Store



//快捷注册
+ (void)QueryStoreCodeWithParams:(StoreCodeModelR *)param
                         success:(void (^)(id))success
                         failure:(void (^)(HttpException *))failure{
    [[HttpClient sharedInstance] get:GetQueryStoreCode params:[param dictionaryModel] success:^(id responseObj) {
        
        StoreCodeModel *model=[StoreCodeModel parse:responseObj];
        
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
    
}

//获取商家的基本信息

+ (void)GetBranchGroupWithParams:(BranchGroupModelR *)param
                         success:(void (^)(id))success
                         failure:(void (^)(HttpException *))failure{
    // change  by s ehn
    HttpClientMgr.progressEnabled = NO;
    //change  en d
    [[HttpClient sharedInstance] get:GetBranchGroup params:[param dictionaryModel] success:^(id responseObj) {
        
        BranchGroupModel *model=[BranchGroupModel parse:responseObj];
        
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
    
}


//快捷注册的最后一步（最后一步）
+ (void)RegisterWithParams:(RegisterModelR *)param
                   success:(void (^)(id))success
                   failure:(void (^)(HttpException *))failure{
    
    [[HttpClient sharedInstance] post:PostRegister params:[param dictionaryModel] success:^(id responseObj) {
    
        StoreModel *model=[StoreModel parse:responseObj];
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
    
    
}





+ (void)loginWithParam:(LoginModelR *)param
                success:(void (^)(id))success
                failure:(void(^)(HttpException * e))failure{
    
    HttpClientMgr.progressEnabled = YES;
    [[HttpClient sharedInstance] post:StoreLogin params:[param dictionaryModel] success:^(id responseObj) {
        
        StoreUserInfoModel *model = [StoreUserInfoModel parse:responseObj];
        
        if (success) {
            success(model);
        }
        
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
}



#pragma mark
#pragma mark 机构信息新接口
+ (void)GetBranhBranchInfoWithGroupId:(NSString *)groupId
                              success:(void (^)(id responseObj))success
                              failure:(void (^)(HttpException *e))failure
{
    HttpClientMgr.progressEnabled = NO;
    NSDictionary *setting = @{@"branchId":StrFromObj(groupId)};
    [[HttpClient sharedInstance] get:JG_getBranhBranchInfoWithApprove params:setting success:^(id responseObj) {
        
        
        BranchInfoModel *infoModel = [BranchInfoModel parse:responseObj Elements:[StoreTagModel class] forAttribute:@"branchTagList"];
        if (success) {
            success(infoModel);
        }
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
}





+ (void)GetBranhGroupDetailWithGroupId:(NSString *)groupId
                              success:(void (^)(id responseObj))success
                              failure:(void (^)(HttpException *e))failure
{
    HttpClientMgr.progressEnabled = NO;
    NSDictionary *setting = @{@"branchId":StrFromObj(groupId)};
    [[HttpClient sharedInstance] get:JG_getBranhGroupDetail params:setting success:^(id responseObj) {
        
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)UpdatePasswordWithParams:(NSDictionary *)param
                         success:(void (^)(id))success
                         failure:(void (^)(HttpException *))failure
{
    {
        [[HttpClient sharedInstance] post:UpdatePassword params:param success:^(id responseObj) {
            
            if (success) {
                success(responseObj);
            }
        } failure:^(HttpException *e) {
            
            if (failure) {
                failure(e);
            }
        }];
    }
}



/**
 *  3.5.39	查询机构所有待审信息
 *
 *  @return
 */

+ (void)QueryBranchApproveWithGroupId:(NSString *)groupId
                              success:(void(^)(id responseObj))success
                              failure:(void(^)(HttpException *e))failure;
{
    
    NSDictionary *setting = @{@"groupId":StrFromObj(groupId)};
    [[HttpClient sharedInstance] get:Branch_queryBranchApprove params:setting success:^(id responseObj) {
        
        
        StoreApproveListModel *listModel = [StoreApproveListModel parse:responseObj Elements:[StoreApproveModel class] forAttribute:@"list"];
        
        
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
 *  @brief 3.5.20	查询机构执照
 *
 *  @return
 */

+ (void)QueryCertifiWithGroupId:(NSString *)groupId
                        success:(void(^)(id responseObj))success
                        failure:(void(^)(HttpException *e))failure
{
    NSDictionary *setting = @{@"branchId":StrFromObj(groupId)};
    
    [[HttpClient sharedInstance] get:Branch_queryAllCertifi params:setting success:^(id responseObj) {
        
        NSMutableArray *keyArray = [NSMutableArray array];
        [keyArray addObject:NSStringFromClass([CertificateModel class])];
        [keyArray addObject:NSStringFromClass([CertificateItemModel class])];
        
        NSMutableArray *valueArray = [NSMutableArray array];
        [valueArray addObject:@"certifis"];
        [valueArray addObject:@"items"];
        
        CertifiArrayModel *arrModel = [CertifiArrayModel parse:responseObj ClassArr:keyArray Elements:valueArray];
        
        if (success) {
            success(arrModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *  @brief 3.5.21	查询待审核机构执照
 *
 */
+ (void)QueryCertifiApproveWithGroupId:(NSString *)groupId
                               success:(void(^)(id responseObj))success
                               failure:(void(^)(HttpException *e))failure
{
    NSDictionary *setting = @{@"branchId":StrFromObj(groupId)};
    
    [[HttpClient sharedInstance] get:Branch_queryCertifiApprove params:setting success:^(id responseObj) {
        if (responseObj) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}





+ (void)LogoutWithParams:(LogoutModelR *)param
                 success:(void (^)(id))success
                 failure:(void (^)(HttpException *))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] put:NW_logout params:[param dictionaryModel] success:^(id responseObj) {
        
        if ([responseObj[@"apiStatus"] intValue] == 0) {
            if (success) {
                success(responseObj);
            }
        }
        
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
}


+ (void)MobileValidWithParams:(MobileValidModelR *)param
                      success:(void (^)(id))success
                      failure:(void (^)(HttpException *))failure
{
    {
        [[HttpClient sharedInstance] get:MobileValid params:[param dictionaryModel] success:^(id responseObj) {
            
            if (success) {
                success(responseObj);
            }
        } failure:^(HttpException *e) {
            
            if (failure) {
                failure(e);
            }
        }];
    }
}

+ (void)FetchLoginNameByPhoneWithParams:(NSDictionary *)param
                                success:(void (^)(id))success
                                failure:(void (^)(HttpException *))failure
{
    {
        [[HttpClient sharedInstance] get:FetchLoginNameByPhone params:param success:^(id responseObj) {
            
            if ([responseObj[@"apiStatus"] intValue] == 0) {
                if (success) {
                    success(responseObj);
                }
            }
            
        } failure:^(HttpException *e) {
            
            if (failure) {
                failure(e);
            }
        }];
    }
}

+ (void)ResetPasswordWithParams:(NSDictionary *)param
                        success:(void (^)(id responseObj))success
                        failure:(void (^)(HttpException *e))failure
{
    {
        [[HttpClient sharedInstance] post:ResetPassword params:param success:^(id responseObj) {
            
            if (success) {
                success(responseObj);
            }
        } failure:^(HttpException *e) {
            
            if (failure) {
                failure(e);
            }
        }];
    }
}

+ (void)StoreInfoCheckWithParams:(NSDictionary *)param
                         success:(void (^)(id))success
                         failure:(void (^)(HttpException *))failure;
{
    {
        HttpClientMgr.progressEnabled = NO;
        [[HttpClient sharedInstance] get:JG_infoCheck params:param success:^(id responseObj) {
            
            if (success) {
                success(responseObj);
            }
        } failure:^(HttpException *e) {
            
            if (failure) {
                failure(e);
            }
        }];
    }
}

+ (void)SearchTagQueryWithParams:(NSDictionary *)param
                         success:(void (^)(id))success
                         failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] get:ShopTagquery params:param success:^(id responseObj) {
        
        if ([responseObj[@"apiStatus"] intValue] == 0) {
            NSArray *array = [StoreTagModel parseArray:responseObj[@"list"]];
            if (success) {
                success(array);
            }
        }
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)SaveBranchWithParams:(SaveBranchModelR *)param
                     success:(void (^)(id))success
                     failure:(void (^)(HttpException *))failure
{
    {
        [[HttpClient sharedInstance] post:SaveInstitutionInfo params:[param dictionaryModel] success:^(id responseObj) {
            
            if (success) {
                success(responseObj);
            }
        } failure:^(HttpException *e) {
            
            if (failure) {
                failure(e);
            }
        }];
    }
    
}
+ (void)UpdateRegisterWithParams:(NSDictionary *)param
                         success:(void (^)(id))success
                         failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] put:UpdateBranch params:param success:^(id responseObj) {
        
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)QueryCertifiWithParams:(NSDictionary *)param
                       success:(void (^)(id))success
                       failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] get:SearchCerfiti params:param success:^(id responseObj) {
        
        QueryCertifiPage *page=[QueryCertifiPage parse:responseObj Elements:[QueryCertifiModel class] forAttribute:@"certifiList"];

        if (success) {
            success(page);
        }
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)UpdateBranchGroupTypeWithParams:(NSDictionary *)param
                                success:(void (^)(id))success
                                failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] put:UpdateBranchGroupType params:param success:^(id responseObj) {
        

        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)UpdateBranchStatusWithParams:(NSDictionary *)param
                             success:(void (^)(id))success
                             failure:(void (^)(HttpException *))failure
{
    {
        [[HttpClient sharedInstance] put:UpdateBranchStatus params:param success:^(id responseObj) {
            
            
            if (success) {
                success(responseObj);
            }
        } failure:^(HttpException *e) {
            
            if (failure) {
                failure(e);
            }
        }];
    }

}

+ (void)SavePharmacistWithParams:(NSDictionary *)param
                         success:(void (^)(id))success
                         failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] post:SavePharmacist params:param success:^(id responseObj) {
        
        
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)SavecerfitiWithParams:(NSDictionary *)param
                      success:(void (^)(id))success
                      failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] post:Savecerfiti params:param success:^(id responseObj) {
        
        
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
 *  更新商家机构信息
 */
+ (void)UpdateBranchWithParams:(NSDictionary *)param
                       success:(void(^)(id responseObj))success
                       failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance] post:Branch_updateBranchInfo params:param success:^(id responseObj) {
        
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
 *  3.5.23	修改机构执照(OK)
 */
+ (void)updateCertifiWithParams:(id)param
                        success:(void(^)(id responseObj))success
                        failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance] put:Branch_updateCertifi params:[param dictionaryModel] success:^(id responseObj) {
        
        BranchModel *branchModel = [BaseAPIModel parse:responseObj];
        
        if (success) {
            success(branchModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure (e);
        }
    }];
}

/**
 *  3.5.28	修改药师信息(OK)
 */
+ (void)updatePharmacistWithParams:(NSDictionary *)param
                           success:(void(^)(id responseObj))success
                           failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance]post:Branch_updatePharmacist params:param success:^(id responseObj) {
        //Branch_savePharmacist
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
 *  @brief 查询药店药师信息
 *
 *   queryPharmacist
 */

+ (void)queryPharmacistWithGroupId:(NSString *)groupId
                           success:(void(^)(id responseObj))success
                           failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance] get:Branch_queryPharmacist params:@{@"branchId":StrFromObj(groupId)} success:^(id responseObj)
    {
        PharmacistListModel *listModel = [PharmacistListModel parse:responseObj];
        
        if (success) {
            success(listModel);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)queryPharmacistNewWithGroupId:(NSString *)groupId
                              success:(void(^)(id responseObj))success
                              failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance] get:Branch_queryPharmacistNew params:@{@"branchId":StrFromObj(groupId)} success:^(id responseObj) {
        
        PharmacistListModel *listModel = [PharmacistListModel parse:responseObj Elements:[PharmacistMemberModel class] forAttribute:@"list"];
        
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
 *  @brief 查询药店药师审核信息
 *
 *   queryPharmacistApprove
 */

+ (void)queryPharmacistApproveWithGroupId:(NSString *)groupId
                                  success:(void(^)(id responseObj))success
                                  failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance] get:Branch_queryPharmacistApprove params:@{@"branchId":StrFromObj(groupId)} success:^(id responseObj) {
        
        PharmacistListModel *listModel = [PharmacistListModel parse:responseObj];
        
        if (success) {
            success(listModel);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)getWenyaoActivityList:(WenyaoActivityListR *)param
                      success:(void (^)(ActNoticeListModel *))success
                         fail:(void (^)(HttpException *))failure
{
    [HttpClientMgr get:API_Store_GetWenyaoActivityList params:[param dictionaryModel] success:^(id responseObj) {
        NSMutableArray *keyArray = [NSMutableArray array];
        [keyArray addObject:NSStringFromClass([ActNoticeModel class])];
        
        NSMutableArray *valueArray = [NSMutableArray array];
        [valueArray addObject:@"list"];
        
        ActNoticeListModel *model = [ActNoticeListModel parse:responseObj ClassArr:keyArray Elements:valueArray];
        if (success) {
            success(model);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)noticeWithParams:(NSDictionary *)param
                 success:(void(^)(NoticeModel* actNoticeList))success
                    fail:(void(^)(HttpException *e))failure{

    [HttpClientMgr get:GetNotice params:param success:^(id responseObj) {
      
        if (success) {
            success(responseObj);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];

}

+ (void)getWenyaoActivityListWithoutProgress:(WenyaoActivityListR *)param
                                     success:(void (^)(ActNoticeListModel *))success
                                        fail:(void (^)(HttpException *))failure
{
    [HttpClientMgr getWithoutProgress:API_Store_GetWenyaoActivityList params:[param dictionaryModel] success:^(id responseObj) {
        NSMutableArray *keyArray = [NSMutableArray array];
        [keyArray addObject:NSStringFromClass([ActNoticeModel class])];
        
        NSMutableArray *valueArray = [NSMutableArray array];
        [valueArray addObject:@"list"];
        
        ActNoticeListModel *model = [ActNoticeListModel parse:responseObj ClassArr:keyArray Elements:valueArray];
        if (success) {
            success(model);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)configInfoQueryBanner:(ConfigInfoQueryModelR *)model
                      success:(void(^)(BannerInfoListModel* responseObj))success
                      failure:(void(^)(HttpException *e))failure{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:ConfigInfoQueryBanner params:[model dictionaryModel] success:^(id responseObj) {
        HttpClientMgr.progressEnabled = NO;
        BannerInfoListModel *listModel = [BannerInfoListModel parse:responseObj Elements:[BannerInfoModel class] forAttribute:@"list"];
        if (success) {
            success(listModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)getTrainDetail:(GetTrainDetailR *)param
               success:(void (^)(TrainModel *))success
                  fail:(void (^)(HttpException *))failure
{
    [HttpClientMgr getWithoutProgress:API_Store_GetTrainDetails params:[param dictionaryModel] success:^(id responseObj) {
        TrainModel* model = [TrainModel parse:responseObj];
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)getTrainList:(GetTrainListR *)param
             success:(void (^)(TrainListModel *))success
                fail:(void (^)(HttpException *))failure
{
    [HttpClientMgr get:API_Store_GetTrainList params:[param dictionaryModel] success:^(id responseObj) {
        NSMutableArray *keyArray = [NSMutableArray array];
        [keyArray addObject:NSStringFromClass([TrainModel class])];
        
        NSMutableArray *valueArray = [NSMutableArray array];
        [valueArray addObject:@"trainList"];
        
        TrainListModel *model = [TrainListModel parse:responseObj ClassArr:keyArray Elements:valueArray];
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)getTrainListWithoutProgress:(GetTrainListR *)param success:(void (^)(TrainListModel *))success fail:(void (^)(HttpException *))failure
{
    [HttpClientMgr getWithoutProgress:API_Store_GetTrainList params:[param dictionaryModel] success:^(id responseObj) {
        NSMutableArray *keyArray = [NSMutableArray array];
        [keyArray addObject:NSStringFromClass([TrainModel class])];
        
        NSMutableArray *valueArray = [NSMutableArray array];
        [valueArray addObject:@"trainList"];
        
        TrainListModel *model = [TrainListModel parse:responseObj ClassArr:keyArray Elements:valueArray];
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)getProductSales:(GetProductSalesR *)param
                success:(void (^)(ProductSalesListModel *))success
                   fail:(void (^)(HttpException *))failure
{
    [HttpClientMgr getWithoutProgress:API_Store_GetProductMarket params:[param dictionaryModel] success:^(id responseObj) {
        NSMutableArray *keyArray = [NSMutableArray array];
        [keyArray addObject:NSStringFromClass([ProductStatiticsModel class])];
        
        NSMutableArray *valueArray = [NSMutableArray array];
        [valueArray addObject:@"list"];
        
        ProductSalesListModel *model = [ProductSalesListModel parse:responseObj ClassArr:keyArray Elements:valueArray];
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+(void)queryEmployees:(NSDictionary *)param
              success:(void (^)(EmployeeInfoModel *))success
                 fail:(void (^)(HttpException *))failure
{
    [HttpClientMgr get:API_Store_QueryEmployees params:param success:^(id responseObj) {
        EmployeeInfoModel* model = [EmployeeInfoModel parse:responseObj];
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)employeeSign:(NSDictionary *)param
             success:(void (^)(StoreUserSignModel *))success
                fail:(void (^)(HttpException *))failure
{
    [HttpClientMgr getWithoutProgress:API_StoreEmployee_Sign params:param success:^(id responseObj) {
        StoreUserSignModel* apiModel = [StoreUserSignModel parse:responseObj];
        if (success) {
            success(apiModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

@end
