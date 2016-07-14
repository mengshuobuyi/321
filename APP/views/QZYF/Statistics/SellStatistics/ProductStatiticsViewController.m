//
//  ConsultPharmacyViewController.m
//  wenyao
//
//  Created by caojing on 14-9-17.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "ProductStatiticsViewController.h"
#import "ProductStatiticsCellTableViewCell.h"
#import "SellStatistics.h"
#import "PSStatiticsViewController.h"
#import "StaSearchDrugViewController.h"

@interface ProductStatiticsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSUInteger                  currentPage;
}

@property (nonatomic, strong) NSMutableArray           *dataSource;

@end

@implementation ProductStatiticsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewInfoClickAction:(id)sender
{
    [self removeInfoView];
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring33 image:@"img_network"];
    }else{
        [self queryProduct:@"footer"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"优惠商品销量统计";
    currentPage = 1;
    self.dataSource = [NSMutableArray array];
    [self setupTableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navBar_icon_search_white"] style:UIBarButtonItemStylePlain target:self action:@selector(searchBarButtonClick)];
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring33 image:@"img_network"];
    }else{
        [self queryProduct:@"footer"];
    }
}

#pragma mark ---- 设置 tableView ----

- (void)setupTableView
{
    self.tableMain = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_W, APP_H-NAV_H) style:UITableViewStylePlain];
    self.tableMain.delegate = self;
    self.tableMain.dataSource = self;
    self.tableMain.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableMain.backgroundColor =RGBHex(qwColor11);
//    [self.tableMain addHeaderWithTarget:self action:@selector(headerRefresh)];
    
    [self enableSimpleRefresh:self.tableMain block:^(SRRefreshView *sender) {
        [self headerRefresh];
    }];
    
    [self.tableMain addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableMain.footerNoDataText = kWaring55;
    [self.view addSubview:self.tableMain];
}

#pragma mark ---- 搜索 Action ----

- (void)searchBarButtonClick
{
    StaSearchDrugViewController *vc = [[StaSearchDrugViewController alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark ---- 头部刷新 ----

- (void)headerRefresh
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        return;
    }
    currentPage=1;
    [self queryProduct:@"header"];
}

#pragma mark ---- 尾部刷新 ----

- (void)footerRereshing
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
        [self.tableMain.footer endRefreshing];
        return;
    }
    [self queryProduct:@"footer"];
}

#pragma mark ---- 请求商品数据 ----

- (void)queryProduct:(NSString *)isHeader;
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        return;
    }
    [self removeInfoView];
    
    QueryStatisticsProductModelR *activitR=[QueryStatisticsProductModelR new];
    activitR.token=QWGLOBALMANAGER.configure.userToken;
    activitR.page = [NSString stringWithFormat:@"%lu",(unsigned long)currentPage];
    activitR.pageSize = @"10";
    
    [SellStatistics GetProductSellWithParams:activitR success:^(id resultObj) {
        
        RptProductArrayVo *activitys=(RptProductArrayVo*)resultObj;
        if(activitys.products.count>0){
            if([isHeader isEqualToString:@"header"]){
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:activitys.products];
            [self removeInfoView];
            [self.tableMain reloadData];
            currentPage++;
        }else{
            if(currentPage==1){
                [self showInfoView:@"暂无优惠商品销量统计" image:@"img_statistical" flatY:40];
            }else{
                self.tableMain.footer.canLoadMore=NO;
                [self removeInfoView];
            }
        }
        // 停止刷新
        if([isHeader isEqualToString:@"header"]){
        [self.tableMain headerEndRefreshing];
        }else{
        [self.tableMain footerEndRefreshing];
        }
    } failure:^(HttpException *e) {
        if([isHeader isEqualToString:@"header"]){
            [self.tableMain headerEndRefreshing];
        }else{
            [self.tableMain footerEndRefreshing];
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

#pragma mark ---- 列表代理 ----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)atableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)atableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ProductStatiticsCellTableViewCell getCellHeight:nil];
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CoupnIdentifier = @"ProductIdentifier";
    ProductStatiticsCellTableViewCell *cell = (ProductStatiticsCellTableViewCell *)[atableView dequeueReusableCellWithIdentifier:CoupnIdentifier];
    if(cell == nil){
        UINib *nib = [UINib nibWithNibName:@"ProductStatiticsCellTableViewCell" bundle:nil];
        [atableView registerNib:nib forCellReuseIdentifier:CoupnIdentifier];
        cell = (ProductStatiticsCellTableViewCell *)[atableView dequeueReusableCellWithIdentifier:CoupnIdentifier];
    }
    RptProductVo *mod = self.dataSource[indexPath.row];
    [cell setCell:mod];
    [cell.productLogo setImageWithURL:[NSURL URLWithString:mod.productLogo] placeholderImage:[UIImage imageNamed:@"img_goods_default"] options:SDWebImageRetryFailed|SDWebImageContinueInBackground];
    cell.consume.text = [NSString stringWithFormat:@"累计销量为%@",mod.consume];
    
    return cell;
}

- (void)tableView:(UITableView *)atableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [atableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RptProductVo *model=(RptProductVo*)self.dataSource[indexPath.row];
    PSStatiticsViewController *vc=[[PSStatiticsViewController alloc] init];
    vc.hidesBottomBarWhenPushed=YES;
    vc.proId=model.productId;
    vc.title = model.productName;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
