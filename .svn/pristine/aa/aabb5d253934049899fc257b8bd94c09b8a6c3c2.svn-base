//
//  MemberMarketModel.h
//  wenYao-store
//
//  Created by PerryChen on 5/11/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "BaseAPIModel.h"

@interface MemberMarketModel : BaseAPIModel

@end

@interface MemberNcdListVo : MemberMarketModel
@property (nonatomic, strong) NSString *counts;
@property (nonatomic, strong) NSArray *ncds;
@property (nonatomic, strong) NSString *mktgCounts;
@end

@interface MemberNcdVo : MemberMarketModel
@property (nonatomic, strong) NSString *ncdId;
@property (nonatomic, strong) NSString *ncdName;
@property (nonatomic, strong) NSString *userCounts;
@property (nonatomic, assign) BOOL isSelected;
@end

@interface MemberCheckVo : MemberMarketModel
@property (nonatomic, strong) NSString *counts;
@property (nonatomic, strong) NSString *score;
@end

@interface MemberNcdDetailVo : MemberMarketModel
@property (nonatomic, strong) NSString *id;             // 会员id,
@property (nonatomic, strong) NSString *userId;         // 用户id,
@property (nonatomic, strong) NSString *tags;           // 标签,
@property (nonatomic, strong) NSString *avatar;         // 头像,
@property (nonatomic, strong) NSString *indexName;      // 显示名,
@property (nonatomic, strong) NSString *sex;            // 性别：M/F
@end

@interface MemberNcdCustomerListVo : MemberMarketModel
@property (nonatomic, strong) NSArray *customers;
@end
