//
//  PoisModel.h
//  wenYao-store
//
//  Created by YYX on 15/8/22.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseModel.h"

@interface PoisModel : BaseModel
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (assign, nonatomic) CGFloat  latitude;
@property (assign, nonatomic) CGFloat  longitude;

@property (strong, nonatomic) NSString *provinceName;  // 省
@property (strong, nonatomic) NSString *cityName;      // 市
@property (strong, nonatomic) NSString *countyName;    // 区

@end
