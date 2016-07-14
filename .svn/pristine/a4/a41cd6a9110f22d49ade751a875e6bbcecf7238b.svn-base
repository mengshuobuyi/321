//
//  ForumModel.h
//  APP
//
//  Created by Martin.Liu on 16/1/7.
//  Copyright © 2016年 carret. All rights reserved.
//

// 圈子cell中显示的类型
typedef NS_ENUM(NSInteger, CircleCellType) {
    CircleCellType_None = 0,     // 不显示按钮
    CircleCellType_Normal,       // 全部圈子页面中使用 ：关注、取消关注、我是圈主
    CircleCellType_SelectedRadio // 选择圈子  单选
};

// 帖子cell所属页面类型
typedef NS_ENUM(NSInteger, PostCellType) {
    PostCellType_HotDiscuss ,           // 热议        置顶 > 专栏
    PostCellType_SpecailColumn ,        // 专栏        置顶 > 热门
    PostCellType_LookPost,              // 圈子看帖     置顶 > 专栏 > 热门
    PostCellType_HotTopic,              // 圈子热门     热门
    PostCellType_Expert,                // 圈子专家     专栏
    PostCellType_HisSendPost,           // 他的发帖     热门
    PostCellType_MineSendPost,          // 我的发帖     热门
    PostCellType_CollectionPost,        // 收藏的帖子   专栏 > 热门
};

// 如果圈子cell类型是CircleCellType_Normal的情况下 圈子关注按钮类型
typedef NS_ENUM(NSInteger, CircleTableCellType) {
    CircleTableCellType_None,
    CircleTableCellType_Care,
    CircleTableCellType_CancelCare,
    CircleTableCellType_IAMCircler,
};

// 帖子发布者类型
typedef NS_ENUM(NSInteger, PosterType) {
    PosterType_Nomal = 1,     // 普通用户
    PosterType_MaJia = 2,        // 马甲
    PosterType_YaoShi = 3,        // 药师
    PosterType_YingYangShi = 4    // 营养师
};

// 帖子发布状态 帖子状态 (1:草稿箱/待发布, 2:已发布, 3已删除/取消发布),
typedef NS_ENUM(NSInteger, PostStatusType) {
    PostStatusType_None = 0,            // 帖子默认状态
    PostStatusType_WaitForPost = 1,     // 草稿箱/待发布
    PostStatusType_HavePost,            // 已发布
    PostStatusType_Delete,              // 已删除/取消发布
    
    PostStatusType_SaveDraft,           // 保存草稿 点击保存按钮 保存草稿箱会赋此值
    PostStatusType_Editing,             // 编辑中 ， 草稿箱专用 ， 为了不让点击提醒专家
};

#define ForumDefaultImage [UIImage imageNamed:@"expert_ic_people"]
#define ForumCircleImage [UIImage imageNamed:@"bg_tx_circletouxiang"]
#import "BaseAPIModel.h"
#import "ForumModelR.h"
#import "CircleModel.h"
#import "QWMessage.h"

@class QWPostContentInfoWithImage;
@interface ForumModel : BaseAPIModel

@end

// 热议
@interface QWCircleHotInfo : BaseAPIModel
@property (nonatomic, strong) NSArray* teamList;            // 推荐圈子
@property (nonatomic, strong) NSArray* noticePushList;      // 公告
@property (nonatomic, strong) NSArray* postInfoList;        // 热帖列表
@end

// 圈子
@interface QWCircleModel : BaseAPIModel
@property (nonatomic, strong) NSString* teamId;         // 圈子ID
@property (nonatomic, strong) NSString* teamName;       // 圈子名称
@property (nonatomic, strong) NSString* teamDesc;       // 圈子描述
@property (nonatomic, strong) NSString* teamLogo;       // 圈子Logo
@property (nonatomic, assign) NSInteger postCount;      // 帖子数
@property (nonatomic, assign) NSInteger attnCount;      // 关注人数
@property (nonatomic, assign) NSInteger master;         // 专家圈主数
@property (nonatomic, assign) BOOL flagPhar;       // 是否有药师(Y:是,N:否)
@property (nonatomic, assign) BOOL flagDietitian;  // 是否有营养师(Y:是,N:否)
@property (nonatomic, assign) BOOL flagRecommend;  // 是否推荐(Y:是,N:否)
@property (nonatomic, assign) BOOL flagMaxMaster;  // 是否达到圈主上限(Y:是,N:否)
@property (nonatomic, assign) BOOL flagMaster;     // 是否圈主(Y:是,N:否)
@property (nonatomic, assign) BOOL flagAttn;       // 是否关注(Y:是,N:否)

