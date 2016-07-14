//
//  Message.h
//  APP
//
//  Created by qw on 15/2/22.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BasePrivateModel.h"
#import "BasePrivateModel+ExcludeORM.h"

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

@interface QWMessage : BasePrivateModel

@property (nonatomic,strong) NSString           *direction;                 //营销活动
@property (nonatomic,strong) NSString           *timestamp;
@property (nonatomic,strong) NSString           *UUID;                      //聊天记录id 数据库关联
@property (nonatomic,strong) NSString           *star;                      //营销活动 title
@property (nonatomic,strong) NSString           *avatorUrl;                 //头像
@property (nonatomic,strong) NSString           *imgUrl;                    //图片地址
@property (nonatomic,strong) NSString           *sendname;
@property (nonatomic,strong) NSString           *recvname;
@property (nonatomic,strong) NSString           *issend;
@property (nonatomic,strong) NSString           *messagetype;
@property (nonatomic,strong) NSString           *isRead;
@property (nonatomic,strong) NSString           *richbody;                  //营销活动 图片地址或者经纬度信息
@property (nonatomic,strong) NSString           *body;
@property (nonatomic,strong) NSString           *voicePath;
@property (nonatomic,strong) NSString           *title;
@property (nonatomic,strong) NSString           *duration;
@property (nonatomic,strong) NSString           *fileUrl;
@property (nonatomic,strong) NSString           *download;
@property (nonatomic,strong) NSString           *list;
@property (nonatomic,assign) NSInteger            fromTag;
@property (nonatomic,assign) NSInteger            tags;

@property (nonatomic,strong) NSString *spec;
@property (nonatomic,strong) NSString *branchId;
@property (nonatomic,strong) NSString *branchProId;

-(id)initWithMessage:(QWMessage*)msg;
@end

@interface QWXPMessage :QWMessage
@property (nonatomic,strong) NSString           *direction;                 //收发
@property (nonatomic,strong) NSString           *timestamp;
@property (nonatomic,strong) NSString           *UUID;                      //聊天记录id 数据库关联
@property (nonatomic,strong) NSString           *star;                      //营销活动 title
@property (nonatomic,strong) NSString           *avatorUrl;                 //头像
@property (nonatomic,strong) NSString           *imgUrl;                    //图片地址
@property (nonatomic,strong) NSString           *sendname;
@property (nonatomic,strong) NSString           *recvname;
@property (nonatomic,strong) NSString           *issend;
@property (nonatomic,strong) NSString           *messagetype;
@property (nonatomic,strong) NSString           *isRead;
@property (nonatomic,strong) NSString           *richbody;                  //营销活动 图片地址或者经纬度信息
@property (nonatomic,strong) NSString           *body;
@property (nonatomic,strong) NSString           *title;
@property (nonatomic,strong) NSString           *duration;
@property (nonatomic,strong) NSString           *fileUrl;
@property (nonatomic,strong) NSString           *download;
@property (nonatomic,strong) NSString           *list;
@property (nonatomic,assign) NSInteger            fromTag;
@property (nonatomic,assign) NSInteger            tags;

@property (nonatomic,strong) NSString           *spec;
@property (nonatomic,strong) NSString           *branchId;
@property (nonatomic,strong) NSString           *branchProId;

@end

@interface QWPTPMessage :QWMessage
@property (nonatomic,strong) NSString           *direction;                 //收发
@property (nonatomic,strong) NSString           *timestamp;
@property (nonatomic,strong) NSString           *UUID;                      //聊天记录id 数据库关联
@property (nonatomic,strong) NSString           *star;                      //营销活动 title
@property (nonatomic,strong) NSString           *avatorUrl;                 //头像
@property (nonatomic,strong) NSString           *imgUrl;                    //图片地址
@property (nonatomic,strong) NSString           *sendname;
@property (nonatomic,strong) NSString           *recvname;
@property (nonatomic,strong) NSString           *issend;
@property (nonatomic,strong) NSString           *messagetype;
@property (nonatomic,strong) NSString           *isRead;
@property (nonatomic,strong) NSString           *richbody;                  //营销活动 图片地址或者经纬度信息
@property (nonatomic,strong) NSString           *body;
@property (nonatomic,strong) NSString           *title;
@property (nonatomic,strong) NSString           *duration;
@property (nonatomic,strong) NSString           *fileUrl;
@property (nonatomic,strong) NSString           *download;
@property (nonatomic,strong) NSString           *list;
@property (nonatomic,assign) NSInteger            fromTag;
@property (nonatomic,assign) NSInteger            tags;
@property (nonatomic,strong) NSString           *spec;
@property (nonatomic,strong) NSString           *branchId;
@property (nonatomic,strong) NSString           *branchProId;
@end

//    result = [_db executeUpdate:@"create table if not exists officialMessages(fromId text default '',toId text default '',timestamp text,body text,direction integer,messagetype integer,UUID text,issend integer,relatedid text,unique(UUID))"];

//officialMessages数据类型  官方

@interface OfficialMessages : BasePrivateModel

@property (nonatomic,strong) NSString           *relatedid;         //对方的qq号
@property (nonatomic,strong) NSString           *fromId;            //谁发的就是谁
@property (nonatomic,strong) NSString           *toId;              //谁收
@property (nonatomic,strong) NSString           *timestamp;
@property (nonatomic,strong) NSString           *body;
@property (nonatomic,strong) NSString           *direction;
@property (nonatomic,strong) NSString           *messagetype;
@property (nonatomic,strong) NSString           *UUID;              //聊天记录id 数据库关联
@property (nonatomic,strong) NSString           *issend;
@property (nonatomic,strong) NSString           *title;
@property (nonatomic,strong) NSString           *subTitle;
@property (nonatomic,assign) NSInteger           fromTag;

