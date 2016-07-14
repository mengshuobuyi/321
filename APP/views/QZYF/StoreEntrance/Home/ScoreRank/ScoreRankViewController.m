//
//  ScoreRankViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/5/5.
//  Copyright © 2016年 carret. All rights reserved.
//

/*
    积分排行
    h5/branch/score/rank  积分排行列表
 */

#import "ScoreRankViewController.h"
#import "ScoreRankCell.h"
#import "ScoreRankDetailViewController.h"
#import "Branch.h"
#import "ScoreModel.h"

@interface ScoreRankViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger currentPage;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *name_layout_left;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalScore_layout_right;

@property (strong, nonatomic) NSMutableArray *dataList;

@end

@implementation ScoreRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    currentPage = 1;
    self.title = @"积分排行";
    
    self.dataList = [NSMutableArray array];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self configureHeaderUI];
    [self headerRefreshing];
    
    //下拉刷新
    [self enableSimpleRefresh:self.tableView block:^(SRRefreshView *sender) {
        if (QWGLOBALMANAGER.currentNetWork != kNotReachable) {
            [self headerRefreshing];
        }else{
            [SVProgressHUD showErrorWithStatus:@"网络未连接，请重试！" duration:0.8];
        }
        [self.tableView headerEndRefreshing];
    }];
    
    //分页加载
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableView.footerPullToRefreshText = kWaring6;
    self.tableView.footerReleaseToRefreshText = kWaring7;
    self.tableView.footerRefreshingText = kWaring9;
    self.tableView.footerNoDataText = kWaring55;

}

#pragma mark ---- UI 适配 ----
- (void)configureHeaderUI
{
    self.name_layout_left.constant = 97*APP_W/320;
    self.totalScore_layout_right.constant = 90*APP_W/320;
}

#pragma mark ---- 获取列表数据 ----
- (void)headerRefreshing
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
    setting[@"page"] = @"1";
    setting[@"pageSize"] = @"20";
    
    [Branch BranchScoreRankWithParams:setting success:^(id obj) {
        
        [self.tableView headerEndRefreshing];
        [self.dataList removeAllObjects];
        
        ScoreRankPageModel *page = [ScoreRankPageModel parse:obj Elements:[ScoreRankListModel class] forAttribute:@"list"];
        
        if ([page.apiStatus integerValue] == 0)
        {
            NSArray *arr = page.list;
            
            ScoreRankListModel *model = (ScoreRankListModel *)page.self;
            if (model)
            {
                model.isDog = YES;
                [self.dataList addObject:model];
            }
            
            if (arr.count>0)
            {
                currentPage++;
                [self.dataList addObjectsFromArray:arr];
            }
            
            if (self.dataList.count > 0)
            {
                [self.tableView reloadData];
            }else
            {
                [self showInfoView:@"暂无排行" image:@"ic_img_fail"];
            }
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:page.apiMessage];
        }
        
    } failure:^(HttpException *e) {
        [self.tableView headerEndRefreshing];
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [self showInfoView:kWaring12 image:@"img_network"];
        }else
        {
            if(e.errorCode != -999){
                if(e.errorCode == -1001){
                    [self showInfoView:kWarning215N54 image:@"ic_img_fail"];
                }else{
                    [self showInfoView:kWarning215N0 image:@"ic_img_fail"];
                }
            }
        }
    }];
}

#pragma mark ---- 分页加载 ----
- (void)footerRereshing
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
    setting[@"page"] = [NSString stringWithFormat:@"%ld",(long)currentPage];
    setting[@"pageSize"] = @"20";
    HttpClientMgr.progressEnabled = NO;
    
    
    [Branch BranchScoreRankWithParams:setting success:^(id obj) {
        
        [self.tableView footerEndRefreshing];
        
        ScoreRankPageModel *page = [ScoreRankPageModel parse:obj Elements:[ScoreRankListModel class] forAttribute:@"list"];
        
        if ([page.apiStatus integerValue] == 0)
        {
            NSArray *arr = page.list;
            if (arr.count == 0)
            {
                self.tableView.footer.canLoadMore = NO;
                [self.tableView footerEndRefreshing];
            }
            
            if (arr.count>0)
            {
                [self.dataList addObjectsFromArray:arr];
                [self.tableView reloadData];
                currentPage++;
            }else
            {
                if (currentPage == 1)
                {
                    [self showInfoView:@"暂无排行" image:@"ic_img_fail"];
                }
            }
        }
        
    } failure:^(HttpException *e) {
         [self.tableView footerEndRefreshing];
    }];
}

#pragma mark ---- UITableViewDelegate ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 39;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.tableHeaderView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScoreRankListModel *model = self.dataList[indexPath.row];
    return [ScoreRankCell getCellHeight:model];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScoreRankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoreRankCell"];
    ScoreRankListModel *model = self.dataList[indexPath.row];
    [cell setCell:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ScoreRankListModel *model = self.dataList[indexPath.row];
    
    ScoreRankDetailViewController *vc = [[UIStoryboard storyboardWithName:@"ScoreRank" bundle:nil] instantiateViewControllerWithIdentifier:@"ScoreRankDetailViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.empId = model.empId;
    vc.title = [NSString stringWithFormat:@"%@积分",model.empName];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
