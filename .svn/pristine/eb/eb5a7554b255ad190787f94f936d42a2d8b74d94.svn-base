//
//  MedicineListViewController.m
//  wenyao
//
//  Created by Meng on 14-9-28.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "MedicineListViewController.h"
#import "MedicineListCell.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "DrugDetailViewController.h"
#import "SVProgressHUD.h"
#import "UIViewController+isNetwork.h"
#import "AppDelegate.h"
#import "Order.h"
#import "OrderMedelR.h"
#import "OrderModel.h"
#import "WebDirectViewController.h"


@interface MedicineListViewController ()<TopTableViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSInteger currentPage;
   
    BOOL menuIsShow;
    UIButton * rightBarButton;
}
@property (nonatomic,strong)TopTableView *topTable;
@property (nonatomic ,strong) NSMutableArray * dataSource;
@property (nonatomic ,strong) UITableView *listTableView;
@property (nonatomic ,strong) __block NSMutableArray *data;
@property (nonatomic ,strong) NSMutableArray * factoryArray;
@property (nonatomic, strong) UIButton        *backGoundCover;
@end

@implementation MedicineListViewController


- (id)init{
    if (self = [super init]) {
        menuIsShow = NO;
        
        self.topTable = [TopTableView sharedTopview];
        self.topTable.tag=2000;
        self.topTable.hidden = YES;
        self.topTable.mTableView.tag=1000;
        self.topTable.delegate = self;
        self.topTable.mTableView.frame = CGRectMake(0,-500, APP_W, 380);
        [self.view addSubview:self.topTable];
        
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"列表";
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_W, APP_H) style:UITableViewStylePlain];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.frame = CGRectMake(0, 0, APP_W, APP_H-NAV_H);
    self.listTableView.rowHeight = 88;
    [self.view addSubview:self.listTableView];
    
    [self.listTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    [self.listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.listTableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.listTableView.footerReleaseToRefreshText = @"松开加载更多数据了";
    self.listTableView.footerRefreshingText = @"正在帮你加载中";
    currentPage = 1;
    
    self.backGoundCover = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rect = self.view.frame;
    self.backGoundCover.frame = rect;
    self.backGoundCover.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    self.backGoundCover.hidden = YES;
    menuIsShow = NO;
    self.dataSource = [NSMutableArray array];
    self.factoryArray = [NSMutableArray array];
    self.data = [NSMutableArray array];
}

- (void)initRightBarButton{
    CGSize size = //[@"全部生产厂家" sizeWithFont:fontSystem(kFontS1)];
        [GLOBALMANAGER sizeText:@"全部生产厂家" font:fontSystem(kFontS1)];
    rightBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, size.width, 20)];
    rightBarButton.backgroundColor = [UIColor clearColor];
    rightBarButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    [rightBarButton setTitle:@"全部生产厂家" forState:UIControlStateNormal];
    rightBarButton.titleLabel.font = fontSystem(kFontS1);
    [rightBarButton setTintColor:[UIColor blueColor]];
    [rightBarButton addTarget:self action:@selector(barButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage * arrImage = [UIImage imageNamed:@"头部下拉箭头.png"];
    
    
    UIImageView * arrImageView = [[UIImageView alloc] initWithFrame:CGRectMake(rightBarButton.frame.origin.x + rightBarButton.frame.size.width, 15, arrImage.size.width, arrImage.size.height)];
    arrImageView.image = arrImage;
    [rightBarButton addSubview:arrImageView];
    
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
}




- (void)setClassId:(NSString *)classId{
    _classId = [classId copy];
    if (self.isShow == 1) {
        [self initRightBarButton];
        self.topTable.classId = self.classId;
    }
    if ([self.className isEqualToString:@"SubRegularDrugsViewController"]) {
        [self loadHealthyScenarioData:self.classId];
    }else{
        [self loadDataWithClassId:self.classId];
    }
}

- (void)setKeyWord:(NSString *)keyWord{
    _keyWord = [keyWord copy];
    self.title = keyWord;
    [self loadDataWithKeyWord:keyWord];
}

//加载健康方案的药品列表
- (void)loadHealthyScenarioData:(NSString *)classId
{
    
    HealthyScenarioDrugModelR *model = [HealthyScenarioDrugModelR new];
    model.classId = classId;
    model.currPage = @(currentPage);
    model.pageSize = @(PAGE_ROW_NUM);
    
    [Order queryRecommendProductByClassWithParam:model success:^(id UFModel) {
        
        HealthyScenarioListModel *scneario =(HealthyScenarioListModel *) UFModel;
        [self.dataSource addObjectsFromArray:scneario.data];
        currentPage ++ ;
        [self.listTableView reloadData];
        [self.listTableView footerEndRefreshing];
         NSLog(@"list = %@",self.dataSource);
        
    } failure:^(HttpException *e) {
         NSLog(@"error = %@",e);
    }];

}

//加载其他带id药品列表
- (void)loadDataWithClassId:(NSString *)classId{
    
    QueryProductByClassModelR *queryProductByClassModelR = [QueryProductByClassModelR new];
    queryProductByClassModelR.classId = classId;
    queryProductByClassModelR.currPage = @(currentPage);
    queryProductByClassModelR.pageSize = @(PAGE_ROW_NUM);
    queryProductByClassModelR.factory = @"";
    
    
    [Order queryProductByClassWithParam:queryProductByClassModelR Success:^(id DFUserModel) {
        QueryProductClassModel *queryProductClassModel = (QueryProductClassModel *)DFUserModel;
        [self.dataSource addObjectsFromArray:queryProductClassModel.list];
        currentPage ++ ;
        [self.listTableView reloadData];
        [self.listTableView footerEndRefreshing];
        NSLog(@"list = %@",self.dataSource);
    } failure:^(HttpException *e) {
        NSLog(@"error = %@",e);
    }];
    
}

//加载关键字药品列表
- (void)loadDataWithKeyWord:(NSString *)keyword{
//    [[HTTPRequestManager sharedInstance] queryProductByKeyword:@{@"keyword": keyword,@"currPage":@(currentPage),@"pageSize":@PAGE_ROW_NUM} completion:^(id resultObj) {
//        if ([resultObj[@"result"] isEqualToString:@"OK"]) {
//            [self.dataSource addObjectsFromArray:resultObj[@"body"][@"data"]];
//        }
//        NSLog(@"dataSource = %@",self.dataSource);
//        currentPage ++ ;
//        [self.tableView reloadData];
//        [self.tableView footerEndRefreshing];
//    } failure:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"数据加载失败" duration:DURATION_SHORT];
//        NSLog(@"%@",error);
//    }];
}

- (void)footerRereshing
{
    if (self.classId) {
        if ([self.className isEqualToString:@"SubRegularDrugsViewController"]) {
            [self loadHealthyScenarioData:self.classId];
            
        }else{
            [self loadDataWithClassId:self.classId];
        }
    }
    
    if (self.keyWord) {
        [self loadDataWithKeyWord:self.keyWord];
    }
    
}

- (void)barButtonClick{
    
    if (menuIsShow == NO) {
        if (self.topTable.dataSource.count == 0) {
            FetchProFactoryByClassModelR *requestModel = [FetchProFactoryByClassModelR new];
            requestModel.classId = self.classId;
            requestModel.currPage = @1;
            requestModel.pageSize = @20;
            
            [Order fetchProFactoryByClassWithParam:requestModel Success:^(id DFUserModel) {
                
                QueryProductClassModel *queryProductClassModel = (QueryProductClassModel *)DFUserModel;
                
                self.topTable.dataArr = queryProductClassModel.list;
            } failure:^(HttpException *e) {
                NSLog(@"%@",e);
            }];
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            self.topTable.hidden = NO;
            self.topTable.mTableView.frame = CGRectMake(0, 0, APP_W, 360);
            self.backGoundCover.hidden = NO;
        }];
        menuIsShow = YES;
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.topTable.hidden = YES;
            self.topTable.mTableView.frame = CGRectMake(0, -500, APP_W, 360);
            self.backGoundCover.hidden = YES;
            
        }];
        menuIsShow = NO;
    }
    
}

