//
//  UserPageAttenCircleViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/16.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "UserPageAttenCircleViewController.h"
#import "AllCircleCell.h"
#import "Circle.h"
#import "CircleModel.h"
#import "CircleDetailViewController.h"

@interface UserPageAttenCircleViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataList;

@end

@implementation UserPageAttenCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Ta关注的圈子";
    
    self.dataList = [NSMutableArray array];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self queryList];
}

#pragma mark ---- 获取圈子列表 ----
- (void)queryList
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"userId"] = StrFromObj(self.userId);
    [Circle TeamHisAttnTeamListWithParams:setting success:^(id obj) {
        
        CircleListPageModel *page = [CircleListPageModel parse:obj Elements:[CircleListModel class] forAttribute:@"teamInfoList"];
        if ([page.apiStatus integerValue] == 0)
        {
            if (page.teamInfoList.count > 0) {
                [self.dataList removeAllObjects];
                [self.dataList addObjectsFromArray:page.teamInfoList];
                [self.tableView reloadData];
            }else{
                [self showInfoView:@"Ta还没有关注的圈子" image:@"ic_img_fail"];
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
    static NSString *allCircleCell = @"userpageattencircleCell";
    AllCircleCell *cell = (AllCircleCell *)[tableView dequeueReusableCellWithIdentifier:allCircleCell];
    if(cell == nil){
        UINib *nib = [UINib nibWithNibName:@"AllCircleCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:allCircleCell];
        cell = (AllCircleCell *)[tableView dequeueReusableCellWithIdentifier:allCircleCell];
    }
    CircleListModel *model = self.dataList[indexPath.section];
    [cell TattenCircle:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //圈子详情
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
