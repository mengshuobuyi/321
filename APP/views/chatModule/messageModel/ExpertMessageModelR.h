//
//  ExpertMessageModelR.h
//  wenYao-store
//  砖家私聊/抢答param ModelR
//  Created by 李坚 on 16/3/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface ExpertMessageModelR : NSObject

@end

/**
 *  删除私聊 ModelR
 *  add at V3.1
 */
@interface ExpertDeleteModelR : BaseModel

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *sessionId;

@end


/**
 *  私聊发送 ModelR
 *  add at V3.1
 */
@interface ExpertCreateModelR : BaseModel

@property (nonatomic, strong) NSString *UUID;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *recipientId;
@property (nonatomic, strong) NSString *contentJson;
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic, strong) NSString *device;

@end



/**
 *  获取私聊详情 ModelR
 *  add at V3.1
 */
@interface ChatDetailModelR : BaseModel

@property (nonatomic, strong) NSString *token;      //专家令牌
@property (nonatomic, strong) NSString *sessionId;      //专家令牌
@property (nonatomic, strong) NSString *recipientId;   //会话用户账号UserId
@property (nonatomic, assign) NSInteger point;      //查询时间点（最后回复时间sessionLatestTime）。 0=>取系统当前最新时间，且类型为-1历史数据
@property (nonatomic, assign) NSInteger view;       //明细查询条数，默认10
@property (nonatomic, assign) NSInteger viewType;   //查询类型：-1 历史数据，1新数据

@end

@interface ChatNewDetailModelR : BaseModel
@property (nonatomic, strong) NSString *token;      //专家令牌
@property (nonatomic, strong) NSString *chatId;      //会话Id
@property (nonatomic, assign) NSInteger point;      //查询时间点（最后回复时间sessionLatestTime）。 0=>取系统当前最新时间，且类型为-1历史数据
@property (nonatomic, assign) NSInteger view;       //明细查询条数，默认10
@property (nonatomic, assign) NSInteger viewType;   //查询类型：-1 历史数据，1新数据
@end

/**
 *  获取会话列表 ModelR
 *  add at V3.1
 */
@interface ChatPointModelR : BaseModel

@property (nonatomic, strong) NSString *token;      //专家令牌
@property (nonatomic, assign) NSInteger point;      //查询时间点（最后回复时间sessionLatestTime）。 0=>取系统当前最新时间，且类型为-1历史数据
@property (nonatomic, assign) NSInteger view;       //明细查询条数，默认10
@property (nonatomic, assign) NSInteger viewType;   //查询类型：-1 历史数据，1新数据

@end

/**
 *  砖家回复问答 ModelR
 *  add at V3.1
 */
@interface ReplayInterlocuationModelR : BaseModel

@property (nonatomic, strong) NSString *token;      //专家令牌
@property (nonatomic, strong) NSString *consultId;  //咨询问题id
@property (nonatomic, strong) NSString *contentType;//回复明细类型：TXT、IMG、POS、ACT
@property (nonatomic, strong) NSString *contentJson;//回复明细内容，已格式化{"content":"回复内容"}
@end

/**
 *  砖家抢答、忽略、详情问答ModelR
 *  add at V3.1
 */
@interface InterlocuationModelR : BaseModel

@property (nonatomic, strong) NSString *token;      //专家令牌
@property (nonatomic, strong) NSString *consultId;  //咨询问题id
@property (nonatomic, assign) NSInteger expertPlatform;  //专家平台(1.App 2.m站 3.微信 4.马甲)

@end

/**
 *  问答问题列表 ModelR
 *  add at V3.1
 */
@interface QAListModelR : BaseModel

@property (nonatomic, strong) NSString *token;      //专家令牌
@property (nonatomic, strong) NSString *func;       //1:待抢答全量，2:待抢答增量， 3:解答中（全量），4:已关闭
@property (nonatomic, assign) NSInteger page;       //页码
@property (nonatomic, assign) NSInteger pageSize;   //分页条数
@end

/**
 *  问答发送 ModelR
 *  add at V3.1
 */
@interface ExpertXPCreateModelR : BaseModel

@property (nonatomic, strong) NSString *UUID;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *consultId;
@property (nonatomic, strong) NSString *contentJson;
@property (nonatomic, strong) NSString *contentType;

@end
