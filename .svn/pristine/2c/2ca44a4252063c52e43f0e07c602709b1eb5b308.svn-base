//
//  Employ.h
//  wenYao-store
//
//  Created by Meng on 15/4/7.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "EmployeeModelR.h"
#import "EmployeeModel.h"
@interface Employee : NSObject


+ (void)employeeQueryWithGroupId:(NSString *)groupId
                         success:(void (^)(id responseObj))success
                         failure:(void (^)(HttpException *e))failure;


+ (void)employeeCreateWithParam:(id)param
                        success:(void (^)(id responseObj))success
                        failure:(void (^)(HttpException *e))failure;

+ (void)employeeEditWithParam:(id)param
                      success:(void (^)(id responseObj))success
                      failure:(void (^)(HttpException *e))failure;



+ (void)employeeRemoveWithIds:(NSString *)ids
                      success:(void (^)(id responseObj))success
                      failure:(void (^)(HttpException *e))failure;

//获取店员信息
+ (void)employeeGetInfoWithParam:(NSDictionary *)param
                         success:(void (^)(id responseObj))success
                         failure:(void (^)(HttpException *e))failure;


//更新店员信息
+ (void)employeeUpdateEmployeeWithParam:(NSDictionary *)param
                                success:(void (^)(id responseObj))success
                                failure:(void (^)(HttpException *e))failure;


//3.2我的等级
+ (void)employeeQueryEmpLvlInfo:(EmployeeLvlInfoR *)param
                        success:(void(^)(EmpLvlInfoVo *response))success
                        failure:(void(^)(HttpException *e))failure;


@end
