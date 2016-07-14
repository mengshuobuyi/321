//
//  ProductSalesStatiticsViewController.m
//  wenYao-store
//  接口
//  商品销售统计：         h5/salesrpt/productMarket
//  Created by Martin.Liu on 16/5/13.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ProductSalesStatiticsViewController.h"
#import "MARStatisticsDateView.h"
#import "SVProgressHUD.h"
#import "NSDate+TKCategory.h"
#import "Store.h"
#import "ProductSearchTableVCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "SearchProductSalesViewController.h"        // 搜索页面
#import "ProductStatiticsViewController.h"          // 优惠商品销量统计
NSString *const kProductCellIdentifier = @"ProductSearchTableVCell";

@interface ProductSalesStatiticsViewController ()<MARStatisticsDateViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) IBOutlet MARStatisticsDateView *statisticsDateView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *noneDateView;
@property (strong, nonatomic) IBOutlet UIView *searchAsistantView;

@property (nonatomic, strong) NSArray* productArray;
@property (strong, nonatomic) IBOutlet UIButton *sortBtn;  // 一般状态是升序，选中状态的降序。

- (IBAction)sortBtnAction:(UIButton*)sender;
- (IBAction)searchProductAction:(id)sender;

// 缓存查询的日期
@property (nonatomic, strong) NSString* tempStartDateString;
@property (nonatomic, strong) NSString* tempEndDateString;
// 弹出日期的时候的一个辅助视图，点击会隐藏日期控件
@property (nonatomic, strong) UIView*   coverView;
@property (nonatomic, strong) UITapGestureRecognizer* tapGesture;

@end

@implementation ProductSalesStatiticsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"商品销售统计";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self UIConfig];
    
    // 默认倒序排序
    self.sortBtn.selected = YES;
}

#pragma mark - 配置UI
- (void)UIConfig
{
    self.noneDateView.hidden = YES;
    self.statisticsDateView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductSearchTableVCell" bundle:nil] forCellReuseIdentifier:kProductCellIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    // 需要设置成YES（在UISB里面子视图加了约束被设置成NO了），不然会突然消失
    [self.tableHeaderView setTranslatesAutoresizingMaskIntoConstraints:YES];
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.searchAsistantView.backgroundColor = RGBHex(0xfafafa);
    self.searchAsistantView.layer.masksToBounds = YES;
    self.searchAsistantView.layer.cornerRadius = CGRectGetHeight(self.searchAsistantView.frame)/2;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"历史统计" style:UIBarButtonItemStyleDone target:self action:@selector(gotoHistoryStatiticsVC:)];
}

- (UIView *)coverView
{
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = RGBHex(0x000000);
        _coverView.alpha = 0;
        [_coverView addGestureRecognizer:self.tapGesture];
    }
    return _coverView;
}

- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenDateBoardViews:)];
    }
    return _tapGesture;
}

