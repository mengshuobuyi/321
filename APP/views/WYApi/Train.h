//
//  Train.h
//  wenYao-store
//
//  Created by PerryChen on 5/12/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "TrainModelR.h"
#import "TrainModel.h"
@interface Train : NSObject
/**
 *  3.2 培训列表
 */
+(void)queryTrainList:(TrainListModelR *)params
              success:(void(^)(TrainListVoModel *responseModel))success
              failure:(void(^)(HttpException *e))failure;

/**
 *  3.2 培训详情
 */
+(void)queryTrainDetail:(TrainDetailModelR *)params
                success:(void(^)(TrainVoModel *responseModel))success
                failure:(void(^)(HttpException *e))failure;
@end
