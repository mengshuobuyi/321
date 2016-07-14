//
//  SearchActivityResultViewController.m
//  wenYao-store
//  商品活动搜索结果页
//  QueryMMallActivity 商品活动列表
//  Created by qw_imac on 16/3/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "SearchActivityResultViewController.h"
#import "WechatActivityCell.h"
#import "ActivityDetailViewController.h"
#import "WechatActivity.h"
@interface SearchActivityResultViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger       currPage;
    NSMutableArray  *dataSource;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SearchActivityResultViewController
static NSString *const cellIdentifier = @"WechatActivityCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索结果";
    currPage = 1;
    dataSource = [@[] mutableCopy];
    [self.tableView registerNib:[UINib nibWithNibName:@"WechatActivityCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self searchResult];
}

#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MicroMallActivityVO *vo = dataSource[indexPath.row];
    WechatActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell setCell:vo];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MicroMallActivityVO *vo = dataSource[indexPath.row];
    ActivityDetailViewController *vc = [[ActivityDetailViewController alloc]initWithNibName:@"ActivityDetailViewController" bundle:nil];
    vc.activityId = vo.actId;
    vc.type = vo.type.integerValue;
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 94.0;
}

-(void)searchResult {
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring12 image:@"img_network" flatY:40.0f];
    }else {
        [self removeInfoView];
        WechatActivityR *modelR = [WechatActivityR new];
        if (QWGLOBALMANAGER.configure.userToken) {
            modelR.token = QWGLOBALMANAGER.configure.userToken;
        }
        modelR.source = 0;
        modelR.type = 0;
        modelR.status = 0;
        modelR.currPage = currPage;
        modelR.keyWord = _searchWord;
        modelR.pageSize = 100;
        [WechatActivity queryWechatActivityList:modelR success:^(WechatActivityModel *responseModel) {
            if ([responseModel.apiStatus integerValue] == 0) {
                if (currPage == 1) {
                    [dataSource removeAllObjects];
                }
                [dataSource addObjectsFromArray:responseModel.resultList];
                if (dataSource.count == 0) {
                    [self showInfoView:@"没有搜到该活动" image:@"img_search" flatY:40.0f];
                }
                [self.tableView reloadData];
            }
        } failure:^(HttpException *e) {
        }];}

}
@end
