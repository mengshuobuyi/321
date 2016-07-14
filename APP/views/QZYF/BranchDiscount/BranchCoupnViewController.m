//
//  ConsultPharmacyViewController.m
//  wenyao
//
//  Created by xiezhenghong on 14-9-17.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "BranchCoupnViewController.h"
#import "ComboxView.h"
#import "ComboxViewCell.h"
#import "RightAccessButton.h"
#import "FirstCoupnTableViewCell.h"
#import "ThreeCoupnTableViewCell.h"
#import "SecondProductTableViewCell.h"
#import "BranchdetailCViewController.h"
#import "BranchViewController.h"
#import "PurchaseViewController.h"

@interface BranchCoupnViewController ()<ComboxViewDelegate>

{
    NSUInteger             currentPage;
    
    ComboxView             *rightComboxView;       // 全部来源
    ComboxView             *centerrightComboxView;    // 满减、礼品、折扣
    ComboxView             *newrightComboxView;    // 全部领用/未领用
    
    RightAccessButton      *rightButton;
    RightAccessButton      *centerrightButton;
    RightAccessButton      *newrightButton;
    
    NSArray                *rightMenuItems;
    NSArray                *centerrightMenuItems;
    NSArray                *newrightMenuItems;

    NSUInteger             rightIndex;
    NSUInteger             centerrightIndex;
    NSUInteger             newrightIndex;

    BOOL isFirstRequest;    // 是否第一次请求数据  缓存用
}

@property (nonatomic, strong) NSMutableArray           *dataSource;
@property (nonatomic ,strong) UITableView              *rootTableView;

@end

@implementation BranchCoupnViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"优惠券";

    currentPage = 1;
    isFirstRequest = YES;
    
    rightIndex = 0;
    centerrightIndex=0;
    newrightIndex = 1;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"赠送记录" style:UIBarButtonItemStylePlain target:self action:@selector(purchaseRecord)];
    self.dataSource = [NSMutableArray array];
    
    rightMenuItems = @[@"来源",@"来源商家",@"来源全维"];
    centerrightMenuItems = @[@"类型",@"满减",@"礼品",@"折扣",@"兑换券"];
    newrightMenuItems = @[@"状态",@"可领用",@"已领完"];
    
    // 设置headerView
    [self setupHeaderView];
    
    // 设置tableView
    [self setupTableView];
    
    // 获取列表数据
    [self queryDataList];
}

-(void)purchaseRecord{
    [QWGLOBALMANAGER statisticsEventId:@"s_yhq_zsjl" withLable:@"优惠券赠送纪录" withParams:nil];
    PurchaseViewController *vc=[[PurchaseViewController alloc]initWithNibName:@"PurchaseViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark ---- 获取列表数据 ----

- (void)queryDataList
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable)
    {
        NSArray *arr = [QWUserDefault getObjectBy:[NSString stringWithFormat:@"branchCoupon%@",QWGLOBALMANAGER.configure.passportId]];
        if (arr.count > 0) {
            [self removeInfoView];
            [self.dataSource addObjectsFromArray:arr];
            [self.rootTableView reloadData];
        }else{
            [self showInfoView:@"暂无优惠券" image:@"img_vouchers" flatY:40];
        }
    }else
    {
        [self detailflag:NO header:@"footer"];
    }
}

#pragma mark ---- 设置 tableView ----

- (void)setupTableView
{
    self.rootTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, APP_W, APP_H-NAV_H-40) style:UITableViewStylePlain];
    self.rootTableView.delegate = self;
    self.rootTableView.dataSource = self;
    self.rootTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.rootTableView setBackgroundColor:[UIColor clearColor]];
    
    [self.rootTableView addFooterWithTarget:self action:@selector(footerRereshing)];
//    [self.rootTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    
    [self enableSimpleRefresh:self.rootTableView block:^(SRRefreshView *sender) {
        [self headerRefresh];
    }];
    
    self.rootTableView.footerPullToRefreshText = kWaring6;
    self.rootTableView.footerReleaseToRefreshText = kWaring7;
    self.rootTableView.footerRefreshingText = kWaring9;
    self.rootTableView.footerNoDataText = kWaring55;
    
    [self.view addSubview:self.rootTableView];
}

