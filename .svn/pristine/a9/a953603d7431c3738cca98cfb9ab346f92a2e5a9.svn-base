//
//  ForumModelR.h
//  APP
//
//  Created by Martin.Liu on 16/1/7.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "BaseModel.h"
#import "ForumModel.h"
@class QWPostContentModelR;
@class QWPostContentInfo;
@interface ForumModelR : BaseModel

@end

@interface GetHotPostR : BaseModel
@property (nonatomic, strong) NSString* token;   // 登陆令牌
@property (nonatomic, assign) NSInteger page;   // 页数
@property (nonatomic, assign) NSInteger pageSize;   // 每页显示数
@end

@interface GetAllCircleListR : BaseModel
@property (nonatomic, strong) NSString* token;   // 登陆令牌
@end

@interface ApplyCirclerR : BaseModel
@property (nonatomic, strong) NSString* teamId;  // 圈子Id
@property (nonatomic, strong) NSString* token;   // 登陆令牌
@property (nonatomic, strong) NSString* applyReson; // 申请理由
@end

@interface AttentionMbrR : BaseModel
@property (nonatomic, strong) NSString* objId;  // 被关注的人Id
@property (nonatomic, assign) NSInteger reqBizType; // 业务请求类型(0:关注or 1：取消关注)
@property (nonatomic, strong) NSString* token;  // 登陆令牌
@end

@interface AttentionCircleR : BaseModel
@property (nonatomic, strong) NSString* teamId; // 圈子Id
@property (nonatomic, assign) NSInteger isAttentionTeam;    //业务请求类型(0:关注or 1：取消关注)
@property (nonatomic, strong) NSString* token;  // 登陆令牌
@end

@interface GetCirclerInfoR : BaseModel
@property (nonatomic, strong) NSString* teamId; // 圈子Id
@property (nonatomic, strong) NSString* token;  // 登陆令牌
@end

@interface GetPostListInfoR: BaseModel
@property (nonatomic, strong) NSString* teamId;    // 圈子Id
@property (nonatomic, strong) NSString* sortType;  // 排序类型: 1:看帖、2:热门、3:专家
@property (nonatomic, assign) NSInteger page;   // 页数
@property (nonatomic, assign) NSInteger pageSize;   // 每页显示数
@end

@interface GetCircleDetailsInfoR : BaseModel
@property (nonatomic, strong) NSString* teamId; // 圈子Id
@property (nonatomic, strong) NSString* token;  // 登陆令牌
@end

@interface ComplaintPostInfoR : BaseModel
@property (nonatomic, strong) NSString* token;          // 登陆令牌
@property (nonatomic, strong) NSString* objId;          // 举报对象Id
@property (nonatomic, strong) NSString* reson;          // 举报原因（存举报原因，用分号隔开）
@property (nonatomic, strong) NSString* resonRemark;    // 举报原因备注（用户填写的举报原因备注）
@end

@interface DeletePostInfoR : BaseModel
@property (nonatomic, strong) NSString* token;          // 登陆令牌
@property (nonatomic, strong) NSString* poster;         // 发帖人
@property (nonatomic, strong) NSString* postId;         // 帖子Id
@property (nonatomic, strong) NSString* postTitle;      // 帖子标题
@property (nonatomic, strong) NSString* teamId;         // 圈子Id
@end

@interface EditPostInfoR : BaseModel
@property (nonatomic, strong) NSString* token;          // 登陆令牌
@property (nonatomic, strong) NSString* operateType;    // 操作类型(0:新增,1:修改)
@property (nonatomic, strong) NSString* expertIds;      // 提醒专家Id(多个用分隔符)
@property (nonatomic, strong) QWPostContentModelR* postJson;       // 帖子信息Json集合
// 4.0.0 增加
@property (nonatomic, strong) NSString            *anonFlag;    // 是否匿名(Y/N)
@property (nonatomic, strong) NSString            *syncTeamId;  // 同步圈子ID  商家圈发帖的时候可以同步，公共圈不可同步
@end