@property (nonatomic,strong) NSString           *unread;
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

@interface HistoryMessages : BasePrivateModel

@property (nonatomic,strong) NSString           *relatedid;             // 对应 ConsultId
@property (nonatomic,strong) NSString           *timestamp;             // 对应 consultLatestTime 最近回复时间
@property (nonatomic,strong) NSString           *body;                  // 对应 consultTitle
@property (nonatomic,strong) NSString           *direction;
@property (nonatomic,strong) NSString           *messagetype;
@property (nonatomic,strong) NSString           *UUID;
@property (nonatomic,strong) NSString           *issend;
@property (nonatomic,strong) NSString           *avatarurl;             // 对应 pharAvatarUrl
@property (nonatomic,strong) NSString           *groupName;             // 对应 pharShotName
@property (nonatomic,strong) NSString           *groupType;
@property (nonatomic,strong) NSString           *groupId;               //药店唯一标识
@property (nonatomic,assign) BOOL               diffusion;             //是否群发扩散消息,YES 代表群发扩散消息,NO代表指定药店
@property (nonatomic,strong) NSString           *isRead;
@property (nonatomic,strong) NSString           *stick;

@property (nonatomic, strong) NSString          *pharType;               // 对应PharType // 1是普通药师 2是明星药房
@property (nonatomic, strong) NSString          *consultStatus;          // 1等待药师回复、2药师已回复、3问题已过期、4问题已关闭
@property (nonatomic, strong) NSString          *unreadCounts;           // 未读数
@property (nonatomic, strong) NSString          *systemUnreadCounts;     // 系统未读数，如果过期，则为1

@property (nonatomic, strong) NSString          *consultMessage;         // 话术

// 新增
@property (nonatomic, strong) NSString          *isOutOfDate;             // 已过期
@property (nonatomic, strong) NSString          *isShowRedPoint;          // 过期问题显示小红点
@property (nonatomic, strong) NSString          *consultFormatShowTime;
//@property (nonatomic, strong) NSString          *isClosed;                // 问题已关闭
//@property (nonatomic, strong) NSString          *ClosedisRead;            // 关闭问题是否已读
@property (nonatomic,copy)NSString *nickname;
// change by perry
// 弃用
//@property (nonatomic, strong) NSString          *spreadHasReaded;        // 该扩散是否已读
//@property (nonatomic, strong) NSString          *isSpreadMsg;            // 是否是扩散消息
//@property (nonatomic, strong) NSString          *isQizCloseOrOutDate;    // 该消息是否关闭或者过期
//@property (nonatomic, strong) NSString          *qizHasReadCloseOrOutDate;   // 该关闭消息是否读过

@end

@interface TagWithMessage : BasePrivateModel

@property (nonatomic,strong) NSString           *UUID;
@property (nonatomic,strong) NSString           *start;
@property (nonatomic,strong) NSString           *length;
@property (nonatomic,strong) NSString           *tagType;
@property (nonatomic,strong) NSString           *title;
@property (nonatomic,strong) NSString           *tagId;

@end





@interface PharMsgModel : BasePrivateModel

@property (nonatomic, strong) NSString *type;       // 消息类型：1全维药事 2咨询 3即时聊天
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *formatShowTime;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *latestTime;
@property (nonatomic, strong) NSString *unreadCounts;           // 未读数
@property (nonatomic, strong) NSString *systemUnreadCounts;     // 系统未读数。=> 若>1，则表示有扩散提醒
@property (nonatomic, strong) NSString *branchId;   // 会话药师所属门店ID
@property (nonatomic, strong) NSString *branchName;
@property (nonatomic, strong) NSString *branchPassport;         // 会话药师所属门店账号ID
@property (nonatomic, strong) NSString *pharType;               // 1普通药师、2明星药师
@property (nonatomic, strong) NSString *sessionId;  // 会话编号
@property (nonatomic, strong) NSString *isRead;
@property (nonatomic,strong) NSString  *UUID;
@property (nonatomic,strong) NSString  *issend;
@property (nonatomic, strong) NSString *timestamp;


//@property (nonatomic, strong) NSString *sessionLatestContent;   // 会话内容
//@property (nonatomic, strong) NSString *sessionCreateTime;      // 会话创建时间
//@property (nonatomic, strong) NSString *sessionFormatShowTime;  // 会话显示时间 - 已格式化的创建时间
//@property (nonatomic, strong) NSString *sessionLatestTime;      // 最新一条回复时间
//@property (nonatomic, strong) NSString *pharAvatarUrl;          // 会话药师头像
//@property (nonatomic, strong) NSString *branchShortName;        // 会话药师所属门店简称
//@property (nonatomic, strong) NSString *body;

@end

@interface MsgNotifyListModel : BasePrivateModel
@property (nonatomic, strong) NSString *relatedid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *formatShowTime;
@property (nonatomic, strong) NSString *consultLatestTime;
@property (nonatomic, strong) NSString *showRedPoint;
@property (nonatomic, strong) NSString *consultStatus;
@property (nonatomic, strong) NSString *pharShortName;
@property (nonatomic, strong) NSString *unreadCounts;
@property (nonatomic, strong) NSString *systemUnreadCounts;
@property (nonatomic, strong) NSString *pharPassport;
@property (nonatomic, strong) NSString *pharAvatarUrl;
@property (nonatomic, strong) NSString *consultShowTitle;
@end
