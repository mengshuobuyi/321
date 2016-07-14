//
//  ClientMemberViewController.m
//  wenYao-store
//
//  Created by YYX on 15/10/29.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "ClientMemberViewController.h"
#import "BATableView.h"
#import "MyDefineCell.h"
#import "MGSwipeButton.h"
#import "SetLabelViewController.h"
#import "AppDelegate.h"
#import "QWMessage.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "CustomerModelR.h"
#import "Customer.h"
#import "MyCustomerBaseModel.h"
#import "LoginViewController.h"
#import "ClientInfoViewController.h"
#import "SearchDefineViewController.h"
#import "OrganAuthBridgeViewController.h"
#import "OrganAuthCommitOkViewController.h"
#import "ClientGroupViewController.h"


@interface ClientMemberViewController ()<UITableViewDataSource,UITableViewDelegate,BATableViewDelegate,MGSwipeTableCellDelegate,changeLabeldelegate>

{
    BATableView * myTableView;
}

// 右侧索引数组
@property (nonatomic ,strong) NSMutableArray *rightIndexArray;

// 设置每个section下的cell内容
@property (nonatomic ,strong) NSMutableArray *LetterResultArr;

@property (nonatomic ,strong) UIView *noDataView;

// 创建会员分组
- (IBAction)goToMyGroup:(id)sender;

@end

@implementation ClientMemberViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        if (iOSv7 && self.view.frame.origin.y==0) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"会员";
    self.view.backgroundColor = RGBHex(qwColor11);
    
    self.rightIndexArray = [NSMutableArray array];
    self.LetterResultArr = [NSMutableArray array];
    
    [self setNoDataView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_ic_searchyyx"] style:UIBarButtonItemStylePlain target:self action:@selector(searchClientAction:)];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self removeInfoView];
    
    if (OrganAuthPass)
    {
        // 审核通过    功能正常
        if (QWGLOBALMANAGER.currentNetWork != NotReachable)
        {
            // 请求网络数据
            [self getMydefineList];
        }
        else
        {
            // 取缓存数据
            if(self.rightIndexArray.count > 0)
                return;
            NSMutableDictionary *subDict = [QWUserDefault getObjectBy:[NSString stringWithFormat:@"myDefineOne%@",QWGLOBALMANAGER.configure.groupId]];
            [self sortIndexPersonNoWifi:subDict];
        }
    }
    else
    {
        // 未认证
        self.noDataView.hidden = NO;
        myTableView.hidden = YES;
    }
}

#pragma mark ---- 网络获取会员数据 ----

-(void)getMydefineList
{
    if (!QWGLOBALMANAGER.loginStatus) {
        return;
    }
    if(self.rightIndexArray.count > 0)
        return;
    
    [self queryCustomer];
}

#pragma mark ---- 请求客户数据 ----

- (void)queryCustomer
{
    CustomerQueryIndexModelR *model = [[CustomerQueryIndexModelR alloc] init];
    model.token = QWGLOBALMANAGER.configure.userToken;
    model.tags = @"";
    model.item = @"";
    [Customer QueryCustomerWithParams:model success:^(id obj) {
        NSDictionary *subDict = (NSDictionary *)obj;
        if([[subDict allKeys] count] == 0) {
            self.noDataView.hidden = NO;
            myTableView.hidden = YES;
            return;
        }
        // 缓存数据
        
        [QWUserDefault setObject:subDict key:[NSString stringWithFormat:@"myDefineOne%@",QWGLOBALMANAGER.configure.groupId]];
        [self sortIndexPerson:subDict];
        
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ---- 修改标签delegate ----

-(void)changeLabeldelegate
{
    [self getMydefineList];
}

#pragma mark ---- 整理缓存客户数据 ----

- (void)sortIndexPersonNoWifi:(NSDictionary *)subDict
{
    [self.rightIndexArray removeAllObjects];
    [self.LetterResultArr removeAllObjects];
    self.rightIndexArray  = [[subDict allKeys] mutableCopy];
    
    [self.rightIndexArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *string1 = (NSString *)obj1;
        NSString *string2 = (NSString *)obj2;
        if([string1 isEqualToString:@"#"]) {
            return 1;
        }else if([string2 isEqualToString:@"#"]) {
            return -1;
        }
        return [string1 compare:string2];
    }];
    for(NSString *keyValue in self.rightIndexArray)
    {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:15];
        for(NSDictionary *singlePerson in subDict[keyValue])
        {
            [array addObject:singlePerson];
        }
        [self.LetterResultArr addObject:array];
    }
    
    if (self.self.rightIndexArray .count == 0){
        [self showInfoView:kWarning215N6 image:@"img_network"];
        myTableView.hidden = YES;
    }else{
        [self makeTableView];
    }
}

- (void)viewInfoClickAction:(id)sender
{
    [self removeInfoView];
    if (QWGLOBALMANAGER.currentNetWork != NotReachable) {
        [self getMydefineList];
    }else
    {
        if(self.rightIndexArray.count > 0)
            return;
        
        NSMutableDictionary *subDict = [QWUserDefault getObjectBy:[NSString stringWithFormat:@"myDefineOne%@",QWGLOBALMANAGER.configure.groupId]];
        [self sortIndexPersonNoWifi:subDict];
    }
}

#pragma mark ---- 整理网络请求客户数据 ----

- (void)sortIndexPerson:(NSDictionary *)subDict
{
    [self.rightIndexArray removeAllObjects];
    [self.LetterResultArr removeAllObjects];
    self.rightIndexArray  = [[subDict allKeys] mutableCopy];
    
    [self.rightIndexArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *string1 = (NSString *)obj1;
        NSString *string2 = (NSString *)obj2;
        if([string1 isEqualToString:@"#"]) {
            return 1;
        }else if([string2 isEqualToString:@"#"]) {
            return -1;
        }
        return [string1 compare:string2];
    }];
    for(NSString *keyValue in self.rightIndexArray)
    {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:15];
        for(NSDictionary *singlePerson in subDict[keyValue])
        {
            [array addObject:singlePerson];
        }
        [self.LetterResultArr addObject:array];
    }
    
    if (self.self.rightIndexArray .count == 0){
        self.noDataView.hidden = NO;
        myTableView.hidden = YES;
    }else{
        [self makeTableView];
    }
}


