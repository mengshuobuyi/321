//
//  InstitutionListViewController.m
//  wenYao-store
//
//  Created by qwfy0006 on 15/4/1.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "InstitutionListViewController.h"
#import "InstitutionListCell.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "PerfectInfoViewController.h"
#import "AppDelegate.h"
#import "Pharmacy.h"
#import "PharmacyModel.h"

@interface InstitutionListViewController ()<UIAlertViewDelegate,ChoseInstitutionDelegate>

@property (strong, nonatomic) IBOutlet UIButton     *btn_write;
@property (strong, nonatomic) IBOutlet UITableView  *tbinstitution;

@property (assign, nonatomic) int            currPage;
@property (strong, nonatomic) NSMutableArray *storedataArr;

@end

@implementation InstitutionListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"从查询结果中选择我的机构";
    self.currPage = 2;
    self.tbinstitution.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if (!self.storedataArr) {
        self.storedataArr =[[NSMutableArray alloc] init];
    }
    [ self.btn_write addTarget:self action:@selector(userWriteAction) forControlEvents:UIControlEventTouchUpInside];
    [self getDataList];
}

- (void)getDataList
{
    if ([QWUserDefault getObjectBy:REGISTER_JG_REGISTERID]) {
        NSLog(@"%@",[QWUserDefault getObjectBy:REGISTER_JG_REGISTERID]);
        self.searchInfo[@"groupId"] = [[QWUserDefault getObjectBy:REGISTER_JG_REGISTERID] objectForKey:@"groupId"];
    }
    
    [Pharmacy QueryStoreWithParams:self.searchInfo success:^(id obj) {
        
        QueryStorePage *page = (QueryStorePage *)obj;
        if ([page.apiStatus intValue] == 0) {
            NSArray *array  = page.list;
            [self.storedataArr addObjectsFromArray:array];
            // 刷新表格
            [self.tbinstitution reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:page.apiMessage duration:DURATION_SHORT];
        }
    } failure:^(HttpException *e) {
        
    }];
    
}

#pragma mark ====
#pragma mark ==== 界面刷新

//- (void)setupRefresh
//{
//    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
//    [self.tbinstitution addHeaderWithTarget:self action:@selector(headerRereshing)];
//    [self.tbinstitution headerBeginRefreshing];
//
//    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
//    [self.tbinstitution addFooterWithTarget:self action:@selector(footerRereshing)];
//
//    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
//    self.tbinstitution.headerPullToRefreshText = @"下拉可以刷新了";
//    self.tbinstitution.headerReleaseToRefreshText = @"松开马上刷新了";
//    self.tbinstitution.headerRefreshingText = @"正在帮你刷新中";
//
//    self.tbinstitution.footerPullToRefreshText = @"上拉可以加载更多数据了";
//    self.tbinstitution.footerReleaseToRefreshText = @"松开马上加载更多数据了";
//    self.tbinstitution.footerRefreshingText = @"正在帮你加载中";
//}
//
//- (void)headerRereshing
//{
//    self.searchInfo[@"currPage"] = @"1";
//
//    if ([QWUserDefault getObjectBy:REGISTER_JG_REGISTERID]) {
//
//        self.searchInfo[@"groupId"] = [[QWUserDefault getObjectBy:REGISTER_JG_REGISTERID] objectForKey:@"groupId"];
//    }
//
//    [Pharmacy QueryStoreWithParams:self.searchInfo success:^(id obj) {
//
//        QueryStorePage *page = (QueryStorePage *)obj;
//
////        if ([page.currPage intValue] == 1) {
////            [self.storedataArr removeAllObjects];
////        }
////        self.totalPage = [page.totalPage intValue];
//        [self.storedataArr addObjectsFromArray: page.list];
//        // 刷新表格
//        [self.tbinstitution reloadData];
//        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//        [self.tbinstitution headerEndRefreshing];
//
//    } failure:^(HttpException *e) {
//        [self.tbinstitution headerEndRefreshing];
//    }];
//
//
//}
//
//- (void)footerRereshing
//{
//    if (self.currPage < self.totalPage ) {
//        self.searchInfo[@"currPage"] = [NSString stringWithFormat:@"%d",self.currPage];
//
//        if ([QWUserDefault getObjectBy:REGISTER_JG_REGISTERID]) {
//            self.searchInfo[@"groupId"] = [[QWUserDefault getObjectBy:REGISTER_JG_REGISTERID] objectForKey:@"groupId"];
//        }
//
//        [Pharmacy QueryStoreWithParams:self.searchInfo success:^(id obj) {
//
//            QueryStorePage *page = (QueryStorePage *)obj;
//
//             self.currPage ++;
//            NSArray *array  = page.list;
//            [self.storedataArr addObjectsFromArray:array];
//            // 刷新表格
//            [self.tbinstitution reloadData];
//            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//            [self.tbinstitution footerEndRefreshing];
//
//        } failure:^(HttpException *e) {
//            [self.tbinstitution headerEndRefreshing];
//        }];
//
//    }else {
//        [self.tbinstitution footerEndRefreshing];
//    }
//}

#pragma mark =====
#pragma mark ===== 列表代理

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [InstitutionListCell getCellHeight:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.storedataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *InstitutionListCellIdentifier = @"InstitutionListCell";
    InstitutionListCell *cell = (InstitutionListCell *)[tableView dequeueReusableCellWithIdentifier:InstitutionListCellIdentifier];
    if(cell == nil){
        UINib *nib = [UINib nibWithNibName:@"InstitutionListCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:InstitutionListCellIdentifier];
        cell = (InstitutionListCell *)[tableView dequeueReusableCellWithIdentifier:InstitutionListCellIdentifier];
    }
    
    QueryStoreModel *model = self.storedataArr[indexPath.row];
    [cell setCell:model];
    
    cell.btn_chose.tag = indexPath.row;
    cell.institutiondelegate = self;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark ====
#pragma mark ==== 没找到我的机构，直接填写

-(void)userWriteAction{
    PerfectInfoViewController *perfectVC = [[PerfectInfoViewController alloc] initWithNibName:@"PerfectInfoViewController" bundle:nil];
    
    if ([QWUserDefault getObjectBy:REGISTER_JG_COMPANYINFO]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:REGISTER_JG_COMPANYINFO];
    }
    
    perfectVC.comefromWrite = YES;
    [self.navigationController pushViewController:perfectVC animated:NO];
    
}

-(void)deleteHasSaveInfo{
    
    if ([QWUserDefault getObjectBy:REGISTER_JG_INSTITUTIONINFO]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:REGISTER_JG_INSTITUTIONINFO];
    }
    
    if ([QWUserDefault getObjectBy:REGISTER_JG_REGISTERID]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:REGISTER_JG_REGISTERID];
    }
    
    if ([QWUserDefault getBoolBy:REGISTER_JG_FINISHCOMPANYINFO]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:REGISTER_JG_FINISHCOMPANYINFO];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark ====
#pragma mark ==== 确认选择的机构

-(void)ChoseInstitution:(NSInteger)indexpath{
    
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"确认选择这家机构吗?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertV show];
    
    QueryStoreModel *model = self.storedataArr[indexpath];
    
    [QWUserDefault setObject:model key:REGISTER_JG_COMPANYINFO];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self deleteHasSaveInfo];
        
        PerfectInfoViewController *perfectVC = [[PerfectInfoViewController alloc] initWithNibName:@"PerfectInfoViewController" bundle:nil];
        [self.navigationController pushViewController:perfectVC animated:NO];
        
    }
}


@end

