//
//  IMAPI.h
//  AppFramework
//
//  Created by Yan Qingyang on 15/5/25.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConsultPTPR.h"
#import "ConsultPTPModel.h"
#import "ConsultModel.h"
#import "IMHttpClient.h"
#import "ConsultModelR.h"
#import "QWGlobalManager.h"
@interface ChatAPI : NSObject
#pragma mark - 普通聊天
//用户
+ (void)XPClientAllMessagesWithID:(NSString *)consultId
                          success:(void(^)(CustomerConsultDetailList *model))success
                          failure:(void (^)(HttpException *e))failure;

+ (void)XPClientPollMessagesWithID:(NSString *)consultId
                           success:(void(^)(CustomerConsultDetailList *model))success
                           failure:(void (^)(HttpException *e))failure;

//商户
+ (void)XPStoreAllMessagesWithID:(NSString *)consultId
                         success:(void(^)(PharConsultDetail *model))success
                         failure:(void (^)(HttpException *e))failure;

+ (void)XPStorePollMessagesWithID:(NSString *)consultId
                          success:(void(^)(PharConsultDetail *model))success
                          failure:(void (^)(HttpException *e))failure;
//增删读
+ (void)XPSendAMessageWithParams:(XPCreate *)param
                         success:(void(^)(ConsultDetailCreateModel *obj))success
                         failure:(void(^)(HttpException * e))failure;

+ (void)XPDeleteAMessageWithParams:(XPRemove *)param
                           success:(void(^)(id obj))success
                           failure:(void(^)(HttpException * e))failure;

+ (void)XPReadMessagesWithParams:(XPRead *)param
                         success:(void (^)(ConsultModel *responModel))success
                         failure:(void (^)(HttpException *e))failure;

#pragma mark - PTP聊天
//用户
+ (void)PTPClientAllMessagesWithParams:(GetByPharModelR *)param
                               success:(void (^)(CustomerSessionDetailList *responModel))succsee
                               failure:(void (^)(HttpException *e))failure;
+ (void)PTPClientPollMessagesWithID:(NSString *)sessionId
                            success:(void (^)(CustomerSessionDetailList *responModel))succsee
                            failure:(void (^)(HttpException *e))failure;
//商户
+ (void)PTPStoreAllMessagesWithParams:(GetByCustomerModelR *)param
                              success:(void (^)(PharSessionDetailList *responModel))succsee
                              failure:(void (^)(HttpException *e))failure;

+ (void)PTPStorePollMessagesWithID:(NSString *)sessionId
                           success:(void (^)(PharSessionDetailList *responModel))succsee
                           failure:(void (^)(HttpException *e))failure;

//增删读
+ (void)PTPSendAMessageWithParams:(PTPCreate *)param
                          success:(void (^)(DetailCreateResult *responModel))succsee
                          failure:(void (^)(HttpException *e))failure;
+ (void)PTPReadMessagesWithParams:(PTPRead *)param
                          success:(void (^)(ApiBody *responModel))succsee
                          failure:(void (^)(HttpException *e))failure;
+ (void)PTPDeleteAMessageWithParams:(PTPRemove *)param
                            success:(void (^)(ApiBody *responModel))succsee
                            failure:(void (^)(HttpException *e))failure;
#pragma mark - 全维药事
@end
