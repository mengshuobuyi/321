//
//  VersionUpdate.m
//  APP
//
//  Created by qw on 15/2/22.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "VersionUpdate.h"
#import "Constant.h"

@implementation VersionUpdate

//读取服务器上最新版本数据
+ (void)checkVersion:(NSString*)version success:(void (^)(Version *))success failure:(void (^)(HttpException *))failure
{
    HttpClientMgr.progressEnabled = NO;
    [[HttpClient sharedInstance] get:NW_checkNewVersion
                               params:@{@"version":version,@"platform":@"IOS",@"app":@"BRANCH"}
                              success:^(id resultObj) {
                                  
                                  Version * vmodel = [Version parse:resultObj];
                                  NSLog(@"the model is %@",vmodel);
                                  if ([vmodel.apiStatus intValue] == 0) {
                                      if (success) {
                                          success(vmodel);
                                      }
                                  }
                                  
                              }
                              failure:^(HttpException *e) {
                                    NSLog(@"%@",e);
                                    if (failure) {
                                        failure(e);
                                    }
                                }];
}
@end
