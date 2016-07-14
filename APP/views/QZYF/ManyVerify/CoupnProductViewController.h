//
//  CoupnProductViewController.h
//  wenYao-store
//
//  Created by caojing on 15/8/18.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseVC.h"
#import "secondCustomAlertView.h"
#import "Verify.h"
typedef void (^CheckProductBlock)(NSMutableArray *productArray,NSString *total);
@interface CoupnProductViewController : QWBaseVC
@property (weak, nonatomic) IBOutlet UIButton *addSome;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIView *noneView;
@property (weak, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UITableView *addTableView;
@property (nonatomic ,strong) secondCustomAlertView *customAlertView;


@property (weak, nonatomic) IBOutlet UITextField *total;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property(nonatomic,strong)NSMutableArray *addDateSource;
@property(nonatomic,strong)BranchCouponVo *CoupnList;
@property(nonatomic,strong)NSString *totalSum;

@property (nonatomic, copy, readwrite) CheckProductBlock CheckProduct;


//@property(nonatomic,strong)OrderDrugVo *drugList;
//@property(nonatomic,strong)NSString *typeCell;

//@property (strong, nonatomic)  NSString *coupnId;


@end
