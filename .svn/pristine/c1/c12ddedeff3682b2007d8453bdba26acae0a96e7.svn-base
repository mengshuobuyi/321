//
//  ConsultPTPModel.h
//  APP
//
//  Created by carret on 15/6/4.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseAPIModel.h"
#import "BasePrivateModel.h"

@interface ConsultPTPModel : BaseAPIModel

@end

@interface CustomerSessionDetailList : BaseAPIModel
@property (nonatomic, strong) NSArray *details;
@property (nonatomic, strong) NSString *serverTime;
@property (nonatomic, strong) NSString *sessionCreateTime;
@property (nonatomic, strong) NSString *sessionId;
@property (nonatomic, strong) NSString *pharAvatarUrl;
@property (nonatomic, strong) NSString *pharType;
@property (nonatomic, strong) NSString *pharName;
@property (nonatomic, strong) NSString *pharContact;
@property (nonatomic, strong) NSString *branchId;
@property (nonatomic, strong) NSString *branchName;
@property (nonatomic, strong) NSString *branchAccount;
@end

@interface PharSessionDetailList : BaseAPIModel
@property (nonatomic, strong) NSArray *details;
@property (nonatomic, strong) NSString *serverTime;
@property (nonatomic, strong) NSString *sessionCreateTime;
@property (nonatomic, strong) NSString *pharAvatarUrl;
@property (nonatomic, strong) NSString *sessionId;
@property (nonatomic, strong) NSString *customerIndex;
@property (nonatomic, strong) NSString *customerAvatarUrl;
@property (nonatomic, strong) NSString *customerPassport;
@end

@interface SessionDetailVo : BaseModel
@property (nonatomic, strong) NSString *detailId;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *contentJson;
@property (nonatomic, strong) NSString *readStatus;
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic, strong) NSString *createTime;
@end


@interface MessageList : BaseAPIModel
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSString *lastTimestamp;
@end

@interface MessageItemVo : BaseModel
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *formatShowTime;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *unreadCounts;
@property (nonatomic, strong) NSString *branchId;
@property (nonatomic, strong) NSString *systemUnreadCounts;
@property (nonatomic, strong) NSString *branchName;
@property (nonatomic, strong) NSString *branchPassport;
@property (nonatomic, strong) NSString *pharType;
@property (nonatomic, strong) NSString *latestTime;
@property (nonatomic, strong) NSString *sessionId;
@end

@interface CustomerSessionList : BaseAPIModel
@property (nonatomic, strong) NSMutableArray *sessions;
@property (nonatomic, strong) NSString *lastTimestamp;
@end

@interface CustomerSessionVo : BaseModel
@property (nonatomic, strong) NSString *branchId;
@property (nonatomic, strong) NSString *sessionId;  // 会话编号
@property (nonatomic, strong) NSString *sessionLatestContent;   // 会话创建时间
@property (nonatomic, strong) NSString *sessionCreateTime;      // 会话创建时间
@property (nonatomic, strong) NSString *sessionFormatShowTime;  // 会话显示时间 - 已格式化的创建时间
@property (nonatomic, strong) NSString *sessionLatestTime;      // 最新一条回复时间

@property (nonatomic, strong) NSString *pharAvatarUrl;          // 会话药师头像
@property (nonatomic, strong) NSString *branchShortName;        // 会话药师所属门店简称
@property (nonatomic, strong) NSString *branchPassport;         // 会话药师所属门店账号ID
@property (nonatomic, strong) NSString *pharType;               // 1普通药师、2明星药师
@property (nonatomic, strong) NSString *unreadCounts;           // 未读数
@property (nonatomic, strong) NSString *systemUnreadCounts;     // 系统未读数。=> 若>1，则表示有扩散提醒

@end


@interface DetailCreateResult : BaseAPIModel
@property (nonatomic, strong) NSString *detailId;

@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *UUID;

@end

@interface ApiBody : BaseAPIModel

@end


////////
@interface PharSessionList : BaseAPIModel
@property (nonatomic, strong) NSArray *sessions;
@property (nonatomic, strong) NSString *lastTimestamp;
@property (nonatomic, strong) NSString *unreadCounts;
@end



@interface PharSessionVo  : BasePrivateModel
@property (nonatomic, strong) NSString *sessionId;
@property (nonatomic, strong) NSString *sessionCreateTime;
@property (nonatomic, strong) NSString *sessionFormatShowTime;
@property (nonatomic, strong) NSString *sessionLatestContent;
@property (nonatomic, strong) NSString *sessionLatestTime;
@property (nonatomic, strong) NSString *customerAvatarUrl;
@property (nonatomic, strong) NSString *customerIndex;
@property (nonatomic, strong) NSString *customerPassport;
@property (nonatomic, strong) NSString *unreadCounts;
@property (nonatomic, strong) NSString *sessionTop; //会话是否置顶。Y是 N否
@end



@interface SendPTPMap : BaseModel

@property (nonatomic, strong) NSString   *sessionId;
@property (nonatomic, strong) NSString   *sendStatus;
@property (nonatomic, strong) NSString   *body;
@end

