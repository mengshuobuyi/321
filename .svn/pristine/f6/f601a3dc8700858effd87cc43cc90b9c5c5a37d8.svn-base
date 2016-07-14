//
//  VerifyDetailViewController.h
//  wenYao-store
//
//  Created by caojing on 15/8/18.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseVC.h"
#import "Verify.h"

@interface VerifyDetailViewController : QWBaseVC<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *coupbView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancleButton;

@property (strong, nonatomic) BranchCouponVo *CoupnList; // 优惠券列表
@property (strong, nonatomic) OrderDrugVo *drugList;     // 优惠商品列表
@property (strong, nonatomic) NSString *scope;           // 验证券的类型 礼品 慢病 商品 普通
@property (strong, nonatomic) NSString *typeCell;        // 1 券 2 商品
@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) NSMutableArray *Endarray;
@property (strong, nonatomic) NSString *total;


@end
