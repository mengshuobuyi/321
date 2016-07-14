//
//  Activity.m
//  wenYao-store
//
//  Created by caojing on 15/4/1.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "Activity.h"

@implementation Activity



+(void)QueryActivityListWithParams:(id)param success:(void (^)(id))success failure:(void (^)(HttpException *))failure{
    [[HttpClient sharedInstance] get:GetActivities params:[param dictionaryModel] success:^(id responseObj) {
        QueryActivityList *branch=[QueryActivityList parse:responseObj Elements:[QueryActivityInfo class] forAttribute:@"list"];
        if (success) {
            success(branch);
        }
        
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
}

+(void)QueryActivityCoupnListWithParams:(id)param success:(void (^)(id))success failure:(void (^)(HttpException *))failure{
    // change by shen  聊天页面掉用这个接口有菊花。。
    HttpClientMgr.progressEnabled = NO;
    // change  end
    [[HttpClient sharedInstance] get:GetActivitiesCoupn params:[param dictionaryModel] success:^(id responseObj) {
        QueryActivityList *branch=[QueryActivityList parse:responseObj Elements:[QueryActivityInfo class] forAttribute:@"list"];
        if (success) {
            success(branch);
        }
        
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
}



+(void)DeleteActivitWithParams:(id)param success:(void (^)(id))success failure:(void (^)(HttpException *))failure{
    [[HttpClient sharedInstance] put:PutDeleteActivities params:[param dictionaryModel] success:^(id responseObj) {
        DeleteActivitys *branch=[DeleteActivitys parse:responseObj];
        if (success) {
            success(branch);
        }
        
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
}


//获取营销活动的详情
+ (void)GetActivityWithParams:(id)param
                      success:(void (^)(id))success
                      failure:(void(^)(HttpException * e))failure{
    
    [[HttpClient sharedInstance] get:GetActivityInfo params:[param dictionaryModel] success:^(id responseObj) {
            NSMutableArray *keyArray = [NSMutableArray array];
            [keyArray addObject:NSStringFromClass([QueryActivityImage class])];
            
            NSMutableArray *valueArray = [NSMutableArray array];
            [valueArray addObject:@"imgs"];
            
            QueryActivityInfo* activityModel = [QueryActivityInfo parse:responseObj ClassArr:keyArray Elements:valueArray];
            if (success) {
                success(activityModel);
            }
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
    
}

//保存或者更新营销活动
+ (void)SaveOrUpdateActivityWithParams:(id)param
                               success:(void (^)(id))success
                               failure:(void(^)(HttpException * e))failure{
    
    [[HttpClient sharedInstance] post:PostSaveOrUpdate params:[param dictionaryModel] success:^(id responseObj) {
        
         ActivityModel* activityModel = [ActivityModel parse:responseObj];
        
        if (success) {
            success(activityModel);
        }
        
    } failure:^(HttpException *e) {
        
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *  获取指定药店的优惠活动
 */
+ (void)getStoreBranchPromotion:(id)param success:(void (^)(id))succsee failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] get:StoreBranchPromotion params:[param dictionaryModel] success:^(id responseObj) {
        /*
         NSMutableArray *keyArr = [NSMutableArray array];
         [keyArr addObject:NSStringFromClass([StoreNearByModel class])];
         [keyArr addObject:NSStringFromClass([StoreNearByTagModel class])];
         NSMutableArray *valueArr = [NSMutableArray array];
         [valueArr addObject:@"list"];
         [valueArr addObject:@"tags"];
         StoreNearByListModel *listModel = [StoreNearByListModel parse:responseObj ClassArr:keyArr Elements:valueArr];
         */
        BranchPromotionListModel *listModel = [BranchPromotionListModel parse:responseObj Elements:[BranchPromotionModel class] forAttribute:@"list"];
        if (succsee) {
            succsee(listModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *  获取指定药店的新的优惠活动
 */
+ (void)getNewStoreBranchPromotion:(id)param success:(void (^)(id))succsee failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] get:GetQueryCoupnActivity params:[param dictionaryModel] success:^(id responseObj) {
        
        BranchPromotionListModel *listModel = [BranchPromotionListModel parse:responseObj Elements:[BranchNewPromotionModel class] forAttribute:@"list"];
        if (succsee) {
            succsee(listModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *  优惠活动的详情页
 */

+ (void)getPromotionDetail:(id)param success:(void (^)(id))succsee failure:(void (^)(HttpException *))failure{
    [[HttpClient sharedInstance] get:GetCoupnActivityDetail params:[param dictionaryModel] success:^(id responseObj) {
        if (succsee) {
            succsee(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];

}


+ (void)getPromotionProductListProduct:(id)param success:(void (^)(id))succsee failure:(void (^)(HttpException *))failure{
    [[HttpClient sharedInstance] get:GetProductActivityDetail params:[param dictionaryModel] success:^(id responseObj) {
        if (succsee) {
            succsee(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
    
}


@end
