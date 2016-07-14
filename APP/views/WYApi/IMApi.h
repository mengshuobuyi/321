//
//  IMApi.h
//  APP
//
//  Created by qw on 15/3/9.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "IMApiModel.h"
#import "BaseAPIModel.h"

@interface IMApi : NSObject

//删除指定药店/客户的IM聊天记录DelAllMessage
+ (void)deleteallWithParams:(NSDictionary *)param
                      success:(void (^)(id))success
                      failure:(void (^)(HttpException *))failure;
//设置IM消息状态已接受IMSetReceived
+ (void)setReceivedWithParams:(NSDictionary *)param
                      success:(void (^)(id))success
                      failure:(void (^)(HttpException *))failure;

//获取所有未接收的会话记录 AlternativeIMSelect
+ (void)alternativeIMSelectWithParams:(NSDictionary *)param
                      success:(void (^)(id))success
                      failure:(void (^)(HttpException *))failure;

//默认30条，每个条目里面携带最近最多三个月的聊天记录
+ (void)chatViewWithParams:(NSDictionary *)param
                   success:(void (^)(id))success
                   failure:(void (^)(HttpException *))failure;

//查询全维药事聊天记录 SelectQWIM
+ (void)selectIMQwWithParams:(NSDictionary *)param
                     success:(void (^)(id))success
                     failure:(void (^)(HttpException *))failure;


//新增全维药事聊天记录 SelectQWIM
+ (void)selectIMQwNewlyAddedWithParams:(NSDictionary *)param
                               success:(void (^)(id))success
                               failure:(void (^)(HttpException *))failure;

//查询IM聊天记录数目 SelectIM
+ (void)selectIMWithParams:(NSDictionary *)param
                   success:(void (^)(id))success
                   failure:(void (^)(HttpException *))failure;

//推送设置 CheckCert
+ (void)certcheckIMWithParams:(NSDictionary *)param
                   success:(void (^)(BaseAPIModel *))success
                   failure:(void (^)(HttpException *))failure;

//删除IM聊天记录 DeleteIM
+ (void)deleteIMWithParams:(NSDictionary *)param
                   success:(void (^)(id))success
                   failure:(void (^)(HttpException *))failure;

//3.10.2	获取所有可用的快捷回复
+ (void)qReplyIMWithParams:(NSDictionary *)param
                   success:(void (^)(id))success
                   failure:(void (^)(HttpException *))failure;

//清空全维药事会话记录
+ (void)delQwRecordWithParams:(NSDictionary *)param
                   success:(void (^)(id))success
                   failure:(void (^)(HttpException *))failure;

//设置IM聊天条目是否置顶
+ (void)topChatViewWithParams:(NSDictionary *)param
                      success:(void (^)(id))success
                      failure:(void (^)(HttpException *))failure;

//24check    CheckTimeout
+ (void)checkTimeoutWithParams:(NSDictionary *)param
                       success:(void (^)(id))success
                       failure:(void (^)(HttpException *))failure;

//添加会话记录 官方    AddQWIM
+ (void)addQwIMWithParams:(NSDictionary *)param
                  success:(void (^)(id))success
                  failure:(void (^)(HttpException *))failure;



+ (void)pollByPhar:(NSDictionary *)param
           success:(void (^)(id))success
           failure:(void (^)(HttpException *))failure;
@end
