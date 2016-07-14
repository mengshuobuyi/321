//
//  FeedBack.m
//  APP
//
//  Created by qwfy0006 on 15/3/19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "FeedBack.h"
#import "FeedBackModelR.h"

@implementation FeedBack

+ (void)SubmitFeedBackWithParams:(FeedBackModelR *)param
                         success:(void (^)(id))success
                         failure:(void (^)(HttpException *))failure
{
    {
        [[HttpClient sharedInstance] post:NW_submitFeedback params:[param dictionaryModel] success:^(id responseObj) {
            
            if ([responseObj[@"apiStatus"] intValue] == 0) {
                if (success) {
                    success(responseObj);
                }
            }
        } failure:^(HttpException *e) {
            
            if (failure) {
                failure(e);
            }
        }];
    }
}

@end
