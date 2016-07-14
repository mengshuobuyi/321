//
//  CoupnProductViewController.h
//  wenYao-store
//
//  Created by caojing on 15/8/18.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseVC.h"
#import "Verify.h"
typedef void (^SlowCheckProductBlock)(NSMutableArray *productArray,NSString *total);
@interface SlowCoupnProductViewController : QWBaseVC
@property (weak, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UITableView *addTableView;

@property (strong, nonatomic)  NSString *coupnId;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UITextField *textFiled;


@property(nonatomic,strong)BranchCouponVo *CoupnList;
@property(nonatomic,strong)NSMutableArray *addDateSource;//做的缓存
@property(nonatomic)NSString *totalSum;

@property (nonatomic, copy, readwrite) SlowCheckProductBlock SlowCheckProduct;


//@property(nonatomic,strong)OrderDrugVo *drugList;
//@property(nonatomic,strong)NSString *typeCell;
@end
