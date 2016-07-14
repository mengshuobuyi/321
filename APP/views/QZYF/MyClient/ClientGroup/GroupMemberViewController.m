//
//  GroupMemberViewController.m
//  wenYao-store
//
//  Created by YYX on 15/6/2.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "GroupMemberViewController.h"
#import "MyDefineCell.h"
#import "SVProgressHUD.h"
#import "SetLabelViewController.h"
#import "MGSwipeButton.h"
#import "AddMemberViewController.h"
#import "Customer.h"
#import "ClientInfoViewController.h"

@interface GroupMemberViewController ()<UITableViewDataSource,UITableViewDelegate,MGSwipeTableCellDelegate,changeLabeldelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataList;

@end

@implementation GroupMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataList = [NSMutableArray array];
    
    //店员账号
    if (AUTHORITY_ROOT) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addNewClientMember:)];
    }
    
    self.view.backgroundColor = RGBHex(0xffffff);
    
    [self setUpTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable)
    {
        //断网缓存
        
        [self.dataList removeAllObjects];
        self.dataList = [QWUserDefault getObjectBy:[NSString stringWithFormat:@"myDefineOne%@+%@",QWGLOBALMANAGER.configure.groupId,self.customerGroupId]];
        
        if (self.dataList.count == 0) {
            self.tableView.hidden = YES;
            [self showInfoView:kWarning215N6 image:@"noData"];
        }
        
        [self.tableView reloadData];
        
    }else
    {
        //服务器请求数据
        
        [self getMyClientList];
    }
}

#pragma mark ---- 添加客户 Action ----

- (void)addNewClientMember:(id)sender
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring12 duration:0.8];
        return;
    }
    
    AddMemberViewController *addVc = [[UIStoryboard storyboardWithName:@"ClientGroup" bundle:nil] instantiateViewControllerWithIdentifier:@"AddMemberViewController"];
    addVc.hidesBottomBarWhenPushed = YES;
    addVc.customerGroupId = self.customerGroupId;
    addVc.tempArray = self.dataList;
    [self.navigationController pushViewController:addVc animated:YES];
}

#pragma mark ---- 请求数据 ----

-(void)getMyClientList
{
    if (!QWGLOBALMANAGER.loginStatus) {
        return;
    }
    
    [self removeInfoView];
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
    setting[@"customerGroupId"] = StrFromObj(self.customerGroupId);
    
    [Customer CustomerGroupCustListWithParams:setting success:^(id obj) {
        
        [self.dataList removeAllObjects];
        
        if ([obj[@"apiStatus"] integerValue] == 0) {
                        
            self.dataList = [NSMutableArray arrayWithArray:obj[@"list"]];
            self.tableView.hidden = NO;
            [self.tableView reloadData];
            
            //缓存数据
            
            [QWUserDefault removeObjectBy:[NSString stringWithFormat:@"myDefineOne%@+%@",QWGLOBALMANAGER.configure.groupId,self.customerGroupId]];
            [QWUserDefault setObject:self.dataList key:[NSString stringWithFormat:@"myDefineOne%@+%@",QWGLOBALMANAGER.configure.groupId,self.customerGroupId]];
            
        }else if ([obj[@"apiStatus"] integerValue] == 1){
           
            [self showInfoView:@"暂无会员" image:@"img_nogroup_people"];
            self.tableView.hidden = YES;
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"] duration:0.8];
        }
        
    } failue:^(HttpException *e) {
        if(e.errorCode!=-999){
            if(e.errorCode == -1001){
                [self showInfoView:kWarning215N54 image:@"ic_img_fail"];
            }else{
                [self showInfoView:kWarning215N0 image:@"ic_img_fail"];
            }
        }
    }];
    
}

#pragma mark ---- 修改标签delegate ----

-(void)changeLabeldelegate
{
    [self getMyClientList];
}


#pragma mark ---- 设置tableView ----

- (void)setUpTableView
{
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.tableView.backgroundColor = [UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0f];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.headerPullToRefreshText = @"下拉刷新";
    self.tableView.headerReleaseToRefreshText = @"松开刷新";
    self.tableView.headerRefreshingText = @"正在刷新";
    
    __weak GroupMemberViewController *weakSelf = self;
    
//    [self.tableView addHeaderWithCallback:^{
//        
//        if (QWGLOBALMANAGER.currentNetWork != kNotReachable) {
//            [weakSelf getMyClientList];
//        }else{
//            [SVProgressHUD showErrorWithStatus:@"网络未连接，请重试！" duration:0.8];
//        }
//        
//        [weakSelf.tableView headerEndRefreshing];
//    }];
    
    [self enableSimpleRefresh:self.tableView block:^(SRRefreshView *sender) {
        
        if (QWGLOBALMANAGER.currentNetWork != kNotReachable) {
            [weakSelf getMyClientList];
        }else{
            [SVProgressHUD showErrorWithStatus:@"网络未连接，请重试！" duration:0.8];
        }
    }];
    
}

