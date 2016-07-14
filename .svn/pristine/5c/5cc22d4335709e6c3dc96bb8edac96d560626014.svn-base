//
//  AllCircleViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 15/12/17.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "AllCircleViewController.h"
#import "AllCircleCell.h"
#import "CircleDetailViewController.h"
#import "Circle.h"
#import "CircleModel.h"

@interface AllCircleViewController ()<UITableViewDataSource,UITableViewDelegate,AllCircleCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;

@property (strong, nonatomic) NSMutableArray *sectionList;
@property (strong, nonatomic) NSMutableArray *dataList;

@end

@implementation AllCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.sectionList = [NSMutableArray array];
    self.dataList = [NSMutableArray array];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [QWGLOBALMANAGER statisticsEventId:@"全部圈子页面_出现" withLable:@"圈子" withParams:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self queryList];
}

#pragma mark ---- 获取圈子列表数据 ----
- (void)queryList
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    HttpClientMgr.progressEnabled = NO;
    
    [Circle TeamQueryTeamListWithParams:setting success:^(id DFUserModel) {
        
        [self.sectionList removeAllObjects];
        [self.dataList removeAllObjects];
        
        NSMutableArray *keyArr = [NSMutableArray array];
        [keyArr addObject:NSStringFromClass([CircleListModel class])];
        [keyArr addObject:NSStringFromClass([CircleListModel class])];
        [keyArr addObject:NSStringFromClass([CircleListModel class])];
        NSMutableArray *valueArr = [NSMutableArray array];
        [valueArr addObject:@"myTeamList"];
        [valueArr addObject:@"attnTeamList"];
        [valueArr addObject:@"teamList"];
        AllCirrclePageModel *page = [AllCirrclePageModel parse:DFUserModel ClassArr:keyArr Elements:valueArr];
        
        if ([page.apiStatus integerValue] == 0)
        {
            if (page.myTeamList.count > 0)
            {
                NSMutableArray *arr = [NSMutableArray array];
                for (CircleListModel *mod in page.myTeamList)
                {
                    mod.allCircleType = 1;
                    [arr addObject:mod];
                }
                [self.dataList addObject:arr];
                [self.sectionList addObject:@"我的圈子"];
            }
            
            if (page.attnTeamList.count > 0)
            {
                NSMutableArray *arr = [NSMutableArray array];
                for (CircleListModel *mod in page.attnTeamList)
                {
                    mod.allCircleType = 2;
                    [arr addObject:mod];
                }
                [self.dataList addObject:arr];
                [self.sectionList addObject:@"我关注的圈子"];
            }
            
            if (page.teamList.count > 0)
            {
                NSMutableArray *arr = [NSMutableArray array];
                for (CircleListModel *mod in page.teamList)
                {
                    mod.allCircleType = 3;
                    [arr addObject:mod];
                }
                [self.dataList addObject:arr];
                [self.sectionList addObject:@"推荐圈子"];
            }
            
            if (self.dataList.count > 0)
            {
                [self.tableView reloadData];
            }
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
    [self queryList];
}

#pragma mark ---- UITableViewDelegate ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
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
    lab.text = self.sectionList[section];
    lab.textColor = RGBHex(qwColor8);
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
    NSArray *arr = self.dataList[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *allCircleCell = @"AllCircleCell";
    AllCircleCell *cell = (AllCircleCell *)[tableView dequeueReusableCellWithIdentifier:allCircleCell];
    if(cell == nil){
        UINib *nib = [UINib nibWithNibName:@"AllCircleCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:allCircleCell];
        cell = (AllCircleCell *)[tableView dequeueReusableCellWithIdentifier:allCircleCell];
    }
    
    CircleListModel *model = [CircleListModel new];
    model = self.dataList[indexPath.section][indexPath.row];
    [cell configureData:model withType:0];
    
    //关注
    cell.allCircleCellDelegate = self;
    cell.attentionButton.obj = indexPath;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CircleListModel *model = [CircleListModel new];
    model = self.dataList[indexPath.section][indexPath.row];
    
    //进入圈子详情页面
    CircleDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Circle" bundle:nil] instantiateViewControllerWithIdentifier:@"CircleDetailViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.teamId = model.teamId;
    vc.title = [NSString stringWithFormat:@"%@圈",model.teamName];
    [self.cusNavigationController pushViewController:vc animated:YES];
}

#pragma mark ---- 关注／取消关注圈子 ----
- (void)payAttentionCircleAction:(NSIndexPath *)indexPath
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    
    if (QWGLOBALMANAGER.configure.silencedFlag) {
        [SVProgressHUD showErrorWithStatus:@"您已被禁言"];
        return;
    }

    CircleListModel *model = self.dataList[indexPath.section][indexPath.row];
    
    NSString *type;
    if (model.flagAttn)
    {
        //取消关注
        type = @"1";
    }else
    {
        //关注
        type = @"0";
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"teamId"] = StrFromObj(model.teamId);
    setting[@"isAttentionTeam"] = StrFromObj(type);
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    [Circle teamAttentionTeamWithParams:setting success:^(id obj) {
        if ([obj[@"apiStatus"] integerValue] == 0)
        {
            [SVProgressHUD showSuccessWithStatus:obj[@"apiMessage"]];
            [self queryList];
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
