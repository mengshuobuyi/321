//
//  IMHttpClient.h
//  APP
//
//  Created by Yan Qingyang on 15/5/25.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#define  IMManager [IMHttpClient instance].request

@interface IMHttpClient : NSObject
+ (instancetype)instance;
@property (nonatomic, retain) HttpClient *request;
@end
