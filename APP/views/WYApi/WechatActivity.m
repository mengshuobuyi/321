//
//  WechatActivity.m
//  wenYao-store
//
//  Created by qw_imac on 16/3/18.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "WechatActivity.h"

@implementation WechatActivity

+(void)queryWechatActivityList:(WechatActivityR *)params success:(void(^)(WechatActivityModel *responseModel))success failure:(void(^)(HttpException *e))failure {
    [[HttpClient sharedInstance]get:QueryMMallActivity params:[params dictionaryModel] success:^(id responseObj) {
        WechatActivityModel *list=[WechatActivityModel parse:responseObj Elements:[MicroMallActivityVO class] forAttribute:@"resultList"];
        if (success) {
            success(list);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];

}

+(void)queryActivityCombo:(ActivityComboR *)params success:(void(^)(BusinessComboVO *responseModel))success failure:(void(^)(HttpException *e))failure {
    [[HttpClient sharedInstance]get:QueryActivityCombo params:[params dictionaryModel] success:^(id responseObj) {
        BusinessComboVO *model = [BusinessComboVO parse:responseObj Elements:[BusinessComboProductVO class] forAttribute:@"list"];
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+(void)queryActivityPromotion:(ActivityPromotionR *)params success:(void(^)(BusinessPromotionVO *responseModel))success failure:(void(^)(HttpException *e))failure {
    [[HttpClient sharedInstance]get:QueryActivityPromotion params:[params dictionaryModel] success:^(id responseObj) {
        BusinessPromotionVO *model = [BusinessPromotionVO parse:responseObj Elements:[BusinessPromotionProductVO class] forAttribute:@"list"];
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+(void)queryActivityRepd:(ActivityRepdR *)params success:(void(^)(BusinessRedpVO *responseModel))success failure:(void(^)(HttpException *e))failure {
    [[HttpClient sharedInstance]get:QueryActivityRepd params:[params dictionaryModel] success:^(id responseObj) {
        BusinessRedpVO *model = [BusinessRedpVO parse:responseObj Elements:[BusinessRedpProductVO class] forAttribute:@"list"];
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+(void)queryActivityRush:(ActivityRushR *)params success:(void(^)(BusinessRushVO *responseModel))success failure:(void(^)(HttpException *e))failure {
    [[HttpClient sharedInstance]get:QueryActivityRush params:[params dictionaryModel] success:^(id responseObj) {
        BusinessRushVO *model = [BusinessRushVO parse:responseObj Elements:[BusinessRushProductVO class] forAttribute:@"list"];
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+(void)updateActivity:(UpdateActivityR *)params success:(void(^)(UpdateActivityModel *responseModel))success failure:(void(^)(HttpException *e))failure {
    [[HttpClient sharedInstance]post:WechatUpdateActivity params:[params dictionaryModel] success:^(id responseObj) {
        UpdateActivityModel *model = [UpdateActivityModel parse:responseObj];
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
