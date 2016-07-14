//
//  CouponDeatilViewController.h
//  wenyao
//
//  Created by 李坚 on 15/1/19.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import "QWBaseVC.h"
#import "CouponModel.h"

@interface CouponDeatilViewController : QWBaseVC<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *line101;
@property (weak, nonatomic) IBOutlet UILabel *line102;
@property (weak, nonatomic) IBOutlet UIButton *pushBtn;


@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *tickets;
@property (weak, nonatomic) IBOutlet UILabel *consulteLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;


@property (weak, nonatomic) IBOutlet UILabel *couponTimes;
@property (weak, nonatomic) IBOutlet UILabel *couponTimesLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftChanges;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downSpace;

//@property (nonatomic, strong) CouponDetailModel *detail;
//@property (nonatomic) NSString *promotionId;
@property (nonatomic, strong) CouponDetailModel *coupnDetail;
@property (nonatomic) NSString *commonPromotionId;
@property (nonatomic) NSMutableArray *drugList;
@property (nonatomic) NSMutableArray *array;//活动药店的名字


@end
