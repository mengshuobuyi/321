//
//  MsgBoxModel.h
//  wenYao-store
//
//  Created by  ChenTaiyu on 16/5/17.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "BasePrivateModel.h"

@interface MsgBoxModel : BasePrivateModel

+ (void)syncDBWithObjArray:(NSArray *)modelList;
+ (void)syncDBWithObjArray:(NSArray *)modelList primaryKey:(NSString *)primaryKey;
+ (NSUInteger)valueExists:(NSString *)key withValue:(NSString *)value withArr:(NSMutableArray *)arrOri;
+ (void)batchUpdateToDBWithArray:(NSArray *)modelList primaryKey:(NSString *)primaryKey completion:(void (^)(BOOL success))completion;
@end

/*
 BranchNoticeIndexVo {
 apiStatus (int, optional),
 apiMessage (java.lang.String, optional),
 notices (java.util.List[BranchNoticeVo], optional): 消息列表
 }
 BranchNoticeVo {
 title (java.lang.String, optional): 标题,
 content (java.lang.String, optional): 内容,
 formatShowTime (java.lang.String, optional): 显示时间,
 type (int, optional): 类型：1.消息中心 2.订单通知 3.积分通知,
 unread (boolean, optional): 是否未读,
 time (long, optional): 时间
 }

 */
@interface BranchNoticeIndexVo : BaseModel

@property (nonatomic, strong) NSString *apiStatus;
@property (nonatomic, strong) NSString *apiMessage;
//@property (nonatomic, strong) NSString *lastTimestamp;
@property (nonatomic, strong) NSArray *notices;

@end

@interface BranchNoticeVo : MsgBoxModel
@property (nonatomic, strong) NSString *title; // 标题
@property (nonatomic, strong) NSString *content; //内容
@property (nonatomic, strong) NSString *formatShowTime; //显示时间
@property (nonatomic, strong) NSString *unread; //是否未读
@property (nonatomic, strong) NSString *type; //类型：1.消息中心 2.订单通知 3.积分通知,
@property (nonatomic, strong) NSString *time; //时间
@end

/*
 MessageArrayVo {
 apiStatus (int, optional),
 apiMessage (java.lang.String, optional),
 lastTimestamp (long, optional): 上次同步时间戳：服务器返回的,
 messages (java.util.List[MessageVo], optional): 消息列表
 }
 MessageVo {
 messageId (long, optional): 通知ID,
 createTime (long, optional): 通知时间,
 showTime (java.lang.String, optional): 通知显示时间 - 格式化,
 read (boolean, optional): 是否已读,
 title (java.lang.String, optional): 标题,
 content (java.lang.String, optional): 消息内容,
 objId (java.lang.String, optional): objid,
 objType (int, optional): objType
 }
 
 消息类型：
 18.原有的订单通知
 20.跳转至商品详情
 21.跳转至优惠
 22.跳转至抢购
 31.无外链
 32.外链
 33.积分消息
 */
@interface MessageArrayVo : BaseModel

@property (nonatomic, strong) NSString *apiStatus;
@property (nonatomic, strong) NSString *apiMessage;
@property (nonatomic, strong) NSString *lastTimestamp;
@property (nonatomic, strong) NSArray *messages;

@end


@interface MessageVo : MsgBoxModel
@property (nonatomic, strong) NSString *title; // 标题
@property (nonatomic, strong) NSString *content; //消息内容
@property (nonatomic, strong) NSString *messageId; 
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *showTime; //通知显示时间 - 格式化,
@property (nonatomic, strong) NSString *read; //是否已读
@property (nonatomic, strong) NSString *objId;
@property (nonatomic, strong) NSString *objType;
@property (nonatomic, strong) NSString *href;

+ (instancetype)modelCopyFromModel:(MessageVo *)model;

@end

@interface MsgBoxNotiMessageVo : MessageVo
@end

@interface MsgBoxOrderMessageVo : MessageVo
@end

@interface MsgBoxCreditMessageVo : MessageVo
@end