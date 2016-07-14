//
//  MyPostTopicViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/4.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "MyPostTopicViewController.h"
#import "Circle.h"
#import "CircleModel.h"
#import "MGSwipeButton.h"
#import "Circle.h"
#import "PostDetailViewController.h"
#import "HotCircleCell.h"

@interface MyPostTopicViewController ()<UITableViewDataSource,UITableViewDelegate,MGSwipeTableCellDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end

@implementation MyPostTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的发帖";
    self.indexPath = [[NSIndexPath alloc] init];
    self.dataList = [NSMutableArray array];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 7)];
    vv.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = vv;
    
    
    //下拉刷新
    __weak MyPostTopicViewController *weakSelf = self;
    [self enableSimpleRefresh:self.tableView block:^(SRRefreshView *sender) {
        if (QWGLOBALMANAGER.currentNetWork != kNotReachable) {
            HttpClientMgr.progressEnabled = NO;
            [weakSelf queryList];
        }else{
            [SVProgressHUD showErrorWithStatus:@"网络未连接，请重试！" duration:0.8];
        }
    }];
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
    setting[@"page"] = @"1";
    setting[@"pageSize"] = @"100000";
    [Circle TeamMyPostListWithParams:setting success:^(id obj) {
        TopicListArrayModel *page = [TopicListArrayModel parse:obj Elements:[TopicListModel class] forAttribute:@"postInfoList"];
        if ([page.apiStatus integerValue] == 0) {
            if (page.postInfoList.count > 0) {
                [self.dataList removeAllObjects];
                [self.dataList addObjectsFromArray:page.postInfoList];
                [self.tableView reloadData];
            }else{
                [self showInfoView:@"您还没有发过帖子" image:@"ic_img_fail"];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HotCircleCell getCellHeight:self.dataList[indexPath.row]]-40-7;
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
    
    [cell myPostTopic:self.dataList[indexPath.row]];
    cell.swipeDelegate = self;
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
        self.indexPath = indexPath;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要删除该帖子吗？一经删除，不可回复哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        [alert show];
        
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    
    if (buttonIndex == 1) {
        //删除
        
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [SVProgressHUD showErrorWithStatus:kWaring33];
            return;
        }
        
        TopicListModel *model = self.dataList[self.indexPath.row];
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
        setting[@"poster"] = StrFromObj(model.posterId);
        setting[@"postId"] = StrFromObj(model.postId);
        setting[@"postTitle"] = StrFromObj(model.postTitle);
        setting[@"teamId"] = StrFromObj(model.teamId);
        
        [Circle TeamDelPostInfoWithParams:setting success:^(id obj) {
            
            if ([obj[@"apiStatus"] integerValue] == 0) {
                [self queryList];
                [self.tableView reloadData];
            }else{
                [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"]];
            }
            
        } failure:^(HttpException *e) {
            
        }];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