- (void)hiddenDateBoardViews:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark - 历史统计 prd:跳转至该门店原有的优惠商品销量统计页面，保持原有页面逻辑不变。
- (void)gotoHistoryStatiticsVC:(UIBarButtonItem*)sender
{
    // 优惠商品销量统计
    
    ProductStatiticsViewController *vc = [[ProductStatiticsViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 从服务端获取商品销售数据
- (void)loadData
{
    self.tempStartDateString = self.statisticsDateView.startDateString;
    self.tempEndDateString = self.statisticsDateView.endDateString;
    
    GetProductSalesR* getProdcctSalesR = [GetProductSalesR new];
    getProdcctSalesR.begin = self.statisticsDateView.startDateString;
    getProdcctSalesR.end = self.statisticsDateView.endDateString;
    getProdcctSalesR.token = QWGLOBALMANAGER.configure.userToken;
    getProdcctSalesR.upOrDown = self.sortBtn.selected ? 1 : 2;
    __weak __typeof(self) weakSelf = self;
    [Store getProductSales:getProdcctSalesR success:^(ProductSalesListModel *productList) {
        if ([productList.apiStatus integerValue] == 0) {
            weakSelf.productArray = productList.list;
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:productList.apiMessage duration:DURATION_LONG];
        }
        weakSelf.noneDateView.hidden = weakSelf.productArray.count > 0;
        [weakSelf.tableView reloadData];

    } fail:^(HttpException *e) {
        weakSelf.noneDateView.hidden = weakSelf.productArray.count <= 0;
        [weakSelf.tableView reloadData];

    }];
}

// 用上次搜索的日期排序
- (void)loadDataWithSort
{
    GetProductSalesR* getProdcctSalesR = [GetProductSalesR new];
    getProdcctSalesR.begin = self.tempStartDateString;
    getProdcctSalesR.end = self.tempEndDateString;
    getProdcctSalesR.token = QWGLOBALMANAGER.configure.userToken;
    getProdcctSalesR.upOrDown = self.sortBtn.selected ? 1 : 2;
    __weak __typeof(self) weakSelf = self;
    [Store getProductSales:getProdcctSalesR success:^(ProductSalesListModel *productList) {
        if ([productList.apiStatus integerValue] == 0) {
            weakSelf.productArray = productList.list;
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:productList.apiMessage duration:DURATION_LONG];
        }
        weakSelf.noneDateView.hidden = weakSelf.productArray.count > 0;
        [weakSelf.tableView reloadData];
        
    } fail:^(HttpException *e) {
        weakSelf.noneDateView.hidden = weakSelf.productArray.count <= 0;
        [weakSelf.tableView reloadData];
        
    }];

}

#pragma mark - MARStatisticsDateViewDelegate        start  -----
- (void)marDateView:(MARStatisticsDateView *)dateView didClickQueryBtnStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    [self.view endEditing:YES];
    if ([startDate compare:endDate] ==  NSOrderedDescending) {
        [SVProgressHUD showErrorWithStatus:@"起始日期大于终止日期，请重新输入！"];
        return;
    }
    NSInteger days = [NSDate daysBetweenDate:startDate andDate:endDate];
    if (days >= 30) {
//        [SVProgressHUD showErrorWithStatus:@"查询的起止时间不能超过30天"];
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"查询的起止时间不能超过30天" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    [self loadData];
}

- (void)marDateViewBecomResponder:(MARStatisticsDateView *)dateView
{
    [self.view addSubview:self.coverView];
    PREPCONSTRAINTS(self.coverView);
    ALIGN_TOPLEFT(self.coverView, 0);
    ALIGN_BOTTOMRIGHT(self.coverView, 0);
    [UIView animateWithDuration:0.25 animations:^{
        self.coverView.alpha = 0.3;
    }];
}

- (void)marDateViewResignResponder:(MARStatisticsDateView *)dataView
{
    [UIView animateWithDuration:0.25 animations:^{
        _coverView.alpha = 0;
    } completion:^(BOOL finished) {
        [_coverView removeFromSuperview];
        _coverView = nil;
    }];
}
#pragma mark - MARStatisticsDateViewDelegate        end   -----

#pragma mark - UITableView delegate         start ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.productArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kProductCellIdentifier forIndexPath:indexPath];
    [self configure:cell indexPath:indexPath];
    return cell;
}

- (void)configure:(id)cell indexPath:(NSIndexPath*)indexPath
{
    NSInteger row = indexPath.row;
    if (self.productArray.count > row) {
        [cell setCell:self.productArray[row]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak __typeof(self) weakSelf = self;
    return [tableView fd_heightForCellWithIdentifier:kProductCellIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
        [weakSelf configure:cell indexPath:indexPath];
    }];
}
#pragma mark - UITableView delegate         end  ----

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 点击搜索输入框，跳转到所搜商品的页面
- (IBAction)searchProductAction:(id)sender {
    if (self.productArray.count > 0) {
        // 调到商品查询页面
        SearchProductSalesViewController* searchProductSales = [[SearchProductSalesViewController alloc] init];
        searchProductSales.startDate = self.tempStartDateString;
        searchProductSales.endDate = self.tempEndDateString;
        searchProductSales.upOrDown = self.sortBtn.selected ? 1 : 2;
        searchProductSales.hidesBottomBarWhenPushed = YES;
        searchProductSales.productArray = self.productArray;
        [self.navigationController pushViewController:searchProductSales animated:YES];
    }
}

- (IBAction)sortBtnAction:(UIButton*)sender {
    [self.view endEditing:YES];
    if (self.productArray.count > 0 && !StrIsEmpty(self.tempStartDateString) && !StrIsEmpty(self.tempEndDateString)) {
        sender.selected = !sender.selected;
        [self loadDataWithSort];
    }
}
@end
