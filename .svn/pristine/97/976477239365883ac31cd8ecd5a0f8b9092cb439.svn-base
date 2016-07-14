//
//  MyFollowExpertViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/7.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "MyFollowExpertViewController.h"
#import "MyFollowExpertCell.h"
#import "CircleModel.h"
#import "Circle.h"
#import "ExpertPageViewController.h"
#import "UserPageViewController.h"

@interface MyFollowExpertViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataList;

@end

@implementation MyFollowExpertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataList = [NSMutableArray array];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (self.jumpType == 1) {
        self.title = @"我关注的专家";
    }else if (self.jumpType == 2){
        self.title = @"Ta关注的专家";
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.jumpType == 1) {
        [self queryMyList];
    }else if (self.jumpType == 2){
        [self queryTaList];
    }
}

#pragma mark ---- 我关注的圈子 ----
- (void)queryMyList
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    [Circle teamMyAttnExpertListWithParams:setting success:^(id obj) {
        
        CircleFunsPageModel *page = [CircleFunsPageModel parse:obj Elements:[CircleMaserlistModel class] forAttribute:@"expertList"];
        if ([page.apiStatus integerValue] == 0) {
            if (page.expertList.count > 0) {
                [self.dataList removeAllObjects];
                [self.dataList addObjectsFromArray:page.expertList];
                [self.tableView reloadData];
            }else{
                [self showInfoView:@"您还没有关注的专家" image:@"ic_img_fail"];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:page.apiMessage];
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

#pragma mark ---- Ta关注的圈子 ----
- (void)queryTaList
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"userId"] = StrFromObj(self.userId);
    [Circle TeamHisAttnExpertListWithParams:setting success:^(id obj) {
        CircleFunsPageModel *page = [CircleFunsPageModel parse:obj Elements:[CircleMaserlistModel class] forAttribute:@"expertList"];
        if ([page.apiStatus integerValue] == 0) {
            if (page.expertList.count > 0) {
                [self.dataList removeAllObjects];
                [self.dataList addObjectsFromArray:page.expertList];
                [self.tableView reloadData];
            }else{
                [self showInfoView:@"Ta还没有关注的专家" image:@"ic_img_fail"];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:page.apiMessage];
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

#pragma mark ---- 列表代理 ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 96;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyFollowExpertCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyFollowExpertCell"];
    [cell setCell:self.dataList[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //进入药师专栏  用户主页
    CircleMaserlistModel *model = self.dataList[indexPath.row];
    
    //如果是当前登陆账号，不可点击
    if ([model.id isEqualToString:QWGLOBALMANAGER.configure.expertPassportId]) {
        return;
    }
    
    if (model.userType == 3 || model.userType == 4) {
        ExpertPageViewController *vc = [[UIStoryboard storyboardWithName:@"ExpertPage" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertPageViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.posterId = model.id;
        vc.expertType = model.userType;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        UserPageViewController *vc = [[UIStoryboard storyboardWithName:@"UserPage" bundle:nil] instantiateViewControllerWithIdentifier:@"UserPageViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.mbrId = model.id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
