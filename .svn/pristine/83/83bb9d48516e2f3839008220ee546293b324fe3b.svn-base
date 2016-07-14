//
//  BasePrivateModel.m
//  APP
//
//  Created by qw on 15/3/11.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BasePrivateModel.h"
#import "QWGlobalManager.h"

@implementation BasePrivateModel

+(LKDBHelper*)getUsingLKDBHelperEx:(NSString*)dbName
{
    NSString* ret = [QWGLOBALMANAGER getPrivateDBName];
    if ([ret length] > 0) {
        NSString* resultPath = [NSString stringWithFormat:@"private_%@",ret];
        static LKDBHelper* db=nil;
        static NSString* dbName = @"";
        static dispatch_once_t onceToken1;
        if (db) {
            if (![dbName isEqualToString:resultPath])
            {
                db = nil;
                dbName = resultPath;
                NSString* dbpath = [LKDBHelper getDBPathWithDBName:resultPath];
                db = [[LKDBHelper alloc] initWithDBPath:dbpath];
            }
            [db createTableWithModelClass:[self class] tableName:[[self class] getTableName]];
        }
        else
        {
            dbName = resultPath;
            dispatch_once(&onceToken1, ^{
                NSString* dbpath = [LKDBHelper getDBPathWithDBName:resultPath];
                db = [[LKDBHelper alloc] initWithDBPath:dbpath];
            });
            [db createTableWithModelClass:[self class] tableName:[[self class] getTableName]];
        }
        return db;
    }
    return nil;
}

@end
