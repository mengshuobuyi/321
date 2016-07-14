//
//  SystemModel.h
//  APP
//
//  Created by garfield on 15/4/17.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseModel.h"
#import "BaseAPIModel.h"

@interface SystemModel : BaseModel

@end

@interface AppLogFlagModel : BaseAPIModel

@property (nonatomic, assign) BOOL flag;

@end

@interface CheckTimeModel : BaseAPIModel

@property (nonatomic, assign) long long check_timestamp;

@end


@interface HeartBeatModel : BaseAPIModel

@property (nonatomic, strong) NSString *respTime;

@end

@interface DomianIsModel : BaseAPIModel

@property (nonatomic, assign) BOOL domainFlag;

@end


@interface DomianModel : BaseAPIModel

@property (nonatomic, strong) NSString *apiDomain;
@property (nonatomic, strong) NSString *h5Domain;

@end