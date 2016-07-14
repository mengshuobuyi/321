//
//  QWError.m
//  APP
//
//  Created by carret on 15/1/23.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWError.h"

@implementation QWError
@synthesize description;

+ (QWError *)errorWithCode:(QWErrorType)errCode
            andDescription:(NSString *)description
{
    QWError *qwError = [[QWError alloc]init];
    
    return qwError;
}


+ (QWError *)errorWithNSError:(NSError *)error
{
    QWError *qwError = [[QWError alloc]init];
    
    return qwError;
}
//- (QWErrorType)errorCode
//{
//    description = @"test";
//    return self;
//}
//- (NSString *)description
//{
////    if (30000000>self.errorCode >1000000) {
////        return description;
////    }
//    NSString *plist =    [[NSBundle mainBundle] pathForResource:@"QWError" ofType:@"plist"];
//    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plist];
////    NSLog(@"%@",data);
////      NSLog(@"%lu",self.errorCode);
////    self.errorCode ;
//    return [data objectForKey:[NSString stringWithFormat:@"%lu",self.errorCode]]?[data objectForKey:[NSString stringWithFormat:@"%lu",self.errorCode]]:@"未定义错误";
//}
@end