#pragma mark -------topTable数据回调-------
- (void)tableViewCellSelectedReturnData:(NSArray *)dataArr withClassId:(NSString *)classId  withIndexPath:(NSIndexPath *)indexPath keyWord:(NSString *)keyword{
    [self barButtonClick];
    [rightBarButton setTitle:keyword forState:UIControlStateNormal];
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:dataArr];
    if (indexPath.row == 0) {
        //如果是第一行,那就是加载全部数据
        currentPage = 1;

        [self performSelectorOnMainThread:@selector(loadDataWithClassId:) withObject:classId waitUntilDone:YES];
        //[self loadDataWithClassId:self.classId];
    }else{
        //如果不是第一行,那就不需要上拉刷新,移除底部刷新工具
        [self.listTableView removeFooter];
        [self.listTableView reloadData];
    }
    
}

- (void)dismissMenuWithButton
{
    [UIView animateWithDuration:0.5 animations:^{
        self.topTable.mTableView.frame = CGRectMake(0, -500, APP_W, 360);
        self.topTable.hidden = YES;
        self.backGoundCover.hidden = YES;
    }];
    menuIsShow = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MedicineListCell getCellHeight:nil] ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"cellIdentifier";
    MedicineListCell * cell = (MedicineListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MedicineListCell" owner:self options:nil][0];
        cell.separatorInset = UIEdgeInsetsZero;
        UIView *bkView = [[UIView alloc]initWithFrame:cell.frame];
        bkView.backgroundColor = RGBHex(qwColor10);
        cell.selectedBackgroundView = bkView;
    }
    
    if ([self.className isEqualToString:@"SubRegularDrugsViewController"]) {
        HealthyScenarioDrugModel *drugModel=self.dataSource[indexPath.row];
        [cell setCell:drugModel];
    }else{
        QueryProductByClassItemModel *model = self.dataSource[indexPath.row];
        [cell setCell:model];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *selection = [tableView indexPathForSelectedRow];
    if (selection) {
        [tableView deselectRowAtIndexPath:selection animated:YES];
    }
    
    WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
    WebDrugDetailModel *modelDrug = [[WebDrugDetailModel alloc] init];
    if (self.classId) {
        if ([self.className isEqualToString:@"SubRegularDrugsViewController"]) {
            HealthyScenarioDrugModel *dic=self.dataSource[indexPath.row];
            modelDrug.proDrugID = dic.proId;
        }else{
            QueryProductByClassItemModel *dic = self.dataSource[indexPath.row];
            modelDrug.proDrugID = dic.proId;
        }
    }else{
        QueryProductByClassItemModel *dic = self.dataSource[indexPath.row];
        modelDrug.proDrugID = dic.proId;
    }
    
    modelDrug.promotionID = @"";
    
    WebDirectLocalModel *modelLocal = [[WebDirectLocalModel alloc] init];
    modelLocal.modelDrug = modelDrug;
    modelLocal.typeLocalWeb = WebLocalTypeCouponProduct;
    modelLocal.title = @"药品详情";
    [vcWebDirect setWVWithLocalModel:modelLocal];
    
    vcWebDirect.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcWebDirect animated:YES];
    
