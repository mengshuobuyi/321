//
//  ConsultPharmacyViewController.m
//  wenyao
//
//  Created by xiezhenghong on 14-9-17.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "BranchProductViewController.h"
#import "ComboxView.h"
#import "ComboxViewCell.h"
#import "RightAccessButton.h"
#import "SecondProductTableViewCell.h"
#import "BranchdetailPViewController.h"
#import "WebDirectViewController.h"
#import "ButtonsView.h"
#import "OrganAuthTotalViewController.h"
#import "OrganAuthCommitOkViewController.h"

@interface BranchProductViewController ()<ComboxViewDelegate,
MAMapViewDelegate,UIAlertViewDelegate,UIAlertViewDelegate,UISearchBarDelegate,ButtonsViewDelegate>

{
    NSInteger               currentPageAgain;
    
    ComboxView              *leftComboxViewAgain;       // 全部优惠
    ComboxView              *centerComboxViewAgain;     // 全部来源
    ButtonsView             *buttonsView;               // 全部类型
    
    RightAccessButton       *leftButtonAgain;
    RightAccessButton       *centerButtonAgain;
    RightAccessButton       *rightButtonAgain;
    
    NSArray                 *leftMenuItemsAgain;
    NSArray                 *centerMenuItemsAgain;
    NSMutableArray          *rightMenuItemsAgain;
    
    NSUInteger              leftIndexAgain;
    NSUInteger              centerIndexAgain;
    NSUInteger              rightIndexAgain;
    
    BOOL isFirstRequest;   // 第一次进入该页面，请求数据，做缓存用
}

@property (nonatomic, strong) NSMutableArray           *dataSourceAgain;
@property (nonatomic ,strong) UITableView              *rootTableViewAgain;
@property (strong, nonatomic) OrganAuthTotalViewController *vcOrganAuthTotal;
@property (strong, nonatomic) OrganAuthCommitOkViewController *vcOrganAuthCommitOk;
@end

@implementation BranchProductViewController

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
    
    if (self.isFromActivity) {
        self.navigationItem.title = @"优惠商品";
    }else{
        self.navigationItem.title = @"本店商品";
    }
    
    if (!OrganAuthPass) {
        return;
    }
    
    currentPageAgain = 1;
    isFirstRequest = YES;
    self.dataSourceAgain = [NSMutableArray array];
    
    leftMenuItemsAgain = @[@"全部优惠",@"买赠",@"折扣",@"抵现",@"特价"];
    centerMenuItemsAgain=@[@"全部来源",@"来源商家",@"来源全维"];
    rightMenuItemsAgain =[NSMutableArray arrayWithObject:@"全部类型"];
    
    // 请求全部类型的标签
    [self loadTags];
    
    // 设置tableView
    [self setupTableView];
    
    // 设置列表的header
    [self setupHeaderView];
    
    // 获取优惠商品数据
    [self queryDataList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!OrganAuthPass)
    {
        if ([QWGLOBALMANAGER.configure.approveStatus integerValue] == 4 || [QWGLOBALMANAGER.configure.approveStatus integerValue] == 2)
        {
            self.vcOrganAuthTotal = [[UIStoryboard storyboardWithName:@"OrganAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"OrganAuthTotalViewController"];
            [self.view addSubview:self.vcOrganAuthTotal.view];
            return;
            
            
        }else if ([QWGLOBALMANAGER.configure.approveStatus integerValue] == 1)
        {
            self.vcOrganAuthCommitOk = [[UIStoryboard storyboardWithName:@"OrganAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"OrganAuthCommitOkViewController"];
            [self.view addSubview:self.vcOrganAuthCommitOk.view];
            return;
        }
    }
}
#pragma mark ---- 获取优惠商品数据 ----

- (void)queryDataList
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        
        NSArray *arr = [QWUserDefault getObjectBy:[NSString stringWithFormat:@"couponProduct%@",QWGLOBALMANAGER.configure.passportId]];
        if (arr.count >0) {
            [self removeInfoView];
            [self.dataSourceAgain addObjectsFromArray:arr];
            [self.rootTableViewAgain reloadData];
        }else{
            [self showInfoView:@"暂无优惠商品" image:@"img_preferential" flatY:40];
        }
    }else
    {
        [self detailflag:NO header:@"footer"];
    }
    
}

#pragma mark ---- 获取全部类型的标签 ----

- (void)loadTags
{
    TagModelR *modelR = [TagModelR new];
    modelR.token=QWGLOBALMANAGER.configure.userToken;
    
    [Coupn queryTagWithParams:modelR success:^(id obj) {
        
        TagFilterList *List = [TagFilterList parse:obj Elements:[TagFilterVo class] forAttribute:@"list"];
        [rightMenuItemsAgain  addObjectsFromArray: List.list];
        
    } failure:^(HttpException *e) {
    }];
}

#pragma mark ---- 设置 tableView ----

- (void)setupTableView
{
    self.rootTableViewAgain = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, APP_W, APP_H-NAV_H-40) style:UITableViewStylePlain];
    self.rootTableViewAgain.delegate = self;
    self.rootTableViewAgain.dataSource = self;
    self.rootTableViewAgain.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.rootTableViewAgain setBackgroundColor:[UIColor clearColor]];
    
    [self.rootTableViewAgain addFooterWithTarget:self action:@selector(footerRereshing)];
   // [self.rootTableViewAgain addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self enableSimpleRefresh:self.rootTableViewAgain block:^(SRRefreshView *sender) {
        [self headerRefresh];
    }];
    self.rootTableViewAgain.footerPullToRefreshText = kWaring6;
    self.rootTableViewAgain.footerReleaseToRefreshText = kWaring7;
    self.rootTableViewAgain.footerRefreshingText = kWaring9;
    self.rootTableViewAgain.footerNoDataText = kWaring55;
    
    [self.view addSubview:self.rootTableViewAgain];
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
        [self.rootTableViewAgain.footer endRefreshing];
        return;
    }
    HttpClientMgr.progressEnabled = NO;
    [self detailflag:NO header:@"footer"];
}

