//
//  UserChat.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/3/24.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "UserChat.h"

@implementation UserChat

/**
 *    专家私聊会话列表
 *
 */
+ (void)TeamChatSessionGetAllWithParams:(NSDictionary *)param
                                success:(void(^)(id obj))success
                                failure:(void(^)(HttpException * e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [HttpClientMgr get:TeamChatSessionGetAll params:param success:^(id responseObj) {
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
 *    专家私聊会话列表轮询
 *
 */
+ (void)TeamChatSessionGetChatListWithParams:(NSDictionary *)param
                                     success:(void(^)(id obj))success
                                     failure:(void(^)(HttpException * e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [HttpClientMgr get:TeamChatSessionGetChatList params:param success:^(id responseObj) {
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
 *    私聊聊天详情
 *
 */
+ (void)TeamChatDetailGetAllWithParams:(NSDictionary *)param
                               success:(void(^)(id obj))success
                               failure:(void(^)(HttpException * e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [HttpClientMgr get:TeamChatDetailGetAll params:param success:^(id responseObj) {
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
 *    私聊聊天详情轮询
 *
 */
+ (void)TeamChatDetailGetChatDetailListWithParams:(NSDictionary *)param
                                          success:(void(^)(id obj))success
                                          failure:(void(^)(HttpException * e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [HttpClientMgr get:TeamChatDetailGetChatDetailList params:param success:^(id responseObj) {
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
 *    私聊发消息
 *
 */
+ (void)TeamChatDetailAddChatDetailWithParams:(PrivatePTPCreate *)param
                                      success:(void(^)(id obj))success
                                      failure:(void(^)(HttpException * e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [HttpClientMgr post:TeamChatDetailAddChatDetail params:[param dictionaryModel]success:^(id responseObj) {
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
 *    查询问答列表
 *
 */
+ (void)ImConsultQueryQAListWithParams:(NSDictionary *)param
                               success:(void(^)(id obj))success
                               failure:(void(^)(HttpException * e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [HttpClientMgr getWithoutProgress:ImConsultQueryQAList params:param success:^(id responseObj) {
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
 *    问答详情
 *
 */
+ (void)ImConsultQueryQADetailWithParams:(NSDictionary *)param
                                 success:(void(^)(id obj))success
                                 failure:(void(^)(HttpException * e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [HttpClientMgr get:ImConsultQueryQADetail params:param success:^(id responseObj) {
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
 *    问答详情轮询
 *
 */
+ (void)ImConsultLoopNewsWithParams:(NSDictionary *)param
                            success:(void(^)(id obj))success
                            failure:(void(^)(HttpException * e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [HttpClientMgr getWithoutProgress:ImConsultLoopNews params:param success:^(id responseObj) {
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
 *    问答发消息
 *
 */
+ (void)ImConsultReplyWithParams:(InterlocutionXPCreate *)param
                         success:(void(^)(id obj))success
                         failure:(void(^)(HttpException * e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [HttpClientMgr post:ImConsultReply params:[param dictionaryModel] success:^(id responseObj) {
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
 *    商户检查是否可以抢答
 *
 */
+ (void)ImConsultCheckCanRaceWithParams:(NSDictionary *)param
                                success:(void(^)(id obj))success
                                failure:(void(^)(HttpException * e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [HttpClientMgr post:ImConsultCheckCanRace params:param success:^(id responseObj) {
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
 *    专家忽略
 *
 */
+ (void)ImConsultIgnoreWithParams:(NSDictionary *)param
                          success:(void(^)(id obj))success
                          failure:(void(^)(HttpException * e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [HttpClientMgr post:ImConsultIgnore params:param success:^(id responseObj) {
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
 *    专家抢答
 *
 */
+ (void)ImConsultRaceWithParams:(NSDictionary *)param
                        success:(void(^)(id obj))success
                        failure:(void(^)(HttpException * e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [HttpClientMgr post:ImConsultRace params:param success:^(id responseObj) {
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
