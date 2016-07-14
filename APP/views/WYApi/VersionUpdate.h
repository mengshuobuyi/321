//
//  VersionUpdate.h
//  APP
//  版本更新相关操作
//  Created by qw on 15/2/22.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "Version.h"

@interface VersionUpdate : NSObject

//读取服务器上最新版本数据
+ (void)checkVersion:(NSString*)version success:(void (^)(Version *))success failure:(void (^)(HttpException *))failure;
@end