@interface QWPostContentModelR : BaseModel
@property (nonatomic, strong) NSString* postId;         // 帖子ID
@property (nonatomic, strong) NSString* postTitle;      // 帖子标题
@property (nonatomic, strong) NSString* teamId;         // 圈子ID
@property (nonatomic, strong) NSString* status;         // 帖子状态（发布时：传2）
@property (nonatomic, strong) NSMutableArray * postContentList;  // QWPostContentDetailModel
@end

@interface QWPostContentDetailModelR : BaseModel
@property (nonatomic, strong) NSString* postContent;    //'帖子内容',
@property (nonatomic, strong) NSString* imgDesc;        //'【图片类型专用】内容描述',
@property (nonatomic, assign) NSInteger contentType;    //'帖子内容类型（1：文本、2：图片）',
@property (nonatomic, assign) NSInteger sort;           //'排序'

- (void)buildWithQWPostContentInfo:(QWPostContentInfo*)model;

@end

//@interface PostInfoR : BaseModel
//@property (nonatomic, strong) NSString* postId;         // 帖子ID
//@property (nonatomic, strong) NSString* postTitle;      // 帖子标题
//@property (nonatomic, strong) NSString* teamId;         // 圈子ID
//@property (nonatomic, strong) NSString* status;         // 帖子状态（发布时：传2）
//@property (nonatomic, strong) NSArray* postContentList; // QWPostContentDetailModel
//@end


@interface QWComplaintR : BaseModel
@property (nonatomic, assign) NSInteger objType;        // 举报对象类型：1.未开通微商的药房，2.社会药房，3.微商药房，4.帖子，5.药师
@property (nonatomic, strong) NSString* objId;          // 举报对象id
@property (nonatomic, strong) NSString* token;          // 举报人token
@property (nonatomic, strong) NSString* reason;         // 举报原因，若有多个原因则用分号隔开，中文
@property (nonatomic, strong) NSString* reasonRemark;   // 举报原因备注
@property (nonatomic, strong) NSString* title;          // 帖子标题
@end

@interface GetComplaintResonR : BaseModel
@property (nonatomic, assign) NSInteger objType;        // 举报对象类型：1.未开通微商的药房，2.社会药房，3.微商药房，4.帖子，5.药师
@end

@interface GetExpertListInfoR : BaseModel
@property (nonatomic, strong) NSString* token;          // 登陆令牌
@end

@interface GetPostDetailsR : BaseModel
@property (nonatomic, strong) NSString* token;          // 登陆令牌
@property (nonatomic, strong) NSString* postId;         // 帖子Id
@property (nonatomic, strong) NSString* deviceCode;     // 本机设备号
@property (nonatomic, assign) NSInteger page;           // 页数
@property (nonatomic, assign) NSInteger pageSize;       // 每页显示数
@property (nonatomic, assign) BOOL      showLink;
@end

@interface GetMyPostListR : BaseModel
@property (nonatomic, strong) NSString* token;          // 登陆令牌
@property (nonatomic, assign) NSInteger page;           // 页数
@property (nonatomic, assign) NSInteger pageSize;       // 每页显示数
@end

@interface PraisePostR : BaseModel
@property (nonatomic, strong) NSString* token;          // 登陆令牌
@property (nonatomic, strong) NSString* posterId;       // 发帖人
@property (nonatomic, strong) NSString* postTitle;      // 帖子标题
@property (nonatomic, strong) NSString* deviceCode;     // 本机设备号
@property (nonatomic, strong) NSString* postId;         // 帖子Id
@end

@interface GetMyCircleListR : BaseModel
@property (nonatomic, strong) NSString* token;          // 登录令牌
@end

@interface GetHisPostListR : BaseModel
@property (nonatomic, strong) NSString* userId;         // 用户Id
@end

@interface GetHisReplyR : BaseModel
@property (nonatomic, strong) NSString* userId;         // 用户Id
@end

@interface GetMyAttnExpertListR : BaseModel
@property (nonatomic, strong) NSString* token;          // 登陆令牌
@end

@interface GetMyFansListR : BaseModel
@property (nonatomic, strong) NSString* token;          // 登陆令牌
@end

@interface GetMyPostReplyListR : BaseModel
@property (nonatomic, strong) NSString* token;          // 登陆令牌
@property (nonatomic, assign) NSInteger page;           // 页数
@property (nonatomic, assign) NSInteger pageSize;       // 每页显示数
@end

