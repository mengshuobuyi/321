//
//  AllScanReaderViewController.h
//  APP
//
//  Created by cj on 15/2/27.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseScanReaderViewController.h"
#import "Drug.h"
#import "Promotion.h"
#import "Verify.h"
#import "Order.h"

typedef enum  Enum_Scan_Type {
    Enum_Scan_Items_Index        = 0,       //首页的扫码的验证（二维码） 首页的扫码验证，原来的功能
    Enum_Scan_Items_Slow         = 1,       //慢病优惠券的扫码，添加商品到购物列表
    Enum_Scan_Items_Common       = 2,       //普通优惠券的扫码，添加商品到购物列表
    Enum_Scan_Items_QuickOrder   = 3,       //快递单号扫描
    Enum_Scan_Items_OrderDetail  = 4,       //扫描查看订单详情
    Enum_Scan_Items_InterProduct = 5,       //扫描本店商品
    Enum_Scan_Items_ProductSales = 6,       //扫描药品名称，搜索该药品的销售统计
    Enum_Scan_Items_AddInternalProduct = 7, //扫描添加本店商品
}Scan_Type;

//运用的block
typedef void(^addCommonMedicineBlock)(ProductModel *productModel);
typedef int(^addSlowHasBlock)(ProductModel *productModel);
typedef void(^scanCode)(NSString *code);
typedef void (^scanResult)(NSMutableArray *listArr);  // 扫本店商品 coment by Perry
@interface AllScanReaderViewController : BaseScanReaderViewController

@property (nonatomic, assign) Scan_Type                scanType;
@property (nonatomic, copy)   addCommonMedicineBlock   addCommonMedicineBlock;
@property (nonatomic, copy)   addSlowHasBlock      addSlowHasBlock;
@property (nonatomic, copy)   scanResult                scanProResult;
@property (nonatomic, assign) NSUInteger                useType;
@property (nonatomic, copy) scanCode scan;

@end