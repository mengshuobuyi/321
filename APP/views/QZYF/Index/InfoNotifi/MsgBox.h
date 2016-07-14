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

typedef NS_ENUM(NSUInteger, MsgBoxMessageType) {
    MsgBoxMessageTypeQWYS,
    MsgBoxMessageTypeNotify = 1,
    MsgBoxMessageTypeOrder = 2,
    MsgBoxMessageTypeCredit = 3
};

typedef NS_ENUM(NSUInteger, MsgBoxCellActionType) {
      MsgBoxCellActionTypeOrder = 18,  //    18.原有的订单通知
      MsgBoxCellActionTypeProductDetail = 20,  //    20.跳转至商品详情
      MsgBoxCellActionTypeCoupon = 21,  //    21.跳转至优惠
      MsgBoxCellActionTypeOnSales = 22,  //    22.跳转至抢购
      MsgBoxCellActionTypeNotOutLink = 31,  //    31.无外链
      MsgBoxCellActionTypeOutLink = 32,  //    32.外链
      MsgBoxCellActionTypeCreditMsg = 33  //    33.积分消息
};

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
