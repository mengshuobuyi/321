//
//  ImModelR.h
//  APP
//
//  Created by garfield on 15/3/25.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseModel.h"

@interface ImModelR : BaseModel

@end

@interface ImSelectQWModelR : ImModelR

@property (nonatomic, strong) NSString *endpoint;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *viewType;
@property (nonatomic, strong) NSString *view;
@property (nonatomic, strong) NSString *to;
@property (nonatomic, strong) NSString *point;
@property (nonatomic, strong) NSString *cl;

@end


@interface PollByCustomerR : ImModelR

@property (nonatomic, strong) NSString *lastTimestamp;
@property (nonatomic, strong) NSString *token;


@end