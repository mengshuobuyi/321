//
//  MsgBoxModel.h
//  wenYao-store
//
//  Created by  ChenTaiyu on 16/5/17.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "BasePrivateModel.h"

typedef NS_ENUM(NSUInteger, MsgBoxMessageType) {
    MsgBoxMessageTypeQWYS,
    MsgBoxMessageTypeNotify = 1,
    MsgBoxMessageTypeOrder = 2,
    MsgBoxMessageTypeCredit = 3
};

typedef NS_ENUM(NSUInteger, MsgBoxCellActionType) {
    MsgBoxCellActionTypeOrder = 18,  //    18.原有的订单通知
    MsgBoxCellActionTypeProductDetail = 20,  //    20.跳转至商品详情
    MsgBoxCellActionTypeCoupon = 21,  //    21.跳转至优惠
    MsgBoxCellActionTypeOnSales = 22,  //    22.跳转至抢购
    MsgBoxCellActionTypeNotOutLink = 31,  //    31.无外链
    MsgBoxCellActionTypeOutLink = 32,  //    32.外链
    MsgBoxCellActionTypeCreditMsg = 33  //    33.积分消息
};

@interface MsgBoxModel : BasePrivateModel

+ (void)syncDBWithObjArray:(NSArray *)modelList;
+ (void)syncDBWithObjArray:(NSArray *)modelList primaryKey:(NSString *)primaryKey;
+ (NSUInteger)valueExists:(NSString *)key withValue:(NSString *)value withArr:(NSMutableArray *)arrOri;
+ (void)batchUpdateToDBWithArray:(NSArray *)modelList primaryKey:(NSString *)primaryKey completion:(void (^)(BOOL success))completion;
@end

@interface BranchNoticeIndexVo : BaseModel

@property (nonatomic, strong) NSString *apiStatus;
@property (nonatomic, strong) NSString *apiMessage;
@property (nonatomic, strong) NSArray *notices; //消息列表

@end

@interface BranchNoticeVo : MsgBoxModel
@property (nonatomic, strong) NSString *title; // 标题
@property (nonatomic, strong) NSString *content; //内容
@property (nonatomic, strong) NSString *formatShowTime; //显示时间
@property (nonatomic, strong) NSString *unread; //是否未读
@property (nonatomic, strong) NSString *type; //类型：1.消息中心 2.订单通知 3.积分通知,
@property (nonatomic, strong) NSString *time; //时间
@end

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