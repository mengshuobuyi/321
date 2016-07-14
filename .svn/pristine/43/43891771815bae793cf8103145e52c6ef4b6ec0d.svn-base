//
//  Train.m
//  wenYao-store
//
//  Created by PerryChen on 5/12/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "Train.h"

@implementation Train
/**
 *  3.2 培训列表
 */
+(void)queryTrainList:(TrainListModelR *)params success:(void(^)(TrainListVoModel *responseModel))success failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance]get:TrainList params:[params dictionaryModel] success:^(id responseObj) {
        TrainListVoModel *list=[TrainListVoModel parse:responseObj Elements:[TrainVoModel class] forAttribute:@"trainList"];
        if (success) {
            success(list);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *  3.2 培训详情
 */
+(void)queryTrainDetail:(TrainDetailModelR *)params success:(void(^)(TrainVoModel *responseModel))success failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance]get:TrainDetail params:[params dictionaryModel] success:^(id responseObj) {
        TrainVoModel *model = [TrainVoModel parse:responseObj];
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}
@end