#pragma mark ---- 列表代理 ----


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 76.0f;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  [(NSArray *)self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MyDefineCellIdentifier = @"MyDefineCellIdentifier";
    MyDefineCell *cell = (MyDefineCell *)[tableView dequeueReusableCellWithIdentifier:MyDefineCellIdentifier];
    if(cell == nil){
        UINib *nib = [UINib nibWithNibName:@"MyDefineCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:MyDefineCellIdentifier];
        cell = (MyDefineCell *)[tableView dequeueReusableCellWithIdentifier:MyDefineCellIdentifier];
    }else {
        cell.lbl_one.text = @"";
        cell.img_lblone.hidden = YES;
        cell.lbl_two.text = @"";
        cell.img_lbltwo.hidden = YES;
        cell.lbl_three.text = @"";
        cell.img_lblthree.hidden = YES;
        cell.lbl_username.text= @"";
        [cell.img_user setImage:nil];
        [cell.img_logo setImage:nil];
    }
    
    cell.backline.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectButton.hidden = YES;
    
    NSDictionary *dic = self.dataList[indexPath.row];
    [cell configureCellData:dic];
        
    if (AUTHORITY_ROOT) {
        cell.swipeDelegate = self;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (QWGLOBALMANAGER.currentNetWork == NotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:0.8];
        return;
    }
    
    ClientInfoViewController *info = [[UIStoryboard storyboardWithName:@"ClientInfo" bundle:nil] instantiateViewControllerWithIdentifier:@"ClientInfoViewController"];
    info.hidesBottomBarWhenPushed = YES;
    info.dic = self.dataList[indexPath.row];
    [self.navigationController pushViewController:info animated:YES];
    
}

#pragma mark ---- MGSwipeTableCellDelegate ----

-(NSArray*) swipeTableCell:(MGSwipeTableCell*)cell
  swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*)swipeSettings
         expansionSettings:(MGSwipeExpansionSettings*)expansionSettings;
{
    
    if (direction == MGSwipeDirectionRightToLeft) {
        return [self createRightButtons:2];
    }
    return nil;
}

-(BOOL) swipeTableCell:(MGSwipeTableCell*)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion
{
    NSIndexPath *indexPath = nil;
    
    if (index == 1) {
        if (QWGLOBALMANAGER.currentNetWork == NotReachable) {
            [self showError:@"网络异常，请稍后重试"];
            return YES;
        }
        
        //设置标签及备注
        
        indexPath = [self.tableView indexPathForCell:cell];
        SetLabelViewController *setVC = [[SetLabelViewController alloc] initWithNibName:@"SetLabelViewController" bundle:nil];
        NSDictionary *dicUser = self.dataList[indexPath.row];
        MyCustomerInfoModel *modelCustomer = [MyCustomerInfoModel parse:dicUser];
        setVC.modelUserInfo = modelCustomer;
        setVC.delegate = self;
        setVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:setVC animated:YES];
        
    }else{
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [SVProgressHUD showErrorWithStatus:kWaring33 duration:0.8];
            return YES ;
        }
        
        //移除客户
        
        indexPath = [self.tableView indexPathForCell:cell];
        NSDictionary *clientDic = self.dataList[indexPath.row];
        
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
        setting[@"customerGroupId"] = self.customerGroupId;
        setting[@"customerIds"] = clientDic[@"passportId"];
        
        [Customer CustomerGroupCustRemoveWithParams:setting success:^(id obj) {
            
            if ([obj[@"apiStatus"] integerValue] == 0) {
                
                [self getMyClientList];
                [self.tableView reloadData];
            }else
            {
                [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"] duration:0.8];
            }
            
        } failue:^(HttpException *e) {
            
        }];
        
    }
    return YES;
}

-(NSArray *) createRightButtons: (int) number
{
    NSMutableArray * result = [NSMutableArray array];
    NSString* titles[2] = {@"移出", @"设置"};
    UIColor * colors[2] = {RGBHex(qwColor3), RGBHex(qwColor9)};
    UIColor *titlecolor[2] = {RGBHex(qwColor4),RGBHex(qwColor4)};
    for (int i = 0; i < number; ++i)
    {
        MGSwipeButton * button = [MGSwipeButton buttonWithTitle:titles[i] backgroundColor:colors[i] callback:^BOOL(MGSwipeTableCell * sender){
            return YES;
        }];
        [button setTitleColor:titlecolor[i] forState:UIControlStateNormal];
        [result addObject:button];
    }
    return result;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
