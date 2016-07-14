//
//  ExpertMessageModel.h
//  wenYao-store
//  砖家私聊/抢答responseObj Model
//  Created by 李坚 on 16/3/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseAPIModel.h"
#import "QWMessage.h"

#pragma mark - 私聊模块Model

@interface IMChatDetailSended  : BaseAPIModel

@property (nonatomic, strong) NSString *detailId; //会话明细Id
@property (nonatomic, strong) NSString *sessionId; //会话Id
@property (nonatomic, strong) NSString *createTime; //会话创建时间
@end

//用于存DB
@interface ExpertMessageModel : QWMessage

//父类继承
@property (nonatomic, strong) NSString *UUID;
@property (nonatomic, strong) NSString *timestamp;
@property (nonatomic, strong) NSString *isRead;
@property (nonatomic, strong) NSString *sendname;
@property (nonatomic, strong) NSString *recvname;
@property (nonatomic, strong) NSString *issend;
@property (nonatomic, strong) NSString *download;
@property (nonatomic, strong) NSString *direction;
@property (nonatomic, strong) NSString *avatorUrl;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *messagetype;
@property (nonatomic, strong) NSString *richbody;
@property (nonatomic, strong) NSString *fileUrl;
@property (nonatomic, strong) NSString *duration;

//特有
@property (nonatomic, strong) NSString *detailId;
@property (nonatomic, strong) NSString *recipientId;//接收人Id
@property (nonatomic, strong) NSString *passportId;
@property (nonatomic, strong) NSString *sessionId;
@property (nonatomic, strong) NSString *userType;//发送人的类型
@property (nonatomic, strong) NSString *posterId;//发送人Id
@property (nonatomic, strong) NSString *latestTime;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *spec;
@property (nonatomic, strong) NSString *branchId;
@property (nonatomic, strong) NSString *branchProId;
@property (nonatomic,strong) NSString    *imgUrl;                    //图片地址

@end

//用于寸DB
@interface ExpertXPMessageModel : QWMessage

//父类继承
@property (nonatomic, strong) NSString *UUID;
@property (nonatomic, strong) NSString *timestamp;
@property (nonatomic, strong) NSString *isRead;
@property (nonatomic, strong) NSString *sendname;
@property (nonatomic, strong) NSString *recvname;
@property (nonatomic, strong) NSString *issend;
@property (nonatomic, strong) NSString *download;
@property (nonatomic, strong) NSString *direction;
@property (nonatomic, strong) NSString *avatorUrl;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *messagetype;
@property (nonatomic, strong) NSString *richbody;

//特有
@property (nonatomic, strong) NSString *detailId;
@property (nonatomic, strong) NSString *consultId;//咨询问题id
@property (nonatomic, strong) NSString *latestTime;
@property (nonatomic, strong) NSString *content;

@end

/**
 *  会话列表 Model
 *  add at V3.1
 */
@interface ChatDetailList  : BaseAPIModel

@property (nonatomic, strong) NSString *sessionId;  //会话ID
@property (nonatomic, strong) NSString *nickName;   //会话用户昵称
@property (nonatomic, strong) NSString *headImg;    //会话用户头像
@property (nonatomic, strong) NSString *passportId; //会话用户账号
@property (nonatomic, strong) NSArray  *details;    //会话明细
@property (nonatomic, strong) NSString *serverTime; //当前服务器时间

@end

@interface IMChatDetailVo  : BaseModel

@property (nonatomic, strong) NSString *detailId;   //私聊明细表ID
@property (nonatomic, strong) NSString *sessionId;  //会话Id
@property (nonatomic, strong) NSString *recipientId;//接收人Id
@property (nonatomic, strong) NSString *senderId;   //发送人Id
@property (nonatomic, strong) NSString *nickName;   //接收人昵称
@property (nonatomic, strong) NSString *headImg;    //接收人头像
@property (nonatomic, strong) NSString *userType;   //接收人类型
@property (nonatomic, strong) NSString *contentJson;//会话json内容
@property (nonatomic, strong) NSString *content;    //会话内容（AB端展示或者分析使用）
@property (nonatomic, strong) NSString *contentType;//会话内容类型(TXT/IMG/POS/ACT/AUD/PRO/PMT/SYS)
@property (nonatomic, strong) NSString *myselfFlag; //是否本人
@property (nonatomic, strong) NSString *readFlag;   //已读标识(Y/N)
@property (nonatomic, strong) NSString *device;     //设备号
@property (nonatomic, strong) NSString *createTime; //创建时间
@end


