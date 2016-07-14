//
//  MessageCenter.h
//  AppFramework
//
//  Created by Yan Qingyang on 15/5/25.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QWMessage.h"
#import "MessageModel.h"
#import "uploadFile.h"
#import "ChatAPI.h"
#import "NSString+EX.h"
#import "UIImageView+WebCache.h"
#import "ConsultPTPR.h"
#import "FileManager.h"

typedef NS_ENUM(NSInteger, IMType) {
    IMTypeIM=0,
    IMTypeXPClient,
    IMTypeXPStore,
    IMTypePTPClient,
    IMTypePTPStore,
    
};

typedef NS_ENUM(NSInteger, IMListType) {
    IMListAll=0,
    IMListPolling,
    IMListDelete,
    IMListAdd,
    IMListHistory,
    IMListDB,
    IMListCurrent,
};

typedef void (^IMSuccessBlock)(id successObj);
typedef void (^IMFailureBlock)(id failureObj);
typedef void (^IMListBlock)(NSArray* list, IMListType gotType);
typedef void (^IMHistoryBlock)(BOOL hadHistory);


@interface MessageCenter : NSObject
@property (nonatomic, assign) id delegate;
@property (nonatomic,copy)   NSString       *oID;   //房间id
@property (nonatomic, assign) IMType        type;   //聊天类型
@property (nonatomic, assign) NSInteger     count;  //数据总数
@property (nonatomic, assign) double        serverTime;  //当前服务器时间
@property (nonatomic ,copy)NSString *shopName;
//@property (nonatomic,copy) NSString *avatarUrl;
#pragma mark -
//房间id，聊天类型
- (id)initWithID:(NSString*)oID type:(IMType)type;

- (void)start;//开始消息中心
- (void)close;//关闭消息中心
- (void)restart;//重新开始
- (void)stop;//暂停
- (void)expertStart;

- (BOOL)isClose;
//判断是否有数据
- (BOOL)hadMessages;

//显示tableview当前位置单数据
- (MessageModel*)getMessageByIndex:(NSInteger)index;
//- (void)getMessageByIndex:(NSInteger)index messageBlock:(void (^)(id message))messageBlock success:(IMSuccessBlock)success failure:(IMFailureBlock)failure;

- (void)sendMessageWithoutMessageQueue:(MessageModel*)model success:(IMSuccessBlock)success failure:(IMFailureBlock)failure;
//显示当前数据列表
- (void)getMessages:(IMListBlock)list success:(IMSuccessBlock)success failure:(IMFailureBlock)failure;

//翻上页数据列表
- (void)getHistory:(IMHistoryBlock)list success:(IMSuccessBlock)success failure:(IMFailureBlock)failure;

//添加对话
- (void)sendMessage:(MessageModel*)model success:(IMSuccessBlock)success failure:(IMFailureBlock)failure;
//重发对话
- (void)resendMessage:(MessageModel*)model success:(IMSuccessBlock)success failure:(IMFailureBlock)failure;
//删除对话
- (void)removeMessage:(MessageModel*)mode success:(IMSuccessBlock)success failure:(IMFailureBlock)failure;
//添加/重发大数据
- (void)sendFileMessage:(MessageModel*)model success:(IMSuccessBlock)success failure:(IMFailureBlock)failure  uploadProgressBlock:(void (^)(MessageModel* target, float progress ))uploadProgressBlock;
- (void)resendFileMessage:(MessageModel* )model success:(IMSuccessBlock)success failure:(IMFailureBlock)failure  uploadProgressBlock:(void (^)(MessageModel* target, float progress ))uploadProgressBlock;
//添加DB数据
- (void)addMessage:(MessageModel*)model;
//从队列删除该类型数据
- (BOOL)deleteMessagesByType:(MessageBodyType)type;

//获取图片UUID数组
- (NSArray*)getImages;



- (MessageModel *)getMessageWithUUID:(NSString *)uuid;//数组查询


- (NSInteger) getMessageIndex:(MessageModel*)messagemodel;

//更新mod
- (BOOL)updateAMessage:(MessageModel*)mode;
//////////////////////////////////////////////////////////////////////
//
// 以下父类方法，供子类调用
//
//////////////////////////////////////////////////////////////////////

#pragma mark - 内部方法
@property (nonatomic,copy)   NSString       *sessionID;
//@property (nonatomic,retain) NSString       *otherAvatarUrl;//对方头像
@property (nonatomic,assign) NSInteger      pageSize;
@property (nonatomic,assign) NSInteger     sendingCount;  //发送中总数

+ (QWMessage*)checkMessageState:(QWMessage*)msg;
#pragma mark  返回所需数据
- (void)showCurrentMessages:(IMListType)rType successData:(id)successData;
- (void)showHistoryMessages:(IMHistoryBlock)block success:(IMSuccessBlock)success;
#pragma mark API
- (void)getAllMessages;
- (void)pollMessages;
- (void)getHistoryMessages:(IMHistoryBlock)block success:(IMSuccessBlock)success failure:(IMFailureBlock)failure;
- (void)readMessages:(NSArray*)arrItems containSystem:(NSInteger)containSystem;
- (void)sendAMessage:(MessageModel*)model success:(IMSuccessBlock)success failure:(IMFailureBlock)failure;
- (void)deleteAMessage:(MessageModel*)model success:(IMSuccessBlock)success failure:(IMFailureBlock)failure;

- (void)sendAMessageDidSuccess:(NSString *)UUID QWMessage:(id)qwmsg MessageModel:(MessageModel*)msg;
- (void)sendAMessageDidFailure:(NSString *)UUID QWMessage:(id)qwmsg MessageModel:(MessageModel*)msg;
- (void)uploadImage:(NSData*)file params:(NSDictionary*)params success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure  uploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))uploadProgressBlock;
#pragma mark - 文件上传
- (void)uploadFile:(NSData*)file params:(NSDictionary*)params success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure  uploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))uploadProgressBlock;

#pragma mark - DB
- (void)DBDataInit;
- (NSArray *)getDataFromDB;
- (NSArray *)getCurrentMessagesFromDB;
- (MessageModel *)getLastModel;
- (MessageModel *)getOffsetModel;
- (BOOL)createMessage:(QWMessage*)msg;
- (BOOL)updateMessage:(QWMessage*)msg;
- (BOOL)updateMessage:(QWMessage*)msg where:(NSString*)where;
- (BOOL)deleteMessage:(QWMessage*)msg;
#pragma mark 数据转化
//api model转message model
- (BOOL)checkMessagesFromAPI:(id)mode type:(IMListType)lType;
//QWMessage->MessageModel
- (MessageModel *)buildMessageFromQWMessage:(QWMessage *)qwmsg;
//APIModel->QWMessage
- (QWMessage *)buildQWMessageFromAPIModel:(id)mode detail:(id)detail;
//MessageModel->QWMessage
- (QWMessage *)buildQWMessageFromMessage:(MessageModel *)model;
//加入MessageModel队列
- (void)messagesQueue:(id)obj reset:(BOOL)reset;
- (void)messagesHistory:(id)obj;
//反序
- (NSArray*)reverseArray:(NSArray*)arr;
#pragma mark  弹性轮询
- (void)checkNoDataTimes:(NSInteger)num;

#pragma mark 方法
//- (NSString*)getMessageType:(MessageBodyType)MessageBodyType;
- (void)setOffset:(NSInteger)index;
- (NSString *)toJSONStr:(id)theData;
- (NSString*)getReadIDs:(NSArray*)arrItems;
//加一秒
- (NSDate *)dateAddOneSecond:(NSDate*)date;
- (NSDate *)getServerMaxInterval;
@end
