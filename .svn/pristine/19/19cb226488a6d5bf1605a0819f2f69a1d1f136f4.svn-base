//
//  UserPageReplyViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/16.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "UserPageReplyViewController.h"
#import "Circle.h"
#import "CircleModel.h"
#import "MyBackTopicCell.h"
#import "PostDetailViewController.h"

@interface UserPageReplyViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataList;

@end

@implementation UserPageReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Ta的回帖";
    
    self.dataList = [NSMutableArray array];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //下拉刷新
    __weak UserPageReplyViewController *weakSelf = self;
    [self enableSimpleRefresh:self.tableView block:^(SRRefreshView *sender) {
        if (QWGLOBALMANAGER.currentNetWork != kNotReachable) {
            HttpClientMgr.progressEnabled = NO;
            [weakSelf queryList];
        }else{
            [SVProgressHUD showErrorWithStatus:@"网络未连接，请重试！" duration:0.8];
        }
    }];
    
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
    setting[@"userId"] = StrFromObj(self.expertId);
    setting[@"page"] = @"1";
    setting[@"pageSize"] = @"10000";
    [Circle TeamHisReplyListWithParams:setting success:^(id obj) {
        
        [self removeInfoView];
        [self.dataList removeAllObjects];
        CircleReplayPageModel *page = [CircleReplayPageModel parse:obj Elements:[CircleReplayListModel class] forAttribute:@"postReplyList"];
        if ([page.apiStatus integerValue] == 0)
        {
            [self.dataList addObjectsFromArray:page.postReplyList];
            if (self.dataList.count > 0) {
                [self.tableView reloadData];
            }else{
                [self showInfoView:@"Ta还没有回帖" image:@"ic_img_fail"];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 7;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 7)];
    v.backgroundColor = RGBHex(qwColor11);
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MyBackTopicCell getCellHeight:self.dataList[indexPath.section]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *circleDetailCell = @"userpagereplyCell";
    MyBackTopicCell *cell = (MyBackTopicCell *)[tableView dequeueReusableCellWithIdentifier:circleDetailCell];
    if(cell == nil){
        UINib *nib = [UINib nibWithNibName:@"MyBackTopicCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:circleDetailCell];
        cell = (MyBackTopicCell *)[tableView dequeueReusableCellWithIdentifier:circleDetailCell];
    }
    [cell setCellData:self.dataList[indexPath.section] type:3];
    cell.topicBgView.tag = indexPath.section+1;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTopicAction:)];
    [cell.topicBgView addGestureRecognizer:tap];
    return cell;
}

#pragma mark ---- 点击帖子标题进入帖子详情 ----
- (void)tapTopicAction:(UITapGestureRecognizer *)tap
{
    UIView *vi = tap.view;
    int row = vi.tag - 1;
    
    PostDetailViewController* postDetailVC = [[UIStoryboard storyboardWithName:@"Forum" bundle:nil] instantiateViewControllerWithIdentifier:@"PostDetailViewController"];
    CircleReplayListModel* topic = self.dataList[row];
    postDetailVC.postId = topic.postId;
    postDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:postDetailVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
