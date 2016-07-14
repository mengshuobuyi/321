//
//  ClientOrderListViewController.m
//  wenYao-store
//  会员订单列表
//  h5/maicromall/order/queryMemberOrders
//  Created by PerryChen on 5/16/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "ClientOrderListViewController.h"
#import "ClientOrderListCell.h"
#import "Customer.h"
#import "IndentDetailListViewController.h"
#import "OrderHistoryViewController.h"
@interface ClientOrderListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *headerViewOrder;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderSumNum;
@property (weak, nonatomic) IBOutlet UITableView *tbViewContent;

@property (assign, nonatomic) NSInteger curPage;
@property (assign, nonatomic) NSInteger pageSize;
@property (strong, nonatomic) NSMutableArray *arrOrderList;
@end

@implementation ClientOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrOrderList = [NSMutableArray array];
    self.navigationItem.title = @"订单";
    self.curPage = 1;
    self.pageSize = 10;
    self.tbViewContent.rowHeight = 70.0f;
    [self getMemberOrderList];
    self.tableHeaderView.backgroundColor = RGBHex(qwColor11);
    self.headerViewOrder.backgroundColor = [UIColor whiteColor];
    self.tbViewContent.tableHeaderView = self.tableHeaderView;
    [self.tbViewContent addFooterWithCallback:^{
        [HttpClient sharedInstance].progressEnabled = NO;
        self.curPage ++;
        [self getMemberOrderList];
    }];
    [self setupRightItem];
    // Do any additional setup after loading the view.
}

/**
 *  设置导航栏右侧按钮
 */
- (void)setupRightItem
{
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = -15;
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    
    //三个点button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, 0, 70, 40);
    [button setTitle:@"历史订单" forState:UIControlStateNormal];
    button.titleLabel.font = fontSystem(kFontS1);
    [button addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:button];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"历史订单" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    self.navigationItem.rightBarButtonItems = @[fixed, rightItem];
}

/**
 *  点击导航栏右侧按钮事件
 */
- (void)rightAction
{
    OrderHistoryViewController *vc = [[UIStoryboard storyboardWithName:@"OrderHistory" bundle:nil] instantiateViewControllerWithIdentifier:@"OrderHistoryViewController"];
    vc.passport = self.customerId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([self.tbViewContent viewWithTag:1018] == nil) {
        [self enableSimpleRefresh:self.tbViewContent block:^(SRRefreshView *sender) {
            self.curPage = 1;
            [HttpClient sharedInstance].progressEnabled = NO;
            [self.arrOrderList removeAllObjects];
            [self.tbViewContent reloadData];
            self.tbViewContent.footer.canLoadMore = YES;
            [self getMemberOrderList];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getMemberOrderList
{
    CustomerOrderListModelR *modelR = [CustomerOrderListModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.userId = self.customerId;
    modelR.page = [NSString stringWithFormat:@"%d",self.curPage];
    modelR.pageSize = [NSString stringWithFormat:@"%d",self.pageSize];
    [Customer queryCustomerOrderListWithParams:modelR
                                       success:^(CustomerOrdersVoModel *responseModel) {
                                           self.lblOrderSumNum.text = [NSString stringWithFormat:@"%@单",responseModel.orderAmount];
                                           if (responseModel.memberOrderListVOs.count > 0) {
                                               [self.arrOrderList addObjectsFromArray:responseModel.memberOrderListVOs];
                                           } else {
                                               if (self.curPage == 1) {
                                                   [self showInfoView:@"暂无订单" image:@"ic_img_fail"];
                                               } else {
                                                   self.tbViewContent.footer.canLoadMore = NO;
                                               }
                                           }
                                           [self.tbViewContent.footer endRefreshing];
                                           [self.tbViewContent reloadData];
                                       } failure:^(HttpException *e) {
                                           [self.tbViewContent.footer endRefreshing];
                                       }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableView methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomerOrderVoModel *model = self.arrOrderList[indexPath.row];
    ClientOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClientOrderListCell"];
    [cell setCell:model];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrOrderList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomerOrderVoModel *model = self.arrOrderList[indexPath.row];
    IndentDetailListViewController *vc = [IndentDetailListViewController new];
    vc.orderId = model.orderId;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
