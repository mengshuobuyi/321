//
//  MemberMarketModelR.h
//  wenYao-store
//
//  Created by PerryChen on 5/11/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "BaseAPIModel.h"

@interface MemberMarketModelR : BaseAPIModel
@property (nonatomic, strong) NSString *token;
@end

@interface MarketQueryTicketModelR : MemberMarketModelR

@end

@interface MarketQueryProductModelR : MemberMarketModelR

@end

@interface MarketQueryBrochureModelR : MemberMarketModelR

@end

@interface MarketCheckMarkModelR : MemberMarketModelR
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *min;
@property (nonatomic, strong) NSString *max;
@property (nonatomic, strong) NSString *ncd;
@end

@interface MarketMemberNcdsModelR : MemberMarketModelR

@end

@interface MarketMemberSubmitModelR : MemberMarketModelR
@property (nonatomic, strong) NSString *actJson;
@property (nonatomic, strong) NSString *couponId;
@property (nonatomic, strong) NSString *dmId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *day;
@end

@interface MemberQueryByNcdModelR : MemberMarketModelR
@property (nonatomic, strong) NSString *ncd;
@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSString *pageSize;
@end