//
//  FileManager.h
//  APP
//
//  Created by Yan Qingyang on 15/7/30.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"


@interface FileManager : NSObject
+ (NSString*)rename:(NSString*)name oldPath:(NSString*)oldPath;
+ (BOOL)checkFileExist:(NSString*)path;
+ (void)downloadFile:(NSString*)url
                name:(NSString*)name
             success:(void(^)(NSString *savePath))success
             failure:(void(^)(HttpException * e))failure;
@end
