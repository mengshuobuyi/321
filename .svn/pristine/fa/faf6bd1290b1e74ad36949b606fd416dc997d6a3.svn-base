//
//  Promotion.m
//  wenYao-store
//
//  Created by 李坚 on 15/3/26.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "Promotion.h"
#import "OrderModel.h"
@implementation Promotion

//+ (void)promotionScanWithParams:(PromotionScanR *)param
//                        success:(void(^)(id))success
//                        failure:(void(^)(HttpException * e))failure{
//    
//    [[HttpClient sharedInstance] get:PromotionScan params:[param dictionaryModel] success:^(id responseObj) {
//        
//        if (success) {
//            
//            PromotionScanModel *model = [PromotionScanModel parse:responseObj];
//            NSLog(@"resutl====>%@",model);
//            
//            success(model);
//            
//        }
//    } failure:^(HttpException *e) {
//        
//        if (failure) {
//            failure(e);
//        }
//    }];
//    
//}


//扫码获取商品信息
+(void)queryProductByBarCodeWithParam:(NSDictionary *)params
                              Success:(void(^)(id DFUserModel))success
                              failure:(void(^)(HttpException * e))failure
{
    [[HttpClient sharedInstance] get:QueryProductByBarCode params:params success:^(id responseObj) {
        
        NSMutableArray *keyArray = [NSMutableArray array];
        [keyArray addObject:NSStringFromClass([ProductModel class])];
        
        NSMutableArray *valueArray = [NSMutableArray array];
        [valueArray addObject:@"list"];
        
        ProductListModel *model = [ProductListModel parse:responseObj ClassArr:keyArray Elements:valueArray];
        
        if (success) {
            success(model);
        }
        
    } failure:^(HttpException *e) {
        NSLog(@"%@",e);
        if (failure) {
            failure(e);
        }
    }];
}


@end
