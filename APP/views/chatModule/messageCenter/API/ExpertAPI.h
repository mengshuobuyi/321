//
//  ExpertAPI.h
//  wenYao-store
//  砖家私聊/抢答API请求封装
//  Created by 李坚 on 16/3/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExpertMessageModel.h"
#import "ExpertMessageModelR.h"
#import "IMHttpClient.h"

@interface ExpertAPI : NSObject

#pragma mark - 砖家私聊请求:

//砖家私聊删除会话V3.1
+ (void)DeletePMChat:(ExpertDeleteModelR *)param success:(void (^)(BaseAPIModel *responModel))succsee failure:(void (^)(HttpException *e))failure;
//砖家私聊列表全量 V3.1
+ (void)PMChatListAll:(ChatPointModelR *)param success:(void (^)(ChatPointList *responModel))succsee failure:(void (^)(HttpException *e))failure;
//砖家私聊列表增量 V3.1
+ (void)PMChatListPoll:(ChatPointModelR *)param success:(void (^)(ChatPointList *responModel))succsee failure:(void (^)(HttpException *e))failure;

//砖家私聊详情全量拉取明细列表 V3.1
+ (void)PMChatDetail:(ChatDetailModelR *)param success:(void (^)(ChatDetailList *responModel))succsee failure:(void (^)(HttpException *e))failure;
+ (void)PMNewChatDetail:(ChatNewDetailModelR *)param success:(void (^)(ChatDetailList *responModel))succsee failure:(void (^)(HttpException *e))failure;
//砖家私聊详情轮循拉取明细列表 V3.1
+ (void)LoopPMChatDetail:(ChatDetailModelR *)param success:(void (^)(ChatDetailList *responModel))succsee failure:(void (^)(HttpException *e))failure;

//砖家私聊发送消息V3.1
+ (void)PMChatSendMessage:(ExpertCreateModelR *)param success:(void (^)(IMChatDetailSended *responModel))succsee failure:(void (^)(HttpException *e))failure;


#pragma mark - 砖家问答请求:
//问答聊天回复 V3.1
+ (void)ExpertXPReply:(ExpertXPCreateModelR *)param success:(void (^)(XPChatDetailSended *responModel))succsee failure:(void (^)(HttpException *e))failure;

//问答详情轮循 V.31
+ (void)InterLoop:(InterlocuationModelR *)param success:(void (^)(QADetailVO *responModel))succsee failure:(void (^)(HttpException *e))failure;

//问答详情列表 V3.1
+ (void)GetQADetailListWithParams:(InterlocuationModelR *)param success:(void (^)(QADetailVO *responModel))succsee failure:(void (^)(HttpException *e))failure;
//抢答 V3.1
+ (void)raceInterlocuationWithParams:(InterlocuationModelR *)param success:(void (^)(BaseAPIModel *responModel))succsee failure:(void (^)(HttpException *e))failure;
//商户端检查是否可以抢答 V3.1
+ (void)CheckCanRaceWithParams:(InterlocuationModelR *)param success:(void (^)(BaseAPIModel *responModel))succsee failure:(void (^)(HttpException *e))failure;
//忽略 V3.1
+ (void)ignoreInterlocuationWithParams:(InterlocuationModelR *)param success:(void (^)(BaseAPIModel *responModel))succsee failure:(void (^)(HttpException *e))failure;
//问答列表 (待抢答全量、解答中全量、解答中增量、已关闭全量) V3.1
+ (void)GetQAListWithParams:(QAListModelR *)param success:(void (^)(QAList *responModel))succsee failure:(void (^)(HttpException *e))failure;

@end
