//
//  BranchAppraiseViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "BranchAppraiseViewController.h"
#import "BranchAppraiseCell.h"
#import "EvaluationViewController.h"
#import "Branch.h"

@interface BranchAppraiseViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger currentPage;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;

@property (strong, nonatomic) NSMutableArray *dataList;

@end

@implementation BranchAppraiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单评价";
    self.dataList = [NSMutableArray array];
    currentPage = 1;
    self.view.backgroundColor = RGBHex(qwColor11);
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableView.footerPullToRefreshText = kWaring6;
    self.tableView.footerReleaseToRefreshText = kWaring7;
    self.tableView.footerRefreshingText = kWaring9;
    self.tableView.footerNoDataText = kWaring55;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(historyAppraise)];
    [self.tableHeaderView addGestureRecognizer:tap];
    
    [self queryNewlist];
}

#pragma mark ---- 历史评价 ----
- (void)historyAppraise
{
    EvaluationViewController *viewcontroller=[[EvaluationViewController alloc] init];
    viewcontroller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

#pragma mark ---- 分页加载 ----
- (void)footerRereshing
{
    HttpClientMgr.progressEnabled = NO;
    [self queryNewlist];
}

#pragma mark ---- 新的评价 ----
- (void)queryNewlist
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"branchId"] = StrFromObj(QWGLOBALMANAGER.configure.groupId);
    setting[@"page"] = [NSString stringWithFormat:@"%ld",(long)currentPage];
    setting[@"pageSize"] = @"10";
    
    [Branch BranchAppraiseMmallWithParams:setting success:^(id obj) {
        
        [self.tableView footerEndRefreshing];
        BranchAppraisePageModel *page = [BranchAppraisePageModel parse:obj Elements:[BranchAppraiseModel class] forAttribute:@"appraises"];
        
        if (page.appraises.count == 0) {
            self.tableView.footer.canLoadMore = NO;
        }
        
        [self.dataList addObjectsFromArray:page.appraises];
        if (self.dataList.count > 0) {
            [self.tableView reloadData];
            currentPage++;
        }else{
            if(currentPage==1){
//                [self showInfoView:@"您还没有收到评价" image:@"ic_img_fail"];
            }
        }
        
    } failure:^(HttpException *e) {
        [self.tableView footerEndRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 8)];
    vi.backgroundColor = [UIColor clearColor];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 0.5)];
    line1.backgroundColor = RGBHex(qwColor10);
    [vi addSubview:line1];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 7.5, APP_W, 0.5)];
    line2.backgroundColor = RGBHex(qwColor10);
    [vi addSubview:line2];
    return vi;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [BranchAppraiseCell getCellHeight:self.dataList[indexPath.section]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BranchAppraiseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BranchAppraiseCell"];
    [cell setCell:self.dataList[indexPath.section]];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