#pragma mark ---- 设置 tableView ----

- (void)makeTableView{
    if(myTableView){
        [myTableView removeFromSuperview];
    }
    myTableView = [[BATableView alloc]init];
    myTableView = [[BATableView alloc]initWithFrame:CGRectMake(0, 67, [UIScreen mainScreen].applicationFrame.size.width
                                                               , [UIScreen mainScreen].applicationFrame.size.height-67-44
                                                               )];
    myTableView.delegate = self;
    myTableView.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    myTableView.tableView.backgroundColor = [UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0f];
    
    [self.view addSubview:myTableView];
    
//    myTableView.tableView.headerPullToRefreshText = @"下拉刷新";
//    myTableView.tableView.headerReleaseToRefreshText = @"松开刷新";
//    myTableView.tableView.headerRefreshingText = @"正在刷新";
    
    __weak ClientMemberViewController *weakSelf = self;
    
//    [myTableView.tableView addHeaderWithCallback:^{
//        if (QWGLOBALMANAGER.currentNetWork != kNotReachable) {
//            [weakSelf queryCustomer];
//        }else
//        {
//            [SVProgressHUD showErrorWithStatus:@"网络未连接，请重试！" duration:0.8];
//        }
//        [myTableView.tableView headerEndRefreshing];
//    }];
    [self enableSimpleRefresh:myTableView.tableView block:^(SRRefreshView *sender) {
        if (QWGLOBALMANAGER.currentNetWork != kNotReachable) {
            [weakSelf queryCustomer];
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"网络未连接，请重试！" duration:0.8];
        }
    }];
}

#pragma mark ---- 列表代理 ----

- (NSArray *) sectionIndexTitlesForABELTableView:(BATableView *)tableView{
    
    return self.rightIndexArray;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 23.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 76.0f;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.rightIndexArray.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  [(NSArray *)self.LetterResultArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    
    cell.selectButton.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dic = self.LetterResultArr[indexPath.section][indexPath.row];
    [cell configureCellData:dic];
    
    if ([(NSArray *)self.LetterResultArr[indexPath.section] count]-1==indexPath.row) {
        cell.backline.hidden=YES;
    }else{
        cell.backline.hidden=NO;
    }
    
    if (AUTHORITY_ROOT)
        cell.swipeDelegate = self;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * v = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , APP_W, 23)];
    v.backgroundColor = RGBHex(qwColor11);
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 23)];
    label.font = fontSystem(kFontS4);
    label.textColor = RGBHex(qwColor8);
    if ( [self.rightIndexArray[section] isEqualToString:@"#"]) {
        label.text  =@"#未分类";
    }else {
        label.text = self.rightIndexArray[section];
    }
    [v addSubview:label];
    return v;
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
    info.dic = self.LetterResultArr[indexPath.section][indexPath.row];
    [self.navigationController pushViewController:info animated:YES];
}

