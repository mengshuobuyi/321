//
//  QueryShopOrdersR.h
//  wenYao-store
//
//  Created by qw_imac on 16/1/15.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "BaseModel.h"
/*****************
 * 3.0订单相关
 *****************/
@interface QueryShopOrdersR : BaseModel
@property (nonatomic,strong) NSString *token;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign) NSInteger uploadInvoice;
@end

@interface OperateShopOrder : BaseModel
@property (nonatomic,strong) NSString *token;
@property (nonatomic,assign) NSString *orderId;
@property (nonatomic,assign) NSInteger operate;//1：接单 2：拒接 3：确认订单 4：去配送
@property (nonatomic,assign) NSString *rejectReason;
@property (nonatomic,strong) NSString *confirmCode;
@end

@interface QueryLCR : BaseModel

@end

@interface FillLogisticsR : BaseModel
@property (nonatomic,strong) NSString *orderId;
@property (nonatomic,strong) NSString *company;
@property (nonatomic,strong) NSString *billNo;
@property (nonatomic,strong) NSString *companyCode; //快递编码 add by 3.1
@end

@interface QueryShopOrdersDetailR : BaseModel
@property (nonatomic,strong) NSString *orderId;
@property (nonatomic,strong) NSString *token;
@end

@interface QueryCancelReasons : BaseModel
@property (nonatomic,assign) NSInteger type;
@end

@interface QueryPerformanceOrderListR : BaseModel
@property (nonatomic,strong) NSString *token;
@property (nonatomic,assign) NSInteger func;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pageSize;
@end