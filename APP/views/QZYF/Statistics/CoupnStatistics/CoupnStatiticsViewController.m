//
//  CoupnStatiticsViewController.m
//  wenyao
//
//  Created by caojing on 14-9-17.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "CoupnStatiticsViewController.h"
#import "MXPullDownMenu.h"
#import "ComboxViewCell.h"
#import "SellStatistics.h"
#import "WebDirectViewController.h"
#import "FirstCoupnTableViewCell.h"
#import "ThreeCoupnTableViewCell.h"

@interface CoupnStatiticsViewController ()<MXPullDownMenuDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSUInteger                  currentPage;
    //选择框的标志
//    NSUInteger                  leftIndex;
    NSUInteger                  rightIndex;
}

@property (nonatomic, strong) NSMutableArray           *couponsSource;
@property (nonatomic, strong) NSMutableArray           *overdueCouponsSource;
@property (nonatomic, strong) UITableView           *rootTableView;

@end

@implementation CoupnStatiticsViewController

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
    
    if (QWGLOBALMANAGER.configure.storeType == 3) {
        self.title=@"优惠券统计";
    }else{
        self.title=@"优惠券消费统计";
    }
    
    currentPage = 1;
    self.couponsSource = [NSMutableArray array];
    self.overdueCouponsSource = [NSMutableArray array];
    
    // 设置 tableView
    [self setupTableView];
    
    // 设置头部选择框
    NSArray *pullArray = @[@[@"全部来源",@"来源商家",@"来源全维"]];
    MXPullDownMenu *menu = [[MXPullDownMenu alloc] initWithArray:pullArray selectedColor:RGBHex(qwColor1)];
    menu.delegate = self;
    menu.frame = CGRectMake(0, 0, menu.frame.size.width, menu.frame.size.height);
    [self.view addSubview:menu];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring33 image:@"img_network"];
    }else{
        [self queryCoupnWithFlag:NO header:@"footer"];
    }
    
}

- (void)setupTableView
{
    self.rootTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, APP_W, APP_H-NAV_H-40) style:UITableViewStylePlain];
    self.rootTableView.delegate = self;
    self.rootTableView.dataSource = self;
    self.rootTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.rootTableView setBackgroundColor:RGBHex(qwColor11)];
//    [self.rootTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self enableSimpleRefresh:self.rootTableView block:^(SRRefreshView *sender) {
        [self headerRefresh];
    }];
    
    
    [self.rootTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.rootTableView.footerPullToRefreshText = kWaring6;
    self.rootTableView.footerReleaseToRefreshText = kWaring7;
    self.rootTableView.footerRefreshingText = kWaring9;
    self.rootTableView.footerNoDataText = kWaring55;
    [self.view addSubview:self.rootTableView];
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
    [self queryCoupnWithFlag:NO header:@"footer"];
}

#pragma mark ---- 头部刷新 ----

- (void)headerRefresh
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
        return;
    }
    [self queryCoupnWithFlag:YES header:@"header"];
    [self.rootTableView headerEndRefreshing];
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

#pragma mark ---- MXPullDownMenu Delegate ----

- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu didSelectRowAtColumn:(NSInteger)column row:(NSInteger)row
{
    if(column == 0){//点击左边的
        rightIndex = row;
        [self queryCoupnWithFlag:YES header:@"footer"];
        return;
    }
}

#pragma mark ---- 获取列表数据 ----

