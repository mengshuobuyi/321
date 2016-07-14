//
//  ConsultPharmacyViewController.m
//  wenyao
//
//  Created by caojing on 14-9-17.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "PSStatiticsViewController.h"
#import "ComboxView.h"
#import "RightAccessButton.h"
#import "ComboxViewCell.h"
#import "PSecondStatiticsCellTableViewCell.h"
#import "SellStatistics.h"
#import "WebDirectViewController.h"

@interface PSStatiticsViewController ()<ComboxViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    ComboxView                  *rightComboxView;
    RightAccessButton           *rightButton;
    NSArray                     *rightMenuItems;
    NSUInteger                  currentPage;
    NSUInteger                  rightIndex;
}

@property (nonatomic, strong) NSMutableArray           *dataSource;
@property (nonatomic, strong) NSMutableArray           *rpts;
@property (nonatomic, strong) NSMutableArray           *overdueRpts;

@end

@implementation PSStatiticsViewController

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
    
    self.dataSource = [NSMutableArray array];
    self.rpts = [NSMutableArray array];
    self.overdueRpts = [NSMutableArray array];
    
    currentPage = 1;
    rightMenuItems = @[@"全部来源",@"来源商家",@"来源全维"];

    [self setupTableView];
    [self setupHeaderView];
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring33 image:@"img_network"];
    }else{
        [self queryCoupnWithFlag:NO header:@"footer"];
    }
}

- (void)viewInfoClickAction:(id)sender
{
    [self removeInfoView];
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring33 image:@"img_network"];
    }else{
        [self queryCoupnWithFlag:NO header:@"footer"];
    }
}

#pragma mark ---- 设置 tableView ----

- (void)setupTableView
{
    self.PStableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.PStableView addFooterWithTarget:self action:@selector(footerRereshing)];
//    [self.PStableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self enableSimpleRefresh:self.PStableView block:^(SRRefreshView *sender) {
        [self headerRefresh];
    }];
    
    self.PStableView.footerPullToRefreshText = kWaring6;
    self.PStableView.footerReleaseToRefreshText = kWaring7;
    self.PStableView.footerRefreshingText = kWaring9;
    self.PStableView.footerNoDataText = kWaring55;
    self.PStableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.PStableView.backgroundColor =RGBHex(qwColor11);
}

#pragma mark ---- 设置头部 展开列表 ----

- (void)setupHeaderView
{
    UIImageView *headerView = nil;
    if(![self.view viewWithTag:1008])
    {
        headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 40)];
        headerView.tag = 1008;
        headerView.userInteractionEnabled = YES;
        headerView.backgroundColor = RGBHex(qwColor4);
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, APP_W, 0.5)];
        line.backgroundColor = RGBHex(qwColor10);
        [headerView addSubview:line];
        
        rightButton = [[RightAccessButton alloc] initWithFrame:CGRectMake(0, 0, APP_W, 40)];
        [headerView addSubview:rightButton];
        
        UIImageView *accessView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        [accessView2 setImage:[UIImage imageNamed:@"icon_downArrow"]];
        rightButton.accessIndicate = accessView2;
        [rightButton setCustomColor:RGBHex(qwColor7)];
        [rightButton setButtonTitle:@"全部来源"];
        [rightButton addTarget:self action:@selector(showRightTable:) forControlEvents:UIControlEventTouchDown];
        
        rightComboxView = [[ComboxView alloc] initWithFrame:CGRectMake(0, 40, APP_W, [rightMenuItems count]*46)];
        rightComboxView.delegate = self;
        rightComboxView.comboxDeleagte = self;
        
        rightIndex = 0;
        
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
    [self queryCoupnWithFlag:YES header:@"header"];
}

#pragma mark ---- 尾部刷新 ----

- (void)footerRereshing
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
        [self.PStableView.footer endRefreshing];
        return;
    }
    [self queryCoupnWithFlag:NO header:@"footer"];
}

#pragma mark ---- 获取列表数据 ----

