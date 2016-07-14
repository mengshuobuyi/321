//
//  MsgBox.h
//  wenYao-store
//
//  Created by  ChenTaiyu on 16/5/18.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "BaseModel.h"
#import "HttpClient.h"
#import "MsgBoxModel.h"
#import "MsgBoxModelR.h"

@interface MsgBox : BaseModel

//消息盒子首页
+ (void)getBranchIndexList:(BranchNoticeIndexModelR *)param
                   success:(void (^)(BranchNoticeIndexVo *responseModel))success
                   failure:(void (^)(HttpException *e))failure;
//轮询-获取所有消息
+ (void)pollAllNoticeList:(MessageListPollModelR *)param
                    success:(void (^)(MessageArrayVo *responseModel))success
                    failure:(void (^)(HttpException *e))failure;
//订单消息列表
+ (void)getOrderNoticeList:(MessageListModelR *)param
                    success:(void (^)(MessageArrayVo *responseModel))success
                    failure:(void (^)(HttpException *e))failure;
//消息中心列表
+ (void)getNoNoticeList:(MessageListModelR *)param
                    success:(void (^)(MessageArrayVo *responseModel))success
                    failure:(void (^)(HttpException *e))failure;
//积分消息列表
+ (void)getCreditNoticeList:(MessageListModelR *)param
                success:(void (^)(MessageArrayVo *responseModel))success
                failure:(void (^)(HttpException *e))failure;
// 清空未读数（消息中心，订单通知，积分消息）
+ (void)setReadAll:(MessageListReadAllModelR *)param
           success:(void (^)(BaseAPIModel *responseModel))success
           failure:(void (^)(HttpException *e))failure;
// 单条已读
+ (void)setNoticeReadWithMessageId:(NSString *)messageID
                           success:(void (^)(BaseAPIModel *))success
                           failure:(void (^)(HttpException *))failure;
@end
