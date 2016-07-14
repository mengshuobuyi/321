//
//  Promotion.h
//  wenYao-store
//
//  Created by 李坚 on 15/3/26.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseModel.h"
#import "HttpClient.h"
#import "PromotionModelR.h"
#import "PromotionModel.h"

@interface Promotion : BaseModel

+(void)queryProductByBarCodeWithParam:(NSDictionary *)params
                              Success:(void(^)(id DFUserModel))success
                              failure:(void(^)(HttpException * e))failure;

@end
