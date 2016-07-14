//
//  NotificationModel.h
//  APP
//
//  Created by qw on 15/5/6.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseModel.h"

@interface NotificationModel : BaseModel

@property (nonatomic, strong) NSString *type;       //3:问题已关闭 4:  问题已过期   5: 第二次扩散
@property (nonatomic, strong) NSString *consultid;  //消息id

@property (nonatomic, strong) NSString *nd;     //  消息Id,
@property (nonatomic, strong) NSString *orderId;        // 订单ID

@property (nonatomic,assign) int msgClass; // 消息分类(1:评论 2:赞 (鲜花) 3:＠我的 99：系统消息),
@property (nonatomic,assign) int msgType; // 消息类型(1:评论 2:回复 3:我收藏的帖子有专家回复4:赞(获得鲜花) 5:＠我的 6:删除帖子 7:删除评论 8:举报 9:帐号安全 10:审核通过(认证)1:审核通过(圈子) 12:审核未通过 13:圈主移除 14:圈子下线 15:圈子上线 16:用户禁言 17:用户解禁 18:专家禁言 19:专家解禁 20:帖子恢复21:审核失败,


@end
