//
//  SearchMyorderViewController.m
//  wenyao-store
//
//  Created by chenpeng on 15/1/28.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import "SearchMyorderViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "Constant.h"
#import "ManageTableViewCell.h"
#import "Order.h"
#import "OrderMedelR.h"
#import "OrderModel.h"
#import "InfomationOrderViewController.h"
#import "MJRefresh.h"


@interface SearchMyorderViewController()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *myorderList;
    NSMutableArray *sectiononearray;
    NSMutableArray *sectiontwoarray;
    NSMutableArray *searchArray;
    int tapTag;
    int searchType;
}
@property (strong,nonatomic)UISearchBar *searchBar;
@property (strong,nonatomic)UILabel *lable;
@property (strong,nonatomic)UIBarButtonItem *button;
@property (assign,nonatomic)int currentPage;
@property (assign,nonatomic)int pageSize;
@property (strong,nonatomic)UIImageView *imageViewNetwork;
@property (strong,nonatomic)UIButton *buttonNetwork;
@property (strong,nonatomic)UITapGestureRecognizer *tap;
@property (strong,nonatomic)UITableView *tableView;
@property (nonatomic,assign)BOOL isEnd;
@end
@implementation SearchMyorderViewController
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
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 117;
    [self.view addSubview:self.tableView];
    tapTag=1;
    self.isEnd=YES;
}

-(void)setNavigation{
    self.navigationItem.rightBarButtonItem.enabled=YES;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(searchSomething:)];
}
-(void)searchSomething:(id)sender{
    
    self.navigationItem.rightBarButtonItem.enabled=NO;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [myorderList removeAllObjects];
    [self.view removeGestureRecognizer:self.tap];
    if (![[self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        [self branchMyorder];
    }else{
        [self.view addGestureRecognizer:self.tap];
        [self.tableView reloadData];
    } 
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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
    OrderclassBranch *branchclass=[OrderclassBranch new];
    if([myorderList count]>0){
    branchclass=[myorderList objectAtIndex:indexPath.row];
    [Cell setCell:branchclass];
    }
    return Cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view=[[UIView alloc]init];
    UIView *viewone=[[UIView alloc]initWithFrame:CGRectMake(15, 20, 100, 1)];
    UIView *viewtwo=[[UIView alloc]initWithFrame:CGRectMake(200, 20, 100, 1)];
    viewone.backgroundColor=RGBHex(qwColor10);
    viewtwo.backgroundColor=RGBHex(qwColor10);
    UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 320, 30)];
    if (section==0) {
        lable.text=[NSString stringWithFormat:@"共完成订单%lu笔,其中未上传小票%lu笔",(unsigned long)myorderList.count,(unsigned long)sectiononearray.count];
    }else{
        lable.text=@"已上传小票";
        [view addSubview:viewone];
        [view addSubview:viewtwo];
    }
    lable.font=[UIFont systemFontOfSize:14];
    lable.textAlignment=NSTextAlignmentCenter;
    view.backgroundColor=RGBHex(qwColor11);
    [view addSubview:lable];
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(myorderList.count>0){
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    InfomationOrderViewController *infomation=[[InfomationOrderViewController alloc]init];
    infomation.orderBranchclass=[myorderList objectAtIndex:indexPath.row];
    infomation.modeType=1;
    [self.navigationController pushViewController:infomation animated:YES];
    }
}
-(void)setupRefresh{
    
    [self.tableView addFooterWithTarget:self action:@selector(branchMyorder)];
    self.tableView.footerPullToRefreshText = kWaring6;
    self.tableView.footerReleaseToRefreshText = kWaring7;
    self.tableView.footerRefreshingText = kWaring8;
}

//请求订单列表
-(void)branchMyorder{
    HttpClientMgr.progressEnabled = NO;
    if ([[self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]isEqualToString:@""]) {
        
    }else{
        OrderBranchR *branchR=[OrderBranchR new];
        branchR.token=QWGLOBALMANAGER.configure.userToken;
        branchR.index=[self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if(self.isEnd){
            self.isEnd=NO;
        }
    }
}
- (void)setupSearchBar
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(12, 0, APP_W - 12 - 50, 44)];
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.placeholder = @"搜索订单号或用户";
    self.searchBar.delegate = self;
    self.searchBar.tintColor = [UIColor blueColor];
    self.searchBar.returnKeyType = UIReturnKeySearch;
    
    [self.navigationController.navigationBar addSubview:self.searchBar];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchBar removeFromSuperview];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyBord:)];
    self.tap.numberOfTapsRequired=1;
    self.tap.numberOfTouchesRequired=1;
    [self.view addGestureRecognizer:self.tap];
    self.pageSize = 10;
    self.currentPage = 1;
    self.tableView.backgroundColor=RGBHex(qwColor11);
    myorderList=[NSMutableArray array];
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=nil;
    [self setNavigation];
    [self setupSearchBar];
    [self.searchBar becomeFirstResponder];
}
-(void)resignKeyBord:(UITapGestureRecognizer *)tap{
    [self.searchBar resignFirstResponder];
}


-(void)viewDidCurrentView{
  
}

@end
