//
//  LookFlowerViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/19.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "LookFlowerViewController.h"
#import "LookFlowerCell.h"
#import "CircleModel.h"
#import "Circle.h"
#import "ExpertPageViewController.h"
#import "UserPageViewController.h"

@interface LookFlowerViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataList;

@end

@implementation LookFlowerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"鲜花";
    self.dataList = [NSMutableArray array];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    //下拉刷新
    __weak LookFlowerViewController *weakSelf = self;
    [self enableSimpleRefresh:self.tableView block:^(SRRefreshView *sender) {
        if (QWGLOBALMANAGER.currentNetWork != kNotReachable)
        {
            HttpClientMgr.progressEnabled = NO;
            [weakSelf queryList];
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"网络未连接，请重试！" duration:0.8];
        }
    }];
    
    [self queryList];
}

#pragma mark ---- 请求查看鲜花数据 ----
- (void)queryList
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"objId"] = StrFromObj(self.postId);
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    [Circle TeamQueryZanListByObjIdWithParams:setting success:^(id obj) {
        
        TeamFlowerPageModel *page = [TeamFlowerPageModel parse:obj Elements:[CircleMaserlistModel class] forAttribute:@"zanList"];
        if ([page.apiStatus integerValue] == 0)
        {
            if (page.zanList.count == 0)
            {
                [self showInfoView:@"您还没有消息" image:@"ic_img_fail"];
            }else
            {
                [self.dataList removeAllObjects];
                [self.dataList addObjectsFromArray:page.zanList];
                [self.tableView reloadData];
            }
        }else
        {
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

#pragma mark ---- UITableViewDelegate ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 97;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LookFlowerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LookFlowerCell"];
    CircleMaserlistModel *model = self.dataList[indexPath.row];
    [cell setUpData:model];
    cell.attentionButton.tag = indexPath.row + 10;
    [cell.attentionButton addTarget:self action:@selector(attentionMasterAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CircleMaserlistModel *model = self.dataList[indexPath.row];
    
    //游客不可点击
    if (StrIsEmpty(model.id)) {
        return;
    }
    
    //当前登陆用户 不可点击
    if ([model.id isEqualToString:QWGLOBALMANAGER.configure.expertPassportId]) {
        return;
    }
    
    if (model.userType == 3 || model.userType == 4)
    {
        //专家
        ExpertPageViewController *vc = [[UIStoryboard storyboardWithName:@"ExpertPage" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertPageViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.posterId = model.id;
        vc.expertType = model.userType;
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        //普通用户
        UserPageViewController *vc = [[UIStoryboard storyboardWithName:@"UserPage" bundle:nil] instantiateViewControllerWithIdentifier:@"UserPageViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.mbrId = model.id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark ---- 关注 ----
- (void)attentionMasterAction:(id)sender
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    UIButton *btn = (UIButton *)sender;
    int row = btn.tag-10;
    
    CircleMaserlistModel *model = self.dataList[row];
    NSString *type;
    if (model.isAttnFlag) {
        //取消关注
        type = @"1";
    }else{
        //关注
        type = @"0";
    }
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"objId"] = StrFromObj(model.id);
    setting[@"reqBizType"] = StrFromObj(type);
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    
    [Circle teamAttentionMbrWithParams:setting success:^(id obj) {
        if ([obj[@"apiStatus"] integerValue] == 0)
        {
            [SVProgressHUD showSuccessWithStatus:obj[@"apiMessage"]];
            model.isAttnFlag = !model.isAttnFlag;
            [self.dataList replaceObjectAtIndex:row withObject:model];
            [self.tableView reloadData];
        }else
        {
            [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"]];
        }
    } failure:^(HttpException *e) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
