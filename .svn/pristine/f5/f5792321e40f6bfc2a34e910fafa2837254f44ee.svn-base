//
//  Mbr.m
//  APP
//
//  Created by qwfy0006 on 15/3/19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "Mbr.h"
#import "QueryInfoByIdsModel.h"
#import "StoreModel.h"


@implementation Mbr

+ (void)tokenValidWithParams:(NSDictionary *)param
                     success:(void(^)(id obj))success
                     failure:(void(^)(HttpException * e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] getWithoutProgress:TokenValid
                               params:param
                              success:^(id resultObj) {
                                  
                                  CheckTokenModel *model = [CheckTokenModel parse:resultObj];
                                  if (success) {
                                      success(model);
                                  }
                              }
                              failure:^(HttpException *e) {
                                  NSLog(@"%@",e);
                                  if (failure) {
                                      failure(e);
                                  }
                              }];
}

+ (void)SendVerifyCodeWithParam:(SendVerifyCodeModelR *)param
                         success:(void (^)(id responseObj))success
                         failure:(void (^)(HttpException *e))failure
{
        [[HttpClient sharedInstance] post:PostSendVerifyCode params:[param dictionaryModel] success:^(id responseObj) {
    
            if (success) {
                success(responseObj);
            }
        } failure:^(HttpException *e) {
            
            if (failure) {
                failure(e);
            }
        }];

}

+ (void)QueryInfoByIdsWithParam:(NSDictionary *)param
                        success:(void (^)(id))success
                        failure:(void (^)(HttpException *))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:QueryInfoByIds params:param success:^(id responseObj) {
        NSArray *array = [QueryInfoByIdsModel parseArray:responseObj[@"list"]];
        if (success) {
            success(array);
        }
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *  3.5.9	校验手机验证码(OK)
 *
 */
+ (void)ValidVerifyCodeWithParam:(ValidVerifyCodeModelR *)param
                         success:(void (^)(id responseObj))success
                         failure:(void (^)(HttpException *e))failure
{
    [[HttpClient sharedInstance] post:PostValidVerifyCode params:[param dictionaryModel] success:^(id responseObj) {
        
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
/**
 *  @brief 3.5.40	校验手机号是否已经被注册(OK)
 */
+ (void)MobileValidWithMobile:(NSString *)mobile
                      success:(void (^)(id responseObj))success
                      failure:(void (^)(HttpException *e))failure
{
    NSDictionary *setting = @{@"mobile":mobile};
    [[HttpClient sharedInstance] get:MobileValid params:setting success:^(id responseObj) {
        
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
 *  专家登录
 *
 */
+ (void)MbrUserExpertLoginWithParam:(NSDictionary *)param
                            success:(void (^)(id))success
                            failure:(void (^)(HttpException *))failure
{
    [HttpClientMgr post:MbrUserExpertLogin params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)logoutWithParams:(NSDictionary *)param
                 success:(void(^)(id DFUserModel))success
                 failure:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] post:Expert_logout params:param success:^(id responseObj) {
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
 *  验证图片验证码
 *
 */
+ (void)MbrCodeSendCodeByImageVerifyWithParams:(NSDictionary *)param
                                       success:(void(^)(id DFUserModel))success
                                       failure:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] post:MbrCodeSendCodeByImageVerify params:param success:^(id responseObj) {
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
 *  检验4位验证码，不消耗验证码
 *
 */
+ (void)MbrCodeValidVerifyCodeOnly4checkWithParams:(NSDictionary *)param
                                           success:(void(^)(id DFUserModel))success
                                           failure:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] post:MbrCodeValidVerifyCodeOnly4check params:param success:^(id responseObj) {
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
 *  专家用户名密码登录
 *
 */
+ (void)MbrExpertLoginWithParams:(NSDictionary *)param
                         success:(void(^)(id DFUserModel))success
                         failure:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] post:MbrExpertLogin params:param success:^(id responseObj) {
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
 *  专家注册
 *
 */
+ (void)MbrExpertRegisterWithParams:(NSDictionary *)param
                            success:(void(^)(id DFUserModel))success
                            failure:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] post:MbrExpertRegister params:param success:^(id responseObj) {
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
 *  专家重置密码
 *
 */
+ (void)MbrExpertResetPasswordWithParams:(NSDictionary *)param
                                 success:(void(^)(id DFUserModel))success
                                 failure:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] post:MbrExpertResetPassword params:param success:^(id responseObj) {
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
 *  专家设置新密码／修改密码
 *
 */
+ (void)MbrExpertUpdatePasswordWithParams:(NSDictionary *)param
                                  success:(void(^)(id DFUserModel))success
                                  failure:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] post:MbrExpertUpdatePassword params:param success:^(id responseObj) {
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
 *  检测专家是否已存在
 *
 */
+ (void)MbrExpertRegisterValidWithParams:(NSDictionary *)param
                                 success:(void(^)(id DFUserModel))success
                                 failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:MbrExpertRegisterValid params:param success:^(id responseObj) {
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
 *  推荐人列表
 */
+ (void)queryMyRecommends:(NSDictionary *)param
                  success:(void (^)(MyRecommendListModel *))success
                  failure:(void (^)(HttpException *))failure
{
    [HttpClientMgr get:API_Store_queryMyRecommends params:param success:^(id responseObj) {
        NSMutableArray *keyArr = [NSMutableArray array];
        [keyArr addObject:NSStringFromClass([MyRecommendModel class])];
        
        NSMutableArray *valueArr = [NSMutableArray array];
        [valueArr addObject:@"myRecommends"];
        
        MyRecommendListModel *model = [MyRecommendListModel parse:responseObj ClassArr:keyArr Elements:valueArr];
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
 *  3.2.1 查询推荐顾客预定商品
 */
+ (void)queryRecommendBookProduct:(BookProductR *)param
                          success:(void (^)(BookProductListModel *))success
                          failure:(void (^)(HttpException *))failure
{
    [HttpClientMgr get:API_Store_QueryBookProduct params:[param dictionaryModel] success:^(id responseObj) {
        NSMutableArray *keyArr = [NSMutableArray array];
        [keyArr addObject:NSStringFromClass([BookProductModel class])];
        
        NSMutableArray *valueArr = [NSMutableArray array];
        [valueArr addObject:@"list"];
        
        BookProductListModel *model = [BookProductListModel parse:responseObj ClassArr:keyArr Elements:valueArr];
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
 *  本店信息的药师列表
 */
+ (void)MbrExpertQueryExpertByBranchIdWithParams:(NSDictionary*)param
                                         success:(void(^)(id DFUserModel))success
                                         failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:MbrExpertQueryExpertByBranchId params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}


+ (void)getServiceTelSuccess:(void (^)(ServiceTelModel *))success
                     failure:(void (^)(HttpException *))failure
{
    [HttpClientMgr getWithoutProgress:API_Store_GetServiceTelLists params:nil success:^(id responseObj) {
        ServiceTelModel* serviceTelModel = [ServiceTelModel parse:responseObj];
        if (success) {
            success(serviceTelModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *  设置专家上下线
 */
+ (void)MbrExpertUpdateOnlineFlagWithParams:(NSDictionary*)param
                                    success:(void(^)(id DFUserModel))success
                                    failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr post:MbrExpertUpdateOnlineFlag params:param success:^(id responseObj) {
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
