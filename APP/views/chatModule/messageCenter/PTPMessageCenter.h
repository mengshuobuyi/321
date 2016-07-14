//
//  PTPMessageCenter.h
//  APP
//
//  Created by Yan Qingyang on 15/6/29.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "MessageCenter.h"

@interface PTPMessageCenter : MessageCenter
//检查DB数据状态
+ (QWMessage*)checkMessageStateByID:(NSString*)oid;
//从DB删除所有该id
+ (BOOL)deleteMessagesByID:(NSString*)oid;
- (id)initWithID:(NSString*)oID sessionID:(NSString*)sessionID type:(IMType)type;
@end
