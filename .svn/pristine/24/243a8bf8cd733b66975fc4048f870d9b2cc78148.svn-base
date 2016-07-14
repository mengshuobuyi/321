//
//  DrugMedicineViewController.m
//  wenyao-store
//
//  Created by Meng on 14-10-30.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "DrugMedicineViewController.h"
#import "DrugMedicineCell.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "SVProgressHUD.h"
#import "CustomerModelR.h"
#import "Customer.h"

@interface DrugMedicineViewController ()
@property (strong, nonatomic) IBOutlet UITableView *drugTable;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property(strong,nonatomic)NSMutableArray *datescoreArr;
@property(nonatomic,assign) int page;
@property(nonatomic,assign)int pageSize;
@property(nonatomic,assign)int totalPage;
@end

@implementation DrugMedicineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.drugTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.title = @"购药历史";
    self.datescoreArr = [NSMutableArray array];
    self.pageSize = 10;
    self.page = 1;
    [self setupRefresh];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupRefresh
{
//    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
//    [self.drugTable addHeaderWithTarget:self action:@selector(headerRereshing)];
//    [self.drugTable headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.drugTable addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
//    self.drugTable.headerPullToRefreshText = @"下拉可以刷新了";
//    self.drugTable.headerReleaseToRefreshText = @"松开马上刷新了";
//    self.drugTable.headerRefreshingText = @"正在帮你刷新中";
    
    self.drugTable.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.drugTable.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.drugTable.footerRefreshingText = @"正在帮你加载中";
}

- (void)headerRereshing
{
    
    
}

- (void)queryCustomerDrugList
{
    CustomerDrugModelR *modelR = [CustomerDrugModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.customer = self.userModel.passportId;
    modelR.currPage = [NSString stringWithFormat:@"%d",self.page];
    modelR.pageSize = [NSString stringWithFormat:@"%d",self.pageSize];
    __weak DrugMedicineViewController *weakSelf = self;
    [Customer QueryCustomerDrugWithParams:modelR success:^(id obj) {
        MyCustomerDrugListModel *listModel = (MyCustomerDrugListModel *)obj;
        [weakSelf.datescoreArr addObjectsFromArray:listModel.list];
        [weakSelf.drugTable reloadData];
        if (weakSelf.page == 1) {
            [weakSelf.drugTable headerEndRefreshing];
        } else {
            [weakSelf.drugTable footerEndRefreshing];
        }
        
    } failue:^(HttpException *e) {
        if (weakSelf.page == 1) {
            [weakSelf.drugTable headerEndRefreshing];
        } else {
            [weakSelf.drugTable footerEndRefreshing];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    [[self drugTable] headerBeginRefreshing];
    [self queryCustomerDrugList];
}

- (void)footerRereshing
{
    self.page ++;
    [self queryCustomerDrugList];
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datescoreArr.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *DrugMedicineCellIdentifier = @"DrugMedicineCell";
    DrugMedicineCell *cell = (DrugMedicineCell *)[tableView dequeueReusableCellWithIdentifier:DrugMedicineCellIdentifier];
    if(cell == nil){
        UINib *nib = [UINib nibWithNibName:@"DrugMedicineCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:DrugMedicineCellIdentifier];
        cell = (DrugMedicineCell *)[tableView dequeueReusableCellWithIdentifier:DrugMedicineCellIdentifier];
    }
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CustomerDrugListModel *listModelDetail = self.datescoreArr[0];
    cell.medicine_name.text = listModelDetail.name;
    cell.medicine_num.text = [NSString stringWithFormat:@"%@",listModelDetail.num];
    cell.medicine_time.text = listModelDetail.date;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
