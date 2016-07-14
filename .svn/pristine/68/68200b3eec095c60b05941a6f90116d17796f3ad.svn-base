//
//  NSMutableArray+EX.m
//  APP
//
//  Created by YAN Qingyang on 15/5/31.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "NSMutableArray+EX.h"

@implementation NSMutableArray (EX)
- (void)insertArray:(NSArray *)newAdditions atIndex:(NSUInteger)index
{
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    for(NSUInteger i = index;i < newAdditions.count+index;i++)
    {
        [indexes addIndex:i];
    }
    [self insertObjects:newAdditions atIndexes:indexes];
}
@end