#pragma mark ---- 设置列表 header ----

- (void)setupHeaderView
{
    UIImageView *headerView = nil;
    
    if(![self.view viewWithTag:1008])
    {
        headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 40)];
        headerView.tag = 1008;
        headerView.userInteractionEnabled = YES;
        headerView.backgroundColor = RGBHex(qwColor4);
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(APP_W/3, 4, 0.5, 30)];
        line.backgroundColor = RGBHex(qwColor10);
        [headerView addSubview:line];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(APP_W*2/3, 4, 0.5, 30)];
        line2.backgroundColor = RGBHex(qwColor10);
        [headerView addSubview:line2];
        
        UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0,39.5,APP_W, 0.5)];
        line3.backgroundColor = RGBHex(qwColor10);
        [headerView addSubview:line3];
        
        rightButton = [[RightAccessButton alloc] initWithFrame:CGRectMake(0, 0, APP_W / 3.0, 40)];
        [headerView addSubview:rightButton];
        
        
        centerrightButton = [[RightAccessButton alloc] initWithFrame:CGRectMake(APP_W/3.0, 0, APP_W / 3.0, 40)];
        [headerView addSubview:centerrightButton];
        
        newrightButton = [[RightAccessButton alloc] initWithFrame:CGRectMake(APP_W*2/3.0, 0, APP_W / 3.0, 40)];
        [headerView addSubview:newrightButton];
        
        UIImageView *accessView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        
        UIImageView *accessView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        UIImageView *accessView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        
        [accessView1 setImage:[UIImage imageNamed:@"icon_downArrow"]];
        [accessView2 setImage:[UIImage imageNamed:@"icon_downArrow"]];
        [accessView3 setImage:[UIImage imageNamed:@"icon_downArrow"]];
        
        rightButton.accessIndicate = accessView1;
        centerrightButton.accessIndicate = accessView2;
        newrightButton.accessIndicate = accessView3;
        
        [rightButton setCustomColor:RGBHex(qwColor7)];
        [centerrightButton setCustomColor:RGBHex(qwColor7)];
        [newrightButton setCustomColor:RGBHex(qwColor7)];
        
        [rightButton setButtonTitle:@"来源"];
        [centerrightButton setButtonTitle:@"类型"];
        [newrightButton setButtonTitle:@"可领用"];
        
        [rightButton addTarget:self action:@selector(showRightTable:) forControlEvents:UIControlEventTouchDown];
        [centerrightButton addTarget:self action:@selector(showCenterRightTable:) forControlEvents:UIControlEventTouchDown];
        [newrightButton addTarget:self action:@selector(showNewRightTable:) forControlEvents:UIControlEventTouchDown];
        
        rightComboxView = [[ComboxView alloc] initWithFrame:CGRectMake(0, 40, APP_W, [rightMenuItems count]*46)];
        rightComboxView.delegate = self;
        rightComboxView.comboxDeleagte = self;
        rightComboxView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        centerrightComboxView = [[ComboxView alloc] initWithFrame:CGRectMake(0, 40, APP_W, [centerrightMenuItems count]*46)];
        centerrightComboxView.delegate = self;
        centerrightComboxView.comboxDeleagte = self;
        centerrightComboxView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        newrightComboxView = [[ComboxView alloc] initWithFrame:CGRectMake(0, 40, APP_W, [newrightMenuItems count]*46)];
        newrightComboxView.delegate = self;
        newrightComboxView.comboxDeleagte = self;
        newrightComboxView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  
    }else{
        headerView = (UIImageView *)[self.view viewWithTag:1008];
    }
    [self.view addSubview:headerView];
}

#pragma mark ---- 头部刷新 ----

- (void)headerRefresh
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
        return;
    }
    [self detailflag:YES header:@"header"];
}

#pragma mark ---- 尾部刷新 ----

- (void)footerRereshing
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
        [self.rootTableView.footer endRefreshing];
        return;
    }
    HttpClientMgr.progressEnabled = NO;
    [self detailflag:NO header:@"footer"];
}

- (void)tableViewReloadData
{
    //如果断网情况下,就把顶端的空间给移除
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring12 image:@"img_network"];
    }
    [self.rootTableView reloadData];
}

