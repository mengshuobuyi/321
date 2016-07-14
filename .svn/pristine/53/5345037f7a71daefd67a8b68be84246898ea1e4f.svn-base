//
//  StoreModelR.h
//  APP
//
//  Created by qwfy0006 on 15/3/18.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseModel.h"

@interface StoreModelR : BaseModel

@end

@interface StoreCodeModelR : BaseModel

@property(strong,nonatomic) NSString *sequence;

@end


@interface BranchGroupModelR : BaseModel

@property(strong,nonatomic) NSString *branchId;

@end



@interface UpdatePasswordModelR : BaseModel

@property (strong, nonatomic) NSString  *token;
@property (strong, nonatomic) NSString  *anewPwd;
@property (strong, nonatomic) NSString  *oldPwd;

@end




@interface LogoutModelR : BaseModel

@property (strong, nonatomic) NSString *token;

@end


@interface SendVerifyCodeModelR : BaseModel

@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *type;


@end


@interface RegisterModelR : BaseModel

@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *account;
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *groupId;
@property (strong, nonatomic) NSString *type;


@end



@interface LoginModelR : BaseModel

@property (strong, nonatomic) NSString *deviceCode;
@property (strong, nonatomic) NSString *account;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *deviceType;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *pushDeviceCode;
@property (strong, nonatomic) NSString *credentials;
//@property (strong, nonatomic) NSString *v;


@end

@interface MobileValidModelR : BaseModel

@property (strong, nonatomic) NSString *mobile;

@end

@interface SaveBranchModelR : BaseModel
@property (strong, nonatomic) NSString *account;
@property (strong, nonatomic) NSString *drugStoreId;
@property (strong, nonatomic) NSString *province;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *addr;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *tel;
@property (strong, nonatomic) NSString *tags;
@property (strong, nonatomic) NSString *logo;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *sign;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *maplbl;
@property (strong, nonatomic) NSString *cityname;
@property (strong, nonatomic) NSString *countryname;
@property (strong, nonatomic) NSString *provincename;
@end

@interface ValidVerifyCodeModelR : StoreModelR

@property (nonatomic ,strong) NSString *mobile;
@property (nonatomic ,strong) NSString *code;
@property (nonatomic ,strong) NSNumber *type;

@end

@interface WenyaoActivityListR : BaseModel
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;
@end

@interface ConfigInfoQueryModelR : BaseModel

@property (nonatomic, strong) NSString    *province;
@property (nonatomic, strong) NSString    *city;
@property (nonatomic, strong) NSString    *place;
@property (nonatomic, strong) NSString    *v;
@property (nonatomic, strong) NSString    *platform;

@end

@interface GetTrainDetailR : BaseModel
@property (nonatomic, strong) NSString   *token;        // 登陆令牌
@property (nonatomic, strong) NSString   *trainId;      // 培训Id
@property (nonatomic, assign) NSInteger  reqChannel;    // 请求的渠道(0:列表 1:超链接)
@end

@interface GetTrainListR : BaseModel
@property (nonatomic, strong) NSString   *token;        // 登陆令牌
@property (nonatomic, assign) NSInteger  viewType;      // 显示列表（0：培训，1：生意经）
@property (nonatomic, assign) NSInteger  page;          // 页数
@property (nonatomic, assign) NSInteger  pageSize;      // 每页显示数
@end

@interface GetProductSalesR : BaseModel
@property (nonatomic, strong) NSString   *token;        // 用户令牌
@property (nonatomic, strong) NSString   *begin;        // 开始时间 yyyy-MM-dd 2016-05-10
@property (nonatomic, strong) NSString   *end;          // 结束时间 yyyy-MM-dd 2016-05-10
@property (nonatomic, strong) NSString   *keyWord;      // 商品名
@property (nonatomic, strong) NSString   *code;         // 商品编码
@property (nonatomic, assign) NSInteger  upOrDown;      // 销量 1.高到低 2.低到高
@end

@interface BookProductR : BaseModel
@property (nonatomic, strong) NSString   *token;        // 店员Token
@property (nonatomic, assign) NSInteger  page;          // 当前页号
@property (nonatomic, assign) NSInteger  pageSize;      // 分页条数
@end

