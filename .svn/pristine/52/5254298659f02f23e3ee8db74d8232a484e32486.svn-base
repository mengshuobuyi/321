//
//  QALibrary.h
//  wenYao-store
//
//  Created by chenzhipeng on 4/23/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "QALibraryModelR.h"

@interface QALibrary : NSObject

+ (void)getQALibraryCountWithParams:(QALibraryCountModelR *)param
                            success:(void(^)(id obj))success
                            failure:(void(^)(HttpException * e))failure;


+ (void)getQALibraryListWithParams:(QALibraryListModelR *)param
                           success:(void(^)(id obj))success
                           failure:(void(^)(HttpException * e))failure;


+ (void)getQALibraryDetailWithParams:(QALibraryDetailModelR *)param
                             success:(void(^)(id obj))success
                             failure:(void(^)(HttpException * e))failure;

@end
