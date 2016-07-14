//
//  TipsModelR.h
//  wenYao-store
//
//  Created by caojing on 15/8/22.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseModel.h"

@interface TipsModelR : BaseModel

@end

@interface TipsListModelR : BaseModel
@property(nonatomic,strong)NSString *token;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,strong)NSNumber *source;
@property(nonatomic,strong)NSNumber *couponType;
@end


@interface TipsDetailModelR : BaseModel
@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSString *orderId;
@property(nonatomic,strong)NSNumber *type;
@end

@interface UpTipModelR : BaseModel
@property(nonatomic,strong)NSString *orderId;
@property(nonatomic,strong)NSString *url;//小票URL地址串。多个请用#QZSP#分隔
@property(nonatomic,strong)NSString *token;
@end


@interface SaveUpTipModelR : BaseModel
@property(nonatomic,strong)NSString *orderId;
@property(nonatomic,strong)NSString *invoiceUrl;//小票URL地址串。多个请用#QZSP#分隔
@property(nonatomic,strong)NSString *token;
@end