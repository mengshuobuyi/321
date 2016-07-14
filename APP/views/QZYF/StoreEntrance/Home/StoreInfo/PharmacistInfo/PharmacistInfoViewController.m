//
//  PharmacistInfoViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/5/6.
//  Copyright © 2016年 carret. All rights reserved.
//

/*
    药师信息列表
    h5/mbr/expert/queryExpertByBranchId
 */

#import "PharmacistInfoViewController.h"
#import "PharmacistInfoCell.h"
#import "PharmacistInfoDetailViewController.h"
#import "Mbr.h"
#import "ExpertModel.h"

@interface PharmacistInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataList;

@end

@implementation PharmacistInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"药师信息";
    
    self.dataList = [NSMutableArray array];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self queryInfo];
}

#pragma mark ---- 获取药师列表信息 ----
- (void)queryInfo
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"branchId"] = StrFromObj(QWGLOBALMANAGER.configure.groupId);
    [Mbr MbrExpertQueryExpertByBranchIdWithParams:setting success:^(id DFUserModel) {
        
        PharmacistInfoPageModel *page = [PharmacistInfoPageModel parse:DFUserModel Elements:[PharmacistInfoListModel class] forAttribute:@"expertList"];
        if ([page.apiStatus integerValue] == 0)
        {
            if (page.expertList && page.expertList.count > 0)
            {
                [self.dataList removeAllObjects];
                self.dataList = [NSMutableArray arrayWithArray:page.expertList];
                [self.tableView reloadData];
            }else
            {
                [self showInfoView:@"您还没有药师!" image:@"img_no_pharmacist_tips"];
            }
        }
    } failure:^(HttpException *e) {
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable){
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

#pragma mark ---- UITableViewDelegate ----

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PharmacistInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PharmacistInfoCell"];
    [cell setCell:self.dataList[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PharmacistInfoListModel *model = self.dataList[indexPath.row];
    
    PharmacistInfoDetailViewController *vc = [[UIStoryboard storyboardWithName:@"StoreInfo" bundle:nil] instantiateViewControllerWithIdentifier:@"PharmacistInfoDetailViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.pharmacistInfoModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