- (void)queryCoupnWithFlag:(BOOL)flag header:(NSString *)isHeader
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        return;
    }
    
    [self removeInfoView];
    //清空数组
    if (flag) {
        currentPage = 1;
        self.PStableView.footer.canLoadMore=YES;
    }
    
    QueryStatisticsPSModelR *activitR=[QueryStatisticsPSModelR new];
    activitR.token=QWGLOBALMANAGER.configure.userToken;
    activitR.pageSize=@"10";
    activitR.proId=self.proId;
    activitR.page=[NSString stringWithFormat:@"%lu",(unsigned long)currentPage];
    switch (rightIndex)
    {
        case 0:
        {
            activitR.source=@"0";
            break;
        }
        case 1:
        {
            activitR.source=@"2";
            break;
        }
        case 2:
        {
            activitR.source=@"1";
            break;
        }
        default:
            
            break;
    }
    
    [SellStatistics GetPSSellWithParams:activitR success:^(id resultObj) {
        
        RptPromotionArrayVo *activitys=(RptPromotionArrayVo*)resultObj;
        if(flag){
            [self.rpts removeAllObjects];
            [self.overdueRpts removeAllObjects];
        }
        if(activitys.rpts.count>0||activitys.overdueRpts.count>0){
            [self removeInfoView];
            [self.dataSource addObject:activitys];
            [self.rpts addObjectsFromArray:activitys.rpts];
            [self.overdueRpts addObjectsFromArray:activitys.overdueRpts];
            [self tableViewReloadData];
            currentPage++;
        }else{
            if(currentPage==1){
                [self showInfoView:@"暂无该商品的销量统计" image:@"img_statistical" flatY:40];
            }else{
                self.PStableView.footer.canLoadMore=NO;
                [self removeInfoView];
            }
        }
        
        // 停止刷新
        if([isHeader isEqualToString:@"header"]){
            [self.PStableView headerEndRefreshing];
        }else{
            [self.PStableView footerEndRefreshing];
        }
        
    } failure:^(HttpException *e) {
        if([isHeader isEqualToString:@"header"]){
            [self.PStableView headerEndRefreshing];
        }else{
            [self.PStableView footerEndRefreshing];
        }
        
        if(e.errorCode!=-999){
            if(e.errorCode == -1001){
                [self showInfoView:kWarning215N54 image:@"img_statistical"];
            }else{
                [self showInfoView:kWarning215N0 image:@"img_statistical"];
            }
        }
    }];
}

- (void)tableViewReloadData
{
    //如果断网情况下,就把顶端的空间给移除
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self hiddenTableViewHeader];
    }
    [self.PStableView reloadData];
}

- (void)hiddenTableViewHeader
{
    UIView *headView = (UIView *)[self.view viewWithTag:1008];
    if (headView) {
        [headView removeFromSuperview];
    }
    CGRect rect = self.view.frame;
    rect.origin.y = 0;
    self.PStableView.frame = rect;
}

#pragma mark ---- 点击按钮 展开头部选择列表 ----

- (void)showRightTable:(id)sender
{
    if(rightButton.isToggle) {
        [rightComboxView dismissView];
        [rightButton changeArrowDirectionUp:NO];
    }else{
        [rightComboxView showInView:self.view];
        [rightButton changeArrowDirectionUp:YES];
        rightButton.isToggle = YES;
    }
}

#pragma mark ---- combox Delegate ----

- (void)comboxViewDidDisappear:(ComboxView *)comboxView
{
    if([comboxView isEqual:rightComboxView])
    {
        [rightButton changeArrowDirectionUp:NO];
        rightButton.isToggle = NO;
    }
}

#pragma mark ---- 列表代理 ----

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if([tableView isEqual:self.PStableView])
    {
        if(section == 0){
            return 0;
        }else
        {
            if(self.overdueRpts.count == 0){
                return 0;
            }else{
                return 30;
            }
        }
    }else
    {
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if([tableView isEqual:self.PStableView])
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_W, 30)];
        [view setBackgroundColor:RGBHex(qwColor11)];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 12, APP_W, 15)];
        if (section == 0) {

        }else{
            
            NSString *str = [NSString stringWithFormat:@"已过期"];
            CGSize size = [str boundingRectWithSize:CGSizeMake(APP_W-30, 1000) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil].size;
            
            UIView *viewone = [[UIView alloc]initWithFrame:CGRectMake(15, 20, (APP_W-60-size.width)/2, 1.0)];
            UIView *viewtwo = [[UIView alloc]initWithFrame:CGRectMake(APP_W-15-(APP_W-60-size.width)/2, 20, (APP_W-60-size.width)/2, 1.0)];
            viewone.backgroundColor = RGBHex(qwColor10);
            viewtwo.backgroundColor = RGBHex(qwColor10);
            
            [view addSubview:viewone];
            [view addSubview:viewtwo];
            lable.text = str;
        }
        lable.textColor = RGBHex(qwColor7);
        lable.font = [UIFont systemFontOfSize:13];
        lable.textAlignment = NSTextAlignmentCenter;
        view.backgroundColor = RGBHex(qwColor11);
        [view addSubview:lable];
        return view;
    }else
    {
        UIView *view = [[UIView alloc]init];
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([atableView isEqual:self.PStableView])
        return [PSecondStatiticsCellTableViewCell getCellHeight:nil];
    else
        return 46;
}

