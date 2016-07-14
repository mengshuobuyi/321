//
//  TaskScore.h
//  wenYao-store
//
//  Created by PerryChen on 6/20/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskScoreModel.h"
#import "TaskScoreModelR.h"
#import "HttpClient.h"

@interface TaskScore : NSObject

// 商户端店员任务
+(void)getTaskScore:(TaskScoreModelR *)params
            success:(void(^)(TaskScoreListModel *responseModel))success
            failure:(void(^)(HttpException *e))failure;

@end
