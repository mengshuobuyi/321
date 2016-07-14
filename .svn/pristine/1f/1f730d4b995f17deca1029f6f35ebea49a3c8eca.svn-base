//
//  MsgBox.m
//  wenYao-store
//
//  Created by  ChenTaiyu on 16/5/18.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "MsgBox.h"

@implementation MsgBox

+ (void)getBranchIndexList:(BranchNoticeIndexModelR *)param success:(void (^)(BranchNoticeIndexVo *))succsee failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] get:MsgBoxGetIndex params:[param dictionaryModel] success:^(id responseObj) {
        BranchNoticeIndexVo *listModel = [BranchNoticeIndexVo parse:responseObj Elements:[BranchNoticeVo class] forAttribute:@"notices"];
        if (succsee) {
            succsee(listModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)pollAllNoticeList:(MessageListPollModelR *)param success:(void (^)(MessageArrayVo *))success failure:(void (^)(HttpException *))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] getWithoutProgress:MsgBoxPollAll params:[param dictionaryModel] success:^(id responseObj) {
        // REMARK:根据objType区分通知，订单，积分
        MessageArrayVo *listModel = [MessageArrayVo parse:responseObj Elements:[MessageVo class] forAttribute:@"messages"];
        if (success) {
            success(listModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}


+ (void)getOrderNoticeList:(MessageListModelR *)param success:(void (^)(MessageArrayVo *))success failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] get:MsgBoxGetOrderNoticeList params:[param dictionaryModel] success:^(id responseObj) {
        MessageArrayVo *listModel = [MessageArrayVo parse:responseObj Elements:[MsgBoxOrderMessageVo class] forAttribute:@"messages"];
        if (success) {
            success(listModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)getNoNoticeList:(MessageListModelR *)param success:(void (^)(MessageArrayVo *))success failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] get:MsgBoxGetNoNoticeList params:[param dictionaryModel] success:^(id responseObj) {
        MessageArrayVo *listModel = [MessageArrayVo parse:responseObj Elements:[MsgBoxNotiMessageVo class] forAttribute:@"messages"];
        if (success) {
            success(listModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)getCreditNoticeList:(MessageListModelR *)param success:(void (^)(MessageArrayVo *))success failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] get:MsgBoxGetCreditNoticeList params:[param dictionaryModel] success:^(id responseObj) {
        MessageArrayVo *listModel = [MessageArrayVo parse:responseObj Elements:[MsgBoxCreditMessageVo class] forAttribute:@"messages"];
        if (success) {
            success(listModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)setReadAll:(MessageListReadAllModelR *)param success:(void (^)(BaseAPIModel *))success failure:(void (^)(HttpException *))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] put:MsgBoxReadAllByType params:[param dictionaryModel]success:^(id responseObj) {
        BaseAPIModel *model = [BaseAPIModel parse:responseObj];
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}


+ (void)setNoticeReadWithMessageId:(NSString *)messageID success:(void (^)(BaseAPIModel *))success failure:(void (^)(HttpException *))failure
{
    MessageListReadSingleModelR *modelR = [MessageListReadSingleModelR new];
    modelR.messageId = messageID;
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] post:MsgBoxReadMsg params:[modelR dictionaryModel] success:^(id responseObj) {
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