- (void)queryCoupnWithFlag:(BOOL)flag header:(NSString *)isHeader;
{
    [self removeInfoView];
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        return;
    }
    //清空数组
    if (flag) {
        currentPage = 1;
        self.rootTableView.footer.canLoadMore = YES;
    }
    
    QueryStatisticsModelR *activitR = [QueryStatisticsModelR new];
    activitR.token = QWGLOBALMANAGER.configure.userToken;
    activitR.page = [NSString stringWithFormat:@"%lu",(unsigned long)currentPage];
    activitR.pageSize = @"10";
    
    switch (rightIndex)
    {
        case 0:
        {
            activitR.source = @"0";
            break;
        }
        case 1:
        {
            activitR.source = @"2";
            break;
        }
        case 2:
        {
            activitR.source = @"1";
            break;
        }
        default:
            
            break;
    }
    
    [SellStatistics GetCoupnSellWithParams:activitR success:^(id resultObj) {
        
        StatisticsCoupnListModel *activitys = (StatisticsCoupnListModel*)resultObj;
        if(flag){
            [self.overdueCouponsSource removeAllObjects];
            [self.couponsSource removeAllObjects];
        }
        
        if(activitys.coupons.count > 0 || activitys.overdueCoupons.count > 0)
        {
            [self.couponsSource addObjectsFromArray:activitys.coupons];
            [self.overdueCouponsSource addObjectsFromArray:activitys.overdueCoupons];
            [self removeInfoView];
            [self tableViewReloadData];
            currentPage++;
        }else
        {
            if(currentPage == 1){
                
                if (QWGLOBALMANAGER.configure.storeType == 3) {
                    [self showInfoView:@"暂无优惠券统计" image:@"img_statistical" flatY:40];
                }else{
                    [self showInfoView:@"暂无优惠券消费统计" image:@"img_statistical" flatY:40];
                }
                
            }else{
                self.rootTableView.footer.canLoadMore = NO;
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
        if([isHeader isEqualToString:@"header"]){
            [self.rootTableView headerEndRefreshing];
        }else{
            [self.rootTableView footerEndRefreshing];
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
    [self.rootTableView reloadData];
}

- (void)hiddenTableViewHeader
{
    UIView *headView = (UIView *)[self.view viewWithTag:1008];
    if (headView) {
        [headView removeFromSuperview];
    }
    CGRect rect = self.view.frame;
    rect.origin.y = 0;
    self.rootTableView.frame = rect;
}

#pragma mark ---- 列表代理 ----

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if([tableView isEqual:self.rootTableView])
    {
        if(section==0){
            return 0;
        }else
        {
            if(self.overdueCouponsSource.count==0){
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
    if([tableView isEqual:self.rootTableView])
    {
        UIView *view=[[UIView alloc]init];
        UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, APP_W, 30)];
        if (section==0) {
            
        }else{
            NSString *str=@"已过期";
            CGSize size=[str boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil].size;
            lable.frame=CGRectMake((APP_W-size.width)/2, 5, size.width, 30);
            UIView *viewone=[[UIView alloc]initWithFrame:CGRectMake(15, 20, (APP_W-26-30-size.width)/2, 0.5)];
            UIView *viewtwo=[[UIView alloc]initWithFrame:CGRectMake(lable.frame.origin.x+size.width+13, 20, (APP_W-26-30-size.width)/2, 0.5)];
            viewone.backgroundColor=RGBHex(qwColor10);
            viewtwo.backgroundColor=RGBHex(qwColor10);
            lable.text=str;
            [view addSubview:viewone];
            [view addSubview:viewtwo];
        }
        lable.textColor=RGBHex(qwColor7);
        lable.font=[UIFont systemFontOfSize:14];
        lable.textAlignment=NSTextAlignmentCenter;
        view.backgroundColor=RGBHex(qwColor11);
        [view addSubview:lable];
        return view;
    }else
    {
        UIView *view=[[UIView alloc]init];
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([atableView isEqual:self.rootTableView])
        return 142;
    else
        return 46;
}

- (NSInteger)tableView:(UITableView *)atableView numberOfRowsInSection:(NSInteger)section
{
    if([atableView isEqual:self.rootTableView])
    {
        if(section==0){
            return self.couponsSource.count;
        }else{
            return self.overdueCouponsSource.count;
        }
    }else
    {
        return 10;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)atableView
{
    if(self.overdueCouponsSource.count>0){
        return 2;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([atableView isEqual:self.rootTableView])
    {
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
        
        StatisticsCoupnModel *mod=nil;
        NSString *overDue = @"";
        if(indexPath.section==0)
        {
            // 未过期的
            mod=(StatisticsCoupnModel*)self.couponsSource[indexPath.row];
            overDue = @"1";
            
        }else
        {
            // 已过期的
            mod=(StatisticsCoupnModel*)self.overdueCouponsSource[indexPath.row];
            overDue = @"2";
        }
        
        if(!StrIsEmpty(mod.giftImgUrl)){
            [Threecell setCouponStatisticsCell:mod overDure:overDue];
            return Threecell;
        }else{
            [cell setCouponStatisticsCell:mod overDure:overDue];
            return cell;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)atableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [atableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([atableView isEqual:self.rootTableView])
    {
        StatisticsCoupnModel *modelStatis =nil;
        
        WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
        WebStatisticsModel *modelS = [[WebStatisticsModel alloc] init];
        
        if(indexPath.section==0)
        {
            modelStatis= self.couponsSource[indexPath.row];
            NSString *dateString=modelStatis.begin==nil?@"":modelStatis.begin;
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *date=[dateFormatter dateFromString:dateString];
            modelStatis.begin = [dateFormatter stringFromDate:date];
            if (modelStatis.begin == nil) {
                modelStatis.begin = @"";
            }
            modelS.status = @"0";
        }else
        {
            modelStatis= self.overdueCouponsSource[indexPath.row];
            NSString *dateString=modelStatis.begin==nil?@"":modelStatis.begin;
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *date=[dateFormatter dateFromString:dateString];
            modelStatis.begin = [dateFormatter stringFromDate:date];
            if (modelStatis.begin == nil) {
                modelStatis.begin = @"";
            }
            modelS.status = @"1";
        }
        modelS.begin = modelStatis.begin;
        modelS.couponID = modelStatis.couponId;

        WebDirectLocalModel *modelLocal = [[WebDirectLocalModel alloc] init];
        modelLocal.modelStatis = modelS;
        
        if (QWGLOBALMANAGER.configure.storeType == 3) {
            modelLocal.typeLocalWeb = WebLocalTypeNewStatistics;
        }else{
            modelLocal.typeLocalWeb = WebLocalTypeStatistics;
        }
        [vcWebDirect setWVWithLocalModel:modelLocal];

        vcWebDirect.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vcWebDirect animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
