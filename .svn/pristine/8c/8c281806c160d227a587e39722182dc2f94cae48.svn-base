//
//  MyBackTopicViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/4.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "MyBackTopicViewController.h"
#import "MyBackTopicCell.h"
#import "Circle.h"
#import "CircleModel.h"
#import "MGSwipeButton.h"
#import "PostDetailViewController.h"

@interface MyBackTopicViewController ()<UITableViewDataSource,UITableViewDelegate,MGSwipeTableCellDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end

@implementation MyBackTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的回帖";
    self.indexPath = [[NSIndexPath alloc] init];
    self.dataList = [NSMutableArray array];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self queryList];
    
    //下拉刷新
    __weak MyBackTopicViewController *weakSelf = self;
    [self enableSimpleRefresh:self.tableView block:^(SRRefreshView *sender) {
        if (QWGLOBALMANAGER.currentNetWork != kNotReachable) {
            HttpClientMgr.progressEnabled = NO;
            [weakSelf queryList];
        }else{
            [SVProgressHUD showErrorWithStatus:@"网络未连接，请重试！" duration:0.8];
        }
    }];
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
    setting[@"pageSize"] = @"10000";
    [Circle TeamMyReplyListWithParams:setting success:^(id obj) {
        
        CircleReplayPageModel *page = [CircleReplayPageModel parse:obj Elements:[CircleReplayListModel class] forAttribute:@"postReplyList"];
        if ([page.apiStatus integerValue] == 0) {
            if (page.postReplyList.count > 0) {
                [self.dataList removeAllObjects];
                [self.dataList addObjectsFromArray:page.postReplyList];
                [self.tableView reloadData];
            }else{
                [self showInfoView:@"您还没有回过帖子" image:@"ic_img_fail"];
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
    static NSString *circleDetailCell = @"myBackTopicCell";
    MyBackTopicCell *cell = (MyBackTopicCell *)[tableView dequeueReusableCellWithIdentifier:circleDetailCell];
    if(cell == nil){
        UINib *nib = [UINib nibWithNibName:@"MyBackTopicCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:circleDetailCell];
        cell = (MyBackTopicCell *)[tableView dequeueReusableCellWithIdentifier:circleDetailCell];
    }
    [cell setCellData:self.dataList[indexPath.section] type:1];
    cell.swipeDelegate = self;
    
    cell.topicBgView.tag = indexPath.section+1;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTopicAction:)];
    [cell.topicBgView addGestureRecognizer:tap];
    return cell;
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要删除该回帖吗？一经删除，不可恢复哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
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
        
        CircleReplayListModel *model = self.dataList[self.indexPath.section];
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
        setting[@"replyID"] = StrFromObj(model.id);
        setting[@"replyerID"] = StrFromObj(model.replier);
        [Circle TeamDelReplyWithParams:setting success:^(id obj) {
            BaseAPIModel *model = [BaseAPIModel parse:obj];
            if ([model.apiStatus integerValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"删除成功！"];
                [self queryList];
                [self.tableView reloadData];
            }else{
                [SVProgressHUD showErrorWithStatus:model.apiMessage];
            }
        } failure:^(HttpException *e) {
        }];
    }
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
