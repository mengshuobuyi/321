//
//  News_Channel.m
//  APP
//
//  Created by qw on 15/3/1.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "News_Channel.h"
#import "LKDBHelper.h"

@implementation News_Channel

@synthesize channelId;
@synthesize channelName;
@synthesize sort;

+ (NSError *)saveEntityWithArray:(NSArray *)array
{
    if (array == nil || array.count == 0)
        return [NSError errorWithDomain:[NSString stringWithFormat:@"[save error] :%@", array] code:0 userInfo:nil];
    
    LKDBHelper* globalHelper = [LKDBHelper getUsingLKDBHelper];
    
    NSMutableString *str = [NSMutableString stringWithFormat:@"[save error] :"];
    NSInteger length = str.length;
    
    for (NSObject *entity in array)
    {
        if (![globalHelper insertToDB:(News_Channel*)entity])
        {
            [str stringByAppendingFormat:@"%@ ", entity];
        }
    }
    
    
    if (str.length > length)
    {
        return [NSError errorWithDomain:str code:0 userInfo:nil];
    }
    
    return nil;
}
+ (NSArray *)getEntity
{
    return [News_Channel searchWithWhere:nil orderBy:nil offset:0 count:100];
}

@end
