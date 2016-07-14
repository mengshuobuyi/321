//
//  CircleDetailNextViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/8.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "CircleDetailNextViewController.h"
#import "Circle.h"
#import "CircleModel.h"
#import "ExpertPageViewController.h"
#import "UserPageViewController.h"
#import "PostDetailViewController.h"
#import "HotCircleCell.h"

@interface CircleDetailNextViewController ()<UITableViewDataSource,UITableViewDelegate,HotCircleCellDelegate>
{
    NSInteger currentPage;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataList;

@end

@implementation CircleDetailNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.dataList = [NSMutableArray array];
    [self setUpTableView];
}

#pragma mark ---- 设置tableView ----
- (void)setUpTableView
{
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 7)];
    vi.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = vi;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = YES;
    
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableView.footerPullToRefreshText = kWaring6;
    self.tableView.footerReleaseToRefreshText = kWaring7;
    self.tableView.footerRefreshingText = kWaring9;
    self.tableView.footerNoDataText = @"已显示全部内容";
}

#pragma mark ---- UITableViewDelegate ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.jumpType integerValue] == 1)
    {
        //圈子详情
        return [HotCircleCell getCellHeight:self.dataList[indexPath.row]];
        
    }else if ([self.jumpType integerValue] == 2)
    {
        //专家专栏
        return [HotCircleCell getCellHeight:self.dataList[indexPath.row]]-40;
    }else{
        return 0.1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *circleDetailCell = @"CircleDetailCell";
    HotCircleCell *cell = (HotCircleCell *)[tableView dequeueReusableCellWithIdentifier:circleDetailCell];
    if(cell == nil){
        UINib *nib = [UINib nibWithNibName:@"HotCircleCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:circleDetailCell];
        cell = (HotCircleCell *)[tableView dequeueReusableCellWithIdentifier:circleDetailCell];
    }
    
    if ([self.jumpType integerValue] == 1)
    {
        //圈子详情
        [cell circleDetailList:self.dataList[indexPath.row] type:[self.sliderTabIndex integerValue] flagGroup:self.flagGroup];
        cell.topView.obj = indexPath;
        cell.hotCircleCellDelegate = self;
        
    }else if ([self.jumpType integerValue] == 2)
    {
        //专家专栏
        [cell myPostTopic:self.dataList[indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if ([self.jumpType integerValue] == 2) {
        [QWGLOBALMANAGER statisticsEventId:@"专栏_Ta的发文帖子列表" withLable:@"圈子" withParams:nil];
    }
    
    //进入帖子详情
    PostDetailViewController* postDetailVC = [[UIStoryboard storyboardWithName:@"Forum" bundle:nil] instantiateViewControllerWithIdentifier:@"PostDetailViewController"];
    TopicListModel* topic = self.dataList[indexPath.row];
    postDetailVC.postId = topic.postId;
    postDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:postDetailVC animated:YES];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(didScrollToTop:)]) {
        [self.delegate didScrollToTop:self];
    }
}

#pragma mark ---- 上拉刷新 ----
- (void)currentViewSelected:(void (^)(CGFloat))finishLoading
{
    if ([self.jumpType integerValue] == 1)
    {
        //圈子详情帖子列表
        currentPage = 1;
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"teamId"] = StrFromObj(self.teamId);
        setting[@"sortType"] = StrFromObj(self.requestType);
        setting[@"page"] = [NSString stringWithFormat:@"%ld",(long)currentPage];
        setting[@"pageSize"] = @"10";
        [HttpClientMgr setProgressEnabled:NO];
        
        [Circle TeamGetPostListInfoByTeamIdWithParams:setting success:^(id obj) {
            
            [self removeInfoView];
            [self.dataList removeAllObjects];
            
            TopicListArrayModel *listArrModel = [TopicListArrayModel parse:obj Elements:[TopicListModel class] forAttribute:@"postInfoList"];
            
            if ([listArrModel.apiStatus integerValue] == 0)
            {
                [self.dataList addObjectsFromArray:listArrModel.postInfoList];
                
                if (self.dataList.count > 0)
                {
                    currentPage ++;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                    if ([self.jumpType integerValue] == 1)
                    {
                        if (self.flagGroup)
                        {
                            [QWGLOBALMANAGER statisticsEventId:@"商家圈_帖子列表" withLable:@"圈子" withParams:nil];
                        }else
                        {
                            [QWGLOBALMANAGER statisticsEventId:@"公共圈_帖子列表" withLable:@"圈子" withParams:nil];
                        }
                    }
                }else
                {
                    [self noDataView];
                }
                
            }else
            {
                [SVProgressHUD showErrorWithStatus:listArrModel.apiMessage];
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
        
    }else if ([self.jumpType integerValue] == 2)
    {
        //药师专栏帖子列表请求数据
        //他的发文列表
        
        currentPage = 1;
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"userId"] = StrFromObj(self.expertId);
        setting[@"page"] = [NSString stringWithFormat:@"%ld",(long)currentPage];
        setting[@"pageSize"] = @"10";
        [HttpClientMgr setProgressEnabled:NO];
        
        [Circle TeamHisPostListWithParams:setting success:^(id obj) {
            [self removeInfoView];
            [self.dataList removeAllObjects];
            
            TopicListArrayModel *listArrModel = [TopicListArrayModel parse:obj Elements:[TopicListModel class] forAttribute:@"postInfoList"];
            
            if ([listArrModel.apiStatus integerValue] == 0)
            {
                [self.dataList addObjectsFromArray:listArrModel.postInfoList];
                
                if (self.dataList.count > 0)
                {
                    currentPage ++;
                    [self.tableView reloadData];
                    if ([self.jumpType integerValue] == 1)
                    {
                        if (self.flagGroup)
                        {
                            [QWGLOBALMANAGER statisticsEventId:@"商家圈_帖子列表" withLable:@"圈子" withParams:nil];
                        }else
                        {
                            [QWGLOBALMANAGER statisticsEventId:@"公共圈_帖子列表" withLable:@"圈子" withParams:nil];
                        }
                    }

                }else
                {
                    [self showInfoView:@"暂无相关帖子" image:@"ic_img_fail"];
                }
                
            }else
            {
                [SVProgressHUD showErrorWithStatus:listArrModel.apiMessage];
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
}

- (void)footerRereshing
{
    if ([self.jumpType integerValue] == 1)
    {
        //圈子详情
        if(self.dataList.count == 0)
        {
            [self noDataView];
            return;
        }
        
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"teamId"] = StrFromObj(self.teamId);
        setting[@"sortType"] = StrFromObj(self.requestType);
        setting[@"page"] = [NSString stringWithFormat:@"%ld",(long)currentPage];
        setting[@"pageSize"] = @"10";
        [HttpClientMgr setProgressEnabled:NO];
        
        [Circle TeamGetPostListInfoByTeamIdWithParams:setting success:^(id obj) {
            
            [self.tableView footerEndRefreshing];
            [self removeInfoView];
            TopicListArrayModel *listArr = [TopicListArrayModel parse:obj Elements:[TopicListModel class] forAttribute:@"postInfoList"];
            
            if ([listArr.apiStatus integerValue] == 0)
            {
                if (listArr.postInfoList.count == 0)
                {
                    [self.tableView.footer setCanLoadMore:NO];
                    [self.tableView footerEndRefreshing];
                }
                
                if (listArr.postInfoList.count > 0)
                {
                    currentPage ++;
                    [self.dataList addObjectsFromArray:listArr.postInfoList];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                    if ([self.jumpType integerValue] == 1)
                    {
                        if (self.flagGroup)
                        {
                            [QWGLOBALMANAGER statisticsEventId:@"商家圈_帖子列表" withLable:@"圈子" withParams:nil];
                        }else
                        {
                            [QWGLOBALMANAGER statisticsEventId:@"公共圈_帖子列表" withLable:@"圈子" withParams:nil];
                        }
                    }
                    
                }else
                {
                    if (currentPage == 1)
                    {
                        [self noDataView];
                    }
                }
                
            }else
            {
                [SVProgressHUD showErrorWithStatus:listArr.apiMessage];
            }
            
        } failure:^(HttpException *e) {
            [self.tableView footerEndRefreshing];
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
        
    }else if ([self.jumpType integerValue] == 2)
    {
        //药师专栏
        if(self.dataList.count == 0)
        {
            [self showInfoView:@"暂无相关帖子" image:@"ic_img_fail"];
            return;
        }
        
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"userId"] = StrFromObj(self.expertId);
        setting[@"page"] = [NSString stringWithFormat:@"%ld",(long)currentPage];
        setting[@"pageSize"] = @"10";
        [HttpClientMgr setProgressEnabled:NO];
        
        [Circle TeamHisPostListWithParams:setting success:^(id obj) {
            
            [self removeInfoView];
            [self.tableView footerEndRefreshing];
            TopicListArrayModel *listArr = [TopicListArrayModel parse:obj Elements:[TopicListModel class] forAttribute:@"postInfoList"];
            
            if ([listArr.apiStatus integerValue] == 0)
            {
                if (listArr.postInfoList.count == 0)
                {
                    [self.tableView.footer setCanLoadMore:NO];
                    [self.tableView footerEndRefreshing];
                }
                
                if (listArr.postInfoList.count > 0)
                {
                    currentPage ++;
                    [self.dataList addObjectsFromArray:listArr.postInfoList];
                    [self.tableView reloadData];
                    if ([self.jumpType integerValue] == 1)
                    {
                        if (self.flagGroup)
                        {
                            [QWGLOBALMANAGER statisticsEventId:@"商家圈_帖子列表" withLable:@"圈子" withParams:nil];
                        }else
                        {
                            [QWGLOBALMANAGER statisticsEventId:@"公共圈_帖子列表" withLable:@"圈子" withParams:nil];
                        }
                    }
                }else
                {
                    if (currentPage == 1)
                    {
                        [self showInfoView:@"暂无相关帖子" image:@"ic_img_fail"];
                    }
                }
                
            }else
            {
                [SVProgressHUD showErrorWithStatus:listArr.apiMessage];
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
}

#pragma mark ---- 圈子详情无数据提示 ----
- (void)noDataView
{
    if (self.flagGroup)
    {
        //商家圈
        [self showInfoView:@"还没有帖子\n\n赶快去发一个吧~" image:@"img_common_two"];
    }else
    {
        //公共圈
        if ([self.sliderTabIndex integerValue] == 2)
        {
            //专家帖
            //[self showInfoView:@"还没有专家发帖\n\n敬请期待吧~" image:@"img_common_two"];
            [self showInfoView:@"还没有帖子\n\n赶快去发一个吧~" image:@"img_common_two"];
        }else
        {
            [self showInfoView:@"还没有帖子\n\n赶快去发一个吧~" image:@"img_common_two"];
        }
    }
}

#pragma mark ---- 点击头像进入专栏 ----
- (void)tapHeader:(NSIndexPath *)indexPath
{
    TopicListModel *model = self.dataList[indexPath.row];

    //当前登陆用户 不可点击
    if ([model.posterId isEqualToString:QWGLOBALMANAGER.configure.expertPassportId]) {
        return;
    }
    
    if (model.flagAnon) {
        return;
    }
    
    if (model.posterType == 3 || model.posterType == 4)
    {
        //专家
        ExpertPageViewController *vc = [[UIStoryboard storyboardWithName:@"ExpertPage" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertPageViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.posterId = model.posterId;
        vc.expertType = model.posterType;
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        //普通用户
        UserPageViewController *vc = [[UIStoryboard storyboardWithName:@"UserPage" bundle:nil] instantiateViewControllerWithIdentifier:@"UserPageViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.mbrId = model.posterId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
