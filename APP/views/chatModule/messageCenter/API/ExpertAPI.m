//
//  ExpertAPI.m
//  wenYao-store
//
//  Created by 李坚 on 16/3/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ExpertAPI.h"
#import "ExpertChatUrl.h"

@implementation ExpertAPI

#pragma mark - 私聊请求:

//砖家私聊列表全量 V3.1
+ (void)PMChatListAll:(ChatPointModelR *)param success:(void (^)(ChatPointList *responModel))succsee failure:(void (^)(HttpException *e))failure{
    
    [IMManager getWithoutProgress:PMChatGetAll params:[param dictionaryModel] success:^(id responseObj) {

        NSMutableArray *keyArray = [NSMutableArray array];
        [keyArray addObject:NSStringFromClass([IMChatPointVo class])];
        
        NSMutableArray *valueArray = [NSMutableArray array];
        [valueArray addObject:@"sessions"];
        
        ChatPointList *model = [ChatPointList parse:responseObj ClassArr:keyArray Elements:valueArray];
        
        if(succsee){
            succsee(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

//砖家私聊列表增量 V3.1
+ (void)PMChatListPoll:(ChatPointModelR *)param success:(void (^)(ChatPointList *responModel))succsee failure:(void (^)(HttpException *e))failure{
    
    [IMManager getWithoutProgress:PMChatGetPoll params:[param dictionaryModel] success:^(id responseObj) {
        
        NSMutableArray *keyArray = [NSMutableArray array];
        [keyArray addObject:NSStringFromClass([IMChatPointVo class])];
        
        NSMutableArray *valueArray = [NSMutableArray array];
        [valueArray addObject:@"sessions"];
        
        ChatPointList *model = [ChatPointList parse:responseObj ClassArr:keyArray Elements:valueArray];
        
        if(succsee){
            succsee(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

//砖家私聊详情全量拉取明细列表 V3.1.0
+ (void)PMChatDetail:(ChatDetailModelR *)param success:(void (^)(ChatDetailList *responModel))succsee failure:(void (^)(HttpException *e))failure{
    
    [IMManager getWithoutProgress:PMChatDetailGetAll params:[param dictionaryModel] success:^(id responseObj) {
        
        
        NSMutableArray *keyArray = [NSMutableArray array];
        [keyArray addObject:NSStringFromClass([IMChatDetailVo class])];
        
        NSMutableArray *valueArray = [NSMutableArray array];
        [valueArray addObject:@"details"];
        
        ChatDetailList *model = [ChatDetailList parse:responseObj ClassArr:keyArray Elements:valueArray];
        
        if(succsee){
            succsee(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

//砖家私聊详情全量拉取明细列表 V4.0.0
+ (void)PMNewChatDetail:(ChatNewDetailModelR *)param success:(void (^)(ChatDetailList *responModel))succsee failure:(void (^)(HttpException *e))failure{
    
    [IMManager getWithoutProgress:TeamChatDetailGetAllByChatId params:[param dictionaryModel] success:^(id responseObj) {
        
        NSMutableArray *keyArray = [NSMutableArray array];
        [keyArray addObject:NSStringFromClass([IMChatDetailVo class])];
        
        NSMutableArray *valueArray = [NSMutableArray array];
        [valueArray addObject:@"details"];
        
        ChatDetailList *model = [ChatDetailList parse:responseObj ClassArr:keyArray Elements:valueArray];
        
        if(succsee){
            succsee(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}


//砖家私聊详情轮循拉取明细列表 V3.1
+ (void)LoopPMChatDetail:(ChatDetailModelR *)param success:(void (^)(ChatDetailList *responModel))succsee failure:(void (^)(HttpException *e))failure{
    
    [IMManager getWithoutProgress:PMChatDetailLoop params:[param dictionaryModel] success:^(id responseObj) {
        
        NSMutableArray *keyArray = [NSMutableArray array];
        [keyArray addObject:NSStringFromClass([IMChatDetailVo class])];
        
        NSMutableArray *valueArray = [NSMutableArray array];
        [valueArray addObject:@"details"];
        
        ChatDetailList *model = [ChatDetailList parse:responseObj ClassArr:keyArray Elements:valueArray];
        
        if(succsee){
            succsee(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

//砖家私聊发送消息V3.1
+ (void)PMChatSendMessage:(ExpertCreateModelR *)param success:(void (^)(IMChatDetailSended *responModel))succsee failure:(void (^)(HttpException *e))failure{
    
    [IMManager postWithoutProgress:PMChatDetailSendMsg params:[param dictionaryModel] success:^(id responseObj) {
     
        IMChatDetailSended *model = [IMChatDetailSended parse:responseObj];
        
        if(succsee){
            succsee(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}


//砖家私聊删除会话V3.1
+ (void)DeletePMChat:(ExpertDeleteModelR *)param success:(void (^)(BaseAPIModel *responModel))succsee failure:(void (^)(HttpException *e))failure{
    
    [IMManager postWithoutProgress:PMChatDelete params:[param dictionaryModel] success:^(id responseObj) {
        
        BaseAPIModel *model = [BaseAPIModel parse:responseObj];
        
        if(succsee){
            succsee(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

#pragma mark - 砖家问答请求:
//问答聊天回复 V3.1
+ (void)ExpertXPReply:(ExpertXPCreateModelR *)param success:(void (^)(XPChatDetailSended *responModel))succsee failure:(void (^)(HttpException *e))failure{
    
    [IMManager postWithoutProgress:XPQADetailSend params:[param dictionaryModel] success:^(id responseObj) {

        XPChatDetailSended *model = [XPChatDetailSended parse:responseObj];
        
        if(succsee){
            succsee(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

//问答聊天界面轮循 V3.1
+ (void)InterLoop:(InterlocuationModelR *)param success:(void (^)(QADetailVO *responModel))succsee failure:(void (^)(HttpException *e))failure{
    
    [IMManager getWithoutProgress:IMInterLoop params:[param dictionaryModel] success:^(id responseObj) {
        
        NSMutableArray *keyArray = [NSMutableArray array];
        [keyArray addObject:NSStringFromClass([QADetailListVO class])];
        
        NSMutableArray *valueArray = [NSMutableArray array];
        [valueArray addObject:@"qaDetailListVOs"];
        
        QADetailVO *model = [QADetailVO parse:responseObj ClassArr:keyArray Elements:valueArray];
        
        if(succsee){
            succsee(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

//砖家问答详情列表 V3.1
+ (void)GetQADetailListWithParams:(InterlocuationModelR *)param success:(void (^)(QADetailVO *responModel))succsee failure:(void (^)(HttpException *e))failure{
    
    [IMManager getWithoutProgress:IMQADDetailList params:[param dictionaryModel] success:^(id responseObj) {
        
        QADetailVO *model = [QADetailVO parse:responseObj Elements:[QADetailListVO class] forAttribute:@"qaDetailListVOs"];
        
        if(succsee){
            succsee(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}


//商户端检查是否可以抢答 V3.1
+ (void)CheckCanRaceWithParams:(InterlocuationModelR *)param success:(void (^)(BaseAPIModel *responModel))succsee failure:(void (^)(HttpException *e))failure{
    
    [IMManager postWithoutProgress:CheckCanRace params:[param dictionaryModel] success:^(id responseObj) {
//        ApiStatus 	ApiMessage
//        1             问题已被抢
        if(succsee){
            BaseAPIModel *model = [BaseAPIModel parse:responseObj];
            succsee(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

//砖家抢答 V3.1
+ (void)raceInterlocuationWithParams:(InterlocuationModelR *)param success:(void (^)(BaseAPIModel *responModel))succsee failure:(void (^)(HttpException *e))failure{
    
    [IMManager postWithoutProgress:RaceIMInterlocuation params:[param dictionaryModel] success:^(id responseObj) {
        if(succsee){
            BaseAPIModel *model = [BaseAPIModel parse:responseObj];
            succsee(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

//砖家忽略 V3.1
+ (void)ignoreInterlocuationWithParams:(InterlocuationModelR *)param success:(void (^)(BaseAPIModel *responModel))succsee failure:(void (^)(HttpException *e))failure{
    
    [IMManager postWithoutProgress:IgnoreIMInterlocuation params:[param dictionaryModel] success:^(id responseObj) {
        if(succsee){
            BaseAPIModel *model = [BaseAPIModel parse:responseObj];
            succsee(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

//问答列表 (待抢答全量、解答中全量、解答中增量、已关闭全量) V3.1
+ (void)GetQAListWithParams:(QAListModelR *)param success:(void (^)(QAList *responModel))succsee failure:(void (^)(HttpException *e))failure{
    
    [IMManager getWithoutProgress:LocuationQAList params:[param dictionaryModel] success:^(id responseObj) {
        
        NSMutableArray *keyArray = [NSMutableArray array];
        [keyArray addObject:NSStringFromClass([QAListVO class])];
        
        NSMutableArray *valueArray = [NSMutableArray array];
        [valueArray addObject:@"list"];
        
        QAList *model = [QAList parse:responseObj ClassArr:keyArray Elements:valueArray];
        
        if(succsee){
            succsee(model);
        }

    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

@end