#pragma mark ---- 显示全部来源 列表 ----

- (void)showRightTable:(id)sender
{
    [newrightButton changeArrowDirectionUp:NO];
    newrightButton.isToggle = NO;
    [newrightComboxView dismissView];
    
    [centerrightButton changeArrowDirectionUp:NO];
    centerrightButton.isToggle = NO;
    [centerrightComboxView dismissView];

    if(rightButton.isToggle) {
        [rightComboxView dismissView];
        [rightButton changeArrowDirectionUp:NO];
    }else{
        [rightButton setTitleColor:RGBHex(qwColor1) forState:UIControlStateNormal];
        [rightComboxView showInView:self.view];
        [rightButton changeArrowDirectionUp:YES];
        rightButton.isToggle = YES;
    }
}

#pragma mark ---- 显示类型列表 ----

- (void)showCenterRightTable:(id)sender
{
    [rightButton changeArrowDirectionUp:NO];
    rightButton.isToggle = NO;
    [rightComboxView dismissView];
    
    [newrightButton changeArrowDirectionUp:NO];
    newrightButton.isToggle = NO;
    [newrightComboxView dismissView];

    
    if(centerrightButton.isToggle) {
        [centerrightComboxView dismissView];
        [centerrightButton changeArrowDirectionUp:NO];
        
    }else{
        [centerrightButton setTitleColor:RGBHex(qwColor1) forState:UIControlStateNormal];
        [centerrightComboxView showInView:self.view];
        [centerrightButton changeArrowDirectionUp:YES];
        centerrightButton.isToggle = YES;
    }
}


#pragma mark ---- 显示全部领用/未领用列表 ----

- (void)showNewRightTable:(id)sender
{
    [rightButton changeArrowDirectionUp:NO];
    rightButton.isToggle = NO;
    [rightComboxView dismissView];
    
    [centerrightButton changeArrowDirectionUp:NO];
    centerrightButton.isToggle = NO;
    [centerrightComboxView dismissView];
    
    if(newrightButton.isToggle) {
        [newrightComboxView dismissView];
        [newrightButton changeArrowDirectionUp:NO];
        
    }else{
        [newrightButton setTitleColor:RGBHex(qwColor1) forState:UIControlStateNormal];
        [newrightComboxView showInView:self.view];
        [newrightButton changeArrowDirectionUp:YES];
        newrightButton.isToggle = YES;
    }
}

#pragma mark ---- comboxView 代理 ----

