//
//  RptModelR.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/5/27.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "BaseModel.h"

@interface RptModelR : BaseModel
@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *deviceType;
@property (nonatomic, strong) NSString *deviceCode;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *userType;
@end
