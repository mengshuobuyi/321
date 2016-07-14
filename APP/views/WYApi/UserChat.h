//
//  UserChat.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/3/24.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "UserChatModelR.h"

@interface UserChat : NSObject

/**
 *    专家私聊会话列表
 *
 */
+ (void)TeamChatSessionGetAllWithParams:(NSDictionary *)param
                                success:(void(^)(id obj))success
                                failure:(void(^)(HttpException * e))failure;

/**
 *    专家私聊会话列表轮询
 *
 */
+ (void)TeamChatSessionGetChatListWithParams:(NSDictionary *)param
                                     success:(void(^)(id obj))success
                                     failure:(void(^)(HttpException * e))failure;

/**
 *    私聊聊天详情
 *
 */
+ (void)TeamChatDetailGetAllWithParams:(NSDictionary *)param
                               success:(void(^)(id obj))success
                               failure:(void(^)(HttpException * e))failure;

/**
 *    私聊聊天详情轮询
 *
 */
+ (void)TeamChatDetailGetChatDetailListWithParams:(NSDictionary *)param
                                          success:(void(^)(id obj))success
                                          failure:(void(^)(HttpException * e))failure;


/**
 *    私聊发消息
 *
 */
+ (void)TeamChatDetailAddChatDetailWithParams:(PrivatePTPCreate *)param
                                      success:(void(^)(id obj))success
                                      failure:(void(^)(HttpException * e))failure;

/**
 *    查询问答列表
 *
 */
+ (void)ImConsultQueryQAListWithParams:(NSDictionary *)param
                               success:(void(^)(id obj))success
                               failure:(void(^)(HttpException * e))failure;

/**
 *    问答详情
 *
 */
+ (void)ImConsultQueryQADetailWithParams:(NSDictionary *)param
                                 success:(void(^)(id obj))success
                                 failure:(void(^)(HttpException * e))failure;

/**
 *    问答详情轮询
 *
 */
+ (void)ImConsultLoopNewsWithParams:(NSDictionary *)param
                            success:(void(^)(id obj))success
                            failure:(void(^)(HttpException * e))failure;

/**
 *    问答发消息
 *
 */
+ (void)ImConsultReplyWithParams:(InterlocutionXPCreate *)param
                         success:(void(^)(id obj))success
                         failure:(void(^)(HttpException * e))failure;

/**
 *    商户检查是否可以抢答
 *
 */
+ (void)ImConsultCheckCanRaceWithParams:(NSDictionary *)param
                                success:(void(^)(id obj))success
                                failure:(void(^)(HttpException * e))failure;

/**
 *    专家忽略
 *
 */
+ (void)ImConsultIgnoreWithParams:(NSDictionary *)param
                          success:(void(^)(id obj))success
                          failure:(void(^)(HttpException * e))failure;

/**
 *    专家抢答
 *
 */
+ (void)ImConsultRaceWithParams:(NSDictionary *)param
                        success:(void(^)(id obj))success
                        failure:(void(^)(HttpException * e))failure;

@end
