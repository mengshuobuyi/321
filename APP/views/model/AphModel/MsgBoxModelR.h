//
//  MsgBoxModelR.h
//  wenYao-store
//
//  Created by  ChenTaiyu on 16/5/18.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "BaseModel.h"

@interface MsgBoxModelR : BaseModel

@end

@interface  BranchNoticeIndexModelR: BaseModel
@property (nonatomic, strong) NSString *token;
@end

@interface MessageListPollModelR : BaseModel
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *lastTimestamp; // 0表示不传
@end

@interface MessageListModelR : BaseModel
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *view;
@end

@interface MessageListReadAllModelR : BaseModel
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *type; //消息类型：1.消息中心 2.订单通知 3.积分消息
@end

@interface MessageListReadSingleModelR : BaseModel
@property (nonatomic, strong) NSString *messageId; // 不需要token
@end
