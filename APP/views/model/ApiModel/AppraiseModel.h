//
//  AppraiseModel.h
//  APP
//
//  Created by caojing on 15-3-19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseModel.h"
#import "BaseAPIModel.h"

@interface AppraiseModel : BaseAPIModel

@property(strong,nonatomic) NSString * page;
@property(strong,nonatomic) NSArray  * list;
@property(strong,nonatomic) NSString * pageSum;
@property(strong,nonatomic) NSString * pageSize;
@property(strong,nonatomic) NSString * totalRecords;

@end


@interface QueryAppraiseModel : BaseModel

@property(strong,nonatomic) NSString * appraiseId;
@property(strong,nonatomic) NSString * mobile;
@property(strong,nonatomic) NSString * nickname;
@property(strong,nonatomic) NSString * passportId;
@property(strong,nonatomic) NSString * sex;
@property(strong,nonatomic) NSString * remark;
@property(strong,nonatomic) NSString * addDate;
@property(strong,nonatomic) NSString * star;
@property(strong,nonatomic) NSString * mark;
@property(strong,nonatomic) NSString * sysNickname;
@property(strong,nonatomic) NSString * read;

@end