- (void)buildWithCircleListModel:(CircleListModel*)model;

@end

// 通知
@interface QWNoticePushModel : BaseAPIModel
@property (nonatomic, strong) NSString* noticeId;           // 通知编号
@property (nonatomic, strong) NSString* noticeTitle;        // 对象
@property (nonatomic, strong) NSString* noticeContent;      // 类型内容
@property (nonatomic, assign) NSInteger columnType;        // 栏目分类（1:外链 、10:帖子）,

@end

// 帖子
@interface QWPostModel : BaseAPIModel
@property (nonatomic, strong) NSString* postId;         // 帖子ID,
@property (nonatomic, strong) NSString* postTitle;      // 帖子标题
@property (nonatomic, strong) NSString* posterId;         // 发帖人
@property (nonatomic, assign) NSInteger posterType;     // 发帖人类型(1:普通用户, 2:马甲, 3:药师, 4:营养师),
@property (nonatomic, strong) NSString* headUrl;        // 头像
@property (nonatomic, strong) NSString* nickname;       // 昵称
@property (nonatomic, assign) NSInteger mbrLvl;         // 用户等级
@property (nonatomic, strong) NSString* brandName;      // 专家品牌名称
@property (nonatomic, strong) NSString* postDate;       // 发帖时间
@property (nonatomic, strong) NSString* postStrDate;    // 显示的发帖时间差
@property (nonatomic, strong) NSString* teamId;         // 圈子ID
@property (nonatomic, strong) NSString* teamName;       // 圈子名称
//@property (nonatomic, strong) NSString* brandLogo;      // 专家品牌logo
@property (nonatomic, assign) NSInteger readCount;      // 阅读数
@property (nonatomic, assign) NSInteger replyCount;     // 回复数
@property (nonatomic, assign) NSInteger upVoteCount;    // 点赞数
@property (nonatomic, assign) NSInteger collectCount;   // 收藏数
@property (nonatomic, assign) NSInteger shareCount;     // 分享数

@property (nonatomic, assign) BOOL flagTopHot;     // 是否热议置顶(Y:置顶,N:置顶),
@property (nonatomic, assign) BOOL flagTopTeam;    // 是否圈内置顶(Y:置顶,N:置顶),
@property (nonatomic, assign) BOOL flagTopExpert;  // 是否专家置顶(Y:置顶,N:置顶),
@property (nonatomic, assign) BOOL isHot;           // 是否热帖
@property (nonatomic, assign) BOOL flagReply;           // 是否已回复,
@property (nonatomic, strong) NSString* postHotDate;    // 成为热帖时间
@property (nonatomic, assign) NSInteger postStatus;     // 帖子状态(1:草稿箱/待发布, 2:已发布, 3已删除/取消发布)
@property (nonatomic, strong) NSString* postContent;    // 帖子内容概述
@property (nonatomic, strong) NSArray* postImgList;     // 帖子图片链接（List集合）
@end

@interface QWPostDetailModel : BaseAPIModel
@property (nonatomic, strong) NSString* postId;         // 帖子ID,
@property (nonatomic, strong) NSString* postTitle;      // 帖子标题
@property (nonatomic, strong) NSString* posterId;         // 发帖人
@property (nonatomic, assign) NSInteger posterType;     // 发帖人类型(1:普通用户, 2:马甲, 3:药师, 4:营养师),
@property (nonatomic, strong) NSString* postDate;       // 发帖时间
@property (nonatomic, strong) NSString* postStrDate;    // 显示的发帖时间差
@property (nonatomic, strong) NSString* teamId;         // 圈子ID
@property (nonatomic, strong) NSString* teamName;       // 圈子名称
@property (nonatomic, strong) NSString* teamLogo;       //  圈子Logo
@property (nonatomic, strong) NSString* headUrl;        // 头像
@property (nonatomic, strong) NSString* nickname;       // 昵称
@property (nonatomic, assign) NSInteger mbrLvl;         // 用户等级
@property (nonatomic, strong) NSString* brandName;      // 专家品牌名称
//@property (nonatomic, strong) NSString* brandLogo;      // 专家品牌logo
@property (nonatomic, assign) NSInteger readCount;      // 阅读数
@property (nonatomic, assign) NSInteger replyCount;     // 回复数
@property (nonatomic, assign) NSInteger upVoteCount;    // 点赞数
@property (nonatomic, assign) NSInteger collectCount;   // 收藏数
@property (nonatomic, assign) NSInteger shareCount;     // 分享数

