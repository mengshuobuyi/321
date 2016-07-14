//
//  ConsultPTP.h
//  APP
//
//  Created by carret on 15/6/4.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "HttpClient.h"
#import "ConsultPTPModel.h"
#import "ConsultPTPR.h"

@interface ConsultPTP : NSObject
//p2p  全量拉取消息
+ (void)getByCustomer:(GetByCustomerModelR *)param
              success:(void (^)(PharSessionDetailList *responModel))succsee
              failure:(void (^)(HttpException *e))failure;


//p2p增量拉取消息
+ (void)pollBySessionId:(PollBySessionidModelR *)param
                success:(void (^)(PharSessionDetailList *responModel))succsee
                failure:(void (^)(HttpException *e))failure;


+ (void)ptpMessagetCreate:(PTPCreate *)param
                  success:(void (^)(DetailCreateResult *responModel))succsee
                  failure:(void (^)(HttpException *e))failure;


+ (void)ptpMessagetRead:(PTPRead *)param
                success:(void (^)(ApiBody *responModel))succsee
                failure:(void (^)(HttpException *e))failure;


+ (void)ptpMessagetRemove:(PTPRemove *)param
                  success:(void (^)(ApiBody *responModel))succsee
                  failure:(void (^)(HttpException *e))failure;


+ (void)ptpCheckTimeoutWithParams:(PTP24Check *)param
                          success:(void (^)(id))success
                          failure:(void (^)(HttpException *))failure;


//会同时删除该会话下所有聊天记录（针对药师）
+ (void)ptpRemoveByPharWithParams:(PTPRemoveByPharModelR *)param
                          success:(void (^)(id))success
                          failure:(void (^)(HttpException *))failure;

//会话置顶
+ (void)ptpTopByPharWithParams:(PTPTopByPharModelR *)param
                       success:(void (^)(id))success
                       failure:(void (^)(HttpException *))failure;

//本店咨询全量
+ (void)ptpPharGetAllWithParams:(GetAllByPharModelR *)param
                        success:(void (^)(id obj))success
                        failure:(void (^)(HttpException *e))failure;
//本店咨询增量
+ (void)ptpPharPollWithLastTimestamp:(NSString*)lastTimestamp token:(NSString *)token
                     success:(void (^)(id obj))success
                     failure:(void (^)(HttpException *e))failure;

@end