- (void)tableViewReloadData
{
    [self.rootTableViewAgain reloadData];
}

#pragma mark ---- 设置列表 header ----

- (void)setupHeaderView
{
    UIImageView *headerView = nil;
    
    if(![self.view viewWithTag:1009])
    {
        headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 40)];
        headerView.tag = 1009;
        headerView.userInteractionEnabled = YES;
        headerView.backgroundColor = RGBHex(qwColor4);
        
        UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0,39.5,APP_W, 0.5)];
        line3.backgroundColor = RGBHex(qwColor10);
        [headerView addSubview:line3];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(APP_W/3, 4, 0.5, 30)];
        line.backgroundColor = RGBHex(qwColor10);
        [headerView addSubview:line];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(APP_W*2/3,4,0.5, 30)];
        line2.backgroundColor = RGBHex(qwColor10);
        [headerView addSubview:line2];
        
        leftButtonAgain = [[RightAccessButton alloc] initWithFrame:CGRectMake(0, 0, APP_W / 3.0, 40)];
        [headerView addSubview:leftButtonAgain];
        
        centerButtonAgain = [[RightAccessButton alloc] initWithFrame:CGRectMake(APP_W / 3.0,0, APP_W / 3.0, 40)];
        [headerView addSubview:centerButtonAgain];
        
        rightButtonAgain = [[RightAccessButton alloc] initWithFrame:CGRectMake(APP_W * 2/ 3.0, 0, APP_W / 3.0, 40)];
        [headerView addSubview:rightButtonAgain];
        
        UIImageView *accessView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        UIImageView *accessView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        UIImageView *accessView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        
        [accessView1 setImage:[UIImage imageNamed:@"icon_downArrow"]];
        [accessView2 setImage:[UIImage imageNamed:@"icon_downArrow"]];
        [accessView3 setImage:[UIImage imageNamed:@"icon_downArrow"]];
        
        leftButtonAgain.accessIndicate = accessView1;
        centerButtonAgain.accessIndicate = accessView2;
        rightButtonAgain.accessIndicate = accessView3;
        
        [leftButtonAgain setCustomColor:RGBHex(qwColor7)];
        [centerButtonAgain setCustomColor:RGBHex(qwColor7)];
        [rightButtonAgain setCustomColor:RGBHex(qwColor7)];
        
        [leftButtonAgain setButtonTitle:@"全部优惠"];
        [centerButtonAgain setButtonTitle:@"全部来源"];
        [rightButtonAgain setButtonTitle:@"全部类型"];
        
        [leftButtonAgain addTarget:self action:@selector(showLeftTableAgain:) forControlEvents:UIControlEventTouchDown];
        [centerButtonAgain addTarget:self action:@selector(showCenterTableAgain:) forControlEvents:UIControlEventTouchDown];
        [rightButtonAgain addTarget:self action:@selector(showRightTableAgain:) forControlEvents:UIControlEventTouchDown];
        
        leftComboxViewAgain = [[ComboxView alloc] initWithFrame:CGRectMake(0, 40, APP_W, [leftMenuItemsAgain count]*46)];
        leftComboxViewAgain.delegate = self;
        leftComboxViewAgain.comboxDeleagte = self;
        leftComboxViewAgain.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        centerComboxViewAgain = [[ComboxView alloc] initWithFrame:CGRectMake(0, 40, APP_W, [centerMenuItemsAgain count]*46)];
        centerComboxViewAgain.delegate = self;
        centerComboxViewAgain.comboxDeleagte = self;
        centerComboxViewAgain.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        leftIndexAgain = 0;
        centerIndexAgain = 0;
        rightIndexAgain = 0;
        
    }else{
        headerView = (UIImageView *)[self.view viewWithTag:1009];
    }
    [self.view addSubview:headerView];
}

