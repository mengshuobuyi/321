//
//  MemberSellStatisticsViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 15/12/1.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "MemberSellStatisticsViewController.h"
#import "MemberSellStatisticsCell.h"
#import "MemberSellDetailViewController.h"
#import "Rpt.h"
#import "RptModel.h"

@interface MemberSellStatisticsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation MemberSellStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"商家会员营销方案";
    self.dataSource = [NSMutableArray array];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self queryData];
}

- (void)queryData
{
    [self removeInfoView];
    
    if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
        [self showInfoView:kWaring12 image:@"img_network"];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
    
    [Rpt rptMktgByGroupWithParams:setting success:^(id obj) {
        
        RptPageModel *page = [RptPageModel parse:obj Elements:[RptListModel class] forAttribute:@"mktgs"];
        if ([page.apiStatus integerValue] == 0) {
            if (page.mktgs.count > 0) {
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:page.mktgs];
                [self.tableView reloadData];
            }
            
        }else{
            [self showInfoView:@"暂无营销方案" image:@"img_statistical"];
        }
        
    } failure:^(HttpException *e) {
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

- (void)viewInfoClickAction:(id)sender
{
    [self queryData];
}

#pragma mark ---- 列表代理 ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberSellStatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberSellStatisticsCell"];
    RptListModel *model = self.dataSource[indexPath.row];
    cell.content.text = model.mktgTitle;
    cell.time.text = model.date;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RptListModel *model = self.dataSource[indexPath.row];

    MemberSellDetailViewController *vc = [[UIStoryboard storyboardWithName:@"MemberSellStatistics" bundle:nil] instantiateViewControllerWithIdentifier:@"MemberSellDetailViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.mktgId = model.mktgId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
