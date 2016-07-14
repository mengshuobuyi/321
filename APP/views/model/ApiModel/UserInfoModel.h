//
//  ConfigureModel.h
//  APP
//
//  Created by qw on 15/3/4.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BasePrivateModel.h"
#import "StoreModel.h"
#import "ForumModel.h"
#import "TaskScoreHeader.h"
@interface UserInfoModel : BaseModel

@property (nonatomic,strong) NSString   *userToken;
@property (nonatomic,strong) NSString   *mobile;
@property (nonatomic,strong) NSString   *passportId;
@property (nonatomic,strong) NSString   *userName;
@property (nonatomic,strong) NSString   *passWord;
@property (nonatomic,strong) NSString   *nickName;
@property (nonatomic,strong) NSString   *avatarUrl;
@property (nonatomic,strong) NSString   *sex;
@property (nonatomic,strong) NSString   *version;
@property (nonatomic,strong) NSString   *groupId;
@property (nonatomic,strong) NSString   *type;
@property (nonatomic,strong) NSString   *shortName;
@property (nonatomic,strong) NSString   *approveStatus;  // 机构是否经过认证  1是已认证  0是未认证
@property (nonatomic,assign) int        storeType;   //1.未开通微商药房 2.社会药房 3.开通微商药房
@property (nonatomic,strong) NSString   *storeCity;           // 门店的城市信息
@property (nonatomic,strong) NSString *expertToken;
@property (nonatomic,strong) NSString *expertPassportId;
@property (nonatomic,strong) NSString *expertNickName;
@property (nonatomic,strong) NSString *expertUserName;
@property (nonatomic,strong) NSString *expertAvatarUrl;
@property (nonatomic,strong) NSString *expertMobile;
@property (nonatomic,assign) BOOL expertIsSetPwd; //专家是否设置过密码
@property (nonatomic,strong) NSString *expertPassword;
@property (nonatomic,assign) int expertType;
@property (nonatomic,assign) int expertAuthStatus;
@property (nonatomic,strong) NSString *lastTimestamp;
@property (nonatomic) NSInteger authStatus;             // 专家认证状态:1.未认证,2.认证中(申请成功),3.已认证(认证通过),4.认证失败,
@property (nonatomic) PosterType posterType;            // 发帖用到的，标识是普通用户，营养师还是药师
@property (nonatomic,assign) BOOL expertCommentRed;
@property (nonatomic,assign) BOOL expertFlowerRed;
@property (nonatomic,assign) BOOL expertAtMineRed;
@property (nonatomic,assign) BOOL expertSystemInfoRed;
@property (assign,nonatomic) BOOL silencedFlag; //禁言
@property (assign,nonatomic) BOOL appealFlag;   //申诉

@property (nonatomic,assign) BOOL hadWaitingMessage; //抢答
@property (nonatomic,assign) BOOL hadAnswerMessage; //解答中

@property (nonatomic,strong) NSString *showName;  //强化积分弹出姓名
@end


@interface UserInfoModelPrivate : BasePrivateModel

@property (nonatomic,strong) NSString   *userToken;
@property (nonatomic,strong) NSString   *passPort;
@property (nonatomic,strong) NSString   *userName;
@property (nonatomic,strong) NSString   *passWord;
@property (nonatomic,strong) NSString   *nickName;
@property (nonatomic,strong) NSString   *avatarUrl;

@end

@interface UserTaskScoreModel : BasePrivateModel

@property (nonatomic, strong) NSString          *passPort;
@property (nonatomic, assign) NSInteger      curTaskStep;     // 当前任务
@property (nonatomic, assign) NSTimeInterval    intevalLastLeave;

@end


@interface RegisterAreaInfoModel : BaseModel
@property (nonatomic, strong) NSString     *city;
@property (nonatomic, strong) NSString     *country;
@property (nonatomic, strong) NSString     *province;
@end