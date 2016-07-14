//
//  ExpertModel.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "BaseAPIModel.h"

@interface ExpertModel : BaseAPIModel

@end

@interface ExpertLoginInfoModel : BaseAPIModel
@property (strong, nonatomic) NSString * token;         // 令牌,
@property (strong, nonatomic) NSString * passportId;    // passportId,
@property (strong, nonatomic) NSString * nickName;      // 昵称,
@property (strong, nonatomic) NSString * userName;      // 用户名,
@property (assign, nonatomic) BOOL isSetPwd;            // 是否设置过登录密码,
@property (assign, nonatomic) BOOL isFirstTPAL;         // 是否第一次第三方登录,
@property (strong, nonatomic) NSString * avatarUrl;     // 默认头像,
@property (strong, nonatomic) NSString * mobile;        // 手机号,
@property (strong, nonatomic) NSString * welcome;       // 欢迎语,
@property (strong, nonatomic) NSString * inviteCode;    // 邀请码,
@property (assign, nonatomic) BOOL full;                // 资料是否完善,
@property (assign, nonatomic) BOOL qq;                  // 是否绑定Qq,
@property (assign, nonatomic) BOOL weChat;              // 是否绑定微信,
@property (assign, nonatomic) BOOL reg;                 // 本次登录是否来自注册,
@property (assign, nonatomic) int authStatus; // 专家认证状态:1.未认证,2.认证中(申请成功),3.已认证(认证通过),4.认证失败,
@property (assign, nonatomic) BOOL setPwd;
@property (assign, nonatomic) BOOL firstTPAL;
@property (assign, nonatomic) BOOL silencedFlag;        //是否禁言。 N:否，Y:是
@end

@interface ExpertIsExistsModel : BaseAPIModel
@property (assign, nonatomic) BOOL isExists;            // 是否注册
@end

@interface PharmacistInfoPageModel : BaseAPIModel
@property (strong, nonatomic) NSArray *expertList;
@end

@interface PharmacistInfoListModel : BaseAPIModel
@property (strong, nonatomic) NSString * id;                // 编号,
@property (strong, nonatomic) NSString *  sex;              // 性别(0:男, 1:女, -1:null或空),
@property (strong, nonatomic) NSString *  nickName;         // 昵称,
@property (strong, nonatomic) NSString *  headImageUrl;     // 用户头像,
@property (strong, nonatomic) NSString *  groupId;          // 商户/品牌Id,
@property (strong, nonatomic) NSString *  groupName;        // 商户/品牌名称,
@property (strong, nonatomic) NSString *  expertise;        // 擅长领域,
@property (assign, nonatomic) int userType;                 // 用户类型,
@property (assign, nonatomic) BOOL  onlineFlag;             // 专家是否在线
@end

@interface PharmacistOrderPhoneModel : BaseAPIModel
@property (strong, nonatomic) NSArray *links;               // 接单电话
@property (strong, nonatomic) NSString *mobile;             // 药房电话
@end

@interface ShippingMethodPageModel : BaseAPIModel
@property (strong, nonatomic) NSArray *postTips;            // 送货方式说明
@end

@interface ShippingMethodDetailModel : BaseAPIModel
@property (strong, nonatomic) NSString *title;              // 标题,
@property (strong, nonatomic) NSString *timeSliceTip;       // 服务时间段,
@property (strong, nonatomic) NSString *feeTip;             // 费用,
@property (strong, nonatomic) NSString *manTip;             // 包邮提示,
@property (strong, nonatomic) NSArray * rules;              // 送货上门配送规则
@end




