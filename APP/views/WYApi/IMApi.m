//
//  IMApi.m
//  APP
//
//  Created by qw on 15/3/9.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "IMApi.h"


@implementation IMApi

//删除指定药店/客户的IM聊天记录DelAllMessage
+ (void)deleteallWithParams:(NSDictionary *)param
                    success:(void (^)(id))success
                    failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] put:DelAllMessage params:param success:^(id obj) {
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
//设置IM消息状态已接受IMSetReceived
+ (void)setReceivedWithParams:(NSDictionary *)param
                      success:(void (^)(id))success
                      failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] put:IMSetReceived params:param success:^(id obj) {
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

+ (void)qReplyIMWithParams:(NSDictionary *)param
                   success:(void (^)(id))success
                   failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] get:QuickReply params:param success:^(id obj) {
        NSArray *array = [IMApiModel parseArray:obj[@"replys"]];
        if (success) {
            success(array);
        }
    } failure:^(HttpException *e) {
        NSLog(@"%@",e);
        if (failure) {
            failure(e);
        }
    }];
}

//获取所有未接收的会话记录 AlternativeIMSelect
+ (void)alternativeIMSelectWithParams:(NSDictionary *)param
                              success:(void (^)(id))success
                              failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] post:AlternativeIMSelect params:param success:^(id obj) {
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

//查询全维药事聊天记录 SelectQWIM
+ (void)selectIMQwWithParams:(NSDictionary *)param
                     success:(void (^)(id))success
                     failure:(void (^)(HttpException *))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:SelectQWIM params:param success:^(id obj) {
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

+ (void)pollByPhar:(NSDictionary *)param
                     success:(void (^)(id))success
                     failure:(void (^)(HttpException *))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] getWithoutProgress:PollByPhar params:param success:^(id obj) {
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
//新增全维药事聊天记录 SelectQWIM
+ (void)selectIMQwNewlyAddedWithParams:(NSDictionary *)param
                               success:(void (^)(id))success
                               failure:(void (^)(HttpException *))failure
{
    [HttpClient sharedInstance].progressEnabled = NO;
    [[HttpClient sharedInstance] post:SelectQWIM params: param success:^(id obj) {
        if (success) {
            success(obj);
        }
    } failure:^(HttpException *e) {
        //NSLog(@"%@",e);
        if (failure) {
            failure(e);
        }
    }];
}

//查询IM聊天记录数目 SelectIM
+ (void)selectIMWithParams:(NSDictionary *)param
                   success:(void (^)(id))success
                   failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] get:SelectIM params:param success:^(id obj) {
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

//默认30条，每个条目里面携带最近最多三个月的聊天记录
+ (void)chatViewWithParams:(NSDictionary *)param
                   success:(void (^)(id))success
                   failure:(void (^)(HttpException *))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:GetChatView params:param success:^(id obj) {

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

//推送设置 CheckCert
+ (void)certcheckIMWithParams:(NSDictionary *)param
                      success:(void (^)(BaseAPIModel *))success
                      failure:(void (^)(HttpException *))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:CheckCert params:param success:^(id obj) {
        BaseAPIModel *apiModel = [BaseAPIModel parse:obj];
        if (success) {
            success(apiModel);
        }
    } failure:^(HttpException *e) {
        NSLog(@"%@",e);
        if (failure) {
            failure(e);
        }
    }];
}

//删除IM聊天记录 DeleteIM
+ (void)deleteIMWithParams:(NSDictionary *)param
                   success:(void (^)(id))success
                   failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] put:DeleteIM params:param success:^(id obj) {
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

+ (void)delQwRecordWithParams:(NSDictionary *)param
                      success:(void (^)(id))success
                      failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] post:DelQwRecord params:param success:^(id obj) {
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

//设置IM聊天条目是否置顶
+ (void)topChatViewWithParams:(NSDictionary *)param
                      success:(void (^)(id))success
                      failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] put:TopChatView params:param success:^(id obj) {
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



//添加会话记录 官方    AddQWIM
+ (void)addQwIMWithParams:(NSDictionary *)param
                  success:(void (^)(id))success
                  failure:(void (^)(HttpException *))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] post:AddQWIM params:param success:^(id obj) {
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

@end