@property (nonatomic, assign) NSInteger postStatus;     // 帖子状态(1:草稿箱/待发布, 2:已发布, 3已删除/取消发布),
@property (nonatomic, strong) NSString* postContent;    // 帖子内容概述
@property (nonatomic, assign) BOOL flagMaster;          // 是否圈主
@property (nonatomic, assign) BOOL flagAttn;            // 是否已关注
@property (nonatomic, strong) NSArray* postContentList; // 帖子内容列表（List集合）
@property (nonatomic, strong) NSArray*postReplyList;    // 帖子回复列表（List集合）
@property (nonatomic, assign) BOOL flagFavorite;        // 是否已收藏
@property (nonatomic, assign) BOOL flagZan;             // 是否已点赞
@property (nonatomic, assign) BOOL      flagAnon;           // 是否匿名 4.0.0 增加

// 4.0.0增加 为了加入参数
@property (nonatomic, strong) NSString  *syncTeamId;        // 同步圈子ID
@end

@interface QWPostContentInfo : BaseModel

@property (nonatomic, strong) NSString* postContentId;      // 帖子内容ID
@property (nonatomic, strong) NSString* postId;             // 帖子ID
@property (nonatomic, strong) NSString* postContent;        // 帖子内容
@property (nonatomic, strong) NSString* postContentDesc;    // 【图片类型专用】内容描述
@property (nonatomic, assign) NSInteger postContentType;    // 内容类型（1:文本、2:图片）
@property (nonatomic, assign) NSInteger postContentSort;    // 排序
@property (nonatomic, strong) NSMutableArray   *tagList;    //超链接的tag Model

- (void)buildWithQWPostContentInfoWithImage:(QWPostContentInfoWithImage*)model;
@end

@interface QWPostContentInfoWithImage : QWPostContentInfo
@property (nonatomic, strong) UIImage* fullImage;
@end

@interface QWPostReply : BaseModel

@property (nonatomic, strong) NSString* id;             // 回复ID
@property (nonatomic, strong) NSString* replier;        // 回帖人
@property (nonatomic, strong) NSString* headUrl;        // 头像
@property (nonatomic, strong) NSString* nickName;       // 昵称
@property (nonatomic, assign) NSInteger mbrLvl;         //【冗余】用户等级
@property (nonatomic, strong) NSString* brandName;      //【冗余】专家品牌名称
@property (nonatomic, assign) NSInteger replierType;    // 回帖人类型(1:普通用户, 2:马甲, 3:药师, 4:营养师)
@property (nonatomic, strong) NSString* content;        // 回复内容
@property (nonatomic, strong) NSString* postId;         // 帖子ID
@property (nonatomic, strong) NSString* postTitle;      //【冗余】贴子标题
@property (nonatomic, strong) NSString* replyId;        // 引用的回复ID
@property (nonatomic, strong) NSString* replyUserName;  //【冗余】引用回复人名称
@property (nonatomic, strong) NSString* replyContent;   //【冗余】引用回复人名称,冗余】引用回复内容
@property (nonatomic, assign) NSInteger upVoteCount;    // 点赞数
@property (nonatomic, assign) NSInteger floor;          // 楼层
@property (nonatomic, assign) BOOL flagPoster;          // 是否楼主(Y/N
@property (nonatomic, assign) NSInteger status;         // 状态(1:有效, 2:隐藏)
@property (nonatomic, strong) NSString* createDate;     // 回复时间
@property (nonatomic, assign) BOOL flagZan;             // 是否对评论点过赞
@property (nonatomic, assign) BOOL silencedFlag;        // 回复人是否禁言
@property (nonatomic, assign) BOOL replySilencedFlag;   // 引用回复人是否禁言
@property (nonatomic, assign) BOOL isExpandComment;     // 是否展开评论内容
@property (nonatomic, assign) BOOL isExpandReply;       // 是否展开回复内容
@end

// 圈主
@interface QWCirclerModel : BaseAPIModel
@property (nonatomic, strong) NSString* id;             // 编号
@property (nonatomic, strong) NSString* nickName;       // 昵称
@property (nonatomic, strong) NSString* name;           // 姓名
@property (nonatomic, strong) NSString* headImageUrl;   // 用户头像
@property (nonatomic, strong) NSString* groupName;      // 商户/品牌名称
@property (nonatomic, assign) NSInteger postCount;      // 帖子数
@property (nonatomic, assign) NSInteger replyCount;     // 回复数
@property (nonatomic, assign) NSInteger userType;       // 用户类型
@property (nonatomic, assign) BOOL isAttnFlag;          // 是否关注圈子 Y:已关注，N:未关注
@property (nonatomic, assign) BOOL isMaster;            // 是否圈主Y:圈主，N:非圈主
@end

