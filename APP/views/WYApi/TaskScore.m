//
//  TaskScore.m
//  wenYao-store
//
//  Created by PerryChen on 6/20/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "TaskScore.h"

@implementation TaskScore
// 商户端店员任务
+(void)getTaskScore:(TaskScoreModelR *)params success:(void(^)(TaskScoreListModel *responseModel))success failure:(void(^)(HttpException *e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] getWithoutProgress:TaskReminder params:[params dictionaryModel] success:^(id responseObj) {
        TaskScoreListModel *modelList = [TaskScoreListModel parse:responseObj Elements:[TaskScoreModel class] forAttribute:@"reminder"];
        if (success) {
            success(modelList);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}
@end
