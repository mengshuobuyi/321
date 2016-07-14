//
//  AppraiseModelR.h
//  APP
//
//  Created by caojing on 15-3-19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseModel.h"

@interface AppraiseModelR : BaseModel

@end


@interface QueryAppraiseModelR : BaseModel
@property(strong,nonatomic) NSString * groupId;
@property(strong,nonatomic) NSString * customer;
@property(strong,nonatomic) NSString * currPage;
@property(strong,nonatomic) NSString * pageSize;
@end
