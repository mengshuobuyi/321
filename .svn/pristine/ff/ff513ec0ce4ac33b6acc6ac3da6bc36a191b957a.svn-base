//
//  System.m
//  APP
//
//  Created by qw on 15/3/13.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "System.h"

@implementation System

//系统心跳接口 HeartBeat
+ (void)heartBeatWithParams:(NSDictionary *)param
                    success:(void (^)(id))success
                    failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] post:HeartBeat params:param success:^(id obj) {
        if (success) {
            HeartBeatModel *heartBeat = [HeartBeatModel parse:obj];
            success(heartBeat);
        }
    } failure:^(HttpException *e) {
        NSLog(@"%@",e);
        if (failure) {
            failure(e);
        }
    }];
}

//系统服务器时间 CheckTime
+ (void)checkTimeWithParams:(NSDictionary *)param
                    success:(void (^)(CheckTimeModel *))success
                    failure:(void (^)(HttpException *))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] getRawWithoutProgress:[NSString stringWithFormat:@"%@/time",DE_H5_DOMAIN_URL] params:param success:^(id obj) {
        if (success) {
            CheckTimeModel *model = [CheckTimeModel parse:obj];
            success(model);
        }
    } failure:^(HttpException *e) {
        DebugLog(@"%@",e);
        if (failure) {
            failure(e);
        }
    }];
}

//更新deviceToken推送号
+ (void)updateDeviceByToken:(NSDictionary *)param
                    success:(void (^)(id))success
                    failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] post:UpdateDeviceByToken params:param success:^(id obj) {
        if (success) {

        }
    } failure:^(HttpException *e) {
        NSLog(@"%@",e);
        if (failure) {
            failure(e);
        }
    }];
}

//app是否可以收集日志
+ (void)systemAppLogFlagWithParams:(SystemModelR *)param
                           success:(void (^)(AppLogFlagModel *))success
                           failure:(void (^)(HttpException *))failure
{
    [HttpClientMgr get:AppLogFlag params:[param dictionaryModel] success:^(id responseObj) {
        AppLogFlagModel *model = [AppLogFlagModel parse:responseObj];
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
    
}

//app上传日志
+ (void)systemAppUploadLogWithParams:(NSDictionary *)param
                             success:(void (^)(id))success
                             failure:(void (^)(HttpException *))failure
{
    [HttpClientMgr get:SystemShort params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
    
    
}


//3.13.9	App是否后台状态设置
+ (void)systemBackSetWithParams:(SystemModelR *)param
                        success:(void (^)(id))success
                        failure:(void (^)(HttpException *))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] put:SystemBackSet params:[param dictionaryModel] success:^(id obj) {
        if (success) {
            success(obj);
        }
    } failure:^(HttpException *e) {
        NSLog(@"%@",e);
        if (failure) {
            failure(e);
        }
    }];
}

//设置推送状态
+ (void)systemPushSetWithParams:(NSDictionary *)param
                        success:(void (^)(id))success
                        failure:(void (^)(HttpException *))failure
{
    [HttpClientMgr put:SystemPushSet params:param success:^(id responseObj) {
        
        if (success) {
            success(responseObj);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

//更新DeviceToken
+ (void)updateDeviceToken:(NSString *)deviceToken token:(NSString*)token
                        success:(void (^)(id))success
                        failure:(void (^)(HttpException *))failure
{
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    if (deviceToken) {
        param[@"deviceToken"]=deviceToken;
    }
    if (token) {
        param[@"token"]=token;
    }
    [HttpClientMgr post:UpdateDeviceToken params:param success:^(id responseObj) {
        
        if (success) {
            success(responseObj);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)rptShareSaveLog:(RptShareSaveLogModelR *)param
                success:(void (^)(id))success
                failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] post:RptShareSaveLog params:[param dictionaryModel] success:^(id obj) {
        if (success) {
            success(obj);
        }
    } failure:^(HttpException *e) {
        DebugLog(@"%@",e);
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)systemShortWithParams:(NSDictionary *)param
                      success:(void (^)(id))success
                      failure:(void (^)(HttpException *))failure
{
    [HttpClientMgr get:SystemShort params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}


//检测域名是否被封
+ (void)systemDomainIsParams:(NSDictionary *)param
                     success:(void (^)(id))success
                     failure:(void (^)(HttpException *))failure
{
    [HttpClientMgr CutomGet:GetDomianIs params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

//获取新域名
+ (void)systemNewDomainParams:(NSDictionary *)param
                      success:(void (^)(id))success
                      failure:(void (^)(HttpException *))failure
{
    [HttpClientMgr CutomGet:GetNewDomain params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}


//检测域名是否被封
+ (void)systemDomainIsTwiceParams:(NSDictionary *)param
                          success:(void (^)(id))success
                          failure:(void (^)(HttpException *))failure
{
    [HttpClientMgr CutomTwiceGet:GetDomianIs params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

//获取新域名
+ (void)systemNewDomainTwiceParams:(NSDictionary *)param
                           success:(void (^)(id))success
                           failure:(void (^)(HttpException *))failure
{
    [HttpClientMgr CutomTwiceGet:GetNewDomain params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

//获取IOS审核状态
+ (void)systemCheckIosAuditParams:(NSDictionary *)param
                          success:(void (^)(BaseAPIModel *))success
                          failure:(void (^)(HttpException *))failure
{
    [HttpClientMgr get:CheckIOSAudit params:param success:^(id responseObj) {
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
