//
//  OrderHistoryViewController.m
//  wenYao-store
//
//  Created by qwfy0006 on 15/5/5.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "OrderHistoryViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "Constant.h"
#import "Order.h"
#import "OrderModel.h"
#import "OrderHistoryCell.h"
#import "WebDirectViewController.h"

@interface OrderHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>

// 订单列表数组
@property (strong, nonatomic) NSMutableArray *myOrderList;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation OrderHistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"历史订单";
    self.view.backgroundColor=RGBHex(qwColor11);
    self.myOrderList = [NSMutableArray array];
    
    // 设置tableView
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 12)];
    
    // 请求订单数据
    [self queryMyorder];
    
}

#pragma mark ---- 请求订单历史数据 ----

-(void)queryMyorder
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring12 image:@"img_network"];
        return;
    }
    
    [self removeInfoView];
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
    setting[@"passport"] = StrFromObj(self.passport);
    
    [Order orderQueryCustomerOrdersByBranchWithParams:setting success:^(id obj) {
        
        ClientHistoryOrderList *list = (ClientHistoryOrderList *)obj;
        
        if ([list.apiStatus integerValue] == 0)
        {
            if (list.orders.count > 0) {
                [self.myOrderList removeAllObjects];
                [self.myOrderList addObjectsFromArray:list.orders];
                [self.tableView reloadData];
            }else{
                [self showInfoView:@"暂无历史订单！" image:@"ic_img_fail"];
            }
        }
        else{
            [SVProgressHUD showErrorWithStatus:list.apiMessage];
        }
        
    } failure:^(HttpException *e) {
        if(e.errorCode!=-999){
            if(e.errorCode == -1001){
                [self showInfoView:kWarning215N54 image:@"ic_img_fail"];
            }else{
                [self showInfoView:kWarning215N0 image:@"ic_img_fail"];
            }
        }
    }];
}


#pragma mark ---- 列表代理 ----

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myOrderList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 93;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderHistoryCell"];
    
    ClientHistoryOrder *order = self.myOrderList[indexPath.row];
    [cell configureData:order];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ClientHistoryOrder *order = self.myOrderList[indexPath.row];
    
    // 本地跳转H5页面
    WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
    
    // 订单model的参数
    WebOrderDetailModel *modelOrder = [[WebOrderDetailModel alloc] init];
    modelOrder.orderId = order.orderId;
    
    // 本地跳转H5model的参数
    WebDirectLocalModel *modelLocal = [[WebDirectLocalModel alloc] init];
    modelLocal.modelOrder = modelOrder;
    modelLocal.typeLocalWeb = WebLocalTypeHistoryOrderDetail;
    modelLocal.title = @"订单详情";
    
    [vcWebDirect setWVWithLocalModel:modelLocal];
    
    vcWebDirect.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcWebDirect animated:YES];
    
}

@end
