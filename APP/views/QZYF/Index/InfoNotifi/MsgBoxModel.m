//
//  MsgBoxModel.m
//  wenYao-store
//
//  Created by  ChenTaiyu on 16/5/17.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "MsgBoxModel.h"
#import "Order.h"
#import "QWGlobalManager.h"

@implementation MsgBoxModel

+ (void)syncDBWithObjArray:(NSArray *)modelList
{
    NSString *pKey = [[modelList.firstObject class] getPrimaryKey];
    @try {
        pKey = [[modelList.firstObject class] getPrimaryKey];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    if (pKey.length) {
        [self syncDBWithObjArray:modelList primaryKey:pKey];
    }
}

+ (void)syncDBWithObjArray:(NSArray *)modelList primaryKey:(NSString *)primaryKey
{
    if (!modelList.count ||!primaryKey.length) {
        return;
    }
    Class mClass = [[modelList firstObject] class];

    // 删除服务器上没有，本地有的缓存数据
    NSMutableArray *keyArr = [NSMutableArray array];
    for (id obj in modelList) {
        NSString *key = [obj valueForKey:primaryKey];
        if (key) {
            [keyArr addObject:key];
        }
    }
    [mClass deleteWithWhere:[NSString stringWithFormat:@"%@ not in (%@)", primaryKey,[[keyArr copy] componentsJoinedByString:@","]]];

    [self batchUpdateToDBWithArray:modelList primaryKey:primaryKey completion:^(BOOL success) {
        if (!success) {
        DebugLog(@"[%@ %s] : sqlite transaction update failed", NSStringFromClass(self.class), __func__);
        }
    }];
 
}

+ (void)batchUpdateToDBWithArray:(NSArray *)modelList primaryKey:(NSString *)primaryKey completion:(void (^)(BOOL success))completion
{
    // TODO: 表是否存在
    if (!modelList.count) return;
    Class mClass = [[modelList firstObject] class];
    [[mClass getUsingLKDBHelper] executeForTransaction:^BOOL(LKDBHelper *helper) {
        for (id obj in modelList) {
            if ([mClass isExistsWithModel:obj]) {
                if (![mClass updateToDB:obj where:@{primaryKey : [obj valueForKey:primaryKey]}]) {
                    // roll back
                    if (completion) completion(NO);
                    return NO;
                }
            } else {
                if (![mClass insertToDB:obj]) {
                    if (completion) completion(NO);
                    return NO;
                }
            }
        }
        if (completion) completion(YES);
        // commit
        return YES;
    }];
}

+ (NSUInteger)valueExists:(NSString *)key withValue:(NSString *)value withArr:(NSMutableArray *)arrOri
{
    NSPredicate *predExists = [NSPredicate predicateWithFormat:
                               @"%K MATCHES[c] %@", key, value];
    NSUInteger index = [arrOri indexOfObjectPassingTest:
                        ^(id obj, NSUInteger idx, BOOL *stop) {
                            return [predExists evaluateWithObject:obj];
                        }];
    return index;
}



@end

@implementation BranchNoticeIndexVo

@end

@implementation BranchNoticeVo

+ (NSString *)getPrimaryKey
{
    return @"type";
}

@end

@implementation MessageArrayVo

@end

@implementation MessageVo

+ (NSString *)getPrimaryKey
{
    return @"messageId";
}


+ (instancetype)modelCopyFromModel:(MessageVo *)model
{
    id newModel = [self new];
    unsigned int outCount = 0, i = 0;
    objc_property_t *properties = class_copyPropertyList([model class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [newModel setValue:[model valueForKey:propertyName] forKey:propertyName];
    }
    free(properties);
    return newModel;
}

@end

@implementation MsgBoxNotiMessageVo
+ (BOOL)isContainParent
{
    return YES;
}
@end

@implementation MsgBoxOrderMessageVo
+ (BOOL)isContainParent
{
    return YES;
}
@end

@implementation MsgBoxCreditMessageVo
+ (BOOL)isContainParent
{
    return YES;
}
@end