//    DrugDetailViewController *drugDetailViewController = [[DrugDetailViewController alloc] init];
//    if (self.classId) {
//        if ([self.className isEqualToString:@"SubRegularDrugsViewController"]) {
//            HealthyScenarioDrugModel *dic=self.dataSource[indexPath.row];
//            drugDetailViewController.proId = dic.proId;
//        }else{
//            QueryProductByClassItemModel *dic = self.dataSource[indexPath.row];
//            drugDetailViewController.proId = dic.proId;
//        }
//    }else{
//        QueryProductByClassItemModel *dic = self.dataSource[indexPath.row];
//        drugDetailViewController.proId = dic.proId;
//
//    }
//    
//    [self.navigationController pushViewController:drugDetailViewController animated:YES];
}

- (void)loadFactory{
    
}

- (void)BtnClick{
    
    if(![self isNetWorking]){
        for(UIView *v in [self.view subviews]){
            if(v.tag == 999){
                [v removeFromSuperview];
            }
        }
        [self setClassId:self.classId];
    }
}
@end


#pragma mark --------自定义弹出的tableView--------

@implementation TopTableView
@synthesize classId = _classId;

static TopTableView *topview=nil;
+(TopTableView *)sharedTopview{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        topview=[[TopTableView alloc]initWithFrame:CGRectMake(0, 0, APP_W, APP_H)];
        
        topview.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        
    });
    return topview;
}
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenTopView)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        self.mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, APP_W, 360) style:UITableViewStylePlain];
        self.mTableView.delegate = self;
        self.mTableView.dataSource = self;
        [self addSubview:self.mTableView];
        self.mTableView.rowHeight = 40.0f;
        currentPage = 2;
        
        [self.mTableView addFooterWithTarget:self action:@selector(footerRereshing)];
        self.mTableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
        self.mTableView.footerReleaseToRefreshText = @"松开加载更多数据了";
        self.mTableView.footerRefreshingText = @"正在帮你加载中";
        
        historyRow = -1;
        currentRow = -1;
        
        
        [self.mTableView removeGestureRecognizer:tap];
        
    }
    return self;
}

