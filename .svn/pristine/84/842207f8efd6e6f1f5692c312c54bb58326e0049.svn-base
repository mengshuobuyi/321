//
//  CompareDate.h
//  wenyao-store
//
//  Created by Meng on 14/10/30.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MengClass : NSObject
/**
 *  比较两个日期的大小
 *
 *  @param date01 日期1
 *  @param date02 日期2
 *
 *  @return 比较结果,int型  date1 > date2  返回1; date1 < date2 返回-1 ;相等 返回0
 */
+ (int)compareDate1:(NSString*)date01 withDate2:(NSString*)date02;

/**
 *  时间戳转换为时间字符串 yyyy-MM-dd
 *
 *  @param longTime 时间戳
 *
 *  @return 返回时间字符串 例如:2014-10-30
 */
+ (NSString *)dateStringFromLong:(id)longTime;

/**
 *  返回当前系统时间
 *
 *  @return 返回当前系统时间字符串 例如:2014-10-30
 */
+ (NSString * )localTime;


/**
 *  返回颜色
 *
 *  @param inColorString 十六进制字符串
 *
 *  @return RGB颜色
 */
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;

/**
 *  校验身份证号码
 */
+ (BOOL)validateIDCardNumber:(NSString *)value;

/**
 *  校验身份证号码
 *
 *  @param number 传入参数身份证号码
 *
 *  @return 返回是否是身份证号码
 */
+ (BOOL)checkIDNumber:(NSString *)number;

/**
 *  <#Description#>
 *
 *  @param sPaperId <#sPaperId description#>
 *
 *  @return <#return value description#>
 */
bool Chk18PaperId (NSString *sPaperId);
@end
