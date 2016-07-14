//
//  NSString+TransDomain.m
//  APP
//
//  Created by PerryChen on 1/14/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "NSString+TransDomain.h"

@implementation NSString (TransDomain)
- (NSString *)transStrWithDomain:(NSString *)strDomain
{
    if (([self hasPrefix:@"http://"])||([self hasPrefix:@"https://"])) {
        return self;
    } else {
        NSString *tmp = self;
        if ([self hasPrefix:@"/"]) {
            tmp = [self substringFromIndex:1];
        }
        return [NSString stringWithFormat:@"%@%@",strDomain,tmp];
    }
}
- (BOOL)hasPrefixWithHTTPDomain
{
    if (([self hasPrefix:@"http://"])||([self hasPrefix:@"https://"])) {
        return YES;
    } else {
        return NO;
    }
}
@end
