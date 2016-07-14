//
//  DBOperationExample.m
//  APP
//
//  Created by garfield on 15/7/6.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "DBOperationExample.h"

@implementation DBOperationExample

//查询所有对应会话ID的聊天历史记录
- (NSArray *)getAllMessages:(NSString *)sender
{
    NSString* where = [NSString stringWithFormat:@"sendname = '%@' or recvname = '%@'",sender,sender];
    return [QWMessage getArrayFromDBWithWhere:where];
}

//查询所有对应会话ID的聊天历史记录,按时间戳正向排序
- (NSArray *)getAllOrderMessages:(NSString *)sender
{
    NSString* where = [NSString stringWithFormat:@"sendname = '%@' or recvname = '%@'",sender,sender];
    return [QWMessage getArrayFromDBWithWhere:where WithorderBy:@"timestamp asc"];
}

/**
 *  查询指定ID的历史记录
 *
 *  @param offset 查询结果的偏移量,比如查出100条记录,offset为5,则从第6条数据开始返回
 *  @param count  总共返回数据条数总和
 */
- (NSArray *)getMessagesFromDBWithWhere:(NSString *)sender
                                 offset:(NSInteger)offset
                                  count:(NSInteger)count
{
    NSString* where = [NSString stringWithFormat:@"sendname = '%@' or recvname = '%@'",sender,sender];
    return [QWMessage getArrayFromDBWithWhere:where WithorderBy:@"timestamp asc" offset:offset count:count];
}

/**
 *  更新指定的msg
 *
 *  根据主键ID更新此记录,异步执行,如果存在则更新,否则就插入,不阻塞主线程,完成后执行block
 */
- (void)updateMessageToDB:(QWMessage *)msg
{
    //以主键更新该条记录,异步方式,不阻塞主线程,插入成功后执行block
    [QWMessage updateObjToDB:msg WithKey:msg.UUID withCallBackBlock:^(NSError *error) {
        if(error) {
            NSLog(@"update error,%@",error);
        }
    }];
}

/**
 *  更新指定的msg
 *
 *  根据主键ID更新此记录,与上述函数的区别在于该方法只执行update,如果该数据之前不存在,则返回错误,异步执行,不阻塞主线程,完成后执行block
 *  @param  set exp. issend = '2'发送成功
 *  @param  指定的UUID
 */
- (void)updateMessageSetToDB:(NSString *)set UUID:(NSString *)UUID
{
    [QWMessage updateSetToDB:set WithWhere:[NSString stringWithFormat:@"UUID = '%@'",UUID] withCallBackBlock:^(NSError *error) {
        if(error) {
            NSLog(@"update error,%@",error);
        }else{
            NSLog(@"更新成功");
        }
    }];
}

/**
 *  更新指定的msg
 *
 *  根据主键ID删除词条记录
 *  @param  待保存的msg
 *  @return 保存成功失败的状态
 */
- (BOOL)saveMessageToDB:(QWMessage *)msg
{
    return [QWMessage saveObjToDB:msg];
}

/**
 *  更新指定的msg数组
 *
 *  根据主键ID删除词条记录
 *  @param  待保存的msg数组
 *  @return 保存成功失败的状态
 */
- (BOOL)saveMessageArrayToDB:(NSArray *)array
{
    return [QWMessage saveObjToDBWithArray:array];
}

/**
 *  更新指定的msg
 *
 *  根据主键ID删除词条记录
 *  @param  待删除的msg
 */
- (BOOL)deleteMessageFromDB:(QWMessage *)msg
{
    return [QWMessage deleteObjFromDBWithKey:msg.UUID];
}

/**
 *  更新指定的msg
 *
 *  根据主键ID删除词条记录
 *  @param  删除的条件 exp.  UUID = '31324234'
 */
- (BOOL)deleteMessageFromDBWhere:(NSString *)where
{
    return [QWMessage deleteObjFromDBWithWhere:where];
}

@end
