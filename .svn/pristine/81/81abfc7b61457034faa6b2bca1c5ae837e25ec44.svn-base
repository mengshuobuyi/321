//
//  MyorderViewController.m
//  wenyao-store
//
//  Created by chenpeng on 15/1/19.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import "MyStatiticsViewController.h"
#import "MarketingActivityViewController.h"
#import "ProductStatiticsViewController.h"
#import "InteractiveStatisticViewController.h"
#import "CoupnStatiticsViewController.h"
#import "WebDirectViewController.h"
#import "MemberSellStatisticsViewController.h"
#import "MyStatisticsCell.h"
#import "EmployeeShareToOrderStatisticsViewController.h"
#import "OrganAuthTotalViewController.h"
#import "OrganAuthCommitOkViewController.h"
#import "StoreOrderQueryViewController.h"
#import "ProductSalesStatiticsViewController.h"     // 商品销售统计

#define isReadStatistics @"isReadStatistics"

NSString *const kStatiticsTitle_Order = @"订单统计";
NSString *const kStatiticsTitle_NEWProductSales = @"商品销售统计";
NSString *const kStatiticsTitle_NEWCoupn = @"优惠券统计";
NSString *const kStatiticsTitle_NEWMemberSell = @"会员营销统计";

NSString *const kStatiticsTitle_Coupn = @"优惠券消费统计";
NSString *const kStatiticsTitle_Product = @"优惠商品销量统计";
NSString *const kStatiticsTitle_Interactive = @"互动统计";
NSString *const kStatiticsTitle_EmployeesShare = @"员工分享统计";
NSString *const kStatiticsTitle_MemberSell = @"商家会员营销统计";
NSString *const kStatiticsTitle_EmployeeShareToOrder = @"员工分享转化订单统计";

@interface MyStatiticsViewController()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *listArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) OrganAuthTotalViewController *vcOrganAuthTotal;

@property (strong, nonatomic) OrganAuthCommitOkViewController *vcOrganAuthCommitOk;

@end

