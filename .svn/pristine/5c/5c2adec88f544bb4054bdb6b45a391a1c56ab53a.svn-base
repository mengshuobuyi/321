//
//  System.h
//  APP
//
//  Created by qw on 15/3/13.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "SystemModelR.h"
#import "SystemModel.h"

@interface System : NSObject

//系统心跳接口 HeartBeat
+ (void)heartBeatWithParams:(NSDictionary *)param
                   success:(void (^)(id))success
                   failure:(void (^)(HttpException *))failure;

//3.13.9	App是否后台状态设置
+ (void)systemBackSetWithParams:(SystemModelR *)param
                        success:(void (^)(id))success
                        failure:(void (^)(HttpException *))failure;

//系统服务器时间 CheckTime
+ (void)checkTimeWithParams:(NSDictionary *)param
                    success:(void (^)(CheckTimeModel *))success
                    failure:(void (^)(HttpException *))failure;

//更新deviceToken推送号
+ (void)updateDeviceByToken:(NSDictionary *)param
                    success:(void (^)(id))success
                    failure:(void (^)(HttpException *))failure;

//设置推送状态
+ (void)systemPushSetWithParams:(NSDictionary *)param
                    success:(void (^)(id))success
                    failure:(void (^)(HttpException *))failure;

//更新DeviceToken
+ (void)updateDeviceToken:(NSString *)deviceToken token:(NSString*)token
                  success:(void (^)(id))success
                  failure:(void (^)(HttpException *))failure;

//app是否可以收集日志
+ (void)systemAppLogFlagWithParams:(SystemModelR *)param
                           success:(void (^)(AppLogFlagModel *))success
                           failure:(void (^)(HttpException *))failure;

//app上传日志
+ (void)systemAppUploadLogWithParams:(NSDictionary *)param
                             success:(void (^)(id))success
                             failure:(void (^)(HttpException *))failure;

//分享统计
+ (void)rptShareSaveLog:(RptShareSaveLogModelR *)param
                success:(void (^)(id))success
                failure:(void (^)(HttpException *))failure;

//转化端链接
+ (void)systemShortWithParams:(NSDictionary *)param
                        success:(void (^)(id))success
                        failure:(void (^)(HttpException *))failure;
//检测域名是否被封
+ (void)systemDomainIsParams:(NSDictionary *)param
                     success:(void (^)(id))success
                     failure:(void (^)(HttpException *))failure;

//获取新域名
+ (void)systemNewDomainParams:(NSDictionary *)param
                      success:(void (^)(id))success
                      failure:(void (^)(HttpException *))failure;


//检测域名是否被封
+ (void)systemDomainIsTwiceParams:(NSDictionary *)param
                          success:(void (^)(id))success
                          failure:(void (^)(HttpException *))failure;

//获取新域名
+ (void)systemNewDomainTwiceParams:(NSDictionary *)param
                           success:(void (^)(id))success
                           failure:(void (^)(HttpException *))failure;




//获取IOS审核状态
+ (void)systemCheckIosAuditParams:(NSDictionary *)param
                          success:(void (^)(BaseAPIModel *))success
                          failure:(void (^)(HttpException *))failure;
@end
