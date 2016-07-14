//
//  Consult.h
//  wenYao-store
//
//  Created by garfield on 15/5/4.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "ConsultModelR.h"
#import "ConsultModel.h"
#import "ConsultMode.h"


@interface Consult : NSObject

+ (void)consultClosedtWithParams:(ConsultCloseModelR *)param
                         success:(void(^)(id obj))success
                         failure:(void(^)(HttpException * e))failure;

//全量获取解答列表
+ (void)consultConsultingWithParams:(ConsultCloseModelR *)param
                            success:(void(^)(id obj))success
                            failure:(void(^)(HttpException * e))failure;

//抢而伟答放弃接口
+ (void)consultConsultingGiveUpParams:(ConsultReplyFirstgModelR *)param
                              success:(void(^)(BaseAPIModel *model))success
                              failure:(void(^)(HttpException * e))failure;

+ (void)consultCreateWithParams:(ConsultCloseModelR *)param
                        success:(void(^)(id obj))success
                        failure:(void(^)(HttpException * e))failure;

+ (void)consultCustomerWithParams:(ConsultCloseModelR *)param
                          success:(void(^)(id obj))success
                          failure:(void(^)(HttpException * e))failure;

+ (void)consultIgnoreWithParams:(ConsultReplyFirstgModelR *)param
                        success:(void(^)(BaseAPIModel *model))success
                        failure:(void(^)(HttpException * e))failure;

//聊天过程中第二次及以后每次回复
+ (void)consultDetailCreateWithParams2:(ConsultDetailCreateModelR *)param
                               success:(void(^)(id obj))success
                               failure:(void(^)(HttpException * e))failure;

+ (void)consultDetailCustomertWithParams:(ConsultCloseModelR *)param
                                 success:(void(^)(id obj))success
                                 failure:(void(^)(HttpException * e))failure;

//全量聊天详情
+ (void)consultDetailPharWithParams:(ConsultReplyFirstgModelR *)param
                            success:(void(^)(PharConsultDetail *model))success
                            failure:(void(^)(HttpException * e))failure;
//增量聊天详情
+ (void)consultDetailPharPollWithParams:(ConsultReplyFirstgModelR *)param
                                success:(void(^)(id obj))success
                                failure:(void(^)(HttpException * e))failure;

+ (void)consultDetailReceiveWithParams:(ConsultCloseModelR *)param
                               success:(void(^)(id obj))success
                               failure:(void(^)(HttpException * e))failure;


+ (void)consultDetailRemoveWithParams:(ConsultDetailRemoveModelR *)param
                              success:(void(^)(id obj))success
                              failure:(void(^)(HttpException * e))failure;

+ (void)consultRacedWithParams:(ConsultCloseModelR *)param
                       success:(void(^)(id obj))success
                       failure:(void(^)(HttpException * e))failure;

+ (void)checkStatusByPharWhenGettingDetailFromRacing:(ConsultReplyFirstgModelR *)param
                                             success:(void(^)(id obj))success
                                             failure:(void(^)(HttpException * e))failure;

+ (void)consultRacingWithParams:(ConsultCloseModelR *)param
                        success:(void(^)(id obj))success
                        failure:(void(^)(HttpException * e))failure;

+ (void)consultReplyFirstWithParams:(ConsultReplyFirstgModelR *)param
                            success:(void(^)(id obj))success
                            failure:(void(^)(HttpException * e))failure;

+ (void)consultSpCreateWithParams:(ConsultCloseModelR *)param
                          success:(void(^)(id obj))success
                          failure:(void(^)(HttpException * e))failure;

//互动统计
+ (void)consultStatisticsWithParam:(NSDictionary *)param
                           success:(void (^)(id))success
                           failure:(void (^)(HttpException *))failure;

//咨询历史
+ (void)CustomerQueryConsultListWithParam:(NSDictionary *)param
                                  success:(void (^)(id))success
                                  failure:(void (^)(HttpException *))failure;

+ (void)consultItemReadWithParam:(ConsultDetailReceiveModelR *)param
                         success:(void(^)(id obj))success
                         failure:(void(^)(HttpException * e))failure;

//聊天过程中第一次回复
+ (void)consultDetailCreateFirstWithParams:(ConsultDetailCreateModelR *)param
                                   success:(void(^)(id obj))success
                                   failure:(void(^)(HttpException * e))failure;

//增量获取解答列表
+ (void)consultConsultingnewDetailWithParams:(ConsultnNewDetailModelR *)param
                                     success:(void(^)(id obj))success
                                     failure:(void(^)(HttpException * e))failure;

/**
 *  @brief 更新某条资讯中所有详情为已读
 *
 */
+ (void)updateConsultItemRead:(ConsultItemReadModelR *)param
                      success:(void (^)(ConsultModel *responModel))success
                      failure:(void (^)(HttpException *e))failure;

/**
 *  @brief 客户：更新服务器角标
 */

+ (void)updateNotiNumberWithNum:(NSInteger)num token:(NSString *)token
                        success:(void(^)(id ResModel))success
                        failure:(void (^)(HttpException *e))failure;


//最近时间内的互动统计信息

+ (void)consultStatisticsByRecentWithParam:(NSDictionary *)param
                                   success:(void (^)(id))success
                                   failure:(void (^)(HttpException *))failure;

//根据日期获得统计信息

+ (void)consultStatisticsByDateWithParam:(NSDictionary *)param
                                 success:(void (^)(id))success
                                 failure:(void (^)(HttpException *))failure;

//优惠详情
+ (void)queryCoupnDetailWithParam:(NSDictionary *)params
                          success:(void(^)(id))success
                          failure:(void(^)(HttpException *e))failure;

@end