@interface ReplyPostR : BaseModel
@property (nonatomic, strong) NSString* token;          // 登陆令牌
@property (nonatomic, strong) NSString* posterId;       // 发帖人
@property (nonatomic, strong) NSString* teamId;         // 圈子Id
@property (nonatomic, strong) NSString* postId;         // 帖子Id
@property (nonatomic, strong) NSString* postTitle;      // 帖子标题
@property (nonatomic, strong) NSString* content;        // 评论内容
@property (nonatomic, strong) NSString* replyId;        // 引用的回复ID
@end

@interface PostShareR : BaseModel
@property (nonatomic, strong) NSString* token;          // 登陆令牌
@property (nonatomic, assign) NSInteger channel;        // 分享渠道类型（1:微信, 2:微博, 3:QQ, 4:朋友圈）
@property (nonatomic, strong) NSString* postId;         // 帖子ID

@end

@interface GetCollectionPostR : BaseModel
@property (nonatomic,strong) NSString *token;
@property (nonatomic,assign) NSInteger currPage;
@property (nonatomic,assign) NSInteger pageSize;
@end

@interface TopPostR : BaseModel
@property (nonatomic, strong) NSString* token;          // 登陆令牌
@property (nonatomic, strong) NSString* postId;         // 置顶的帖子
@property (nonatomic, strong) NSString* cancelPostId;   // 取消置顶的帖子ID
@end

@interface CheckCollectPostR : BaseModel
@property (nonatomic, strong) NSString* token;          // 登陆令牌
@property (nonatomic, strong) NSString* objID;         // 置顶的帖子
@end

@interface CollectOBJR : BaseModel
@property (nonatomic, strong) NSString* token;          // 登陆令牌
@property (nonatomic, strong) NSString* objID;          // 置顶的帖子
@property (nonatomic, assign) NSInteger objType;        // 收藏对象类型（1:商品, 2:消息(用药指导收藏信息), 3:疾病, 4:保留, 5:健康资讯, 6:症状, 7:药店, 8:优惠活动, 9:专题/特刊, 10:帖子）
@end

@interface CancelCollectOBJR : BaseModel
@property (nonatomic, strong) NSString* token;          // 登陆令牌
@property (nonatomic, strong) NSString* objID;          // 置顶的帖子
@property (nonatomic, assign) NSInteger objType;        // 收藏对象类型（1:商品, 2:消息(用药指导收藏信息), 3:疾病, 4:保留, 5:健康资讯, 6:症状, 7:药店, 8:优惠活动, 9:专题/特刊, 10:帖子）
@end

@interface PraisePostComment : BaseModel
@property (nonatomic, strong) NSString* token;          // 登陆令牌
@property (nonatomic, strong) NSString* replyUserId;    // 评论人Id
@property (nonatomic, strong) NSString* postTitle;      // 帖子标题
@property (nonatomic, strong) NSString* deviceCode;     // 本机设备号
@property (nonatomic, strong) NSString* postId;         // 帖子Id
@property (nonatomic, strong) NSString* replyId;        // 评论Id
@end

@interface DeletePostReplyR : BaseModel
@property (nonatomic, strong) NSString* token;          // 登陆令牌
@property (nonatomic, strong) NSString* replyID;        // 该条回复的ID
@property (nonatomic, strong) NSString* replyerID;      // 回复人ID
@property (nonatomic, strong) NSString* teamID;         // 圈子ID

@end

@interface GetTopPostIdR : BaseModel
@property (nonatomic, strong) NSString* token;          // 登陆令牌
@end

/**
 *  4.0.0 可同步的圈子列表
 */
@interface GetSyncTeamListR : BaseModel
@property (nonatomic, strong) NSString* token;        // 登陆令牌
@property (nonatomic, assign) NSInteger type;         // 类型(1:用户端 2:商户端)
@end

/**
 *  4.0.1 获取是否禁言、是否申诉
 */
@interface GetSilenceStatusR : BaseModel
@property (nonatomic, strong) NSString *token;          // 用户令牌
@end