//
//  StoreOrderQueryViewController.m
//  wenYao-store
//
//  Created by Martin.Liu on 16/5/13.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "StoreOrderQueryViewController.h"
#import "MARStatisticsDateView.h"
#import "NSDate+TKCategory.h"
#import "SVProgressHUD.h"
@interface StoreOrderQueryViewController ()<MARStatisticsDateViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet MARStatisticsDateView *statisticsDateView;
@property (weak, nonatomic) IBOutlet UIView *hrLIneView;
@property (nonatomic, strong) NSMutableArray* orderArray;
@end

@implementation StoreOrderQueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.statisticsDateView.delegate = self;
    self.hrLIneView.backgroundColor = RGBHex(qwColor11);
}

- (NSMutableArray *)orderArray
{
    if (!_orderArray) {
        _orderArray = [NSMutableArray array];
    }
    return _orderArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MARStatisticsDateViewDelegate
- (void)marDateView:(MARStatisticsDateView *)dateView didClickQueryBtnStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    if ([startDate compare:endDate] ==  NSOrderedDescending) {
        [SVProgressHUD showErrorWithStatus:@"起始日期大于终止日期，请重新输入！"];
        return;
    }
    NSInteger days = [NSDate daysBetweenDate:startDate andDate:endDate];
    if (days >= 30) {
        [SVProgressHUD showErrorWithStatus:@"查询的起止时间不能超过30天"];
        return;
    }
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderArray.count;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
