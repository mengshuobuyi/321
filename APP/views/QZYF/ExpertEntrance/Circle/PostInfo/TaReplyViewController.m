//
//  TaReplyViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/15.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "TaReplyViewController.h"
#import "Circle.h"
#import "CircleModel.h"
#import "MyBackTopicCell.h"
#import "PostDetailViewController.h"

@interface TaReplyViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger currentPage;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *dataList;

@end

@implementation TaReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataList = [NSMutableArray array];
    [self setUpTableView];
}

#pragma mark ---- 设置tableView ----
- (void)setUpTableView
{
    self.tableview.tableFooterView = [[UIView alloc] init];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.scrollEnabled = YES;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor clearColor];
    
    [self.tableview addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableview.footerPullToRefreshText = kWaring6;
    self.tableview.footerReleaseToRefreshText = kWaring7;
    self.tableview.footerRefreshingText = kWaring9;
    self.tableview.footerNoDataText = @"已显示全部内容";
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(expertDidScrollToTop:)]) {
        [self.delegate expertDidScrollToTop:self];
    }
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
    static NSString *circleDetailCell = @"tareplyCell";
    MyBackTopicCell *cell = (MyBackTopicCell *)[tableView dequeueReusableCellWithIdentifier:circleDetailCell];
    if(cell == nil){
        UINib *nib = [UINib nibWithNibName:@"MyBackTopicCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:circleDetailCell];
        cell = (MyBackTopicCell *)[tableView dequeueReusableCellWithIdentifier:circleDetailCell];
    }
    
    [cell setCellData:self.dataList[indexPath.section] type:2];
    cell.topicBgView.tag = indexPath.section+1;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTopicAction:)];
    [cell.topicBgView addGestureRecognizer:tap];
    return cell;
}

#pragma mark ---- HeaderRefresh ----
- (void)currentViewSelected:(void (^)(CGFloat))finishLoading
{
    //他的回帖列表
    currentPage = 1;
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"userId"] = StrFromObj(self.expertId);
    setting[@"page"] = [NSString stringWithFormat:@"%ld",(long)currentPage];
    setting[@"pageSize"] = @"10";
    [HttpClientMgr setProgressEnabled:NO];
    [Circle TeamHisReplyListWithParams:setting success:^(id obj) {
        
        [self removeInfoView];
        [self.dataList removeAllObjects];
        CircleReplayPageModel *page = [CircleReplayPageModel parse:obj Elements:[CircleReplayListModel class] forAttribute:@"postReplyList"];
        if ([page.apiStatus integerValue] == 0) {
            
            [self.dataList addObjectsFromArray:page.postReplyList];
            
            if (self.dataList.count > 0) {
                currentPage ++;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableview reloadData];
                });
            }else{
                [self showInfoView:@"暂无相关帖子" image:@"ic_img_fail"];
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

- (void)footerRereshing
{
    if(self.dataList.count == 0) {
        [self showInfoView:@"暂无相关帖子" image:@"ic_img_fail"];
        return;
    }
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"userId"] = StrFromObj(self.expertId);
    setting[@"page"] = [NSString stringWithFormat:@"%ld",(long)currentPage];
    setting[@"pageSize"] = @"10";
    [HttpClientMgr setProgressEnabled:NO];
    
    [Circle TeamHisReplyListWithParams:setting success:^(id obj) {
        
        [self removeInfoView];
        [self.tableview footerEndRefreshing];
        CircleReplayPageModel *listArr = [CircleReplayPageModel parse:obj Elements:[CircleReplayListModel class] forAttribute:@"postReplyList"];
        if ([listArr.apiStatus integerValue] == 0) {
            
            
            if (listArr.postReplyList.count == 0) {
                [self.tableview.footer setCanLoadMore:NO];
                [self.tableview footerEndRefreshing];
            }
            if (listArr.postReplyList.count > 0) {
                currentPage ++;
                [self.dataList addObjectsFromArray:listArr.postReplyList];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableview reloadData];
                });
                
            }else{
                
                if (currentPage == 1) {
                    [self showInfoView:@"暂无相关帖子" image:@"ic_img_fail"];
                }
            }
            
        }else{
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


#pragma mark ---- 点击帖子标题进入帖子详情 ----
- (void)tapTopicAction:(UITapGestureRecognizer *)tap
{
    UIView *vi = tap.view;
    int row = vi.tag - 1;
    
     [QWGLOBALMANAGER statisticsEventId:@"专栏_Ta的回帖原帖标题" withLable:@"圈子" withParams:nil];
    
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
