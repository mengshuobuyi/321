//
//  News_Channel.h
//  APP
//
//  Created by qw on 15/3/1.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseModel.h"

@interface News_Channel : BaseModel
@property (nonatomic,strong) NSString           *channelId;                  //消息id
@property (nonatomic,strong) NSString           *channelName;               //消息内容
@property (nonatomic,strong) NSString           *sort;              //消息发送者

+ (NSError *)saveEntityWithArray:(NSArray *)array;
+ (NSArray *)getEntity;
@end
