//
//  ExpertFlowerViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/7.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ExpertFlowerViewController.h"
#import "ExpertFlowerCell.h"
#import "MGSwipeButton.h"
#import "Circle.h"
#import "CircleModel.h"
#import "LookFlowerViewController.h"
#import "PostDetailViewController.h"

@interface ExpertFlowerViewController ()<UITableViewDataSource,UITableViewDelegate,ExpertFlowerCellDelegate,MGSwipeTableCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataList;

@end

@implementation ExpertFlowerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataList = [NSMutableArray array];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //下拉刷新
    __weak ExpertFlowerViewController *weakSelf = self;
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
}

- (void)viewDidCurrentView
{
    //请求鲜花数据
    [self queryList];
    
    //设置鲜花消息为已读
    [self markMessageRead];
    
    QWGLOBALMANAGER.configure.expertFlowerRed = NO;
    [QWGLOBALMANAGER saveAppConfigure];
}

#pragma mark ---- 请求鲜花数据 ----
- (void)queryList
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"msgClass"] = @2;
    
    [Circle TeamMessageWithParams:setting success:^(id obj) {
        
        TeamMessagePageModel *page = [TeamMessagePageModel parse:obj Elements:[TeamMessageModel class] forAttribute:@"msglist"];
        
        [self markMessageRead];
        QWGLOBALMANAGER.configure.expertFlowerRed = NO;
        [QWGLOBALMANAGER saveAppConfigure];
        [QWGLOBALMANAGER postNotif:NotifHiddenFlowerRedPoint data:nil object:nil];

        if ([page.apiStatus integerValue] == 0)
        {
            if (page.msglist.count > 0)
            {
                [self.dataList removeAllObjects];
                [self.dataList addObjectsFromArray:page.msglist];
                [self.tableView reloadData];
            }else
            {
                [self showInfoView:@"您还没有消息" image:@"ic_img_fail"];
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

- (void)viewInfoClickAction:(id)sender
{
    [self removeInfoView];
    [self queryList];
}

#pragma mark ---- 设置鲜花消息为已读 ----
- (void)markMessageRead
{
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"readFlag"] = @"Y";
    setting[@"msgClass"] = @"2";
    [Circle TeamChangeMsgReadFlagByMsgClassWithParams:setting success:^(id obj) {
        
    } failure:^(HttpException *e) {
        
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
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 7)];
    vi.backgroundColor = [UIColor clearColor];
    return vi;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ExpertFlowerCell getCellHeight:self.dataList[indexPath.section]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpertFlowerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpertFlowerCell"];
    [cell setCell:self.dataList[indexPath.section]];
    cell.expertFlowerCellDelegate = self;
    cell.swipeDelegate = self;
    
    //查看鲜花
    cell.lookButton.obj = indexPath;
    cell.topicBgView.obj = indexPath;
    cell.topicBgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpCircleDetail:)];
    [cell.topicBgView addGestureRecognizer:tap];
    
    return cell;
}

#pragma mark ---- MGSwipeTableCellDelegate ----
- (NSArray *)swipeTableCell:(MGSwipeTableCell*)cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(MGSwipeSettings*)swipeSettings expansionSettings:(MGSwipeExpansionSettings*)expansionSettings;
{
    if (direction == MGSwipeDirectionRightToLeft) {
        return [self createRightButtons:1];
    }
    return nil;
}

- (BOOL)swipeTableCell:(MGSwipeTableCell*)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion
{
    NSIndexPath *indexPath = nil;
    if (index == 0)
    {
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
            return NO;
        }
        
        indexPath = [self.tableView indexPathForCell:cell];
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [SVProgressHUD showErrorWithStatus:kWaring33];
            return NO;
        }
        
        //接口删除
        TeamMessageModel *model = self.dataList[indexPath.section];
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
        setting[@"showFlag"] = @"N";
        setting[@"msgId"] = StrFromObj(model.id);
        [Circle TeamChangeMessageShowFlagWithParams:setting success:^(id obj) {
            if ([obj[@"apiStatus"] integerValue] == 0)
            {
                [SVProgressHUD showSuccessWithStatus:@"删除成功！"];
                [self queryList];
                [self.tableView reloadData];
            }else
            {
                [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"]];
            }
        } failure:^(HttpException *e) {
            
        }];
    }
    return YES;
}

- (NSArray *)createRightButtons: (int) number
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

#pragma mark ---- 查看鲜花 ----
- (void)lookFlowerInfo:(NSIndexPath *)indexPath;
{
    TeamMessageModel *model = self.dataList[indexPath.section];
    
    LookFlowerViewController *vc = [[UIStoryboard storyboardWithName:@"ExpertInfo" bundle:nil] instantiateViewControllerWithIdentifier:@"LookFlowerViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    if (model.replyId && ![model.replyId isEqualToString:@""]) {
        vc.postId = model.replyId;
    }else{
        vc.postId = model.sourceId;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---- 进入帖子详情 ----
- (void)jumpCircleDetail:(UITapGestureRecognizer *)tap
{
    QWView *view = (QWView *)tap.view;
    NSIndexPath *indexPath = (NSIndexPath *)view.obj;
    TeamMessageModel *model = self.dataList[indexPath.section];
    
    PostDetailViewController* postDetailVC = [[UIStoryboard storyboardWithName:@"Forum" bundle:nil] instantiateViewControllerWithIdentifier:@"PostDetailViewController"];
    postDetailVC.postId = model.sourceId;
    postDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:postDetailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
