//
//  ManageMyorderViewController.m
//  wenyao-store
//
//  Created by chenpeng on 15/1/19.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import "ManageMyorderViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "Constant.h"
#import "ManageTableViewCell.h"
#import "Order.h"
#import "OrderModel.h"
#import "OrderMedelR.h"
#import "InfomationOrderViewController.h"
#import "MJRefresh.h"
#import "SearchMyorderViewController.h"

@interface ManageMyorderViewController()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *myorderList;
    NSMutableArray *sectiononearray;
    NSMutableArray *sectiontwoarray;
    NSMutableArray *searchArray;
    int tapTag;
    int searchType;
    int totalRecords;
    int emptyCount;
    BOOL changeZhisView;
}
@property (strong,nonatomic)UISearchBar *searchBar;
@property (strong,nonatomic)UILabel *lable;
@property (strong,nonatomic)UIBarButtonItem *button;
@property (assign,nonatomic)int currentPage;
@property (assign,nonatomic)int pageSize;
@property (strong,nonatomic)UIImageView *imageViewNetwork;
@property (strong,nonatomic)UIButton *buttonNetwork;
@property (strong,nonatomic)UITableView *tableView;
@end
@implementation ManageMyorderViewController
- (id)init{
    
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView=[[UITableView alloc]init];
    [self.tableView setFrame:CGRectMake(0, 0, APP_W, APP_H-NAV_H)];
    self.tableView.rowHeight = 117;
    tapTag=1;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor=RGBHex(qwColor11);
    self.view.backgroundColor=RGBHex(qwColor11);
    [self.view addSubview:self.tableView];
    changeZhisView=NO;

    myorderList=[NSMutableArray array];
    sectiononearray=[NSMutableArray array];
    sectiontwoarray=[NSMutableArray array];

    searchType=1;
    self.pageSize = 10;
    self.currentPage = 1;
    
    self.title=@"优惠活动订单管理";
    [self setNavigation];
    [self branchMyorder];
}

- (IBAction)viewInfoClickAction:(id)sender{
     [self removeInfoView];
     [self branchMyorder];
}



-(void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj{
    if (NotiMyorderList==type) {
        searchType=1;
        self.pageSize = 10;
        self.currentPage = 1;
        changeZhisView=YES;
    }
}
-(void)setNavigation{
    self.navigationItem.rightBarButtonItem.enabled=YES;
           self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"搜索icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(searchSomething:)];

    
}

-(void)searchSomething:(id)sender{
    if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
        [self showError:kWaring33];
        return;
    }
    self.navigationItem.rightBarButtonItem.enabled=NO;
    SearchMyorderViewController *searchView=[[SearchMyorderViewController alloc]init];
    [self.navigationController pushViewController:searchView animated:YES];

}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [searchArray removeAllObjects];
 

    if (searchArray.count>0) {
   
    }
    if ([self.searchBar.text isEqualToString:@""]) {
        searchType=1;
        [self.searchBar resignFirstResponder];
        [self.tableView reloadData];
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (searchType == 1) {
        return 2;
    } else {
        return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (searchType==1) {
        if(section==0){
            return sectiononearray.count;
        }
        if (section==1) {
            return sectiontwoarray.count;
        }
    }else{
        return searchArray.count;
    }
    
    return myorderList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 117;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"Managercell";
    ManageTableViewCell *Cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (Cell==nil) {
        Cell=[[NSBundle mainBundle]loadNibNamed:@"ManageTableViewCell" owner:self options:nil][0];
    }
        if (indexPath.section==0) {
            OrderclassBranch *branchclass=sectiononearray[indexPath.row];
            [Cell setCell:branchclass];
            
        }else{
            OrderclassBranch *branchclass=sectiontwoarray[indexPath.row];
            [Cell setCell:branchclass];
        }
    Cell.selectedBackgroundView=[[UIView alloc]initWithFrame:Cell.frame];
    Cell.selectedBackgroundView.backgroundColor=RGBHex(qwColor10);
    return Cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (searchType==1) {
        if (myorderList.count==0) {
            return 0;
        }
        return 30;
    }else{
        return 0;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]init];
    UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, APP_W, 30)];
    if (section==0) {
        lable.text=[NSString stringWithFormat:@"共完成订单%d笔,其中未上传小票%d笔",totalRecords,emptyCount];
    }else{
        NSString *str=@"已上传小票";
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
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    InfomationOrderViewController *infomation=[[InfomationOrderViewController alloc]init];
    if (indexPath.section==0) {
        infomation.orderBranchclass=[sectiononearray objectAtIndex:indexPath.row];
    }else{
        infomation.orderBranchclass=[sectiontwoarray objectAtIndex:indexPath.row];
    }
    infomation.modeType=1;
    [self.navigationController pushViewController:infomation animated:YES];
    
}
-(void)setupRefresh{
    [self.tableView addFooterWithTarget:self action:@selector(footreshing)];
    self.tableView.footerPullToRefreshText = kWaring6;
    self.tableView.footerReleaseToRefreshText =kWaring7;
    self.tableView.footerRefreshingText = kWaring8;
    self.tableView.footerNoDataText = kWaring55;
}

-(void)footreshing{
    HttpClientMgr.progressEnabled = NO;
    [self branchMyorder];
}


//请求订单列表
-(void)branchMyorder{

   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem.enabled=YES;
    [self setupRefresh];
    if (changeZhisView==YES) {
      [sectiononearray removeAllObjects];
      [sectiontwoarray removeAllObjects];
      [myorderList removeAllObjects];
        changeZhisView=NO;
      [self branchMyorder];
    }
}


-(void)viewDidCurrentView{
    
}
@end