- (NSInteger)tableView:(UITableView *)atableView numberOfRowsInSection:(NSInteger)section
{
    if([atableView isEqual:self.PStableView])
    {
        if(section == 0){
            return self.rpts.count;
        }else{
            return self.overdueRpts.count;
        }
    }else
    {
        return [rightMenuItems count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)atableView
{
    if([atableView isEqual:self.PStableView])
    {
        if(self.overdueRpts.count > 0){
          return 2;
        }else{
          return 1;
        }
    }else
    {
         return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([atableView isEqual:self.PStableView])
    {
        // 主列表
        static NSString *CoupnIdentifier = @"PSIdentifier";
        PSecondStatiticsCellTableViewCell *cell = (PSecondStatiticsCellTableViewCell *)[atableView dequeueReusableCellWithIdentifier:CoupnIdentifier];
        if(cell == nil){
            UINib *nib = [UINib nibWithNibName:@"PSecondStatiticsCellTableViewCell" bundle:nil];
            [atableView registerNib:nib forCellReuseIdentifier:CoupnIdentifier];
            cell = (PSecondStatiticsCellTableViewCell *)[atableView dequeueReusableCellWithIdentifier:CoupnIdentifier];
        }
        
        RptPromotionArrayVo *model = (RptPromotionArrayVo*)self.dataSource[0];
        RptPromotionVo *mod = nil;
        
        if(indexPath.section == 0){
         mod = (RptPromotionVo*)self.rpts[indexPath.row];
        }else{
         mod = (RptPromotionVo*)self.overdueRpts[indexPath.row];
        }
        
        cell.productName.text = model.productName;
        cell.spec.text = model.spec;
        cell.factory.text = model.factory;
        [cell.productLogo setImageWithURL:[NSURL URLWithString:model.productLogo] placeholderImage:[UIImage imageNamed:@"img_goods_default"] options:SDWebImageRetryFailed|SDWebImageContinueInBackground];
        [cell setCell:mod];
        return cell;
    }else
    {
        // 头部选择列表
        static NSString *MenuIdentifier = @"MenuIdentifier";
        ComboxViewCell *cell = [atableView dequeueReusableCellWithIdentifier:MenuIdentifier];
        if (cell == nil)
        {
            cell = [[ComboxViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MenuIdentifier];
            cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
            cell.textLabel.textColor = RGBHex(qwColor7);
        }
        NSString *content = nil;
        BOOL showImage = NO;
        content = rightMenuItems[indexPath.row];
        if(indexPath.row == rightIndex) {
            showImage = YES;
        }
        [cell setCellWithContent:content showImage:showImage];
        return cell;
    }
}

- (void)tableView:(UITableView *)atableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [atableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([atableView isEqual:self.PStableView])
    {
        RptPromotionVo *modelStatis = nil;
        WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
        WebStatisticsModel *modelS = [[WebStatisticsModel alloc] init];
        
        if(indexPath.section == 0)
        {
            modelStatis = self.rpts[indexPath.row];
            NSString *dateString = modelStatis.begin == nil ? @"":modelStatis.begin;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *date = [dateFormatter dateFromString:dateString];
            modelStatis.begin = [dateFormatter stringFromDate:date];
            if (modelStatis.begin == nil) {
                modelStatis.begin = @"";
            }
             modelS.status = @"0";
        }else
        {
            modelStatis = self.overdueRpts[indexPath.row];
            NSString *dateString = modelStatis.begin == nil ? @"":modelStatis.begin;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *date = [dateFormatter dateFromString:dateString];
            modelStatis.begin = [dateFormatter stringFromDate:date];
            if (modelStatis.begin == nil) {
                modelStatis.begin = @"";
            }
             modelS.status = @"1";
        }
        modelS.begin = modelStatis.begin;
        modelS.couponID = modelStatis.pid;
        
        WebDirectLocalModel *modelLocal = [[WebDirectLocalModel alloc] init];
        modelLocal.modelStatis = modelS;
        modelLocal.typeLocalWeb = WebLocalTypeProSatistics;
        [vcWebDirect setWVWithLocalModel:modelLocal];

        vcWebDirect.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vcWebDirect animated:YES];
        
    }else{
        
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [SVProgressHUD showErrorWithStatus:kWaring33 duration:0.8f];
            return;
        }
        rightIndex = indexPath.row;
        [rightButton setButtonTitle:rightMenuItems[indexPath.row]];
        [rightComboxView dismissView];
        [self queryCoupnWithFlag:YES header:@"footer"];
        [rightComboxView.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
