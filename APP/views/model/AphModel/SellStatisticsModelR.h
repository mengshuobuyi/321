//
//  StatisticsModelR.h
//  wenYao-store
//
//  Created by caojing on 15/8/19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseModel.h"

@interface SellStatisticsModelR : BaseModel

@end

@interface QueryStatisticsModelR : BaseModel

@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSString *page;
@property(nonatomic,strong)NSString *pageSize;
@property(nonatomic,strong)NSString *all;
@property(nonatomic,strong)NSString *scope;
@property(nonatomic,strong)NSString *source;

@end


@interface QueryStatisticsProductModelR : BaseModel

@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSString *page;
@property(nonatomic,strong)NSString *pageSize;

@end


@interface QueryStatisticsPSModelR : BaseModel

@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSString *proId;
@property(nonatomic,strong)NSString *source;
@property(nonatomic,strong)NSString *page;
@property(nonatomic,strong)NSString *pageSize;

@end


@interface QuerySearchPSModelR : BaseModel

@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSString *barcode;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *page;
@property(nonatomic,strong)NSString *pageSize;

@end