#pragma mark ---- 显示全部优惠 列表 ----

- (void)showLeftTableAgain:(id)sender
{
    [centerButtonAgain changeArrowDirectionUp:NO];
    centerButtonAgain.isToggle = NO;
    [centerComboxViewAgain dismissView];
    
    [rightButtonAgain changeArrowDirectionUp:NO];
    rightButtonAgain.isToggle = NO;
    
    if(leftButtonAgain.isToggle) {
        [leftComboxViewAgain dismissView];
        [leftButtonAgain changeArrowDirectionUp:NO];
    }else{
        [leftButtonAgain setTitleColor:RGBHex(qwColor1) forState:UIControlStateNormal];
        [leftComboxViewAgain showInView:self.view];
        [leftButtonAgain changeArrowDirectionUp:YES];
        leftButtonAgain.isToggle = YES;
    }
}

#pragma mark ---- 显示全部来源 列表 ----

- (void)showCenterTableAgain:(id)sender
{
    [leftButtonAgain changeArrowDirectionUp:NO];
    leftButtonAgain.isToggle = NO;
    [leftComboxViewAgain dismissView];
    
    [rightButtonAgain changeArrowDirectionUp:NO];
    rightButtonAgain.isToggle = NO;
    
    if(centerButtonAgain.isToggle) {
        [centerComboxViewAgain dismissView];
        [centerButtonAgain changeArrowDirectionUp:NO];
    }else{
        [centerButtonAgain setTitleColor:RGBHex(qwColor1) forState:UIControlStateNormal];
        [centerComboxViewAgain showInView:self.view];
        [centerButtonAgain changeArrowDirectionUp:YES];
        centerButtonAgain.isToggle = YES;
    }
}

#pragma mark ---- 显示全部类型 标签 ----

- (void)showRightTableAgain:(id)sender
{
    [leftButtonAgain changeArrowDirectionUp:NO];
    leftButtonAgain.isToggle = NO;
    [leftComboxViewAgain dismissView];
    
    [centerButtonAgain changeArrowDirectionUp:NO];
    centerButtonAgain.isToggle = NO;
    [centerComboxViewAgain dismissView];
    
    if(rightButtonAgain.isToggle) {
        [rightButtonAgain changeArrowDirectionUp:NO];
    }else{
        [rightButtonAgain setTitleColor:RGBHex(qwColor1) forState:UIControlStateNormal];
        [rightButtonAgain changeArrowDirectionUp:YES];
        rightButtonAgain.isToggle = YES;
    }
    
    if(buttonsView.alpha == 0){
        buttonsView = [[ButtonsView alloc]initWithFrame:CGRectMake(0, 40, APP_W,164)];
        
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 1; i < rightMenuItemsAgain.count; i ++) {
            TagFilterVo *vo = rightMenuItemsAgain[i];
            [array addObject:vo.tagName];
        }
        [array insertObject:@"全部类型" atIndex:0];
        buttonsView.delegate = self;
        buttonsView.dataArray = array;
        buttonsView.selectIndex = rightIndexAgain;
        [buttonsView setButtons];
        buttonsView.alpha = 0;
        [UIView animateWithDuration:0.4 animations:^{
            buttonsView.alpha = 1;
        } completion:^(BOOL finished) {
            [self.view addSubview:buttonsView];
        }];
    }else{
        [buttonsView removeView];
    }
}

#pragma mark ---- comboxView 代理 ----

