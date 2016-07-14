//
//  VerifyRecords.m
//  wenYao-store
//
//  Created by PerryChen on 6/21/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "VerifyRecords.h"

@implementation VerifyRecordsAPI
// 验证记录列表
+(void)getVerifyRecords:(VerifyRecordModelR *)params success:(void(^)(VerifyRecordListModel *responseModel))success failure:(void(^)(HttpException *e))failure
{
    [[HttpClient sharedInstance] get:VerifyRecords params:[params dictionaryModel] success:^(id responseObj) {
        VerifyRecordListModel *modelList = [VerifyRecordListModel parse:responseObj Elements:[VerifyRecordModel class] forAttribute:@"orders"];
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
