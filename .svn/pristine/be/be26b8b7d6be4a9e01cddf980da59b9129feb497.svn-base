//
//  InterlocutionListViewController.m
//  wenYao-store
//  问答List
//  Created by 李坚 on 16/3/4.
//  Copyright © 2016年 carret. All rights reserved.
//

/*
    问答列表
 
    h5/imConsult/queryQAList    已关闭
    h5/imConsult/ignore         专家忽略
    h5/imConsult/race           我来抢答
    h5/imConsult/checkCanRace   判断是否可以抢答
 */

#import "InterlocutionListViewController.h"
#import "ExpertXPMessageCenter.h"
#import "ExpertXPChatViewController.h"
#import "UserChat.h"
#import "UserChatModel.h"
#import "AskingMedicineTableViewCell.h"
#import "CloseMedicineTableViewCell.h"
#import "ExpertXPMessageCenter.h"
#import "InterLocutionWaitingCell.h"
#import "InterLocutionAnswerCell.h"

@interface InterlocutionListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *waitingList;   //待抢答
@property (strong, nonatomic) NSMutableArray *answerList;    //解答中
@property (strong, nonatomic) NSMutableArray *closedList;    //已关闭

@end

@implementation InterlocutionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentPage = 2;
    
    self.waitingList = [NSMutableArray array];
    self.answerList = [NSMutableArray array];
    self.closedList = [NSMutableArray array];
    
    [self setUpTableView];
    
    //已关闭设置分页加载
    if (self.VCStatus == Enum_Closed){
        [self setUpFooterRefresh];
    }
    
    //全量拉取所有专家咨询消息
    [QWGLOBALMANAGER getAllExpertConsult];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    QWGLOBALMANAGER.vcInterlocutionList = self;
}

- (void)viewDidCurrentView
{
    QWGLOBALMANAGER.vcInterlocutionList = self;
    
    if (self.VCStatus == Enum_Waiting)
    {
        [QWGLOBALMANAGER statisticsEventId:@"问答_待抢答页面_出现" withLable:@"圈子" withParams:nil];
        
    }else if (self.VCStatus == Enum_Answering)
    {
        [QWGLOBALMANAGER statisticsEventId:@"问答_解答中页面_出现" withLable:@"圈子" withParams:nil];
        
    }else if (self.VCStatus == Enum_Closed)
    {
        [QWGLOBALMANAGER statisticsEventId:@"问答_已关闭页面_出现" withLable:@"圈子" withParams:nil];
    }    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    QWGLOBALMANAGER.vcInterlocutionList = nil;
}

#pragma mark ---- 设置tableView ----
- (void)setUpTableView
{
    if(!self.tableView)
    {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, APP_W, APP_H - NAV_H - TAB_H - 39)];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.backgroundColor = RGBHex(qwColor11);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.tableView];
        
        //下拉刷新
        [self enableSimpleRefresh:self.tableView block:^(SRRefreshView *sender) {
            if(QWGLOBALMANAGER.currentNetWork == NotReachable){
                [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试" duration:0.8f];
                return;
            }
            [QWGLOBALMANAGER getAllExpertConsult];
            
            if (_VCStatus == Enum_Waiting)
            {
                //待抢答隐藏小红点
                QWGLOBALMANAGER.configure.hadWaitingMessage = NO;
                [QWGLOBALMANAGER saveAppConfigure];
                [QWGLOBALMANAGER checkInterlocutionRedPoint];
            }
        }];
    }
}

