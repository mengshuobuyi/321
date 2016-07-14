//
//  MyFollowCircleViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/7.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "MyFollowCircleViewController.h"
#import "AllCircleCell.h"
#import "CircleDetailViewController.h"
#import "CircleModel.h"
#import "Circle.h"

@interface MyFollowCircleViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataList;

@end

@implementation MyFollowCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关注的圈子";
    self.dataList = [NSMutableArray array];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self queryList];
}

#pragma mark ---- 请求数据 ----
- (void)queryList
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    
    [Circle TeamMyAttnTeamListWithParams:setting success:^(id obj) {
        NSMutableArray *keyArr = [NSMutableArray array];
        [keyArr addObject:NSStringFromClass([CircleListModel class])];
        [keyArr addObject:NSStringFromClass([CircleListModel class])];
        NSMutableArray *valueArr = [NSMutableArray array];
        [valueArr addObject:@"teamList"];
        [valueArr addObject:@"attnTeamList"];
        CircleAttenPageModel *page = [CircleAttenPageModel parse:obj ClassArr:keyArr Elements:valueArr];
        if ([page.apiStatus integerValue] == 0)
        {
            [self.dataList removeAllObjects];
            
            
            if (page.teamList.count > 0)
            {
                NSMutableArray *arr1 = [NSMutableArray array];
                for (CircleListModel *model in page.teamList) {
                    model.flagAttenMaster = YES;
                    [arr1 addObject:model];
                }
                [self.dataList addObjectsFromArray:arr1];
            }
            
            if (page.attnTeamList.count > 0)
            {
                NSMutableArray *arr1 = [NSMutableArray array];
                for (CircleListModel *model in page.attnTeamList) {
                    model.flagAttenMaster = NO;
                    [arr1 addObject:model];
                }
                [self.dataList addObjectsFromArray:arr1];
            }
            
            if (self.dataList.count == 0) {
                [self showInfoView:@"您还没有关注的圈子" image:@"ic_img_fail"];
            }else{
                [self.tableView reloadData];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 8)];
    vi.backgroundColor = [UIColor clearColor];
    return vi;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *allCircleCell = @"AllCircleCell";
    AllCircleCell *cell = (AllCircleCell *)[tableView dequeueReusableCellWithIdentifier:allCircleCell];
    if(cell == nil){
        UINib *nib = [UINib nibWithNibName:@"AllCircleCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:allCircleCell];
        cell = (AllCircleCell *)[tableView dequeueReusableCellWithIdentifier:allCircleCell];
    }
    CircleListModel *model = self.dataList[indexPath.section];
    [cell attenCircle:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CircleListModel *model = self.dataList[indexPath.section];
    
    CircleDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Circle" bundle:nil] instantiateViewControllerWithIdentifier:@"CircleDetailViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.teamId = model.teamId;
    vc.title = [NSString stringWithFormat:@"%@圈",model.teamName];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
