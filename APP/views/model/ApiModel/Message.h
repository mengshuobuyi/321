//
//  Message.h
//  APP
//
//  Created by qw on 15/2/22.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BasePrivateModel.h"


//Message数据类型
//direction     1是incoming  0是outgoing
//timestamp     是当前发出消息的格林日志时间秒数
//UUID          每条消息的唯一标示符
//star          评价等级
//avatorUrl     头像地址
//sendname      对方的name
//recvname      本人名字
//issend        1是正在发送   2是发送成功   3发送失败
//messagetype   1文本信息    2图片信息    3语音信息   4位置信息  5评价信息
//unread        0已看    1未读  2语音信息已听
//richbody      存放的是富文本下载路径
//body          中存放的是消息的文本字段,如纯文本或者地址位置中描述信息

@interface Message : BasePrivateModel

@property (nonatomic,strong) NSString           *direction;
@property (nonatomic,strong) NSString           *timestamp;
@property (nonatomic,strong) NSString           *UUID;
@property (nonatomic,strong) NSString           *star;
@property (nonatomic,strong) NSString           *avatorUrl;
@property (nonatomic,strong) NSString           *sendname;
@property (nonatomic,strong) NSString           *recvname;
@property (nonatomic,strong) NSString           *issend;
@property (nonatomic,strong) NSString           *messagetype;
@property (nonatomic,strong) NSString           *unread;
@property (nonatomic,strong) NSString           *richbody;
@property (nonatomic,strong) NSString           *body;

-(void)parse:(id)value;

@end

//    result = [_db executeUpdate:@"create table if not exists officialMessages(fromId text default '',toId text default '',timestamp text,body text,direction integer,messagetype integer,UUID text,issend integer,relatedid text,unique(UUID))"];

//officialMessages数据类型  官方

@interface OfficialMessages : Message

@property (nonatomic,strong) NSString           *relatedid;
@property (nonatomic,strong) NSString           *fromId;
@property (nonatomic,strong) NSString           *toId;
@property (nonatomic,strong) NSString           *timestamp;
@property (nonatomic,strong) NSString           *body;
@property (nonatomic,strong) NSString           *direction;
@property (nonatomic,strong) NSString           *messagetype;
@property (nonatomic,strong) NSString           *UUID;
@property (nonatomic,strong) NSString           *issend;

@end


//HistoryMessages数据类型
//relatedid     消息关联的对方jid
//timestamp     时间戳
//body          平文本
//direction     0是incoming  1是outgoing
//messagetype   0文本信息    1图片信息    2语音信息   3位置信息  4评价信息
//UUID          每条消息的唯一标示符
//issend        1是正在发送   2是发送成功   3发送失败
//avatarurl     机构的logo
//groupName     机构名称
//groupType     机构类型

@interface HistoryMessages : Message

@property (nonatomic,strong) NSString           *relatedid;
@property (nonatomic,strong) NSString           *timestamp;
@property (nonatomic,strong) NSString           *body;
@property (nonatomic,strong) NSString           *direction;
@property (nonatomic,strong) NSString           *messagetype;
@property (nonatomic,strong) NSString           *UUID;
@property (nonatomic,strong) NSString           *issend;
@property (nonatomic,strong) NSString           *avatarurl;
@property (nonatomic,strong) NSString           *groupName;
@property (nonatomic,strong) NSString           *groupType;

@property (nonatomic,strong) NSString           *unread;
@property (nonatomic,strong) NSString           *stick;

@end