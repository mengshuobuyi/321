//
//  XHmessage+Helper.h
//  APP
//
//  Created by garfield on 15/4/3.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "XHMessage.h"

@interface XHMessage (Helper)

/**
    聊天界面中的刷新最近历史记录
    @param 参数为服务器返回的json数组
 */
+ (void)refreshingRecentMessage:(NSArray *)array
                  messageSender:(NSString *)messageSender
                       official:(BOOL)official;

/**
    聊天界面中的下拉历史记录
    @param 参数为服务器返回的json数组
 */
+ (void)headerRefreshingMessage:(NSArray *)array
                  messageSender:(NSString *)messageSender
                       infoDict:(NSDictionary *)infoDict
                       messages:(NSMutableArray *)messages
                       official:(BOOL)official;

@end