@implementation MyStatiticsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"统计";
    
    if (!OrganAuthPass) {
        return;
    }
    
    // 判断是否开通微商
    if (QWGLOBALMANAGER.configure.storeType == 3) {
        //开通微商药房
        self.listArray = [NSMutableArray arrayWithObjects:
                          kStatiticsTitle_Order,
                          kStatiticsTitle_NEWProductSales,
                          kStatiticsTitle_NEWCoupn,
                          kStatiticsTitle_Interactive,
                          kStatiticsTitle_EmployeesShare,
                          kStatiticsTitle_NEWMemberSell,
                          kStatiticsTitle_EmployeeShareToOrder, nil];
        
    }else{
        //不开通微商药房
        self.listArray = [NSMutableArray arrayWithObjects:
                          kStatiticsTitle_Coupn,
                          kStatiticsTitle_Product,
                          kStatiticsTitle_Interactive,
                          kStatiticsTitle_EmployeesShare,
                          kStatiticsTitle_MemberSell,
                          kStatiticsTitle_EmployeeShareToOrder, nil];
    }

    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!OrganAuthPass)
    {
        if ([QWGLOBALMANAGER.configure.approveStatus integerValue] == 4 || [QWGLOBALMANAGER.configure.approveStatus integerValue] == 2)
        {
            self.vcOrganAuthTotal = [[UIStoryboard storyboardWithName:@"OrganAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"OrganAuthTotalViewController"];
            [self.view addSubview:self.vcOrganAuthTotal.view];
            return;
            
            
        }else if ([QWGLOBALMANAGER.configure.approveStatus integerValue] == 1)
        {
            self.vcOrganAuthCommitOk = [[UIStoryboard storyboardWithName:@"OrganAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"OrganAuthCommitOkViewController"];
            [self.view addSubview:self.vcOrganAuthCommitOk.view];
            return;
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark ---- 列表代理 ----

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyStatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyStatisticsCell"];
    cell.title.text = self.listArray[indexPath.row];
    //商家会员营销统计 首次安装加小红点
    
    if ([cell.title.text isEqualToString:kStatiticsTitle_MemberSell]) {
        cell.redDot.hidden = NO;
    }
    else
    {
        cell.redDot.hidden = YES;
    }
    
    if ([QWUserDefault getBoolBy:isReadStatistics]) {
        cell.redDot.hidden = YES;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyStatisticsCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString* titleString = cell.title.text;
    if ([titleString isEqualToString:kStatiticsTitle_Coupn]) {
        // 优惠券消费统计
        
        CoupnStatiticsViewController *coupnStatiticsViewController = [[CoupnStatiticsViewController alloc] init];
        coupnStatiticsViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:coupnStatiticsViewController animated:YES];
    }
    else if ([titleString isEqualToString:kStatiticsTitle_Product])
    {
        // 优惠商品销量统计
        
        ProductStatiticsViewController *vc = [[ProductStatiticsViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([titleString isEqualToString:kStatiticsTitle_Interactive])
    {
        //互动统计
        [QWGLOBALMANAGER statisticsEventId:@"s_tj_hdtj" withLable:@"统计-互动统计" withParams:nil];
        InteractiveStatisticViewController *inter = [[UIStoryboard storyboardWithName:@"InteractiveStatistic" bundle:nil] instantiateViewControllerWithIdentifier:@"InteractiveStatisticViewController"];
        inter.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:inter animated:YES];
    }
    else if ([titleString isEqualToString:kStatiticsTitle_EmployeesShare])
    {
        // 员工分享统计
        [QWGLOBALMANAGER statisticsEventId:@"s_tj_ygfxtj" withLable:@"统计-员工分享统计" withParams:nil];
        WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
        WebDirectLocalModel *modelLocal = [[WebDirectLocalModel alloc] init];
        modelLocal.typeLocalWeb = WebLocalTypeEmployeesShareStatistics;
        modelLocal.title = @"员工分享统计";
        [vcWebDirect setWVWithLocalModel:modelLocal];
        
        vcWebDirect.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vcWebDirect animated:YES];
    }
    else if ([titleString isEqualToString:kStatiticsTitle_MemberSell])
    {
        // 商家会员营销统计
        
        MemberSellStatisticsViewController *vc = [[UIStoryboard storyboardWithName:@"MemberSellStatistics" bundle:nil] instantiateViewControllerWithIdentifier:@"MemberSellStatisticsViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        [QWUserDefault setBool:YES key:isReadStatistics];

    }
    else if ([titleString isEqualToString:kStatiticsTitle_EmployeeShareToOrder])
    {
        //员工分享转化订单统计
        [QWGLOBALMANAGER statisticsEventId:@"s_tj_ygzhtj" withLable:@"统计-员工转化订单统计" withParams:nil];
        EmployeeShareToOrderStatisticsViewController *vc = [[UIStoryboard storyboardWithName:@"MyStatistics" bundle:nil] instantiateViewControllerWithIdentifier:@"EmployeeShareToOrderStatisticsViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([titleString isEqualToString:kStatiticsTitle_Order])
    {
        // 订单统计
        [QWGLOBALMANAGER statisticsEventId:@"s_tj_ddtj" withLable:@"统计-订单统计" withParams:nil];
        
        WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
        vcWebDirect.hidesBottomBarWhenPushed = YES;
        WebDirectLocalModel* webModel = [WebDirectLocalModel new];
        webModel.title = @"订单统计";
        webModel.url = [NSString stringWithFormat:@"%@QWSH/web/shareStatistics/html/orderStatistics.html", H5_BASE_URL];
        [vcWebDirect setWVWithLocalModel:webModel];
        [self.navigationController pushViewController:vcWebDirect animated:YES];
//        StoreOrderQueryViewController* orderVC = [[UIStoryboard storyboardWithName:@"StoreOrder" bundle:nil] instantiateViewControllerWithIdentifier:@"StoreOrderQueryViewController"];
//        orderVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:orderVC animated:YES];
    }
    else if ([titleString isEqualToString:kStatiticsTitle_NEWProductSales])
    {
        // 商品销售统计
        [QWGLOBALMANAGER statisticsEventId:@"s_tj_spxstj" withLable:@"统计-商品销售统计" withParams:nil];
        ProductSalesStatiticsViewController* productSalesVC = [[ProductSalesStatiticsViewController alloc] init];
        productSalesVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:productSalesVC animated:YES];
    }
    else if ([titleString isEqualToString:kStatiticsTitle_NEWCoupn])
    {
        // 优惠券统计
        [QWGLOBALMANAGER statisticsEventId:@"s_tj_yhqtj" withLable:@"统计-优惠券统计" withParams:nil];
        CoupnStatiticsViewController *coupnStatiticsViewController = [[CoupnStatiticsViewController alloc] init];
        coupnStatiticsViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:coupnStatiticsViewController animated:YES];
    }
    else if ([titleString isEqualToString:kStatiticsTitle_NEWMemberSell])
    {
        // 会员营销统计
        [QWGLOBALMANAGER statisticsEventId:@"s_tj_hyyxtj" withLable:@"统计-会员营销统计" withParams:nil];
        WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
        vcWebDirect.hidesBottomBarWhenPushed = YES;
        WebDirectLocalModel* webModel = [WebDirectLocalModel new];
        webModel.title = @"会员营销统计";
        webModel.url = [NSString stringWithFormat:@"%@QWSH/web/shareStatistics/html/memberMarketing.html", H5_BASE_URL];
        [vcWebDirect setWVWithLocalModel:webModel];
        [self.navigationController pushViewController:vcWebDirect animated:YES];
    }
        
    
}

@end