- (void)setClassId:(NSString *)classId
{
    _classId = [classId copy];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
     NSLog(@"%@", NSStringFromClass([touch.view class]));
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] ) {
        return NO;
    }
    return YES;
}

- (void)hiddenTopView
{
    NSLog(@"hidden topView");
    if ([self.delegate respondsToSelector:@selector(dismissMenuWithButton)]) {
        [self.delegate dismissMenuWithButton];
    }
}

- (void)footerRereshing{
    
    FetchProFactoryByClassModelR *requestModel = [FetchProFactoryByClassModelR new];
    requestModel.classId = self.classId;
    requestModel.currPage = @(currentPage);
    requestModel.pageSize = @20;
    
    [Order fetchProFactoryByClassWithParam:requestModel Success:^(id DFUserModel) {
        
        QueryProductClassModel *queryProductClassModel = (QueryProductClassModel *)DFUserModel;
        NSInteger count = self.dataSource.count;
        [self.dataSource addObjectsFromArray: queryProductClassModel.list];
        if (self.dataSource.count > count) {
            ++currentPage;
            [self.mTableView reloadData];
        }
        [self.mTableView footerEndRefreshing];
    } failure:^(HttpException *e) {
        [self.mTableView footerEndRefreshing];
        NSLog(@"%@",e);
    }];
}

- (void)setDataArr:(NSArray *)dataArr{
    self.dataSource = [NSMutableArray array];
    [self.dataSource addObjectsFromArray:dataArr];
    FetchProFactoryByClassModel *model = [FetchProFactoryByClassModel new];
    model.factory = @"全部生产厂家";
    [self.dataSource insertObject:model atIndex:0];
    if(self.dataSource.count <= 9){
    self.mTableView.frame = CGRectMake(0, 0, APP_W, self.mTableView.rowHeight * self.dataSource.count);
    }
    
    [self.mTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentfier = @"cellIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentfier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentfier];
        cell.textLabel.font = fontSystem(kFontS4);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == historyRow) {
        UIImage * image = [UIImage imageNamed:@"勾.png"];
        UIImageView * accessView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        accessView.image = image;
        cell.accessoryView = accessView;
        cell.textLabel.textColor = RGBHex(qwColor14);
    } else {
        cell.accessoryView = [[UIView alloc]init];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    FetchProFactoryByClassModel *model = self.dataSource[indexPath.row];
    
    cell.textLabel.text = model.factory;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    currentRow = indexPath.row;
    NSIndexPath * historyPath = [NSIndexPath indexPathForRow:historyRow inSection:0];
    NSIndexPath * currentPath = [NSIndexPath indexPathForRow:currentRow inSection:0];
   
    UITableViewCell * historyCell = [tableView cellForRowAtIndexPath:historyPath];
    UITableViewCell * currentCell = [tableView cellForRowAtIndexPath:currentPath];
    
    UIImage * image = [UIImage imageNamed:@"勾.png"];
    UIImageView * accessView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    accessView.image = image;
    
    
    if (currentRow != historyRow) {
        
        historyCell.accessoryView = [[UIView alloc]init];
        historyCell.textLabel.textColor = [UIColor blackColor];
        currentCell.accessoryView = accessView;
        currentCell.textLabel.textColor = RGBHex(qwColor14);
    }
    historyRow = currentRow;
    QueryProductByClassModelR *queryProductByClassModelR = [QueryProductByClassModelR new];
    queryProductByClassModelR.classId = _classId;
    queryProductByClassModelR.currPage = @1;
    queryProductByClassModelR.pageSize = @10000;
    if (indexPath.row != 0) {
        FetchProFactoryByClassModel *model = self.dataSource[indexPath.row];
        queryProductByClassModelR.factory = model.factory;
    }
    
    NSLog(@"model = %@",queryProductByClassModelR);
    [Order queryProductByClassWithParam:queryProductByClassModelR Success:^(id DFUserModel) {
        QueryProductClassModel *queryProductClassModel = (QueryProductClassModel *)DFUserModel;
        if ([self.delegate respondsToSelector:@selector(tableViewCellSelectedReturnData:withClassId:withIndexPath:keyWord:)]) {
            FetchProFactoryByClassModel *fetchModel = self.dataSource[indexPath.row];
            [self.delegate tableViewCellSelectedReturnData:queryProductClassModel.list
                                               withClassId:self.classId
                                             withIndexPath:indexPath
                                                   keyWord:fetchModel.factory];
        }
        
        
    } failure:^(HttpException *e) {
        NSLog(@"error = %@",e);
    }];
}

@end
