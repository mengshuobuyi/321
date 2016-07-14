//
//  FinderSearch.m
//  APP
//
//  Created by 李坚 on 16/1/13.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "FinderSearch.h"

@implementation FinderSearch
/**
 *  发现搜索联想词
 *  V3.0
 */
+ (void)FindDreamWord:(DiscoverSearchModelR *)model success:(void (^)(KeywordModel *))success failure:(void (^)(HttpException *))failure{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:FinderAssociate params:[model dictionaryModel] success:^(id obj) {
        
        NSMutableArray *keyArray = [NSMutableArray array];
        [keyArray addObject:NSStringFromClass([HighlightAssociateVO class])];
        [keyArray addObject:NSStringFromClass([HighlightPosition class])];
        NSMutableArray *valueArray = [NSMutableArray array];
        [valueArray addObject:@"list"];
        [valueArray addObject:@"highlightPositionList"];
        
        KeywordModel *dreamWordList = [KeywordModel parse:obj ClassArr:keyArray Elements:valueArray];
        
        if (success) {
            success(dreamWordList);
        }
    } failure:^(HttpException *e) {
        DebugLog(@"%@",e);
        if (failure) {
            failure(e);
        }
    }];
}
/**
 *  发现搜索主列表
 *  V3.0
 */
+ (void)DiscoverSearch:(DiscoverSearchModelR *)model success:(void (^)(DiscoverySearchVo *))success failure:(void (^)(HttpException *))failure{
    HttpClientMgr.progressEnabled = YES;
    [[HttpClient sharedInstance] get:SearchDiscovery params:[model dictionaryModel] success:^(id obj) {
        
        NSMutableArray *keyArray = [NSMutableArray array];
        [keyArray addObject:NSStringFromClass([DiscoveryDiseaseVo class])];
        [keyArray addObject:NSStringFromClass([DiscoverySpmVo class])];
        [keyArray addObject:NSStringFromClass([DiscoveryProductVo class])];
        [keyArray addObject:NSStringFromClass([DiscoveryProblemVo class])];
        [keyArray addObject:NSStringFromClass([DiscoveryDiseaseVo class])];
        [keyArray addObject:NSStringFromClass([DiscoverySpmVo class])];
        [keyArray addObject:NSStringFromClass([DiscoveryProductVo class])];
        [keyArray addObject:NSStringFromClass([HighlightPosition class])];
        
        NSMutableArray *valueArray = [NSMutableArray array];
        [valueArray addObject:@"diseaseList"];
        [valueArray addObject:@"spmList"];
        [valueArray addObject:@"productList"];
        [valueArray addObject:@"problemList"];
        [valueArray addObject:@"discoveryDiseaseVo"];
        [valueArray addObject:@"discoverySpmVo"];
        [valueArray addObject:@"discoveryProductVo"];
        [valueArray addObject:@"highlightPositionList"];
        
        DiscoverySearchVo *searchVO = [DiscoverySearchVo parse:obj ClassArr:keyArray Elements:valueArray];
        
        if (success) {
            success(searchVO);
        }
    } failure:^(HttpException *e) {
        DebugLog(@"%@",e);
        if (failure) {
            failure(e);
        }
    }];
}
/**
 *  发现搜索疾病
 *  V3.0
 */
+ (void)DiscoverDiseaseList:(DiscoverSearchModelR *)model success:(void (^)(DiscoveryVo *))success failure:(void (^)(HttpException *))failure{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:SearchDisease params:[model dictionaryModel] success:^(id obj) {
        
        NSMutableArray *keyArray = [NSMutableArray array];
        [keyArray addObject:NSStringFromClass([DiscoveryDiseaseVo class])];
        NSMutableArray *valueArray = [NSMutableArray array];
        [valueArray addObject:@"list"];

        DiscoveryVo *searchVO = [DiscoveryVo parse:obj ClassArr:keyArray Elements:valueArray];
        
        if (success) {
            success(searchVO);
        }
    } failure:^(HttpException *e) {
        DebugLog(@"%@",e);
        if (failure) {
            failure(e);
        }
    }];
}
/**
 *  发现搜索症状
 *  V3.0
 */
+ (void)DiscoverSymptomList:(DiscoverSearchModelR *)model success:(void (^)(DiscoveryVo *))success failure:(void (^)(HttpException *))failure{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:SearchSymptom params:[model dictionaryModel] success:^(id obj) {
        
        NSMutableArray *keyArray = [NSMutableArray array];
        [keyArray addObject:NSStringFromClass([DiscoverySpmVo class])];
        NSMutableArray *valueArray = [NSMutableArray array];
        [valueArray addObject:@"list"];
        
        DiscoveryVo *searchVO = [DiscoveryVo parse:obj ClassArr:keyArray Elements:valueArray];
        
        if (success) {
            success(searchVO);
        }
    } failure:^(HttpException *e) {
        DebugLog(@"%@",e);
        if (failure) {
            failure(e);
        }
    }];
}
/**
 *  发现搜索药品
 *  V3.0
 */
+ (void)DiscoverProductList:(DiscoverSearchModelR *)model success:(void (^)(DiscoveryVo *))success failure:(void (^)(HttpException *))failure{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:SearchProduct params:[model dictionaryModel] success:^(id obj) {
        
        NSMutableArray *keyArray = [NSMutableArray array];
        [keyArray addObject:NSStringFromClass([DiscoveryProductVo class])];
        NSMutableArray *valueArray = [NSMutableArray array];
        [valueArray addObject:@"list"];
        
        DiscoveryVo *searchVO = [DiscoveryVo parse:obj ClassArr:keyArray Elements:valueArray];
        
        if (success) {
            success(searchVO);
        }
    } failure:^(HttpException *e) {
        DebugLog(@"%@",e);
        if (failure) {
            failure(e);
        }
    }];
}
/**
 *  发现搜索问答
 *  V3.0
 */
+ (void)DiscoverProblemList:(DiscoverSearchModelR *)model success:(void (^)(DiscoveryVo *))success failure:(void (^)(HttpException *))failure{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:SearchProblem params:[model dictionaryModel] success:^(id obj) {
        
        NSMutableArray *keyArray = [NSMutableArray array];
        [keyArray addObject:NSStringFromClass([DiscoveryProblemVo class])];
        [keyArray addObject:NSStringFromClass([HighlightPosition class])];
        NSMutableArray *valueArray = [NSMutableArray array];
        [valueArray addObject:@"list"];
        [valueArray addObject:@"highlightPositionList"];
        
        DiscoveryVo *searchVO = [DiscoveryVo parse:obj ClassArr:keyArray Elements:valueArray];
        
        if (success) {
            success(searchVO);
        }
    } failure:^(HttpException *e) {
        DebugLog(@"%@",e);
        if (failure) {
            failure(e);
        }
    }];
}
@end