// 圈子-详细信息
@interface QWCircleDetailsInfo : BaseAPIModel
@property (nonatomic, strong) NSArray* teamVo;          // 圈子信息
@property (nonatomic, strong) NSArray* postInfoList;    // 帖子列表
@end


//@interface QWPostContentModel : BaseModel
//@property (nonatomic, strong) NSString* postId;         // 帖子ID
//@property (nonatomic, strong) NSString* postTitle;      // 帖子标题
//@property (nonatomic, strong) NSString* teamId;         // 圈子ID
//@property (nonatomic, strong) NSString* status;         // 帖子状态（发布时：传2）
//@property (nonatomic, strong) NSMutableArray * postContentList;  // QWPostContentDetailModel
//@end
//
//@interface QWPostContentDetailModel : BaseModel
//@property (nonatomic, strong) NSString* postContent;    //'帖子内容',
//@property (nonatomic, strong) NSString* imgDesc;        //'【图片类型专用】内容描述',
//@property (nonatomic, assign) NSInteger contentType;    //'帖子内容类型（0：文本、1：图片）',
//@property (nonatomic, strong) NSString* sort;           //'排序'
//- (void)buildWithQWPostContentDetailWithImageModel:(QWPostContentDetailWithImageModel*)model;
//@end

// 客户端自用
//@interface QWPostContentDetailWithImageModel : QWPostContentDetailModel
//@property (nonatomic, strong) UIImage* fullImage;
//@end

@interface QWExpertInfoModel : BaseModel<NSCopying>

@property (nonatomic, strong) NSString* id;             // 编号,
@property (nonatomic, strong) NSString* nickName;       // 昵称
@property (nonatomic, strong) NSString* name;           // 姓名
@property (nonatomic, strong) NSString* headImageUrl;   // 用户头像
@property (nonatomic, strong) NSString* groupName;      // 商户/品牌名称
@property (nonatomic, assign) NSInteger postCount;      // 帖子数
@property (nonatomic, assign) NSInteger replyCount;     // 回复数
@property (nonatomic, assign) NSInteger mbrLvl;         // 用户等级
@property (nonatomic, assign) NSInteger upVoteCount;    // 点赞数,
@property (nonatomic, assign) NSInteger attnCount;      // 关注数,
@property (nonatomic, assign) NSInteger userType;       // 用户类型,
@property (nonatomic, strong) NSString* expertise;      // 擅长领域,
@property (nonatomic, assign) BOOL isAttnFlag;          // 是否关注圈子 ,
@property (nonatomic, assign) BOOL isMaster;            // 是否圈主
@end

@interface QWAttnAndRecommendExpertList : BaseModel
@property (nonatomic, strong) NSArray* attnExpertList;  // 我关注的专家列表
@property (nonatomic, strong) NSArray* expertList;  // 推荐的专家列表

@end

@interface QWComplaintReason : BaseModel
@property (nonatomic, strong) NSString* reasonId;       // 举报原因id
@property (nonatomic, strong) NSString* content;        // 举报原因
@end


@interface QWMyCircleList : BaseAPIModel
@property (nonatomic, strong) NSArray* teamList;        // 我的圈子列表
@property (nonatomic, strong) NSArray* attnTeamList;    // 我关注的圈子列表
@end

@interface QWPostDrafts : BaseModel
@property (nonatomic, strong) NSString* passPort;
@property (nonatomic, strong) NSString* postId;
@property (nonatomic, assign) PostStatusType postStatus;
@property (nonatomic, strong) QWPostDetailModel* postDetail;
@property (nonatomic, strong) NSArray* reminderExperts;
@property (nonatomic, strong) QWCircleModel* sendCircle;

+ (BOOL)deleteWIthPostId:(NSString*)postId;

@end

@interface PostCollectList : BaseAPIModel
@property (nonatomic,strong) NSArray *postInfoList;
@end

