//
//  ExpertSystemInfoViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/7.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ExpertSystemInfoViewController.h"
#import "SystemDelCommentCell.h"
#import "SystemAccountCell.h"
#import "SystemCircleMasterCell.h"
#import "SystemGeneralCell.h"
#import "Circle.h"
#import "CircleModel.h"
#import "MGSwipeButton.h"
#import "UploadRegCardViewController.h"
#import "PostDetailViewController.h"
#import "CircleDetailViewController.h"
#import "MyBrandViewController.h"

@interface ExpertSystemInfoViewController ()<UITableViewDataSource,UITableViewDelegate,MGSwipeTableCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataList;

@end

@implementation ExpertSystemInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataList = [NSMutableArray array];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidCurrentView
{
    [self markMessageRead];
    [self queryList];
    QWGLOBALMANAGER.configure.expertSystemInfoRed = NO;
    [QWGLOBALMANAGER saveAppConfigure];
}

#pragma mark ---- 设置系统消息为已读 ----
- (void)markMessageRead
{
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"readFlag"] = @"Y";
    setting[@"msgClass"] = @"99";
    [Circle TeamChangeMsgReadFlagByMsgClassWithParams:setting success:^(id obj) {
        
    } failure:^(HttpException *e) {
        
    }];
}

- (void)viewInfoClickAction:(id)sender
{
    [self removeInfoView];
    [self queryList];
}

#pragma mark ---- 获取系统消息的数据 ----
- (void)queryList
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"msgClass"] = @"99";
    [Circle TeamMessageWithParams:setting success:^(id obj) {
        
        TeamMessagePageModel *page = [TeamMessagePageModel parse:obj Elements:[TeamMessageModel class] forAttribute:@"msglist"];
        
        [self markMessageRead];
        QWGLOBALMANAGER.configure.expertSystemInfoRed = NO;
        [QWGLOBALMANAGER saveAppConfigure];
        [QWGLOBALMANAGER postNotif:NotifHiddenSystemInfoRedPoint data:nil object:nil];
        
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
    TeamMessageModel *model = self.dataList[indexPath.section];
    if (model.msgType == 9)
    {
        //帐号安全，点击上传
        return [SystemAccountCell getCellHeight:model];
        
    }else if (model.msgType == 11 || model.msgType == 15)
    {
        //圈子审核通过，点击进入圈子
        return [SystemCircleMasterCell getCellHeight:model];
        
    }else if (model.msgType == 7 || model.msgType == 8 || model.msgType == 20)
    {
        //举报，删除评论 点击进入帖子
        return [SystemDelCommentCell getCellHeight:model];
    }else
    {
        //其他，展示
        return [SystemGeneralCell getCellHeight:model];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SystemAccountCell *accountCell = [tableView dequeueReusableCellWithIdentifier:@"SystemAccountCell"];
    SystemCircleMasterCell *circleCell = [tableView dequeueReusableCellWithIdentifier:@"SystemCircleMasterCell"];
    SystemDelCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"SystemDelCommentCell"];
    SystemGeneralCell *generalCell = [tableView dequeueReusableCellWithIdentifier:@"SystemGeneralCell"];

    TeamMessageModel *model = self.dataList[indexPath.section];
    
    if (model.msgType == 9)
    {
        //帐号安全，点击上传
        [accountCell setCell:model];
        accountCell.swipeDelegate = self;
        accountCell.uploadButton.obj = indexPath;
        [accountCell.uploadButton addTarget:self action:@selector(uploadRegisterCard:) forControlEvents:UIControlEventTouchUpInside];
        return accountCell;
        
    }else if (model.msgType == 11 || model.msgType == 15)
    {
        //圈子审核通过，圈子上线，点击进入圈子
        [circleCell setCell:model];
        circleCell.swipeDelegate = self;
        
        circleCell.circleName.obj = indexPath;
        circleCell.circleName.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpCircleDetail:)];
        [circleCell.circleName addGestureRecognizer:tap];
        return circleCell;
        
    }else if (model.msgType == 7 || model.msgType == 8 || model.msgType == 20)
    {
        //举报，删除评论，帖子恢复 点击进入帖子
        [commentCell setCell:model];
        commentCell.swipeDelegate = self;
        
        commentCell.topicBgView.obj = indexPath;
        commentCell.topicBgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpTopicDetail:)];
        [commentCell.topicBgView addGestureRecognizer:tap];
        return commentCell;
    }else
    {
        //其他，展示
        [generalCell setCell:model];
        generalCell.swipeDelegate = self;
        return generalCell;
    }

    return accountCell;
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

- (NSArray *)createRightButtons:(int) number
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

#pragma mark ----- 帐号安全，点击上传 ----
- (void)uploadRegisterCard:(id)sender
{
    QWButton *btn = (QWButton *)sender;
    NSIndexPath *indexPath = (NSIndexPath *)btn.obj;
    TeamMessageModel *model = self.dataList[indexPath.section];
    
    MyBrandViewController *vc = [[UIStoryboard storyboardWithName:@"MyInfomation" bundle:nil] instantiateViewControllerWithIdentifier:@"MyBrandViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    //1药师  2营养师
    NSString *expertType = @"";
    if (model.sourceOwnerType == 3){
        expertType = @"1";
    }else if (model.sourceOwnerType == 4){
        expertType = @"2";
    }
    vc.expertType = expertType;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---- 进入帖子详情 ----
- (void)jumpTopicDetail:(UITapGestureRecognizer *)tap
{
    QWView *view = (QWView *)tap.view;
    NSIndexPath *indexPath = (NSIndexPath *)view.obj;
    TeamMessageModel *model = self.dataList[indexPath.section];
    
    PostDetailViewController* postDetailVC = [[UIStoryboard storyboardWithName:@"Forum" bundle:nil] instantiateViewControllerWithIdentifier:@"PostDetailViewController"];
    postDetailVC.postId = model.sourceId;
    postDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:postDetailVC animated:YES];
}

#pragma mark ---- 进入圈子详情 ----
- (void)jumpCircleDetail:(UITapGestureRecognizer *)tap
{
    QWLabel *view = (QWLabel *)tap.view;
    NSIndexPath *indexPath = (NSIndexPath *)view.obj;
    TeamMessageModel *model = [TeamMessageModel new];
    model = self.dataList[indexPath.section];
    CircleDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Circle" bundle:nil] instantiateViewControllerWithIdentifier:@"CircleDetailViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.teamId = model.sourceId;
    vc.title = [NSString stringWithFormat:@"%@圈",model.sourceTitle];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