#pragma mark ---- 列表侧滑 ----

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
        
        indexPath = [myTableView.tableView indexPathForCell:cell];
        SetLabelViewController *setVC = [[SetLabelViewController alloc] initWithNibName:@"SetLabelViewController" bundle:nil];
        NSDictionary *dicUser = self.LetterResultArr[indexPath.section][indexPath.row];
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
        indexPath = [myTableView.tableView indexPathForCell:cell];
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"token"] = QWGLOBALMANAGER.configure.userToken;
        setting[@"customer"] = self.LetterResultArr[indexPath.section][indexPath.row][@"passportId"];
        // TODO: need update
        [HistoryMessages deleteObjFromDBWithKey:setting[@"customer"]];
        BOOL result = [QWMessage deleteWithWhere:[NSString stringWithFormat:@"sendname = '%@' or recvname = '%@'",setting[@"customer"],setting[@"customer"]]];
        //        [QWGLOBALMANAGER updateUnreadCountBadge:0];
        CustomerDeleteModelR *modelR = [CustomerDeleteModelR new];
        modelR.token = QWGLOBALMANAGER.configure.userToken;
        modelR.customer = self.LetterResultArr[indexPath.section][indexPath.row][@"passportId"];
        
        __weak ClientMemberViewController *weakSelf = self;
        [Customer DeleteCustomerWithParams:modelR success:^(id obj) {
            [QWGLOBALMANAGER postNotif:NotifDeleteMessage data:nil object:nil];
            
            [weakSelf deleteOneRecord:indexPath];
            if ([(NSArray *)weakSelf.LetterResultArr[indexPath.section] count] > 1) {
                [weakSelf.LetterResultArr[indexPath.section] removeObject:weakSelf.LetterResultArr[indexPath.section][indexPath.row]];
            }else{
                [weakSelf.LetterResultArr removeObject:weakSelf.LetterResultArr[indexPath.section]];
                [weakSelf.rightIndexArray removeObjectAtIndex:indexPath.section];
            }
            if (weakSelf.LetterResultArr.count == 0)
            {
                self.noDataView.hidden = NO;
                myTableView.hidden  = YES;
            }
            [QWGLOBALMANAGER getAllConsult];
            [myTableView reloadData];
            
            
        } failure:^(HttpException *e) {
            
        }];
    }
    return YES;
}

-(NSArray *) createRightButtons: (int) number
{
    NSMutableArray * result = [NSMutableArray array];
    NSString* titles[2] = {@"删除", @"设置"};
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

#pragma mark ---- 滑动删除聊天记录 ----

- (void)deleteOneRecord:(NSIndexPath *)indexPath
{
    NSString *contactSavePath = [NSString stringWithFormat:@"%@/Documents/%@/%@",NSHomeDirectory(),QWGLOBALMANAGER.configure.userName,@"contactSave.plist"];
    NSMutableDictionary *subDict = [NSMutableDictionary dictionaryWithContentsOfFile:contactSavePath];
    
    NSMutableArray *array = subDict[self.rightIndexArray[indexPath.section]];
    [array removeObjectAtIndex:indexPath.row];
    if([array count] == 0) {
        [subDict removeObjectForKey:self.rightIndexArray[indexPath.section]];
    }
    [subDict writeToFile:contactSavePath atomically:YES];
}

#pragma mark ---- 无数据提示 ----

- (void)setNoDataView
{
    self.noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 67, SCREEN_W, [UIScreen mainScreen].applicationFrame.size.height-67-44-45)];
    self.noDataView.hidden = YES;
    [self.view addSubview:self.noDataView];
    
    UIImageView *image = [[UIImageView alloc] init];
    
    if (IS_IPHONE_6) {
        image.frame = CGRectMake((APP_W-120)/2, 130, 120, 120);
    }else if (IS_IPHONE_6P){
        image.frame = CGRectMake((APP_W-120)/2, 150, 120, 120);
    }else{
        image.frame = CGRectMake((APP_W-120)/2, 70, 120, 120);
    }
    
    image.image=[UIImage imageNamed:@"ic_img_fail"];
    [self.noDataView addSubview:image];
    
    UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, image.frame.origin.y+72+25+30, APP_W-20, 15)];
    [noDataLabel setFont:[UIFont systemFontOfSize:15]];
    noDataLabel.textAlignment = NSTextAlignmentCenter;
    noDataLabel.text = @"暂无会员!";
    noDataLabel.textColor = RGBHex(0x6a7985);
    [self.noDataView addSubview:noDataLabel];
}

- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    if (type == NotifQuitOut) {
        [self logoutAction];
    } else if (type == NotifContactUpdate) {
        [self delayQueryCustomer];
    } else if (type == NotifContactUpdateImmediate) {
        [self queryCustomer];
    }
}

- (void)delayQueryCustomer
{
    [self performSelector:@selector(queryCustomer) withObject:nil afterDelay:6.0f];
}

- (void)logoutAction
{
    [self.rightIndexArray removeAllObjects];
    [self.LetterResultArr removeAllObjects];
    [myTableView reloadData];
}

#pragma mark ---- 搜索客户 ----

- (void)searchClientAction:(id)sender
{
    SearchDefineViewController *searchV = [[SearchDefineViewController alloc] initWithNibName:@"SearchDefineViewController" bundle:nil];
    searchV.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchV animated:YES];
}

#pragma mark ---- 创建会员分组 ----

- (IBAction)goToMyGroup:(id)sender
{
    if ([QWGLOBALMANAGER.configure.approveStatus integerValue] == 4 || [QWGLOBALMANAGER.configure.approveStatus integerValue] == 2)
    {
        OrganAuthBridgeViewController *vc = [[UIStoryboard storyboardWithName:@"OrganAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"OrganAuthBridgeViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([QWGLOBALMANAGER.configure.approveStatus integerValue] == 1)
    {
        OrganAuthCommitOkViewController *vc = [[UIStoryboard storyboardWithName:@"OrganAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"OrganAuthCommitOkViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        ClientGroupViewController *vc = [[UIStoryboard storyboardWithName:@"ClientGroup" bundle:nil] instantiateViewControllerWithIdentifier:@"ClientGroupViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
