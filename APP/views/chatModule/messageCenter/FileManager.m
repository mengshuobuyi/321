//
//  FileManager.m
//  APP
//
//  Created by Yan Qingyang on 15/7/30.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "FileManager.h"
#import "QWGlobalManager.h"

@implementation FileManager

+ (NSString*)rename:(NSString*)name oldPath:(NSString*)oldPath{
    //code
    NSMutableArray *nameArray = [[oldPath componentsSeparatedByString:@"/"] mutableCopy];
    NSString *fileName = [nameArray lastObject];
    NSString *suffix = [[fileName componentsSeparatedByString:@"."] lastObject];
    suffix = [NSString stringWithFormat:@"%@.%@",name,suffix];
    [nameArray replaceObjectAtIndex:nameArray.count - 1 withObject:suffix];
    
    NSString *newPath = [nameArray componentsJoinedByString:@"/"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager moveItemAtPath:oldPath toPath:newPath error:nil];
    
    return newPath;
}

+ (BOOL)checkFileExist:(NSString*)path{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        return YES;
    }
    return NO;
}

+ (void)downloadFile:(NSString*)url
                name:(NSString*)name
             success:(void(^)(NSString *savePath))success
             failure:(void(^)(HttpException * e))failure
{
    NSString *audioPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat: @"Documents/%@/Voice/",QWGLOBALMANAGER.configure.userName]];
    
    [HttpClientMgr downloadFileURL:url savePath:audioPath fileName:[NSString stringWithFormat:@"%@.amr",name] UUID:name success:^(NSString *aSavePath) {
        if(success)
            success(aSavePath);
    } failure:^(HttpException *e) {
        if(failure)
            failure(e);
    } downLoadProgressBlock:NULL];
    
}
@end
