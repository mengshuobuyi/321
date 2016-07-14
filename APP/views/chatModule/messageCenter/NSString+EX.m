//
//  NSString+EX.m
//  APP
//
//  Created by Yan Qingyang on 15/5/29.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "NSString+EX.h"

@implementation NSString (EX)
- (NSDictionary *)jsonStringToDict{
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&err];
    return dict;
}
@end
