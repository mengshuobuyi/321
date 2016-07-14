//
//  VerifyRecords.h
//  wenYao-store
//
//  Created by PerryChen on 6/21/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VerifyRecordModelR.h"
#import "VerifyRecordListModel.h"
#import "HttpClient.h"
@interface VerifyRecordsAPI : NSObject

// 验证记录列表
+(void)getVerifyRecords:(VerifyRecordModelR *)params
                success:(void(^)(VerifyRecordListModel *responseModel))success
                failure:(void(^)(HttpException *e))failure;

@end
