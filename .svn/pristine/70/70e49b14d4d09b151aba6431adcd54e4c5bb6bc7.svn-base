//
//  Message.m
//  APP
//  消息数据结构
//  Created by qw on 15/2/22.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWMessage.h"


@implementation QWMessage

+(NSString *)getPrimaryKey
{
    return @"UUID";
}

-(id)initWithMessage:(QWMessage*)msg
{
    if (self == [super init]) {
        self.direction=msg.direction;
        self.timestamp=msg.timestamp;
        self.UUID=msg.UUID;
        self.star=msg.star;
        self.avatorUrl=msg.avatorUrl;
        self.sendname=msg.sendname;
        self.recvname=msg.recvname;
        self.issend=msg.issend;
        self.messagetype=msg.messagetype;
        self.isRead=msg.isRead;
        self.richbody=msg.richbody;
        self.body=msg.body;
        self.fromTag=msg.fromTag;
        self.title=msg.title;
        self.imgUrl=msg.imgUrl;
        self.duration=msg.duration;
        self.voicePath=msg.voicePath;
        self.fileUrl=msg.fileUrl;
        self.download=msg.download;
        self.list=msg.list;
        self.tags=msg.tags;
        self.spec = msg.spec;
        self.branchId = msg.branchId;
        self.branchProId = msg.branchProId;
        return self;
    }
    return nil;
}
@end

@implementation QWXPMessage
@synthesize  direction;                 //营销活动
@synthesize  timestamp;
@synthesize  UUID;                      //聊天记录id 数据库关联
@synthesize  star;                      //营销活动 title
@synthesize  avatorUrl;
@synthesize  sendname;
@synthesize  recvname;
@synthesize  issend;
@synthesize  messagetype;
@synthesize  isRead;
@synthesize  richbody;                  //营销活动 图片地址或者经纬度信息
@synthesize  body;
@synthesize  fromTag;
@synthesize  title;
@synthesize imgUrl;
@synthesize duration;
@synthesize fileUrl;
@synthesize download;
@synthesize list;
@synthesize tags;
@synthesize spec;
@synthesize branchId;
@synthesize branchProId;

+(void)columnAttributeWithProperty:(LKDBProperty *)property
{
    if([property.sqlColumnName isEqualToString:@"UUID"])
    {
        property.isUnique = YES;
    }
}


+ (NSString *)getPrimaryKey
{
    return @"UUID";
}

@end

@implementation QWPTPMessage
@synthesize  direction;                 //营销活动
@synthesize  timestamp;
@synthesize  UUID;                      //聊天记录id 数据库关联
@synthesize  star;                      //营销活动 title
@synthesize  avatorUrl;
@synthesize  sendname;
@synthesize  recvname;
@synthesize  issend;
@synthesize  messagetype;
@synthesize  isRead;
@synthesize  richbody;                  //营销活动 图片地址或者经纬度信息
@synthesize  body;
@synthesize  fromTag;
@synthesize  title;
@synthesize imgUrl;
@synthesize duration;
@synthesize fileUrl;
@synthesize download;
@synthesize list;
@synthesize tags;
@synthesize spec;
@synthesize branchProId;
@synthesize branchId;

+ (NSString *)getPrimaryKey
{
    return @"UUID";
}
@end

@implementation PharMsgModel

+ (NSString *)getPrimaryKey
{
    return @"branchId";
}

@end

@implementation MsgNotifyListModel

+ (NSString *)getPrimaryKey
{
    return @"relatedid";
}

@end
@implementation OfficialMessages
+ (NSString *)getPrimaryKey
{
    return @"UUID";
}
@end

@implementation HistoryMessages

+ (NSString *)getPrimaryKey
{
    return @"relatedid";
}
@end

@implementation TagWithMessage

@end