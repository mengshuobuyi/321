//
//  PharmacyModel.h
//  wenYao-store
//
//  Created by qwfy0006 on 15/4/1.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseModel.h"
#import "BaseAPIModel.h"

@interface PharmacyModel : BaseModel

@end

@interface QueryStorePage : BaseAPIModel

@property (strong, nonatomic) NSArray *list;


@end

@interface QueryStoreModel : BaseModel

@property (strong, nonatomic) NSString *code;   //药店编码
@property (strong, nonatomic) NSString *province;  //省
@property (strong, nonatomic) NSString *city;  //市
@property (strong, nonatomic) NSString *county;  //区
@property (strong, nonatomic) NSString *name;  //药店名称
@property (strong, nonatomic) NSString *address;  //地址
@property (strong, nonatomic) NSString *introduction;  //简介
@property (strong, nonatomic) NSString *promotionMsg; //营销信息
@property (strong, nonatomic) NSString *mobile;   //联系电话
@property (strong, nonatomic) NSString *contact;  //联系人
@property (strong, nonatomic) NSString *longitude;  //经度
@property (strong, nonatomic) NSString *latitude; //维度
@property (strong, nonatomic) NSString *auth;  //是否全维认证 （0未认证，1已认证）
@property (strong, nonatomic) NSString *join;  //是否加盟 （0未加盟 ， 1 已加盟）
@property (strong, nonatomic) NSString *branchCode;  //全维机构编码
//@property (strong, nonatomic) NSString *distance;  //药店定位的距离

@end

@interface QueryAreaPage : BaseAPIModel
@property (strong, nonatomic) NSArray *list;
@end

@interface QueryAreaModel : BaseModel
@property (strong, nonatomic) NSString *code;  //编码
@property (strong, nonatomic) NSString *name;  //名称
@end