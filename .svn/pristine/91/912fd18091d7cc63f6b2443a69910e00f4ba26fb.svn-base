//
//  QuickSearchDrugListViewController.m
//  wenYao-store
//
//  Created by YYX on 15/6/8.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QuickSearchDrugListViewController.h"
#import "DrugDetailViewController.h"
#import "MedicineListCell.h"
#import "UIImageView+WebCache.h"
#import "Drug.h"

#import "QuickSearchDrugViewController.h"
#import "ChatViewController.h"
#import "XPChatViewController.h"
#import "ExpertChatViewController.h"
#import "ExpertXPChatViewController.h"


@interface QuickSearchDrugListViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    NSInteger currentPage;
    UIView *_nodataView;
}
@property (nonatomic ,strong) NSMutableArray * dataSource;
@property (nonatomic,strong)UITableView *tableViews;

@end

@implementation QuickSearchDrugListViewController

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}
-(void)popVCAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择要发送的药品";
    self.tableViews.rowHeight = 88;
    self.dataSource = [NSMutableArray array];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    
    UIBarButtonItem *barbutton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(popVCAction:)];
    self.navigationItem.leftBarButtonItem=barbutton;
    self.tableViews=[[UITableView alloc]init];
    [self.tableViews setFrame:CGRectMake(0, 0, APP_W, APP_H -NAV_H)];
    self.tableViews.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableViews.dataSource=self;
    self.tableViews.delegate=self;
    [self.tableViews addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableViews.footerPullToRefreshText =kWaring6;
    self.tableViews.footerReleaseToRefreshText = kWaring7;
    self.tableViews.footerRefreshingText = kWaring8;
    self.tableViews.backgroundColor=RGBHex(qwColor11);
    [self.view addSubview:self.tableViews];
    currentPage = 1;
    
    [self loadData:self.kwName];
}

- (void)cancelAction
{
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIViewController *viewController=(UIViewController *)obj;
        if ([viewController isKindOfClass:[XPChatViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
            *stop = YES;
        }else if([viewController isKindOfClass:[ChatViewController class]]){
            [self.navigationController popToViewController:viewController animated:YES];
            *stop = YES;
        }else if(idx == (self.navigationController.viewControllers.count - 1)){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)footerRereshing{
    currentPage ++;
    HttpClientMgr.progressEnabled = NO;
    [self loadData:self.kwName];
}

- (void)loadData:(NSString *)keyName
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWarning215N6 image:@"网络信号icon"];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"keyWord"] = StrFromObj(keyName);
    setting[@"currPage"] = [NSString stringWithFormat:@"%ld",(long)currentPage];
    setting[@"pageSize"] =[NSString stringWithFormat:@"%i",10];
    
    [Drug ProductQueryProductByKwNameWithParams:setting success:^(id DFUserModel) {
        
        ExpertSearchMedicinePageModel *page = [ExpertSearchMedicinePageModel parse:DFUserModel Elements:[ExpertSearchMedicineListModel class] forAttribute:@"qwProductList"];
        
        if ([page.apiStatus integerValue] == 0)
        {
            if(currentPage == 1){
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:page.qwProductList];
            if (self.dataSource.count > 0) {
                [self.tableViews reloadData];
            }else{
                [self showNoDataViewWithString:@"无搜索结果"];
            }
        }
        [self.tableViews footerEndRefreshing];
    } failure:^(HttpException *e) {
        [self.tableViews footerEndRefreshing];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellIdentifier = @"cellIdentifier";
    MedicineListCell * cell = (MedicineListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MedicineListCell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ExpertSearchMedicineListModel *productclass=self.dataSource[indexPath.row];
    [cell configureExpertData:productclass];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *selection = [self.tableViews indexPathForSelectedRow];
    if (selection) {
        [self.tableViews deselectRowAtIndexPath:selection animated:YES];
    }
    
    ExpertSearchMedicineListModel *product = self.dataSource[indexPath.row];
    if (self.block) {
        self.block(product);
    }
    
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIViewController *viewController=(UIViewController *)obj;
        if ([viewController isKindOfClass:[XPChatViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
        }else if([viewController isKindOfClass:[ChatViewController class]]){
            [self.navigationController popToViewController:viewController animated:YES];
        }
        
        else if([viewController isKindOfClass:[ExpertChatViewController class]]){
            [self.navigationController popToViewController:viewController animated:YES];
        }else if([viewController isKindOfClass:[ExpertXPChatViewController class]]){
            [self.navigationController popToViewController:viewController animated:YES];
        }
        
        else if(idx == (self.navigationController.viewControllers.count - 1)){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//显示没有历史搜索记录view
-(void)showNoDataViewWithString:(NSString *)nodataPrompt
{
    if (_nodataView) {
        [_nodataView removeFromSuperview];
        _nodataView = nil;
    }
    _nodataView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_W, APP_H-NAV_H)];
    _nodataView.backgroundColor = [UIColor colorWithRed:231/255.0 green:236/255.0 blue:238/255.0 alpha:1.0];
    //
    UIImage * searchImage = [UIImage imageNamed:@"img_search_common"];
    
    UIImageView *dataEmpty = [[UIImageView alloc]initWithFrame:RECT(0, 0, searchImage.size.width, searchImage.size.height)];
    dataEmpty.center = CGPointMake(APP_W/2, 110);
    dataEmpty.image = searchImage;
    [_nodataView addSubview:dataEmpty];
    
    UILabel* lable_ = [[UILabel alloc]initWithFrame:RECT(0,dataEmpty.frame.origin.y + dataEmpty.frame.size.height + 10, nodataPrompt.length*20,30)];
    lable_.font =fontSystem(kFontS5);
    lable_.textColor =RGBHex(qwColor8);
    lable_.textAlignment = NSTextAlignmentCenter;
    lable_.center = CGPointMake(APP_W/2, lable_.center.y);
    lable_.text = nodataPrompt;
    [_nodataView addSubview:lable_];
    [self.view insertSubview:_nodataView atIndex:self.view.subviews.count];
}


@end
