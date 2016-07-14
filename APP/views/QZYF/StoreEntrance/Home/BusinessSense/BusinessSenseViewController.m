//
//  BusinessSenseViewController.m
//  wenYao-store
//  接口
//  获取列表(培训、生意经):           h5/train/trainList
//  培训详情                        h5/train/trainDetails
//  Created by Martin.Liu on 16/5/10.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "BusinessSenseViewController.h"
#import "BusinessSenseTableCell.h"
#import "ConstraintsUtility.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "Store.h"
#import "WebDirectViewController.h"

static NSString *const kBusinessSenceTableCellIdentifier = @"kBusinessSenceTableCellIdentifier";

@interface BusinessSenseViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) GetTrainListR* getTrainListR;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray* businessArray;
@property (nonatomic, strong) TrainModel* selectedTrainModel;
@end

@implementation BusinessSenseViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"生意经";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBHex(qwColor11);
    [self configTableView];
    [self loadData];
}

#pragma mark - 配置TableView
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
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessSenseTableCell" bundle:nil] forCellReuseIdentifier:kBusinessSenceTableCellIdentifier];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    __weak __typeof(self) weakSelf = self;
    // 要放在这里，否则会自动刷新 (autolayout中[UIView(Geometry) _applyAutoresizingMaskWithOldSuperviewSize:] ()的鬼，会自动条用setFrame方法)
    [self enableSimpleRefresh:self.tableView block:^(SRRefreshView *sender) {
        weakSelf.selectedTrainModel = nil;
        weakSelf.pageIndex = 0;
        [weakSelf loadData];
    }];
    
    // 刷新页面，如果选择了某一个cell，则刷新这个具体的cell。
    if (self.businessArray.count > 0 && self.selectedTrainModel) {
        GetTrainDetailR* getTrainDetailR = [GetTrainDetailR new];
        getTrainDetailR.token = QWGLOBALMANAGER.configure.userToken;
        getTrainDetailR.trainId = self.selectedTrainModel.trainId;
        
        [Store getTrainDetail:getTrainDetailR success:^(TrainModel *trainModel) {
            [weakSelf updateTrainModel:trainModel];
        } fail:^(HttpException *e) {
            ;
        }];
    }
}

#pragma mark - 刷新队列中的某一个生意经model
- (void)updateTrainModel:(TrainModel*)trainModel
{
    // 重写了isEqul：方法
    NSInteger index = [self.businessArray indexOfObject:trainModel];
    if (index != NSNotFound && index >= 0 && index < self.businessArray.count) {
        [self.businessArray replaceObjectAtIndex:index withObject:trainModel];
        [self.tableView reloadData];
    }
}

- (NSMutableArray *)businessArray
{
    if (!_businessArray) {
        _businessArray = [NSMutableArray array];
    }
    return _businessArray;
}

- (GetTrainListR *)getTrainListR
{
    if (!_getTrainListR) {
        _getTrainListR = [GetTrainListR new];
        _getTrainListR.token = QWGLOBALMANAGER.configure.userToken;
        _getTrainListR.page = 0;
        _getTrainListR.viewType = 1;
        _getTrainListR.pageSize = 10;
    }
    return _getTrainListR;
}

#pragma mark - 加载生意经数据
- (void)loadData
{
    __weak __typeof(self) weakSelf = self;
    self.getTrainListR.page = self.pageIndex + 1;
    [Store getTrainList:self.getTrainListR success:^(TrainListModel *trainListModel) {
        [weakSelf.businessArray removeAllObjects];
        [weakSelf.businessArray addObjectsFromArray:trainListModel.trainList];
        if (trainListModel.trainList.count >= weakSelf.getTrainListR.pageSize) {
            weakSelf.pageIndex += 1;
            weakSelf.tableView.footer.canLoadMore = YES;
        }
        else
        {
            weakSelf.tableView.footer.canLoadMore = NO;
        }
        if (weakSelf.businessArray.count == 0) {
            [weakSelf showInfoView:@"暂无数据" image:@"ic_img_fail"];
        }
        else
        {
            [weakSelf removeInfoView];
        }
        [weakSelf.tableView reloadData];
        [weakSelf endHeaderRefresh];
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
        [weakSelf endHeaderRefresh];
    }];
}

- (void)loadMoreData
{
    __weak __typeof(self) weakSelf = self;
    self.getTrainListR.page = self.pageIndex + 1;
    [Store getTrainListWithoutProgress:self.getTrainListR success:^(TrainListModel *trainListModel) {
        [self.businessArray addObjectsFromArray:trainListModel.trainList];
        if (trainListModel.trainList.count >= weakSelf.getTrainListR.pageSize) {
            weakSelf.pageIndex += 1;
        }
        else
        {
            weakSelf.tableView.footer.canLoadMore = NO;
        }
        [weakSelf.tableView.footer endRefreshing];
        [weakSelf.tableView reloadData];
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
        [weakSelf.tableView.footer endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.businessArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BusinessSenseTableCell* businessCell = [tableView dequeueReusableCellWithIdentifier:kBusinessSenceTableCellIdentifier forIndexPath:indexPath];
    [self configCell:businessCell indexPath:indexPath];
    return businessCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:kBusinessSenceTableCellIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
        [self configCell:cell indexPath:indexPath];
    }];
}

- (void)configCell:(id)cell indexPath:(NSIndexPath*)indexPath
{
    NSInteger row = indexPath.row;
    if (self.businessArray.count > row) {
        TrainModel* trainModel = self.businessArray[row];
        [cell setCell:trainModel];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [QWGLOBALMANAGER statisticsEventId:@"s_syj_lb" withLable:@"生意经-列表点击" withParams:nil];
    [QWGLOBALMANAGER statisticsEventId:@"生意经_列表点击" withLable:@"生意经" withParams:nil];
    
    NSInteger row = indexPath.row;
    if (self.businessArray.count > row) {
        TrainModel* trainModel = self.businessArray[row];
        self.selectedTrainModel = trainModel;
        WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
        vcWebDirect.hidesBottomBarWhenPushed = YES;
        WebDirectLocalModel* webModel = [WebDirectLocalModel new];
        webModel.url = [NSString stringWithFormat:@"%@QWSH/web/survey/html/surveyDetail.html?id=%@", H5_BASE_URL,trainModel.trainId];;
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
