//
//  NSString+MarCategory.m
//  APP
//
//  Created by Martin.Liu on 15/12/15.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "NSString+MarCategory.h"

@implementation NSString (MarCategory)

- (NSString*)mar_trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end
