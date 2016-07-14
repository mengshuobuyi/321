//
//  ConfigureModel.h
//  APP
//
//  Created by qw on 15/3/4.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseModel.h"

@interface ConfigureModel : BaseModel
@property (nonatomic,strong) NSString   *userToken;
@property (nonatomic,strong) NSString   *passPort;
@property (nonatomic,strong) NSString   *userName;
@property (nonatomic,strong) NSString   *passWord;
@property (nonatomic,strong) NSString   *nickName;
@property (nonatomic,strong) NSString   *avatarUrl;
@end