//
//  StoreModelR.m
//  APP
//
//  Created by qwfy0006 on 15/3/18.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "StoreModelR.h"

@implementation StoreModelR

@end

@implementation StoreCodeModelR
@synthesize sequence;
@end


@implementation BranchGroupModelR
@synthesize branchId;
@end

@implementation UpdatePasswordModelR
@synthesize token;
@synthesize anewPwd=newPwd;
@synthesize oldPwd;

@end




@implementation LogoutModelR
@synthesize token;

@end

@implementation SendVerifyCodeModelR


@end

@implementation RegisterModelR


@end

@implementation LoginModelR


@end

@implementation MobileValidModelR

@synthesize mobile = mobile;
@end

@implementation SaveBranchModelR
@synthesize account,drugStoreId,province,city,country,name,addr,longitude,latitude,tel,tags,logo,desc,sign,mobile,maplbl,cityname,countryname,provincename;
@end


@implementation ValidVerifyCodeModelR


@end


@implementation WenyaoActivityListR

@end

@implementation ConfigInfoQueryModelR


@end

@implementation GetTrainDetailR

@end

@implementation GetTrainListR

@end

@implementation GetProductSalesR

@end

@implementation BookProductR

@end