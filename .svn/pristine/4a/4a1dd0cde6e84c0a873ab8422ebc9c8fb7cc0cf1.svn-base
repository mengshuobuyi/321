//
//  Customer.m
//  APP
//
//  Created by chenzhipeng on 3/25/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import "Customer.h"
#import "MyCustomerBaseModel.h"
#import "CustomerModel.h"

@implementation Customer
+ (void)QueryCustomerWithParams:(CustomerQueryIndexModelR *)param
                        success:(void (^)(id obj))success
                        failure:(void(^)(HttpException * e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:QueryCustomer params:[param dictionaryModel] success:^(id responseObj) {
        
        if (success) {
            NSDictionary *dicData = (NSDictionary *)responseObj;
            success(dicData[@"data"]);
        }
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
}
+ (void)DeleteCustomerWithParams:(CustomerDeleteModelR *)param
                         success:(void (^)(id obj))success
                         failure:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] put:deleteCustomerLabel params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)QueryCustomerInfoWithParams:(CustomerDetailInfoModelR *)param
                            success:(void (^)(id obj))success
                             failue:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] get:QueryCustomerInfo params:[param dictionaryModel] success:^(id responseObj) {
        
        if (success) {
            MyCustomerInfoModel *modelInfo = [MyCustomerInfoModel parse:responseObj Elements:[MyCustomerNcdLabelModel class] forAttribute:@"ncdTags"];
            success(modelInfo);
        }
        
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)QueryCustomerDrugWithParams:(CustomerDrugModelR *)param
                            success:(void (^)(id obj))success
                             failue:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] get:QueryCustomerDrug params:[param dictionaryModel] success:^(id responseObj) {
        
        if ([responseObj[@"apiStatus"] intValue] == 0) {
            if (success) {
                NSMutableArray *keyArr = [NSMutableArray array];
                NSMutableArray *valueArr = [NSMutableArray array];
                [keyArr addObject:NSStringFromClass([CustomerDrugListModel class])];
                [valueArr addObject:@"list"];
                MyCustomerDrugListModel *listModel = [MyCustomerDrugListModel parse:responseObj ClassArr:keyArr Elements:valueArr];
                success(listModel);
            }
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}
+ (void)QueryCustomerAppriseWithParams:(CustomerAppriseModelR *)param
                               success:(void (^)(id obj))success
                                failue:(void(^)(HttpException * e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:GetAppraise params:[param dictionaryModel] success:^(id responseObj) {
        
        if ([responseObj[@"apiStatus"] intValue] == 0) {
            if (success) {
                MyCustomerAppriseListModel *listModel = [MyCustomerAppriseListModel parse:responseObj Elements:[CustomerAppriseModel class] forAttribute:@"list"];
                success(listModel);
            }
        }
        
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)QueryCustomerTagsWithParams:(CustomerTagsModelR *)param
                            success:(void (^)(id obj))success
                             failue:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] get:QueryCustomerTags params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            BaseAPIModel *modelApi = [BaseAPIModel parse:responseObj];
            NSDictionary *dicResponse = (NSDictionary *)responseObj;
            NSLog(@"%@",responseObj);
            if ([modelApi.apiStatus intValue] == 0) {
                NSDictionary *dicArr = (NSDictionary *)responseObj;
                success(responseObj[@"tags"]);
            } else {
                success([NSArray array]);
            }
            
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)UpdateCustomerTagsWithParams:(CustomerUpdateTagsModelR *)param
                             success:(void (^)(id obj))success
                              failue:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] put:CustomerTags params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            NSLog(@"%@",responseObj);
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}
+ (void)RemoveCustomerTagsWithParams:(CustomerRemoveTagsModelR *)param
                             success:(void (^)(id obj))success
                              failue:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] put:RemoveCustomerTags params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            NSLog(@"%@",responseObj);
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}
+ (void)AddCustomerTagWithParams:(CustomerAddTagModelR *)param
                         success:(void (^)(id obj))success
                          failue:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] post:QueryCustomerTags params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            NSLog(@"%@",responseObj);
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)CustomerCountListWithParams:(NSDictionary *)param
                            success:(void (^)(id obj))success
                             failue:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] get:CustomerInfoCount params:param success:^(id responseObj) {
        
        CustomerCountListModel *model = [CustomerCountListModel parse:responseObj];
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)CustomerGroupCreateWithParams:(NSDictionary *)param
                              success:(void (^)(id obj))success
                               failue:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] post:CustomerGroupCreate params:param success:^(id responseObj) {
        
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)CustomerGroupListWithParams:(NSDictionary *)param
                            success:(void (^)(id obj))success
                             failue:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] get:CustomerGroupList params:param success:^(id responseObj) {
        
        if ([responseObj[@"apiStatus"] integerValue] == 0) {
            NSArray *list = [CustomerGroupModel parseArray:responseObj[@"list"]];
            if (success) {
                success(list);
            }
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)CustomerGroupUpdateWithParams:(NSDictionary *)param
                              success:(void (^)(id obj))success
                               failue:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] put:CustomerGroupUpdate params:param success:^(id responseObj) {
        
        if (success) {
            success(responseObj);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)CustomerGroupRemoveWithParams:(NSDictionary *)param
                              success:(void (^)(id obj))success
                               failue:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] put:CustomerGroupRemove params:param success:^(id responseObj) {
        
        if (success) {
            success(responseObj);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];

}

+ (void)CustomerGroupCustAddWithParams:(NSDictionary *)param
                               success:(void (^)(id obj))success
                                failue:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] post:CustomerCustAdd params:param success:^(id responseObj) {
        
        if (success) {
            success(responseObj);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)CustomerGroupCustRemoveWithParams:(NSDictionary *)param
                                  success:(void (^)(id obj))success
                                   failue:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] put:CustomerCustRemove params:param success:^(id responseObj) {
        
        if (success) {
            success(responseObj);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)CustomerGroupCustListWithParams:(NSDictionary *)param
                                success:(void (^)(id obj))success
                                 failue:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] get:CustomerCustList params:param success:^(id responseObj) {
        
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
 *  3.2 获取会员微商订单列表
 */
+(void)queryCustomerOrderListWithParams:(CustomerOrderListModelR *)params success:(void(^)(CustomerOrdersVoModel *responseModel))success failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance] get:CustomerQueryOrderList params:[params dictionaryModel] success:^(id responseObj) {
        CustomerOrdersVoModel *list=[CustomerOrdersVoModel parse:responseObj Elements:[CustomerOrderVoModel class] forAttribute:@"memberOrderListVOs"];
        if (success) {
            success(list);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}
@end
