//
//  FinderSearch.h
//  APP
//
//  Created by 李坚 on 16/1/13.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FinderSearchModel.h"
#import "FinderSearchModelR.h"
#import "SearchModel.h"
#import "HttpClient.h"
@interface FinderSearch : NSObject
/**
 *  发现搜索联想词
 *  V3.0
 */
+ (void)FindDreamWord:(DiscoverSearchModelR *)model success:(void (^)(KeywordModel *))success failure:(void (^)(HttpException *))failure;
/**
 *  发现搜索主列表
 *  V3.0
 */
+ (void)DiscoverSearch:(DiscoverSearchModelR *)model success:(void (^)(DiscoverySearchVo *))success failure:(void (^)(HttpException *))failure;
/**
 *  发现搜索疾病
 *  V3.0
 */
+ (void)DiscoverDiseaseList:(DiscoverSearchModelR *)model success:(void (^)(DiscoveryVo *))success failure:(void (^)(HttpException *))failure;
/**
 *  发现搜索症状
 *  V3.0
 */
+ (void)DiscoverSymptomList:(DiscoverSearchModelR *)model success:(void (^)(DiscoveryVo *))success failure:(void (^)(HttpException *))failure;
/**
 *  发现搜索药品
 *  V3.0
 */
+ (void)DiscoverProductList:(DiscoverSearchModelR *)model success:(void (^)(DiscoveryVo *))success failure:(void (^)(HttpException *))failure;
/**
 *  发现搜索问答
 *  V3.0
 */
+ (void)DiscoverProblemList:(DiscoverSearchModelR *)model success:(void (^)(DiscoveryVo *))success failure:(void (^)(HttpException *))failure;
@end