/**
 *  会话列表 Model
 *  add at V3.1
 */
@interface ChatPointList  : BaseAPIModel

@property (nonatomic, strong) NSString *lastTimestamp;
@property (nonatomic, strong) NSArray *sessions;

@end

@interface IMChatPointVo  : BaseModel

@property (nonatomic, strong) NSString *sessionId;  //会话Id,
@property (nonatomic, strong) NSString *recipientId;//接收人Id,
@property (nonatomic, strong) NSString *nickname;   //昵称,
@property (nonatomic, strong) NSString *headImg;    //头像,
@property (nonatomic, strong) NSString *mobile;     //手机号,
@property (nonatomic, strong) NSString *userType;   //用户类型(1:普通用户, 2:马甲, 3:专家),
@property (nonatomic, strong) NSString *respond;    //最后回复内容,
@property (nonatomic, strong) NSString *respondDate;//最后回复时间,
@property (nonatomic, strong) NSString *readFlag;   //已读标识:YES未读,NO已读
@property (nonatomic, strong) NSString *displayDate;//最后回复时间，显示用

+ (BOOL)checkPMUnread;
@end



#pragma mark - 问答模块Model
/**
 *  问答消息轮循 Model
 */
@interface NewsList  : BaseModel

@property (nonatomic, strong) NSArray *list;        //时间

@end

@interface NewsVO  : BaseModel

@property (nonatomic, strong) NSString *content;        //消息内容
@property (nonatomic, strong) NSString *headImgUrl;     //头像
@property (nonatomic, strong) NSString *time;           //时间

@end

/**
 *  问答详情聊天 Model
 *  add at V3.1
 */
@interface QADetailVO  : BaseAPIModel

@property (nonatomic, strong) NSString *status;         //问题状态(1：待解答，2：已回复，3：已关闭)
@property (nonatomic, strong) NSArray  *qaDetailListVOs;//问答列表

@end

@interface QADetailListVO  : BaseAPIModel

@property (nonatomic, strong) NSString *detailId;       //消息id,
@property (nonatomic, strong) NSString *direction;      //会话类型(EC:专家推用户, CE:用户推专家),
@property (nonatomic, strong) NSString *nickName;       //昵称
@property (nonatomic, strong) NSString *headImg;        //用户/专家头像
@property (nonatomic, strong) NSString *displayDate;    //回复时间，显示用
@property (nonatomic, strong) NSString *createTime;     //回复时间,long
@property (nonatomic, strong) NSString *consultId;      //咨询问题id
@property (nonatomic, strong) NSString *content;        //回复内容
@property (nonatomic, strong) NSString *contentJson;    //回复内容的json
@property (nonatomic, strong) NSString *contentType;    //会话内容类型(TXT/IMG/POS/ACT/AUD/PRO/PMT/SYS),
@property (nonatomic, strong) NSString *myselfFlag;     //是否是自己
@end


/**
 *  问答列表 Model
 *  add at V3.1
 */
@interface QAList : BaseAPIModel

@property (nonatomic, strong) NSArray *list;

@end

@interface QAListVO : BaseModel

@property (nonatomic, strong) NSString *QAStatus;           //0待抢答，1解答中，2已关闭
@property (nonatomic, strong) NSString *consultId;          //咨询id
@property (nonatomic, strong) NSString *consultTitle;       //咨询的问题
@property (nonatomic, strong) NSString *headImgUrl;         //用户头像
@property (nonatomic, strong) NSString *name;               //用户名称
@property (nonatomic, strong) NSString *responseLast;       //最后回复时间
@property (nonatomic, strong) NSString *responseLastContent;//最后回复内容
@property (nonatomic, assign) BOOL      unRead;             //读取状态，true: 未读， false：已读
@end


@interface XPChatDetailSended  : BaseAPIModel

@property (nonatomic, strong) NSString *consultId;          //咨询问题id
@property (nonatomic, strong) NSString *detailId;           //消息id
@property (nonatomic, strong) NSString *uuid;               //APP消息id
@property (nonatomic, strong) NSString *createTime;         //创建时间

@end
