//
//  IMAPI.m
//  AppFramework
//
//  Created by Yan Qingyang on 15/5/25.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//

#import "ChatAPI.h"
#import "IMApiUrl.h"
#import "IMHttpClient.h"
@implementation ChatAPI
#pragma mark - XP聊天
#pragma mark client
+ (void)XPClientAllMessagesWithID:(NSString *)consultId
                          success:(void(^)(CustomerConsultDetailList *model))success
                          failure:(void (^)(HttpException *e))failure
{
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    if (QWGLOBALMANAGER.configure.userToken) {
        param[@"token"]=QWGLOBALMANAGER.configure.userToken;
    }
    if (consultId) {
        param[@"consultId"]=consultId;
    }
    [IMManager getWithoutProgress:XPClientAllMessages params:param success:^(id responseObj) {
        if(success) {
            CustomerConsultDetailList *consultDetail = [CustomerConsultDetailList parse:responseObj Elements:[ConsultDetail class] forAttribute:@"details"];
            success(consultDetail);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}


+ (void)XPClientPollMessagesWithID:(NSString *)consultId
                           success:(void(^)(CustomerConsultDetailList *model))success
                           failure:(void (^)(HttpException *e))failure
{
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    if (QWGLOBALMANAGER.configure.userToken) {
        param[@"token"]=QWGLOBALMANAGER.configure.userToken;
    }
    if (consultId) {
        param[@"consultId"]=consultId;
    }
    [IMManager getWithoutProgress:XPClientPollMessages params:param success:^(id responseObj) {
        if(success){
            CustomerConsultDetailList *consultDetail = [CustomerConsultDetailList parse:responseObj Elements:[ConsultDetail class] forAttribute:@"details"];
            success(consultDetail);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

//商户
+ (void)XPStoreAllMessagesWithID:(NSString *)consultId
                         success:(void(^)(PharConsultDetail *model))success
                         failure:(void (^)(HttpException *e))failure{
    //XPStoreAllMessages
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    if (QWGLOBALMANAGER.configure.userToken) {
        param[@"token"]=QWGLOBALMANAGER.configure.userToken;
    }
    if (consultId) {
        param[@"consultId"]=consultId;
    }
    [IMManager getWithoutProgress:XPStoreAllMessages params:param success:^(id responseObj) {
        if(success){
            PharConsultDetail *consultDetail = [PharConsultDetail parse:responseObj Elements:[ConsultDetail class] forAttribute:@"details"];
            success(consultDetail);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)XPStorePollMessagesWithID:(NSString *)consultId
                          success:(void(^)(PharConsultDetail *model))success
                          failure:(void (^)(HttpException *e))failure{
    //XPStorePollMessages
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    if (QWGLOBALMANAGER.configure.userToken) {
        param[@"token"]=QWGLOBALMANAGER.configure.userToken;
    }
    if (consultId) {
        param[@"consultId"]=consultId;
    }
    [IMManager getWithoutProgress:XPStorePollMessages params:param success:^(id responseObj) {
        if(success){
            PharConsultDetail *consultDetail = [PharConsultDetail parse:responseObj Elements:[ConsultDetail class] forAttribute:@"details"];
            success(consultDetail);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}
#pragma mark create/read/delete
+ (void)XPDeleteAMessageWithParams:(XPRemove *)param
                           success:(void(^)(id obj))success
                           failure:(void(^)(HttpException * e))failure
{
    [IMManager putWithoutProgress:XPDeleteMessage params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)XPSendAMessageWithParams:(XPCreate *)param
                         success:(void(^)(ConsultDetailCreateModel *obj))success
                         failure:(void(^)(HttpException * e))failure
{
    [IMManager postWithoutProgress:XPSendMessage params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            ConsultDetailCreateModel *detailCreateModel = [ConsultDetailCreateModel parse:responseObj];
            success(detailCreateModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)XPReadMessagesWithParams:(XPRead *)param
                         success:(void (^)(ConsultModel *responModel))success
                         failure:(void (^)(HttpException *e))failure
{
    [IMManager putWithoutProgress:XPReadMessage params:[param dictionaryModel] success:^(id responseObj) {
        ConsultModel *model = (ConsultModel *)responseObj;
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}
#pragma mark - PTP聊天
#pragma mark client
+ (void)PTPClientAllMessagesWithParams:(GetByPharModelR *)param
                               success:(void (^)(CustomerSessionDetailList *responModel))succsee
                               failure:(void (^)(HttpException *e))failure
{
    
    [IMManager getWithoutProgress:PTPClientAllMessages params:[param dictionaryModel] success:^(id responseObj) {
        CustomerSessionDetailList *mm = [CustomerSessionDetailList parse:responseObj Elements:[SessionDetailVo class] forAttribute:@"details"];
        if (succsee) {
            succsee(mm);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)PTPClientPollMessagesWithID:(NSString *)sessionId
                            success:(void (^)(CustomerSessionDetailList *responModel))succsee
                            failure:(void (^)(HttpException *e))failure
{
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    if (QWGLOBALMANAGER.configure.userToken) {
        param[@"token"]=QWGLOBALMANAGER.configure.userToken;
    }
    if (sessionId) {
        param[@"sessionId"]=sessionId;
    }
    
    [IMManager getWithoutProgress:PTPClientPollMessages params:param success:^(id responseObj) {
        CustomerSessionDetailList *mm = [CustomerSessionDetailList parse:responseObj Elements:[SessionDetailVo class] forAttribute:@"details"];
        if (succsee) {
            succsee(mm);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)PTPStoreAllMessagesWithParams:(GetByCustomerModelR *)param
                              success:(void (^)(PharSessionDetailList *responModel))succsee
                              failure:(void (^)(HttpException *e))failure{
    //PTPStoreAllMessages
    [IMManager getWithoutProgress:PTPStoreAllMessages params:[param dictionaryModel] success:^(id responseObj) {
        PharSessionDetailList *mm = [PharSessionDetailList parse:responseObj Elements:[SessionDetailVo class] forAttribute:@"details"];
        if (succsee) {
            succsee(mm);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)PTPStorePollMessagesWithID:(NSString *)sessionId
                           success:(void (^)(PharSessionDetailList *responModel))succsee
                           failure:(void (^)(HttpException *e))failure{
    //PTPStorePollMessages
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    if (QWGLOBALMANAGER.configure.userToken) {
        param[@"token"]=QWGLOBALMANAGER.configure.userToken;
    }
    if (sessionId) {
        param[@"sessionId"]=sessionId;
    }
    
    [IMManager getWithoutProgress:PTPStorePollMessages params:param success:^(id responseObj) {
        PharSessionDetailList *mm = [PharSessionDetailList parse:responseObj Elements:[SessionDetailVo class] forAttribute:@"details"];
        if (succsee) {
            succsee(mm);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

#pragma mark create/read/delete
+ (void)PTPSendAMessageWithParams:(PTPCreate *)param
                          success:(void (^)(DetailCreateResult *responModel))succsee
                          failure:(void (^)(HttpException *e))failure
{
    
    [IMManager postWithoutProgress:PTPSendMessage params:[param dictionaryModel] success:^(id responseObj) {
        DetailCreateResult *listModel = [DetailCreateResult parse:responseObj ];
        if (succsee) {
            succsee(listModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)PTPReadMessagesWithParams:(PTPRead *)param
                          success:(void (^)(ApiBody *responModel))succsee
                          failure:(void (^)(HttpException *e))failure
{
    
    [IMManager putWithoutProgress:PTPReadMessage params:[param dictionaryModel] success:^(id responseObj) {
        ApiBody *listModel = [ApiBody parse:responseObj ];
        if (succsee) {
            succsee(listModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)PTPDeleteAMessageWithParams:(PTPRemove *)param
                            success:(void (^)(ApiBody *responModel))succsee
                            failure:(void (^)(HttpException *e))failure
{
    
    [IMManager putWithoutProgress:PTPDeleteMessage params:[param dictionaryModel] success:^(id responseObj) {
        ApiBody *listModel = [ApiBody parse:responseObj  ];
        if (succsee) {
            succsee(listModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}
@end
