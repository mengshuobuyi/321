//
//  QuickScanDrugViewController.h
//  wenYao-store
//
//  Created by YYX on 15/6/9.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseScanReaderViewController.h"
#import "DiscountSearchDrugViewController.h"

typedef void (^SendNewBranchScanBlock)(NSMutableArray *productModel);

@interface DiscountScanDrugViewController : BaseScanReaderViewController

@property (nonatomic, copy, readwrite) SendNewBranchScanBlock SendNewScan;
@property (nonatomic, copy, readwrite) SendNewBranchProductBlock HoldSendNewProduct;
@property (nonatomic, weak) DiscountSearchDrugViewController     *holdViewController;

@end
