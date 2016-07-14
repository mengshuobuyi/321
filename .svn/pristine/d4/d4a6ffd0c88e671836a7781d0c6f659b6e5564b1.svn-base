//
//  EnterExpertViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/6/16.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "EnterExpertViewController.h"
#import "EnterExpertCell.h"
#import "Circle.h"
#import "CircleModel.h"
#import "ExpertPageViewController.h"
#import "UserPageViewController.h"

@interface EnterExpertViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) IBOutlet UIView *tableFooterView;

@property (strong, nonatomic) NSMutableArray *sectionList;
@property (strong, nonatomic) NSMutableArray *attentionList; //我关注的专家
@property (strong, nonatomic) NSMutableArray *commendList;   //推荐专家

@end

@implementation EnterExpertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.flagGroup){
        self.title = [NSString stringWithFormat:@"%@·专家",self.teamName];
    }else{
        self.title = @"专家列表";
    }
    
    self.attentionList = [NSMutableArray array];
    self.commendList = [NSMutableArray array];
    self.sectionList = [NSMutableArray arrayWithObjects:@"我关注的专家",@"推荐专家", nil];
    
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self queryInfo];
}

#pragma mark ---- 获取药师列表信息 ----
- (void)queryInfo
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"teamId"] = StrFromObj(self.teamId);
    HttpClientMgr.progressEnabled = NO;
    
    [Circle TeamQueryAttnTeamExpertWithParams:setting success:^(id DFUserModel) {
        
        NSMutableArray *keyArray = [NSMutableArray array];
        [keyArray addObject:NSStringFromClass([EnterExpertListModel class])];
        [keyArray addObject:NSStringFromClass([EnterExpertListModel class])];
        NSMutableArray *valueArray = [NSMutableArray array];
        [valueArray addObject:@"attnExpertaList"];
        [valueArray addObject:@"expertList"];
        
        EnterExpertPageModel *page = [EnterExpertPageModel parse:DFUserModel ClassArr:keyArray Elements:valueArray];
        
        if ([page.apiStatus integerValue] == 0)
        {
            [self.attentionList removeAllObjects];
            [self.commendList removeAllObjects];
            
            [self.attentionList addObjectsFromArray:page.attnExpertaList];
            [self.commendList addObjectsFromArray:page.expertList];
            
            if (self.attentionList.count > 0) {
                self.tableView.tableHeaderView = [[UIView alloc] init];
            }else{
                self.tableView.tableHeaderView = self.tableHeaderView;
            }
            
            if (self.commendList.count > 0){
                self.tableView.tableFooterView = [[UIView alloc] init];
            }else{
                self.tableView.tableFooterView = self.tableFooterView;
            }
            
            [self.tableView reloadData];
        }else
        {
            [SVProgressHUD showErrorWithStatus:page.apiMessage];
        }
    } failure:^(HttpException *e) {
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable){
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

#pragma mark ---- 无数据点击事件 ----
- (void)viewInfoClickAction:(id)sender
{
    [self removeInfoView];
    [self queryInfo];
}

#pragma mark ---- UITableViewDelegate ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.attentionList.count == 0)
    {
        return 1;
    }else
    {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.attentionList.count > 0)
    {
        //我关注的专家
        NSUInteger count;
        if (indexPath.section == 0) {
            count = self.attentionList.count;
        }else{
            count = self.commendList.count;
        }
        
        if (indexPath.row == count-1) {
            return 86;
        }else{
            return 93;
        }
    }else
    {
        //推荐专家
        if (indexPath.row == [self.commendList count]-1) {
            return 86;
        }else{
            return 93;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 44)];
    vi.backgroundColor = RGBHex(qwColor11);
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 4, APP_W-15, 40)];
    if (self.attentionList.count > 0) {
        lab.text = self.sectionList[section];
    }else{
        lab.text = self.sectionList[1];
    }
    lab.textColor = RGBHex(qwColor7);
    lab.font = fontSystem(kFontS4);
    [vi addSubview:lab];
    return vi;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.attentionList.count > 0)
    {
        //我关注的专家
        if (section == 0) {
            return self.attentionList.count;
        }else{
            return self.commendList.count;
        }
    }else
    {
        //推荐专家
        return self.commendList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EnterExpertCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EnterExpertCell"];
    
    int type; //1 我关注的专家  2 推荐专家
    EnterExpertListModel *model = [EnterExpertListModel new];
    
    if (self.attentionList.count > 0)
    {
        if (indexPath.section == 0)
        {
            //我关注的专家
            type = 1;
            model = self.attentionList[indexPath.row];
        }else if (indexPath.section == 1)
        {
            //推荐专家
            type = 2;
            model = self.commendList[indexPath.row];
        }
    }else
    {
        //推荐专家
        type = 2;
        model = self.commendList[indexPath.row];
    }
    
    [cell configureData:model withType:type flageGroup:self.flagGroup];
    
    //关注
    cell.attentionButton.tag = indexPath.row + 1;
    [cell.attentionButton addTarget:self action:@selector(payAttentionAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EnterExpertListModel *model = [EnterExpertListModel new];
    if (self.attentionList.count > 0)
    {
        if (indexPath.section == 0)
        {
            //我关注的专家
            model = self.attentionList[indexPath.row];
        }else
        {
            //推荐专家
            model = self.commendList[indexPath.row];
        }
    }else
    {
        //推荐专家
        model = self.commendList[indexPath.row];
    }
    
    //如果是当前登陆账号，不可点击
    if ([model.id isEqualToString:QWGLOBALMANAGER.configure.expertPassportId]) {
        return;
    }
    
    if (model.expertType == 1 || model.expertType == 2) {
        ExpertPageViewController *vc = [[UIStoryboard storyboardWithName:@"ExpertPage" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertPageViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.posterId = model.id;
        
        if (model.expertType == 1)
        {
            vc.expertType = 3;
        }else if (model.expertType == 2)
        {
            vc.expertType = 4;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        UserPageViewController *vc = [[UIStoryboard storyboardWithName:@"UserPage" bundle:nil] instantiateViewControllerWithIdentifier:@"UserPageViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.mbrId = model.id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark ---- 关注／取消关注圈子 ----
- (void)payAttentionAction:(id)sender
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    
    if (QWGLOBALMANAGER.configure.silencedFlag) {
        [SVProgressHUD showErrorWithStatus:@"您已被禁言"];
        return;
    }
    
    [QWGLOBALMANAGER statisticsEventId:@"专家列表_关注专家按键" withLable:@"圈子" withParams:nil];
    
    UIButton *btn = (UIButton *)sender;
    int row = btn.tag-1;
    EnterExpertListModel *model = self.commendList[row];
    
    NSString *type;
//    if (model.flagAttn)
//    {
//        //取消关注
//        type = @"1";
//    }else
//    {
//        //关注
//        type = @"0";
//    }
    
    //关注
    type = @"0";
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"objId"] = StrFromObj(model.id);
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"reqBizType"] = type;
    [Circle teamAttentionMbrWithParams:setting success:^(id obj) {
        if ([obj[@"apiStatus"] integerValue] == 0)
        {
            [SVProgressHUD showSuccessWithStatus:obj[@"apiMessage"]];
            [self queryInfo];
            [self.tableView reloadData];
        }else
        {
            [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"]];
        }
    } failure:^(HttpException *e) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
