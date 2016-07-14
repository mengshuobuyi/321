//
//  QuickSearchDrugViewController.h
//  wenYao-store
//
//  Created by YYX on 15/6/8.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseVC.h"
#import "Drug.h"
#import "BranchViewController.h"

typedef void (^SendNewBranchProductBlock)(BranchSearchPromotionProVO *productModel);

@interface DiscountSearchDrugViewController : QWBaseVC

@property (nonatomic ,strong) NSMutableArray *scanSource;
@property (nonatomic ,strong) NSString * typeSearch;
@property (nonatomic ,strong) NSString *keyWord;
@property (nonatomic, copy, readwrite) SendNewBranchProductBlock SendNewProduct;

@end
