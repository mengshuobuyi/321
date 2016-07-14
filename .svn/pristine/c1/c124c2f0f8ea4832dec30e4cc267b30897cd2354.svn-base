//
//  SearchMedicineListViewController.m
//  wenyao 2.2新的药事知识库
//
//  Created by Meng on 14/12/2.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "SearchMedicineListViewController.h"
#import "DrugDetailViewController.h"
#import "MedicineListCell.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "Drug.h"
#import "SecondProductTableViewCell.h"
#import "WebDirectViewController.h"

@interface SearchMedicineListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger currentPage;
    UIView *_nodataView;
}
@property (nonatomic ,strong) NSMutableArray * dataSource;
@property (nonatomic,strong)UITableView *tableViews;
@end

@implementation SearchMedicineListViewController

- (instancetype)init
{
    if (self = [super init]) {
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
    }
    return self;
}
-(void)popVCAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableViews.rowHeight = 88;
 
    self.dataSource = [NSMutableArray array];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

}

- (void)footerRereshing{
    currentPage ++;
    [self setKwId:self.kwId];
}

- (void)setKwId:(NSString *)kwId
{
    _kwId = kwId;
    productBykwIdR *productR=[productBykwIdR new];
    productR.kwId=kwId;
    productR.currPage=[NSString stringWithFormat:@"%ld",(long)currentPage];
    productR.pageSize=[NSString stringWithFormat:@"%i",10];
    productR.branchId=QWGLOBALMANAGER.configure.groupId;
    productR.token=QWGLOBALMANAGER.configure.userToken;
    productR.type=@"1";
    productR.v=@"2.0";
    [Drug queryProductByKwIdWithParam:productR Success:^(id DFUserModel) {
        DiseaseSpmProductbykwid *product=DFUserModel;
        if(currentPage == 1){
            [self.dataSource removeAllObjects];
        }
        for (productclassBykwId *productclass in product.list) {
            [self.dataSource addObject:productclass];
        }
        if (self.dataSource.count > 0) {
            [self.tableViews reloadData];
        }else{
            [self showNoDataViewWithString:@"暂无数据!"];
        }
        [self.tableViews footerEndRefreshing];

    } failure:^(HttpException *e) {
        [self showNoDataViewWithString:e.Edescription];
        [self.tableViews footerEndRefreshing];
    }];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     productclassBykwId *product = self.dataSource[indexPath.row];
    if(product.promotionId&&![product.promotionId isEqualToString:@""]){
        //2.2做的修改
        NSString * cellIdentifier = @"SecondProductCell";
        SecondProductTableViewCell * cell = (SecondProductTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"SecondProductTableViewCell" owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        productclassBykwId *productclass=self.dataSource[indexPath.row];
        [cell setPillCell:productclass];
        
        return cell;
        
    }else{
    
        NSString * cellIdentifier = @"cellIdentifier";
        MedicineListCell * cell = (MedicineListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"MedicineListCell" owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        productclassBykwId *productclass=self.dataSource[indexPath.row];
        [cell setCell:productclass];
        
        return cell;
    
    }
    
  
    
    
  
 
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    productclassBykwId *product = self.dataSource[indexPath.row];
    if(product.promotionId&&![product.promotionId isEqualToString:@""]){
       return [SecondProductTableViewCell getCellHeight:nil];
    }else{
       return [MedicineListCell getCellHeight:nil];
    }
    
 
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
    productclassBykwId *product = self.dataSource[indexPath.row];
//    DrugDetailViewController * drugDetailViewController = [[DrugDetailViewController alloc] init];
//    drugDetailViewController.proId = product.proId;
//    [self.navigationController pushViewController:drugDetailViewController animated:YES];
    
    WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
    
    WebDrugDetailModel *modelDrug = [[WebDrugDetailModel alloc] init];
    modelDrug.proDrugID = product.proId;
    modelDrug.promotionID = product.promotionId;
    
    WebDirectLocalModel *modelLocal = [[WebDirectLocalModel alloc] init];
    modelLocal.modelDrug = modelDrug;
    modelLocal.typeLocalWeb = WebLocalTypeCouponProduct;
    modelLocal.title = @"药品详情";
    [vcWebDirect setWVWithLocalModel:modelLocal];
    
    vcWebDirect.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcWebDirect animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    UIImage * searchImage = [UIImage imageNamed:@"icon_warning"];
    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
