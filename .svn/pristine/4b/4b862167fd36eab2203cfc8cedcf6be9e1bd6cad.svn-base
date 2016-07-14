//
//  RefCode.h
//  wenYao-store
//
//  Created by PerryChen on 3/23/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RefCodeModel.h"
#import "RefCodeModelR.h"
#import "HttpClient.h"
@interface RefCode : NSObject
/**
 *  获取REF分享URL
 */
+(void)queryRefCode:(RefCodeModelR *)params
            success:(void(^)(RefCodeModel *responseModel))success
            failure:(void(^)(HttpException *e))failure;
@end
