//
//  QALibrary.m
//  wenYao-store
//
//  Created by chenzhipeng on 4/23/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import "QALibrary.h"
#import "QALibraryModel.h"

@implementation QALibrary
+ (void)getQALibraryCountWithParams:(QALibraryCountModelR *)param
                            success:(void(^)(id obj))success
                            failure:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] get:HealthyCountQuestions params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            QALibraryQuestionClassifyListModel *list = [QALibraryQuestionClassifyListModel parse:responseObj Elements:[QALibraryQuestionClassifyModel class] forAttribute:@"list"];
            success(list);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)getQALibraryListWithParams:(QALibraryListModelR *)param
                           success:(void(^)(id obj))success
                           failure:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] get:HealthyQueryTagQuestion params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            NSMutableArray *keyArray = [NSMutableArray array];
            [keyArray addObject:NSStringFromClass([QALibraryHIQuestionModel class])];
            [keyArray addObject:NSStringFromClass([QALibraryHIPositionsModel class])];
            NSMutableArray *valueArray = [NSMutableArray array];
            [valueArray addObject:@"list"];
            [valueArray addObject:@"hlPositions"];
            QALibraryHIQuestionListModel *model = [QALibraryHIQuestionListModel parse:responseObj ClassArr:keyArray Elements:valueArray];
//            QALibraryHIQuestionListModel *model = [QALibraryHIQuestionListModel parse:responseObj Elements:[QALibraryHIQuestionModel class] forAttribute:@"list"];
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)getQALibraryDetailWithParams:(QALibraryDetailModelR *)param
                             success:(void(^)(id obj))success
                             failure:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] get:HealthyDetail params:[param dictionaryModel] success:^(id responseObj) {
        if (success) {
            QALibraryResultDetailModel *model = [QALibraryResultDetailModel parse:responseObj];
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}
@end