- (void)comboxViewWillDisappear:(ComboxView *)comboxView
{
    if([comboxView isEqual:leftComboxViewAgain]){
        [leftButtonAgain setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
        leftButtonAgain.isToggle = NO;
        [leftButtonAgain changeArrowDirectionUp:NO];
    }else if([comboxView isEqual:centerComboxViewAgain]){
        [centerButtonAgain setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
        centerButtonAgain.isToggle = NO;
        [centerButtonAgain changeArrowDirectionUp:NO];
    }else if([comboxView isEqual:buttonsView]){
        [rightButtonAgain setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
        rightButtonAgain.isToggle = NO;
        [rightButtonAgain changeArrowDirectionUp:NO];
    }
}

#pragma mark ---- 点击全部类型 标签 代理 ----

- (void)buttonsViewHasRemoved{
    
    [rightButtonAgain changeArrowDirectionUp:NO];
    [rightButtonAgain setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
    rightButtonAgain.isToggle = NO;
    rightButtonAgain.accessIndicate.image = [UIImage imageNamed:@"icon_downArrow"];
}

- (void)buttonDidSelected:(NSInteger)index
{
    currentPageAgain = 1;
    rightIndexAgain = index;
    
    if(index == 0){
        [rightButtonAgain setTitle:@"全部类型" forState:UIControlStateNormal];
    }else{
        TagFilterVo *vo = rightMenuItemsAgain[index];
        [rightButtonAgain setTitle:vo.tagName forState:UIControlStateNormal];
    }
    [self detailflag:YES header:@"footer"];
}

#pragma mark ---- 列表代理 ----

- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([atableView isEqual:self.rootTableViewAgain])
        return [SecondProductTableViewCell getCellHeight:nil];
    else
        return 46;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)atableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)atableView numberOfRowsInSection:(NSInteger)section
{
    if([atableView isEqual:self.rootTableViewAgain])
    {
        // 主列表
        return [self.dataSourceAgain count];
        
    }else if([atableView isEqual:leftComboxViewAgain.tableView])
    {
        // 全部优惠
        return [leftMenuItemsAgain count];
        
    } else if([atableView isEqual:centerComboxViewAgain.tableView])
    {
        // 全部来源
        return [centerMenuItemsAgain count];
        
    }else{
        return [rightMenuItemsAgain count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   if([atableView isEqual:self.rootTableViewAgain])
   {
       // 主列表
        static NSString *SecondProductCell = @"SecondProductCell";
        SecondProductTableViewCell *cell = (SecondProductTableViewCell *)[atableView dequeueReusableCellWithIdentifier:SecondProductCell];
        if(cell == nil){
            UINib *nib = [UINib nibWithNibName:@"SecondProductTableViewCell" bundle:nil];
            [atableView registerNib:nib forCellReuseIdentifier:SecondProductCell];
            cell = (SecondProductTableViewCell *)[atableView dequeueReusableCellWithIdentifier:SecondProductCell];
        }
       
        DrugVo *model=self.dataSourceAgain[indexPath.row];
        [cell setProductCell:model];
        return cell;
    }else
    {
        // 头部展开列表
        static NSString *MenuIdentifier = @"MenuIdentifier";
        ComboxViewCell *cell = [atableView dequeueReusableCellWithIdentifier:MenuIdentifier];
        if (cell == nil){
            cell = [[ComboxViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MenuIdentifier];
            cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
            cell.textLabel.textColor = RGBHex(qwColor7);
        }
        
        NSString *content = nil;
        BOOL showImage = NO;
        
        if([atableView isEqual:leftComboxViewAgain.tableView])
        {
            content = leftMenuItemsAgain[indexPath.row];
            if(indexPath.row == leftIndexAgain) {
                showImage = YES;
            }
            [cell setCellWithContent:content showImage:showImage withimage:(indexPath.row)];
            
        }else if([atableView isEqual:centerComboxViewAgain.tableView])
        {
            content = centerMenuItemsAgain[indexPath.row];
            if(indexPath.row == centerIndexAgain) {
                showImage = YES;
            }
            [cell setCellWithContent:content showImage:showImage];
            
        }else
        {
            content = rightMenuItemsAgain[indexPath.row];
            if(indexPath.row == rightIndexAgain) {
                showImage = YES;
            }
            [cell setCellWithContent:content showImage:showImage];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)atableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [atableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:0.8f];
        return;
    }

    if([atableView isEqual:self.rootTableViewAgain])
    {
        // 主列表
        DrugVo *model=self.dataSourceAgain[indexPath.row];
        
        if(self.vcController.SendNewBranch)
        {
            // IM 发送优惠商品
            
            self.vcController.SendNewBranch(nil,model);
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }else{
            
            // 药品详情
            
            WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
            WebDrugDetailModel *modelDrug = [[WebDrugDetailModel alloc] init];
            modelDrug.proDrugID = model.proId;
            modelDrug.promotionID = model.pid;
            
            WebDirectLocalModel *modelLocal = [[WebDirectLocalModel alloc] init];
            modelLocal.modelDrug = modelDrug;
            modelLocal.typeLocalWeb = WebLocalTypeCouponProduct;
            modelLocal.title = @"药品详情";
            [vcWebDirect setWVWithLocalModel:modelLocal];

            vcWebDirect.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vcWebDirect animated:YES];
        }
    }else if ([atableView isEqual:leftComboxViewAgain.tableView])
    {
        // 全部优惠列表
        
        leftIndexAgain = indexPath.row;
        [leftButtonAgain setButtonTitle:leftMenuItemsAgain[indexPath.row]];
        [leftComboxViewAgain dismissView];
        [self detailflag:YES header:@"footer"];
        [leftComboxViewAgain.tableView reloadData];
        
    }else if ([atableView isEqual:centerComboxViewAgain.tableView])
    {
        //  全部来源列表
        
        centerIndexAgain = indexPath.row;
        [centerButtonAgain setButtonTitle:centerMenuItemsAgain[indexPath.row]];
        [centerComboxViewAgain dismissView];
        [self detailflag:YES header:@"footer"];
        [centerComboxViewAgain.tableView reloadData];
    }
}

#pragma mark ---- 请求优惠商品 列表 ----

-(void)detailflag:(BOOL)flag header:(NSString *)isHeader
{
    [self removeInfoView];
    
    if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
        [self showInfoView:kWaring12 image:@"img_network"];
        return;
    }
    
    if (flag) {//需要清空数组
        currentPageAgain=1;
        [self.rootTableViewAgain.footer setCanLoadMore:YES];
    }
    
    DrugListModelR * modelR=[DrugListModelR new];
    modelR.token=QWGLOBALMANAGER.configure.userToken;
    modelR.page=[NSNumber numberWithInteger:currentPageAgain];
    modelR.pageSize=@10;
    
    switch (leftIndexAgain) {
        case 0:
        {
            // 全部优惠
            modelR.toolType = @0;
            break;
        }
        case 1:
        {
            // 买赠
            modelR.toolType = @1;
            break;
        }
        case 2:
        {
            // 折扣
            modelR.toolType = @2;
            break;
        }
        case 3:
        {
            // 抵现
            modelR.toolType = @3;
            break;
        }
        case 4:
        {
            // 特价
            modelR.toolType = @4;
            break;
        }
        default:
            break;
    }
    
    
    switch (centerIndexAgain) {
        case 0:
        {
            // 全部来源
            modelR.source = @0;
            break;
        }
        case 1:
        {
            // 来源商家
            modelR.source = @2;
            break;
        }
        case 2:
        {
            // 来源全维
            modelR.source = @1;
            break;
        }
        default:
            break;
    }
    
    if(!rightIndexAgain==0){
        TagFilterVo *model=rightMenuItemsAgain[rightIndexAgain];
        modelR.tagCode=model.tagCode;
    }
    
    if ([self.productFromIM isEqualToString:@"1"]) {
        modelR.forMessageSend = true;
    }
    
    [Coupn GetAllCoupnProductParams:modelR success:^(id responseObj) {
        
        if (flag) {//需要清空数组
            [self.dataSourceAgain removeAllObjects];
        }
        
        CoupnModel *model = [CoupnModel parse:responseObj Elements:[DrugVo class] forAttribute:@"list"];
        
        if(model.list.count>0)
        {
            [self removeInfoView];
            [self.dataSourceAgain addObjectsFromArray:model.list];
            currentPageAgain++;
            [self.rootTableViewAgain reloadData];
            
            // 缓存数据
            if (isFirstRequest) {
                isFirstRequest = NO;
                [QWUserDefault setObject:self.dataSourceAgain key:[NSString stringWithFormat:@"couponProduct%@",QWGLOBALMANAGER.configure.passportId]];
            }
        }else{
            if(currentPageAgain==1){
                [self showInfoView:@"暂无优惠商品" image:@"img_preferential" flatY:40];
            }else{
                self.rootTableViewAgain.footer.canLoadMore=NO;
                [self removeInfoView];
            }
        }
        
        // 停止刷新
        if([isHeader isEqualToString:@"header"]){
            [self.rootTableViewAgain headerEndRefreshing];
        }else{
            [self.rootTableViewAgain footerEndRefreshing];
        }
        
    } failure:^(HttpException *e) {
        // 停止刷新
        if([isHeader isEqualToString:@"header"]){
            [self.rootTableViewAgain headerEndRefreshing];
        }else{
            [self.rootTableViewAgain footerEndRefreshing];
        }
        
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [self showInfoView:kWaring12 image:@"img_network"];
        }else
        {
            if(e.errorCode!=-999){
                if(e.errorCode == -1001){
                    [self showInfoView:kWarning215N54 image:@"img_preferential"];
                }else{
                    [self showInfoView:kWarning215N0 image:@"img_preferential"];
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
