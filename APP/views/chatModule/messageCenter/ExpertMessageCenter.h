//
//  ExpertMessageCenter.h
//  wenYao-store
//  砖家私聊/抢答消息中心
//  Created by 李坚 on 16/3/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageCenter.h"
#import "ExpertAPI.h"

@interface ExpertMessageCenter : MessageCenter


@property (nonatomic, strong) NSString *recipientId;//接收人id，start方法调用之前传入

@property (nonatomic, strong) NSString *senderId;

/**
 *  循环拉取砖家私聊列表数据
 *  V3.1 GlobarManager定时器循环调用
 */
+ (void)pullAllExpertData;

//私聊列表全量拉取
+ (void)pollPrivateMessageExpertList;
//私聊列表全量拉取
+ (void)getAllPivateMessageExpertList;

@end