@interface PostCollectVo : BaseModel
@property (nonatomic, strong) NSString *postId;// 帖子ID,
@property (nonatomic, strong) NSString *postTitle ;// 帖子标题,
@property (nonatomic, strong) NSString *posterId ;//发帖人,
@property (nonatomic, strong) NSString *posterType; //发帖人类型(1:普通用户, 2:马甲, 3:药师, 4:营养师),
@property (nonatomic, strong) NSString *headUrl ;//头像,
@property (nonatomic, strong) NSString *nickname ;// 昵称,
@property (nonatomic, strong) NSString *mbrLvl;//用户等级,
@property (nonatomic, strong) NSString *brandName; //专家品牌名称,
@property (nonatomic, strong) NSString *postDate ;// 发帖时间,
@property (nonatomic, strong) NSString *postStrDate ;// 显示的发帖时间差,
@property (nonatomic, strong) NSString *teamId ;//圈子ID,
@property (nonatomic, strong) NSString *teamName ;// 圈子名称,
@property (nonatomic, strong) NSString *readCount ; //阅读数,
@property (nonatomic, strong) NSString *replyCount ;// 回复数,
@property (nonatomic, strong) NSString *upVoteCount ;// 点赞数,
@property (nonatomic, strong) NSString *collectCount; //收藏数,
@property (nonatomic, strong) NSString *shareCount ;//分享数,
@property (nonatomic, assign) BOOL flagTopHot ; //是否热议置顶,
@property (nonatomic, assign) BOOL flagTopTeam ;// 是否圈内置顶,
@property (nonatomic, assign) BOOL flagTopExpert ; //是否专家置顶,
@property (nonatomic, assign) BOOL isHot ; //是否热帖,
@property (nonatomic, assign) BOOL flagReply ;//是否已回复,
@property (nonatomic, strong) NSString *postHotDate ; //成为热帖时间,
@property (nonatomic, strong) NSString *postStatus ; //帖子状态(1:草稿箱/待发布, 2:已发布, 3已删除/取消发布),
@property (nonatomic, strong) NSString *postContent ; //帖子内容概述,
@property (nonatomic, strong) NSArray *postImgList ; //帖子图片链接（List集合）
@end

@interface  QWTopPostId: BaseAPIModel
@property (nonatomic, strong) NSString* postId;     //  帖子Id
@end






// 消息
@interface QWCircleMessage : BaseModel
@property (nonatomic, strong) NSString* id;                 // 消息Id,
@property (nonatomic, assign) NSInteger msgClass;           // 消息分类(1:评论 2:赞 (鲜花) 3:＠我的 99：系统消息),
@property (nonatomic, assign) NSInteger msgType;            // 消息类型(1:评论 2:回复 3:我收藏的帖子有专家回复4:赞(获得鲜花) 5:＠我的 6:删除帖子 7:删除评论 8:举报 9:帐号安全 10:审核通过(认证)1:审核通过(圈子) 12:审核未通过 13:圈主移除 14:圈子下线 15:圈子上线 16:用户禁言 17:用户解禁 18:专家禁言 19:专家解禁 20:帖子恢复21:审核失败,
@property (nonatomic, strong) NSString* msgTitle;           // 消息标题,
@property (nonatomic, strong) NSString* msgContent;         // 消息内容,
@property (nonatomic, strong) NSString* mbrId;              // 消息接收人ID,
@property (nonatomic, assign) NSInteger mbrType;            // 消息接收人类型(1:普通用户, 2:马甲, 3:专家),
@property (nonatomic, strong) NSString* sourceId;           // 消息来源ID
@property (nonatomic, strong) NSString* replyId;            // 消息来源回复ID,
@property (nonatomic, strong) NSString* sourceTitle;        //【冗余】消息来源标题,
@property (nonatomic, strong) NSString* sourceOwner;        //【冗余】消息来源所属用户名称,
@property (nonatomic, assign) NSInteger sourceOwnerType;    //【冗余】消息来源所属用户类型(1:普通用户, 2:马甲, 3:药师, 4:营养师),
@property (nonatomic, strong) NSString* sourceContent;      //【冗余】消息来源内容,
@property (nonatomic, assign) NSInteger sourceType;         // 消息来源类型（1:圈子, 2:帖子, 3:评论）,
@property (nonatomic, assign) BOOL flagRead;                // 是否已读,
@property (nonatomic, strong) NSString* createDate;         // 创建时间;
@end

/**
 *  4.0.0  可同步的圈子列表
 */
@interface QWSyncTeamListModel : BaseAPIModel
@property (nonatomic, strong) NSArray   *teamInfoList;      // 圈子信息
@end

/**
 *  4.0.1
 */
@interface SilenceStatusModel : BaseAPIModel
@property (nonatomic,assign) BOOL silencedFlag;     // 是否禁言(Y/N)
@property (nonatomic,assign) BOOL appealFlag;       // 是否申诉(Y/N)
@end