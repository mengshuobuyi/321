//
//  Employ.m
//  wenYao-store
//
//  Created by Meng on 15/4/7.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "Employee.h"



@implementation Employee


+ (void)employeeQueryWithGroupId:(NSString *)groupId
                       success:(void (^)(id responseObj))success
                       failure:(void (^)(HttpException *e))failure
{
    NSDictionary *setting = @{@"token":groupId};
    
    [[HttpClient sharedInstance] get:Branch_employeeQuery params:setting success:^(id responseObj) {
        EmployeeQueryListModel *listModel = [EmployeeQueryListModel parse:responseObj Elements:[EmployeeQueryModel class] forAttribute:@"list"];
        if (success) {
            success(listModel);
        }
    } failure:^(HttpException *e) {
        if(failure){
            failure(e);
        }
    }];
}


+ (void)employeeCreateWithParam:(id)param
                        success:(void (^)(id responseObj))success
                        failure:(void (^)(HttpException *e))failure
{
    [[HttpClient sharedInstance] post:Branch_employeeCreate params:[param dictionaryModel] success:^(id responseObj) {
        EmployeeModel *model = [EmployeeModel parse:responseObj];
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if(failure){
            failure(e);
        }
    }];
}

+ (void)employeeEditWithParam:(id)param
                      success:(void (^)(id responseObj))success
                      failure:(void (^)(HttpException *e))failure
{
    [[HttpClient sharedInstance] put:Branch_employeeEdit params:[param dictionaryModel] success:^(id responseObj) {
        
        EmployeeModel *model = [EmployeeModel parse:responseObj];
        if (success) {
            success(model);
        }
        
    } failure:^(HttpException *e) {
        if(failure){
            failure(e);
        }
    }];
}



+ (void)employeeRemoveWithIds:(NSString *)ids
                        success:(void (^)(id responseObj))success
                        failure:(void (^)(HttpException *e))failure
{
    NSDictionary *setting = @{@"employee":ids};
    [[HttpClient sharedInstance] put:Branch_employeeRemove params:setting success:^(id responseObj) {
        
        if (success) {
            success(responseObj);
        }
        
    } failure:^(HttpException *e) {
        if(failure){
            failure(e);
        }
    }];
}

+ (void)employeeGetInfoWithParam:(NSDictionary *)param
                         success:(void (^)(id responseObj))success
                         failure:(void (^)(HttpException *e))failure
{
    [HttpClientMgr get:EmployeeGetInfo params:param success:^(id responseObj) {
        
        EmployeeInfoModel *model = [EmployeeInfoModel parse:responseObj];
        if (success) {
            success(model);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)employeeUpdateEmployeeWithParam:(NSDictionary *)param
                                success:(void (^)(id responseObj))success
                                failure:(void (^)(HttpException *e))failure
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

+ (void)employeeQueryEmpLvlInfo:(EmployeeLvlInfoR *)param success:(void(^)(EmpLvlInfoVo *response))success failure:(void(^)(HttpException *e))failure {
    [[HttpClient sharedInstance] get:QueryEmpLvlInfo params:[param dictionaryModel] success:^(id responseObj) {
        EmpLvlInfoVo *listModel = [EmpLvlInfoVo parse:responseObj];
        if (success) {
            success(listModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}
@end