#pragma mark ---- 已关闭分页加载 ----
- (void)setUpFooterRefresh
{
    __weak typeof (self) weakSelf = self;
    [self.self.tableView addFooterWithCallback:^{
        
        [weakSelf.self.tableView footerEndRefreshing];
        if(QWGLOBALMANAGER.currentNetWork == NotReachable){
            [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试" duration:0.8f];
            return;
        }
        
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
        setting[@"func"] = @"4";
        setting[@"page"] = [NSString stringWithFormat:@"%d",self.currentPage];
        setting[@"pageSize"] = @"20";
        
        //分页加载
        __block NSNumber *headerRefresh;
        headerRefresh = [NSNumber numberWithBool:NO];
        
        [UserChat ImConsultQueryQAListWithParams:setting success:^(id obj) {
            InterlocutionPageModel *page = [InterlocutionPageModel parse:obj Elements:[InterlocutionListModel class] forAttribute:@"list"];
            [QWGLOBALMANAGER postNotif:NotiRefreshExpertClosed data:page.list object:headerRefresh];
        } failure:^(HttpException *e) {
            
        }];
    }];

    self.self.tableView.footerPullToRefreshText = @"下拉刷新了";
    self.self.tableView.footerReleaseToRefreshText = @"松开刷新了";
    self.self.tableView.footerRefreshingText = @"正在刷新中";
}

#pragma mark ---- 忽略 ----
- (void)ignoreQuestion:(UIButton *)sender
{
    InterlocutionListModel *model = self.waitingList[sender.tag];
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"consultId"] = StrFromObj(model.consultId);
    
    [UserChat ImConsultIgnoreWithParams:setting success:^(id obj) {
        
        BaseAPIModel *mod = [BaseAPIModel parse:obj];
        if([mod.apiStatus integerValue] == 0)
        {
            [self.waitingList removeObject:model];
            [self.self.tableView reloadData];
        }else
        {
            //失败后刷新数据
            [SVProgressHUD showErrorWithStatus:mod.apiMessage duration:0.8f];
            [QWGLOBALMANAGER getAllWaitingConsultData];
        }
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ---- 我来回答 ----
- (void)answerQuestion:(UIButton *)sender
{
    InterlocutionListModel *model = self.waitingList[sender.tag];
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"consultId"] = StrFromObj(model.consultId);
    setting[@"expertPlatform"] = @"1";
    
    [UserChat ImConsultRaceWithParams:setting success:^(id obj) {
        
        BaseAPIModel *mod = [BaseAPIModel parse:obj];
        if([mod.apiStatus integerValue] == 0)
        {
            ExpertXPChatViewController *vcOther = nil;
            vcOther = [[UIStoryboard storyboardWithName:@"ExpertXPChatViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ExpertXPChatViewController"];
            vcOther.hidesBottomBarWhenPushed = YES;
            vcOther.chatType=IMTypeXPStore;
            vcOther.mustAnswer = YES;
            vcOther.branchId=StrFromObj(model.consultId);
            vcOther.messageSender = StrFromObj(model.consultId);
            vcOther.interlocutiondetailModel = model;
            vcOther.showType = MessageShowTypeAnswer;
            [self.navController pushViewController:vcOther animated:YES];
            [self.waitingList removeObject:model];
        }else
        {
            //失败后刷新数据
            [SVProgressHUD showErrorWithStatus:mod.apiMessage duration:0.8f];
            [QWGLOBALMANAGER getAllWaitingConsultData];
        }
        [self.self.tableView reloadData];
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ---- UITableViewDelegate ----
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_VCStatus) {
        case Enum_Waiting://待解答
        {
            return 140;
        }
            break;
        case Enum_Answering://解答中
        {
            return 93;
        }
            break;
        case Enum_Closed://已关闭
        {
            return 93;
        }
            break;
        default:{
            return 0.0f;
        }
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (_VCStatus) {
        case Enum_Waiting://待解答
        {
            return self.waitingList.count;
        }
            break;
        case Enum_Answering://解答中
        {
            return self.answerList.count;
        }
            break;
        case Enum_Closed://已关闭
        {
            return self.closedList.count;
        }
            break;
        default:{
            return 0;
        }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (_VCStatus)
    {
        case Enum_Waiting:
        {
            //待抢答
            static NSString *MessageShowTypeAnswerCellIdentfier = @"MessageShowTypeAnswerCellIdentifier";
            cell = [tableView dequeueReusableCellWithIdentifier:MessageShowTypeAnswerCellIdentfier];
            if(cell == nil) {
                UINib *nib = [UINib nibWithNibName:@"InterLocutionWaitingCell" bundle:nil];
                [tableView registerNib:nib forCellReuseIdentifier:MessageShowTypeAnswerCellIdentfier];
                cell = [tableView dequeueReusableCellWithIdentifier:MessageShowTypeAnswerCellIdentfier];
            }
            
            InterlocutionListModel *model = self.waitingList[indexPath.row];
            InterLocutionWaitingCell *consultCell = (InterLocutionWaitingCell *)cell;
            [consultCell setCell:model];
            consultCell.answerButton.tag = indexPath.row;
            [consultCell.answerButton addTarget:self action:@selector(answerQuestion:) forControlEvents:UIControlEventTouchDown];
            consultCell.ignoreButton.tag = indexPath.row;
            [consultCell.ignoreButton addTarget:self action:@selector(ignoreQuestion:) forControlEvents:UIControlEventTouchDown];
            break;
        }
            
        case Enum_Answering:
        case Enum_Closed:
        {
            static NSString *MessageShowTypeCloseCellIdentfier = @"MessageShowTypeCloseCellIdentifier";
            cell = [tableView dequeueReusableCellWithIdentifier:MessageShowTypeCloseCellIdentfier];
            if(cell == nil) {
                UINib *nib = [UINib nibWithNibName:@"InterLocutionAnswerCell" bundle:nil];
                [tableView registerNib:nib forCellReuseIdentifier:MessageShowTypeCloseCellIdentfier];
                cell = [tableView dequeueReusableCellWithIdentifier:MessageShowTypeCloseCellIdentfier];
            }
            InterLocutionAnswerCell *aCell = (InterLocutionAnswerCell *)cell;
            InterlocutionListModel *model = nil;
            
            if(_VCStatus == Enum_Answering)
            {
                //解答中
                model = self.answerList[indexPath.row];
                QWMessage *qwmsg=[ExpertXPMessageCenter checkMessageStateByID:model.consultId];
                [aCell setCell:model type:1];
                [aCell setCell:model status:qwmsg.issend.intValue body:qwmsg.body];
                aCell.closeStatus.hidden = YES;
                
            }else if(_VCStatus == Enum_Closed)
            {
                //已关闭
                model = self.closedList[indexPath.row];
                [aCell setCell:model type:2];
                aCell.closeStatus.hidden = NO;
                aCell.failureStatus.hidden = YES;
            }
            break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    InterlocutionListModel *model = nil;
    ExpertXPChatViewController *vcOther = [[UIStoryboard storyboardWithName:@"ExpertXPChatViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ExpertXPChatViewController"];
    switch (_VCStatus)
    {
        case Enum_Waiting:
        {
            //待抢答
            [QWGLOBALMANAGER statisticsEventId:@"问答_待抢答页面_列表点击" withLable:@"圈子" withParams:nil];
            model = self.waitingList[indexPath.row];
            vcOther.showType = MessageShowTypeAsking;
            break;
        }
        case Enum_Answering:
        {
            //解答中
            [QWGLOBALMANAGER statisticsEventId:@"问答_解答中页面_列表点击" withLable:@"圈子" withParams:nil];
            model = self.answerList[indexPath.row];
            vcOther.showType = MessageShowTypeAnswer;
            break;
        }
        case Enum_Closed:
        {
            //已关闭
            [QWGLOBALMANAGER statisticsEventId:@"问答_已关闭页面_列表点击" withLable:@"圈子" withParams:nil];
            model = self.closedList[indexPath.row];
            vcOther.showType = MessageShowTypeClose;
            break;
        }
        default:
            break;
    }
    
    vcOther.hidesBottomBarWhenPushed = YES;
    vcOther.chatType = IMTypeXPStore;
    vcOther.branchId = StrFromObj(model.consultId);
    vcOther.interlocutiondetailModel = model;
    vcOther.messageSender = StrFromObj(model.consultId);
    
    if(_VCStatus == Enum_Waiting)
    {
        //待抢答
        NSMutableDictionary *setting =[NSMutableDictionary dictionary];
        setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
        setting[@"consultId"] = model.consultId;
        
        [UserChat ImConsultCheckCanRaceWithParams:setting success:^(id obj) {
            
            BaseAPIModel *mod = [BaseAPIModel parse:obj];
            if ([mod.apiStatus integerValue] == 0)
            {
                //进入聊天详情页面
                vcOther.hidesBottomBarWhenPushed = YES;
                vcOther.interlocutiondetailModel = model;
                [self.navController pushViewController:vcOther animated:YES];
            }else
            {
                //抢答失败，刷新数据
                [QWGLOBALMANAGER getAllWaitingConsultData];
                [SVProgressHUD showErrorWithStatus:mod.apiMessage];
            }
        } failure:^(HttpException *e) {
            
        }];
        
    }else
    {
        [self.navController pushViewController:vcOther animated:YES];
        //设置未读数
        model.unRead = NO;
        [InterlocutionListModel updateObjToDB:model WithKey:[NSString stringWithFormat:@"%@",model.consultId]];
    }
}

- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    NSArray *array = (NSArray *)data;

    //刷新待抢答问答
    if (_VCStatus == Enum_Waiting && type == NotiRefreshExpertWaiting)
    {
        [self.waitingList removeAllObjects];
        [self.waitingList addObjectsFromArray:array];
        [self.tableView reloadData];
        [self endHeaderRefresh];
    }
    
    //刷新解答中问答
    if (_VCStatus == Enum_Answering && type == NotiRefreshExpertAnswering)
    {
        [self endHeaderRefresh];
        [self.answerList removeAllObjects];
        self.answerList = [NSMutableArray arrayWithArray:array];
        //需要刷新当前的解答中问题列表
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
    
    //刷新已关闭问答
    if(_VCStatus == Enum_Closed && type == NotiRefreshExpertClosed)
    {
        [self endHeaderRefresh];
        NSNumber *headRefrsh = (NSNumber *)obj;
        if([headRefrsh boolValue])
        {
            //下拉刷新
            [self.closedList removeAllObjects];
            self.closedList = [NSMutableArray arrayWithArray:array];
            [self.tableView reloadData];
        }else
        {
            //分页加载
            if (array.count > 0)
            {
                self.currentPage ++;
                [self.closedList addObjectsFromArray:array];
                [self.tableView reloadData];
            }
        }
    }else if (type == NotiChangeCurrentPage)
    {
        //已关闭下拉刷新，更改当前页
        self.currentPage = 2;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
