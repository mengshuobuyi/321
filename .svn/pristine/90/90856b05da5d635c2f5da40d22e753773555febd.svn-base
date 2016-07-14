//
//  UserChatModel.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/3/24.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "BaseAPIModel.h"
#import "BasePrivateModel.h"

@interface UserChatModel : BaseAPIModel

@end

//私聊列表
@interface PrivateChatPageModel : BaseAPIModel
@property (strong, nonatomic) NSString * lastTimestamp;         // 上次同步时间戳：服务器返回的,
@property (strong, nonatomic) NSArray * sessions;               // 会话列表
@end

@interface PrivateChatListModel : BaseAPIModel
@property (strong, nonatomic) NSString * sessionId;             // 会话Id,
@property (strong, nonatomic) NSString * recipientId;          // 接收人Id,
@property (strong, nonatomic) NSString * nickName;             // 昵称,
@property (strong, nonatomic) NSString * headImg;              // 头像,
@property (strong, nonatomic) NSString * mobile;               // 手机号,
@property (assign, nonatomic) int userType;                    // 用户类型(1:普通用户, 2:马甲, 3:专家),
@property (strong, nonatomic) NSString * respond;              // 最后回复内容,
@property (strong, nonatomic) NSString * respondDate;          // 最后回复时间,
@property (assign, nonatomic) BOOL readFlag;                   // 已读标识（Y/N
@end

//私聊详情
@interface PrivateChatDetailPageModel : BaseAPIModel
@property (strong, nonatomic) NSString * sessionId;            // 会话ID）,
@property (strong, nonatomic) NSString * nickName;             // 会话用户昵称,
@property (strong, nonatomic) NSString * headImg;              // 会话用户头像,
@property (strong, nonatomic) NSString * recipientId;           //会话用户账号,
@property (strong, nonatomic) NSArray * details;               // 会话明细,
@property (strong, nonatomic) NSString * serverTime;           // 当前服务器时间
@end

@interface PrivateChatDetailModel : BaseAPIModel
@property (strong, nonatomic) NSString * detailId;             // 私聊明细表ID,
@property (strong, nonatomic) NSString * sessionId;            // 会话Id,
@property (strong, nonatomic) NSString * recipientId;          // 接收人Id,
@property (strong, nonatomic) NSString * nickName;             // 接收人昵称,
@property (strong, nonatomic) NSString * headImg;              // 接收人头像,
@property (assign, nonatomic) int userType;                    // 接收人类型,
@property (assign, nonatomic) BOOL  myselfFlag;                // 是否本人,
@property (strong, nonatomic) NSString * contentJson;          // 会话json内容,
@property (strong, nonatomic) NSString * content;              // 会话内容（AB端展示或者分析使用）,
@property (strong, nonatomic) NSString * contentType;          // 会话内容类型(TXT/IMG/POS/ACT/AUD/PRO/PMT/SYS),
@property (assign, nonatomic) BOOL  readFlag;                  // 已读标识(Y/N),
@property (strong, nonatomic) NSString * device;               // 设备号,
@property (strong, nonatomic) NSString * createTime;           // 创建时间
@end

//问答列表
@interface InterlocutionPageModel : BasePrivateModel
@property (strong, nonatomic) NSArray *list;
@end

@interface InterlocutionListModel : BasePrivateModel
@property (strong, nonatomic) NSString * consultId;            // 咨询id,
@property (strong, nonatomic) NSString * consultTitle;         // 咨询的问题,
@property (strong, nonatomic) NSString * headImgUrl;           // 用户头像,
@property (strong, nonatomic) NSString * name;                 // 用户名称,
@property (strong, nonatomic) NSString * responseLast;         // 最后回复时间,
@property (strong, nonatomic) NSString * responseLastContent;  // 最后回复内容,
@property (assign, nonatomic) BOOL unRead;                     // 读取状态，true: 未读， false：已读,
@property (assign, nonatomic) int tab;                         // tab栏：1:待抢答，2：解答中，3已关闭
@property (strong, nonatomic) NSString *respondLastType;       //最后回复内容的类型
@end

//问答详情
@interface InterlocutionDetailPageModel : BasePrivateModel
@property (assign, nonatomic) int status;                      // 问题状态(1：待解答，2：已回复，3：已关闭，4:抢而未答，5:已过期)
@property (strong, nonatomic) NSArray * qaDetailListVOs;       // 问答列表
@property (strong, nonatomic) NSString * consultNotice;        // 问题状态提示,
@end

@interface InterlocutionDetailListModel : BasePrivateModel
@property (strong, nonatomic) NSString * direction;            // 会话类型(EC:专家推用户, CE:用户推专家),
@property (strong, nonatomic) NSString * nickName;             // 昵称,
@property (strong, nonatomic) NSString * headImg;              // 用户/专家头像,
@property (strong, nonatomic) NSString * displayDate;          // 回复时间，显示用,
@property (strong, nonatomic) NSString * createTime;           // 回复时间，long,
@property (strong, nonatomic) NSString * consultId;            // 咨询问题id,
@property (strong, nonatomic) NSString * detailId;             // 消息id,
@property (strong, nonatomic) NSString * content;              // 回复内容,
@property (strong, nonatomic) NSString * contentJson;          // 回复内容的json,
@property (strong, nonatomic) NSString * contentType;          // 会话内容类型(TXT/IMG/POS/ACT/AUD/PRO/PMT/SYS),
@property (assign, nonatomic) BOOL myselfFlag;                 // 是否是自己
@end









