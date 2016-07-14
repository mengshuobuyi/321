//
//  MyCollectionTopicViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/7.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "MyCollectionTopicViewController.h"
#import "Circle.h"
#import "CircleModel.h"
#import "MGSwipeButton.h"
#import "ExpertPageViewController.h"
#import "UserPageViewController.h"
#import "PostDetailViewController.h"
#import "HotCircleCell.h"

@interface MyCollectionTopicViewController ()<UITableViewDataSource,UITableViewDelegate,MGSwipeTableCellDelegate,HotCircleCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataList;

@end

@implementation MyCollectionTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我收藏的帖子";
    self.dataList = [NSMutableArray array];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 7)];
    vv.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = vv;
    [self enableSimpleRefresh:self.tableView block:^(SRRefreshView *sender) {
        HttpClientMgr.progressEnabled = NO;
        [self queryMyCollectionList];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self queryMyCollectionList];
}

#pragma mark ---- 请求收藏数据 ----
- (void)queryMyCollectionList
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"currPage"] = @"1";
    setting[@"pageSize"] = @"1000";
    [Circle TeamGetCollectionPostWithParams:setting success:^(id obj) {
        
        [self removeInfoView];
        [self.dataList removeAllObjects];
        TopicListArrayModel *listArr = [TopicListArrayModel parse:obj Elements:[TopicListModel class] forAttribute:@"postInfoList"];
        if ([listArr.apiStatus integerValue] == 0) {
            [self.dataList addObjectsFromArray:listArr.postInfoList];
            if (self.dataList.count > 0) {
                [self.tableView reloadData];
            }else{
                [self showInfoView:@"您还没有收藏的帖子" image:@"ic_img_fail"];
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

#pragma mark ---- 列表代理 ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HotCircleCell getCellHeight:self.dataList[indexPath.row]];
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
    cell.swipeDelegate = self;
    cell.topView.obj = indexPath;
    cell.hotCircleCellDelegate = self;
    [cell myCollectionTopic:self.dataList[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //进入帖子详情
    PostDetailViewController* postDetailVC = [[UIStoryboard storyboardWithName:@"Forum" bundle:nil] instantiateViewControllerWithIdentifier:@"PostDetailViewController"];
    TopicListModel* topic = self.dataList[indexPath.row];
    postDetailVC.postId = topic.postId;
    postDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:postDetailVC animated:YES];
}

#pragma mark ---- MGSwipeTableCellDelegate ----

-(NSArray*) swipeTableCell:(MGSwipeTableCell*)cell
  swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*)swipeSettings
         expansionSettings:(MGSwipeExpansionSettings*)expansionSettings;
{
    if (direction == MGSwipeDirectionRightToLeft) {
        return [self createRightButtons:1];
    }
    return nil;
}

-(BOOL) swipeTableCell:(MGSwipeTableCell*)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion
{
    NSIndexPath *indexPath = nil;
    if (index == 0) {
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
            return NO;
        }
        indexPath = [self.tableView indexPathForCell:cell];
        
        //调接口 取消收藏 刷新列表
        [self cancleCollection:indexPath];
        
    }
    return YES;
}

-(NSArray *) createRightButtons: (int) number
{
    NSMutableArray * result = [NSMutableArray array];
    NSString* titles[1] = {@"删除"};
    UIColor * colors[1] = {RGBHex(qwColor3)};
    for (int i = 0; i < number; ++i)
    {
        MGSwipeButton * button = [MGSwipeButton buttonWithTitle:titles[i] backgroundColor:colors[i] callback:^BOOL(MGSwipeTableCell * sender){
            return YES;
        }];
        [result addObject:button];
    }
    return result;
}

#pragma mark ---- 取消收藏接口 ----
- (void)cancleCollection:(NSIndexPath *)indexPath
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    TopicListModel *model = self.dataList[indexPath.row];
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"objID"] = StrFromObj(model.postId);
    [Circle H5CancelCollectionPostWithParams:setting success:^(id obj) {
        BaseAPIModel *model = [BaseAPIModel parse:obj];
        if ([model.apiStatus integerValue] == 0) {
            [self queryMyCollectionList];
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:model.apiMessage];
        }
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ---- 点击头像进入专栏 ----
- (void)tapHeadericon:(NSIndexPath *)indexpath
{
    TopicListModel *model = self.dataList[indexpath.row];
    
    //如果是当前登陆账号，不可点击
    if ([model.posterId isEqualToString:QWGLOBALMANAGER.configure.expertPassportId]) {
        return;
    }
    
    if (model.flagAnon) {
        return;
    }
    
    if (model.posterType == 3 || model.posterType == 4) {
        ExpertPageViewController *vc = [[UIStoryboard storyboardWithName:@"ExpertPage" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertPageViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.posterId = model.posterId;
        vc.expertType = model.posterType;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
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
