//
//  NSDictionary+MARExtension.m
//  APP
//  容错处理：
//  NSString* niL = nil;
//  @{@"1k":@"1v",niL:@"v",@"k":niL,@"4k":@"4v"};
//  [NSDictionary dictionaryWithObjectsAndKeys:@"1v",@"1k",@"k",niL,niL,@"v",@"4v",@"4k", nil]
//  Created by Martin.Liu on 16/3/1.
//  Copyright © 2016年 MAR. All rights reserved.
//

#import "NSDictionary+MARExtension.h"

@implementation NSDictionary (MARExtension)

+(instancetype)dictionaryWithObjectsAndKeys:(id)firstObject, ...
{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    id eachObject;
    va_list argumentList;
    if (firstObject)
    {
        [objects addObject: firstObject];
        va_start(argumentList, firstObject);
        NSUInteger index = 1;
        while ((eachObject = va_arg(argumentList, id)))
        {
            (index++ & 0x01) ? [keys addObject: eachObject] : [objects addObject: eachObject];
        }
        va_end(argumentList);
    }
    
    
    if (objects.count == keys.count)
    {
        // 直接写空 跳到最后返回
    }
    else
    {
        (objects.count < keys.count)?[keys removeLastObject]:[objects removeLastObject];
    }
    
    return [self dictionaryWithObjects:objects forKeys:keys];
}

+ (instancetype)dictionaryWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)cnt

{
    NSMutableArray *validKeys = [NSMutableArray new];
    NSMutableArray *validObjs = [NSMutableArray new];
    
    for (NSUInteger i = 0; i < cnt; i ++) {
        if (objects[i] && keys[i])
        {
            [validKeys addObject:keys[i]];
            [validObjs addObject:objects[i]];
        }
    }
    
    return [self dictionaryWithObjects:validObjs forKeys:validKeys];
}

@end
