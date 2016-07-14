//
//  URICode.h
//  RYTong
//
//  Created by steven.
//  Copyright 2009 RYTong. All rights reserved.
//
/**
 编码类，该类的方法均为类方法

 */

@interface URICode : NSObject {
    
}
/**
 html转义方法
 
 */
+ (NSString*)escapeHTML:(NSString*)src;
/**
 转义后html转回方法
 
 */
+ (NSString*)unescapeHTML:(NSString*)src;

/**
 url编码
 
 */
+ (NSString*)escapeURIComponent:(NSString*)src;
/**
 url编码转回方法
 
 */
+ (NSString*)unescapeURIComponent:(NSString*)url;


@end

