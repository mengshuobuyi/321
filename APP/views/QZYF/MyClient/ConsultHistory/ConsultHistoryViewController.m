//
//  ConsultHistoryViewController.m
//  wenYao-store
//
//  Created by qwfy0006 on 15/5/6.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "ConsultHistoryViewController.h"
#import "ConsultHistoryCell.h"
#import "Consult.h"
#import "ConsultModel.h"
#import "SVProgressHUD.h"

#import "XPChatViewController.h"

@interface ConsultHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *dataList;
@property (assign, nonatomic) int page;

@end

@implementation ConsultHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"咨询历史";
    self.view.backgroundColor = RGBHex(qwColor11);
    self.dataList = [NSMutableArray array];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    self.tableview.headerPullToRefreshText = @"下拉刷新";
//    self.tableview.headerReleaseToRefreshText = @"松开刷新";
//    self.tableview.headerRefreshingText = @"正在刷新";
    __weak ConsultHistoryViewController *weakSelf = self;
    
//    [self.tableview addHeaderWithCallback:^{
//        if (QWGLOBALMANAGER.currentNetWork != kNotReachable) {
//            [weakSelf queryData];
//        }else
//        {
//            [SVProgressHUD showErrorWithStatus:@"网络未连接，请重试！" duration:0.8];
//        }
//        [weakSelf.tableview headerEndRefreshing];
//    }];
    
    [self enableSimpleRefresh:self.tableview block:^(SRRefreshView *sender) {
        if (QWGLOBALMANAGER.currentNetWork != kNotReachable) {
            [weakSelf queryData];
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"网络未连接，请重试！" duration:0.8];
        }
    }];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring12 image:@"img_network"];
        return;
    }else
    {
        [self queryData];
    }
}

- (void)queryData
{
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
    setting[@"passportId"] = StrFromObj(self.passport);
    
    [Consult CustomerQueryConsultListWithParam:setting success:^(id obj) {
        
        ConsultHistoryPage *page = (ConsultHistoryPage *)obj;
        if ([page.apiStatus integerValue] == 0) {
            
            if (page.list == nil || page.list.count == 0) {
                [self showInfoView:@"您还没有咨询历史" image:@"ic_img_fail"];
            }else
            {
                self.dataList = [NSMutableArray arrayWithArray:page.list];
                [self.tableview reloadData];
            }
        }
    } failure:^(HttpException *e) {
        if(e.errorCode!=-999){
            if(e.errorCode == -1001){
                [self showInfoView:kWarning215N54 image:@"ic_img_fail"];
            }else{
                [self showInfoView:kWarning215N0 image:@"ic_img_fail"];
            }
        }
    }];
}

#pragma mark ---- 列表代理 ----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 93;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConsultHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConsultHistoryCell"];
    
    ConsultHistoryModel *model = self.dataList[indexPath.row];
    model.customerPassport = self.passport;
    [cell setCell:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ConsultHistoryModel *model = self.dataList[indexPath.row];
    
    XPChatViewController *demoWeChatMessageTableViewController = [[UIStoryboard storyboardWithName:@"XPChatViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"XPChatViewController"];
    
    demoWeChatMessageTableViewController.hidesBottomBarWhenPushed = YES;
    
    if ([model.consultStatus integerValue] == 2 ) {
         demoWeChatMessageTableViewController.showType = MessageShowTypeAnswer;
    }else if ([model.consultStatus integerValue] == 4){
        demoWeChatMessageTableViewController.showType = MessageShowTypeClose;
        
    }
    demoWeChatMessageTableViewController.messageSender = [NSString stringWithFormat:@"%@",model.consultId];
    ConsultConsultingModel *consultConsultingModel = [ConsultConsultingModel new];
    consultConsultingModel.customerPassport = model.customerPassport;
    consultConsultingModel.customerAvatarUrl = model.customerAvatarUrl;
    consultConsultingModel.consultId = model.consultId;
    demoWeChatMessageTableViewController.consultingModel = consultConsultingModel;
    demoWeChatMessageTableViewController.chatType = IMTypeXPStore;
    [self.navigationController pushViewController:demoWeChatMessageTableViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
