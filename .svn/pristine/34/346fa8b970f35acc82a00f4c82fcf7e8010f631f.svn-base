//
//  WenyaoActivityViewController.m
//  wenYao-store
//  接口
//  获取问药活动列表    :       h5/act/list
//  Created by Martin.Liu on 16/5/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "WenyaoActivityViewController.h"
#import "ConstraintsUtility.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "WenyaoActivityTableCell.h"
#import "Store.h"
#import "SVProgressHUD.h"
#import "WebDirectViewController.h"
static NSString *const kWenyaoActivityTableCellIdentifier = @"kWenyaoActivityTableCellIdentifier";

@interface WenyaoActivityViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* actNoticeArray;
@property (nonatomic, strong) WenyaoActivityListR* paramR;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation WenyaoActivityViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"问药活动";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBHex(qwColor11);
    self.pageIndex = 0;
    [self configTableView];
    [self loadData];
}

- (void)configTableView
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = RGBHex(qwColor11);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    PREPCONSTRAINTS(self.tableView);
    ALIGN_TOPLEFT(self.tableView, 0);
    ALIGN_BOTTOMRIGHT(self.tableView, 0);
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"WenyaoActivityTableCell" bundle:nil] forCellReuseIdentifier:kWenyaoActivityTableCellIdentifier];
    
//    __weak __typeof(self) weakSelf = self;
//    [self enableSimpleRefresh:self.tableView block:^(SRRefreshView *sender) {
//        weakSelf.pageIndex = 0;
//        [weakSelf loadData];
//    }];
//    
//    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
}

- (NSMutableArray *)actNoticeArray
{
    if (!_actNoticeArray) {
        _actNoticeArray = [NSMutableArray array];
    }
    return _actNoticeArray;
}

- (WenyaoActivityListR *)paramR
{
    if (!_paramR) {
        _paramR = [WenyaoActivityListR new];
        _paramR.page = 0;
        _paramR.pageSize = 1000;
    }
    return _paramR;
}

- (void)loadData
{
    __weak __typeof(self) weakSelf = self;
    self.paramR.page = self.pageIndex + 1;
    [Store getWenyaoActivityList:self.paramR success:^(ActNoticeListModel *actNoticeList) {
        [weakSelf.actNoticeArray removeAllObjects];
        if ([actNoticeList.apiStatus integerValue] == 0) {
            if (actNoticeList.list.count > 0) {
                weakSelf.pageIndex += 1;
                [weakSelf.actNoticeArray addObjectsFromArray:actNoticeList.list];
                [weakSelf removeInfoView];
            }
            else
            {
                [weakSelf showInfoView:@"暂无活动" image:@"img_employee_statistical"];
            }
            [weakSelf.tableView reloadData];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:StrDFString(actNoticeList.apiMessage, @"暂无活动，敬请期待！") duration:DURATION_LONG];
        }
    } fail:^(HttpException *e) {
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [weakSelf showInfoView:kWaring12 image:@"img_network"];
        }else
        {
            if(e.errorCode!=-999){
                if(e.errorCode == -1001){
                    [weakSelf showInfoView:kWarning215N54 image:@"ic_img_fail"];
                }else{
                    [weakSelf showInfoView:kWarning215N0 image:@"ic_img_fail"];
                }
            }
        }
    }];
}

- (void)loadMoreData
{
    __weak __typeof(self) weakSelf = self;
    self.paramR.page = self.pageIndex + 1;
    [Store getWenyaoActivityList:self.paramR success:^(ActNoticeListModel *actNoticeList) {
        if ([actNoticeList.apiStatus integerValue] == 0) {
            if (actNoticeList.list.count >= weakSelf.paramR.pageSize) {
                weakSelf.pageIndex += 1;
                [weakSelf.actNoticeArray addObjectsFromArray:actNoticeList.list];
                [weakSelf removeInfoView];
                [weakSelf.tableView reloadData];
            }
        }
        [weakSelf.tableView footerEndRefreshing];
    } fail:^(HttpException *e) {
        [weakSelf.tableView footerEndRefreshing];
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [weakSelf showInfoView:kWaring12 image:@"img_network"];
        }else
        {
            if(e.errorCode!=-999){
                if(e.errorCode == -1001){
                    [weakSelf showInfoView:kWarning215N54 image:@"ic_img_fail"];
                }else{
                    [weakSelf showInfoView:kWarning215N0 image:@"ic_img_fail"];
                }
            }
        }
    }];
}

- (void)dealloc
{
    NSLog(@"dealloc >>>>>>>>>>");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.actNoticeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WenyaoActivityTableCell* wenyaoActivityCell = [tableView dequeueReusableCellWithIdentifier:kWenyaoActivityTableCellIdentifier forIndexPath:indexPath];
    [self configCell:wenyaoActivityCell indexPath:indexPath];
    return wenyaoActivityCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:kWenyaoActivityTableCellIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
        [self configCell:cell indexPath:indexPath];
    }];
}

- (void)configCell:(id)cell indexPath:(NSIndexPath*)indexPath
{
    NSInteger row = indexPath.row;
    if (self.actNoticeArray.count > row) {
        ActNoticeModel* actNoticeModel = self.actNoticeArray[row];
        [cell setCell:actNoticeModel];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [QWGLOBALMANAGER statisticsEventId:@"s_wyhd_lb" withLable:@"问药活动-列表点击" withParams:nil];
    
    NSInteger row = indexPath.row;
    if (self.actNoticeArray.count > row) {
        ActNoticeModel* actNoticeModel = self.actNoticeArray[row];
        WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
        vcWebDirect.hidesBottomBarWhenPushed = YES;
        WebDirectLocalModel* webModel = [WebDirectLocalModel new];
        webModel.title = @"活动详情";
        webModel.url = [NSString stringWithFormat:@"%@QWSH/web/eventDetail/html/detail.html?id=%@", H5_BASE_URL,actNoticeModel.id];
        [vcWebDirect setWVWithLocalModel:webModel];
        [self.navigationController pushViewController:vcWebDirect animated:YES];
    }
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
