//
//  PerformanceOrderViewController.m
//  wenYao-store
//  业绩订单列表页
//  QueryPerformanceList 业绩订单列表
//  Created by qw_imac on 16/5/6.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "PerformanceOrderViewController.h"
#import "PerformanceOrderTableViewCell.h"
#import "IndentOders.h"
@interface PerformanceOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *dataSource;
    NSInteger      currentPage;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;

@end

@implementation PerformanceOrderViewController
static NSString *const cellIdentifier = @"PerformanceOrderTableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    dataSource = [@[] mutableCopy];
    currentPage = 1;
    [_tableview registerNib:[UINib nibWithNibName:@"PerformanceOrderTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    [_tableview addFooterWithTarget:self action:@selector(loadMoreData)];
    [self enableSimpleRefresh:_tableview block:^(SRRefreshView *sender) {
        [self refreshData];
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring12 image:@"img_network" flatY:40.0f];
    } else {
       [self queryData];
    }
    
}

-(void)loadMoreData {
    currentPage ++;
    HttpClientMgr.progressEnabled = NO;
    [self queryData];
}

-(void)refreshData {
    currentPage = 1;
    [self queryData];
}

-(void)dealloc {
    DebugLog(@"%@ will dealloc",self);
}
#pragma mark - tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PerformanceOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    MicroMallShopOrderVO *vo = dataSource[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCell:vo];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_W, 7)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 145.0;
}

#pragma mark - network
-(void)queryData {
    [self removeInfoView];
    QueryPerformanceOrderListR *modelR = [QueryPerformanceOrderListR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken?QWGLOBALMANAGER.configure.userToken:@"";
    modelR.func = _type;
    modelR.page = currentPage;
    modelR.pageSize = 10;
    [IndentOders queryPerformanceOrders:modelR success:^(PerformanceOrdersVO *model) {
        [_tableview footerEndRefreshing];
        if (model.apiStatus.integerValue == 0) {
            _sumLabel.text = [NSString stringWithFormat:@"共计%@笔订单",model.totalAmount];
            if (model.microMallShopOrderVOs.count > 0) {
                if (currentPage == 1) {
                    [dataSource removeAllObjects];
                }
                [dataSource addObjectsFromArray:model.microMallShopOrderVOs];
            }else {
                if (currentPage == 1) {
                    [dataSource removeAllObjects];
                }else {
                    currentPage --;
                }
            }
            [_tableview reloadData];
            if (dataSource.count == 0) {
               [self showInfoView:@"您还没有订单哦~" image:@"img_order"];
            }
        }
    } failure:^(HttpException *e) {
       [_tableview footerEndRefreshing]; 
    }];
}
@end