- (void)comboxViewWillDisappear:(ComboxView *)comboxView
{
    if([comboxView isEqual:rightComboxView]){
        // 全部来源
        [rightButton setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
        [rightButton changeArrowDirectionUp:NO];
        rightButton.isToggle = NO;
    }else if([comboxView isEqual:newrightComboxView]){
        // 可领用
        [newrightButton setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
        [newrightButton changeArrowDirectionUp:NO];
        newrightButton.isToggle = NO;
    }else{
        [centerrightButton setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
        [centerrightButton changeArrowDirectionUp:NO];
        centerrightButton.isToggle = NO;
    }
}

#pragma mark ---- 列表代理 ----

- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([atableView isEqual:self.rootTableView])
    {
        // 主 View  scope 1.通用2.慢病3.全部4.礼品券5.商品券
        BranchCouponVo *model=self.dataSource[indexPath.row];
        if(!StrIsEmpty(model.giftImgUrl)){
            // 礼品券
            return [ThreeCoupnTableViewCell getCellHeight:nil];
        }else{
            // 其他券
            return [FirstCoupnTableViewCell getCellHeight:nil];
        }
    }else
    {
        // header 选择列表
        return 46;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)atableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)atableView numberOfRowsInSection:(NSInteger)section
{
    if([atableView isEqual:self.rootTableView])
    {
        return [self.dataSource count];
    }
    else if([atableView isEqual:rightComboxView.tableView])
    {
        return [rightMenuItems count];
    }
    else  if([atableView isEqual:newrightComboxView.tableView]){
        return [newrightMenuItems count];
    }else{
        return [centerrightMenuItems count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([atableView isEqual:self.rootTableView])
    {
        // 主列表
        
        // 其他券的cell
        static NSString *FirstCoupnCell = @"FirstCoupnCell";
        FirstCoupnTableViewCell *cell = (FirstCoupnTableViewCell *)[atableView dequeueReusableCellWithIdentifier:FirstCoupnCell];
        if(cell == nil){
            UINib *nib = [UINib nibWithNibName:@"FirstCoupnTableViewCell" bundle:nil];
            [atableView registerNib:nib forCellReuseIdentifier:FirstCoupnCell];
            cell = (FirstCoupnTableViewCell *)[atableView dequeueReusableCellWithIdentifier:FirstCoupnCell];
        }
        
        // 礼品券的cell
        static NSString *ThreeCoupnCell = @"ThreeCoupnCell";
        ThreeCoupnTableViewCell *Threecell = (ThreeCoupnTableViewCell *)[atableView dequeueReusableCellWithIdentifier:ThreeCoupnCell];
        if(Threecell == nil){
            UINib *nib = [UINib nibWithNibName:@"ThreeCoupnTableViewCell" bundle:nil];
            [atableView registerNib:nib forCellReuseIdentifier:ThreeCoupnCell];
            Threecell = (ThreeCoupnTableViewCell *)[atableView dequeueReusableCellWithIdentifier:ThreeCoupnCell];
        }
        
        BranchCouponVo *model=self.dataSource[indexPath.row];
        
        if(!StrIsEmpty(model.giftImgUrl)){ // 礼品券
            [Threecell setCoupnCell:model];
            return Threecell;
        }else{
            [cell setCoupnCell:model];
            return cell;
        }
        
    }
    else{
        // 头部展开列表
        static NSString *MenuIdentifier = @"MenuIdentifier";
        ComboxViewCell *cell = [atableView dequeueReusableCellWithIdentifier:MenuIdentifier];
        if (cell == nil){
            cell = [[ComboxViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MenuIdentifier];
            cell.textLabel.font = fontSystem(kFontS4);
            cell.textLabel.textColor = RGBHex(qwColor1);
        }
        
        NSString *content = nil;
        BOOL showImage = NO;
        if([atableView isEqual:rightComboxView.tableView])
        {
            // 全部来源
            content = rightMenuItems[indexPath.row];
            if(indexPath.row == rightIndex) {
                showImage = YES;
            }
        }else if([atableView isEqual:newrightComboxView.tableView])
        {
            // 可领用
            content = newrightMenuItems[indexPath.row];
            if(indexPath.row == newrightIndex) {
                showImage = YES;
            }
        }else
        {
            // 类型
            content = centerrightMenuItems[indexPath.row];
            if(indexPath.row == centerrightIndex) {
                showImage = YES;
            }
        
        }
        
        [cell setCellWithContent:content showImage:showImage];
        return cell;
    }
}


- (void)tableView:(UITableView *)atableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [atableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 断网提示
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:0.8f];
        return;
    }

    if([atableView isEqual:self.rootTableView])
    {
        // 主列表
        if(self.vcController.SendNewBranch){
            // IM 发送优惠券
            BranchCouponVo *mode = (BranchCouponVo *)self.dataSource[indexPath.row];
            self.vcController.SendNewBranch(mode,nil);
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }else{
            // 优惠券详情
            BranchdetailCViewController *vc = [[BranchdetailCViewController alloc] initWithNibName:@"BranchdetailCViewController" bundle:nil];
            vc.hidesBottomBarWhenPushed = YES;
            BranchCouponVo * model = self.dataSource[indexPath.row];
            vc.coupnId = model.couponId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }

    else  if ([atableView isEqual:rightComboxView.tableView])
    {
        // 全部来源
        rightIndex = indexPath.row;
        [rightButton setButtonTitle:rightMenuItems[indexPath.row]];
        [rightComboxView dismissView];
        [self detailflag:YES header:@"footer"];
        [rightComboxView.tableView reloadData];
        
    }else if ([atableView isEqual:newrightComboxView.tableView])
    {
        // 可领用/未领用
        newrightIndex = indexPath.row;
        [newrightButton setButtonTitle:newrightMenuItems[indexPath.row]];
        [newrightComboxView dismissView];
        [self detailflag:YES header:@"footer"];
        [newrightComboxView.tableView reloadData];
    }else
    {
        // 全部来源
        centerrightIndex = indexPath.row;
        [centerrightButton setButtonTitle:centerrightMenuItems[indexPath.row]];
        [centerrightComboxView dismissView];
        [self detailflag:YES header:@"footer"];
        [centerrightComboxView.tableView reloadData];

    }
}

#pragma mark ---- 请求优惠列表 ----

-(void)detailflag:(BOOL)flag header:(NSString*)isHeader
{
    [self removeInfoView];
    
    // 断网提示
    if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
        [self showInfoView:kWaring12 image:@"img_network"];
        return;
    }
    
    if (flag){  //需要清空数组
        currentPage = 1;
        [self.rootTableView.footer setCanLoadMore:YES];
    }
    
    CoupnListModelR * modelR = [CoupnListModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.page = [NSNumber numberWithInteger:currentPage];
    modelR.pageSize = @10;
    modelR.all=@"N";
    
    switch (rightIndex) {
        case 0:
        {
            // 全部来源
            modelR.source = @"0";
            break;
        }
        case 1:
        {
            // 来源商家
            modelR.source = @"2";
            break;
        }
        case 2:
        {
            // 来源全维
            modelR.source = @"1";
            break;
        }
        default:
            break;
    }
    
    switch (centerrightIndex) {
        case 0:
        {
//            modelR.scope = @1;
            break;
        }
        case 1:
        {
            modelR.scope = @1;
            break;
        }
        case 2:
        {
            modelR.scope = @4;
            break;
        }
        case 3:
        {
            modelR.scope = @6;
            break;
        }
        case 4:
        {
            modelR.scope = @8;
            break;
        }
        default:
            break;
    }
    
    switch (newrightIndex) {
        case 0:
        {
            //全部
            modelR.pickStatus = @"0";
            break;
        }
        case 1:
        {
            //可领用
            modelR.pickStatus = @"1";
            break;
        }
        case 2:
        {
            //已领完
            modelR.pickStatus = @"2";
            break;
        }
        default:
            break;
    }
    
    if ([self.couponFromIM isEqualToString:@"1"]) {
        modelR.forMessageSend = true;
    }
    
    [Coupn GetAllCoupnParams:modelR success:^(id responseObj) {
        
        BranchCouponArrayVo *model = [BranchCouponArrayVo parse:responseObj Elements:[BranchCouponVo class] forAttribute:@"coupons"];
        
        if (flag) { // 需要清空数组
            [self.dataSource removeAllObjects];
        }
        
        if(model.coupons.count > 0)
        {
            [self removeInfoView];
            
            [self.dataSource addObjectsFromArray:model.coupons];
            currentPage++;
            [self.rootTableView reloadData];
            
            // 缓存数据
            if (isFirstRequest) {
                isFirstRequest = NO;
                [QWUserDefault setObject:self.dataSource key:[NSString stringWithFormat:@"branchCoupon%@",QWGLOBALMANAGER.configure.passportId]];
            }
            
        }else
        {
            if (currentPage==1) {//第一页且没有数据
                [self showInfoView:@"暂无优惠券" image:@"img_vouchers" flatY:40];
            }else{
                self.rootTableView.footer.canLoadMore=NO;
                [self removeInfoView];
            }
        }
        
        // 停止刷新
        if([isHeader isEqualToString:@"header"]){
            [self.rootTableView headerEndRefreshing];
        }else{
            [self.rootTableView footerEndRefreshing];
        }
        
    } failure:^(HttpException *e) {
        // 停止刷新
        if([isHeader isEqualToString:@"header"]){
            [self.rootTableView headerEndRefreshing];
        }else{
            [self.rootTableView footerEndRefreshing];
        }
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [self showInfoView:kWaring12 image:@"img_network"];
        }else{
            if(e.errorCode!=-999){
                if(e.errorCode == -1001){
                    [self showInfoView:kWarning215N54 image:@"img_vouchers"];
                }else{
                    [self showInfoView:kWarning215N0 image:@"img_vouchers"];
                }
            }
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
