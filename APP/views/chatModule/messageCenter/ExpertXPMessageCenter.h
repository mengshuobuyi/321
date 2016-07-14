//
//  ExpertXPMessageCenter.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/3/26.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "MessageCenter.h"

typedef void (^IMPharConsultBlock)(id model);
@interface ExpertXPMessageCenter : MessageCenter

//预存数据，之后要发出去
@property (nonatomic, strong) NSMutableArray *arrPrepare;
@property (nonatomic, copy, readwrite) IMPharConsultBlock pharConsultBlock;

//只用于预存照片的发送，不重复加数据队列
- (void)sendPhotosMessage:(MessageModel* )model success:(IMSuccessBlock)success failure:(IMFailureBlock)failure  uploadProgressBlock:(void (^)(MessageModel* target, float progress ))uploadProgressBlock;

//特殊方法，不发送直接db加聊天数据
- (void)addMessagePre:(MessageModel*)model;
//检查DB数据状态
+ (QWMessage*)checkMessageStateByID:(NSString*)oid;
//从DB删除所有该id
+ (BOOL)deleteMessagesByID:(NSString*)oid;

@end
