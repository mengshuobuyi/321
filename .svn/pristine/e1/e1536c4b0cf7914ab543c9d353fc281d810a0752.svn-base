//
//  DBOperationExample.h
//  APP
//
//  Created by garfield on 15/7/6.
//  Copyright (c) 2015年 carret. All rights reserved.
//

/**
 *  由于现在数据库统一采用LKDB框架,ORM形式进行数据的CRUD,优点为使用方便
 *  但缺点是每次都需要利用反射读取Model属性,拼接sql语句,在某些频繁IO进行
 *  数据操作的地方严重影响性能,导致界面卡顿
 *  出于此考虑,写了一套原始的Sql语句的方式,来加速DB的增删改查
 *  该类为Demo类,方便大家参考使用
 */


#import <Foundation/Foundation.h>
#import "QWMessage.h"
#import "BasePrivateModel+ExcludeORM.h"

@interface DBOperationExample : NSObject

//查询所有对应会话ID的聊天历史记录
- (NSArray *)getAllMessages:(NSString *)sender;

//查询所有对应会话ID的聊天历史记录,按时间戳正向排序
- (NSArray *)getAllOrderMessages:(NSString *)sender;

/**
 *  查询指定ID的历史记录
 *
 *  @param offset 查询结果的偏移量,比如查出100条记录,offset为5,则从第6条数据开始返回
 *  @param count  总共返回数据条数总和
 */
- (NSArray *)getMessagesFromDBWithWhere:(NSString *)sender
                                 offset:(NSInteger)offset
                                  count:(NSInteger)count;

/**
 *  更新指定的msg
 *
 *  根据主键ID更新此记录,异步执行,如果存在则更新,否则就插入,不阻塞主线程,完成后执行block
 */
- (void)updateMessageToDB:(QWMessage *)msg;

/**
 *  更新指定的msg
 *
 *  根据主键ID更新此记录,与上述函数的区别在于该方法只执行update,如果该数据之前不存在,则返回错误,异步执行,不阻塞主线程,完成后执行block
 *  @param  set exp. issend = '2'发送成功
 *  @param  指定的UUID
 */
- (void)updateMessageSetToDB:(NSString *)set UUID:(NSString *)UUID;

/**
 *  更新指定的msg
 *
 *  根据主键ID删除词条记录
 *  @param  待保存的msg
 *  @return 保存成功失败的状态
 */
- (BOOL)saveMessageToDB:(QWMessage *)msg;

/**
 *  更新指定的msg数组
 *
 *  根据主键ID删除词条记录
 *  @param  待保存的msg数组
 *  @return 保存成功失败的状态
 */
- (BOOL)saveMessageArrayToDB:(NSArray *)array;

/**
 *  更新指定的msg
 *
 *  根据主键ID删除词条记录
 *  @param  待删除的msg
 */
- (BOOL)deleteMessageFromDB:(QWMessage *)msg;

/**
 *  更新指定的msg
 *
 *  根据主键ID删除词条记录
 *  @param  删除的条件 exp.  UUID = '31324234'
 */
- (BOOL)deleteMessageFromDBWhere:(NSString *)where;

@end
