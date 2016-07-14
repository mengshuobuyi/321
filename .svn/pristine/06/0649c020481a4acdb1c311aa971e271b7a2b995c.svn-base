//
//  SearchProductSalesViewController.m
//  wenYao-store
//  接口
//  商品销售统计：         h5/salesrpt/productMarket
//  Created by Martin.Liu on 16/5/16.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "SearchProductSalesViewController.h"
#import "AllScanReaderViewController.h"
#import "ProductSearchTableVCell.h"
#import "Store.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "QWSpecailIntoView.h"
#import "ConstraintsUtility.h"
#import "QYPhotoAlbum.h"

NSString *const kProductSalesCellIdentifier = @"ProductSearchTableVCell";

@interface SearchProductSalesViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) QWSpecailIntoView* specailInfoView;
@property (nonatomic, strong) UISearchBar* searchBar;
@end

@implementation SearchProductSalesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIConfig];
}

- (void)UIConfig
{
    self.view.backgroundColor = RGBHex(qwColor11);
    self.tableView.backgroundColor = RGBHex(qwColor11);
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductSearchTableVCell" bundle:nil] forCellReuseIdentifier:kProductSalesCellIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(popVCAction:)];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, APP_W, 44)];
    self.searchBar.placeholder = @"商品搜索";
    self.searchBar.barTintColor = RGBHex(qwColor1);
    self.searchBar.delegate = self;
    self.searchBar.returnKeyType = UIReturnKeyDone;
    self.navigationItem.titleView = self.searchBar;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 需要在viewWillAppear里面设置
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_scan"] style:UIBarButtonItemStyleDone target:self action:@selector(scanBtnAction:)]];
}

- (QWSpecailIntoView *)specailInfoView
{
    if (!_specailInfoView) {
        _specailInfoView = [[QWSpecailIntoView alloc] init];
        _specailInfoView.imageName = @"img_noSearch";
        _specailInfoView.title = @"暂无该商品销售统计";
        _specailInfoView.detail = @"出现原因：\n1、您搜索的商品不是门店商品\n2、该商品在门店暂无消费记录";
    }
    return _specailInfoView;
}

- (void)showNoSearchInfoView:(BOOL)show
{
    if (show) {
        if (_specailInfoView.superview == nil) {
            [self.view addSubview:self.specailInfoView];
            PREPCONSTRAINTS(self.specailInfoView);
            ALIGN_TOPLEFT(self.specailInfoView, 0);
            ALIGN_BOTTOMRIGHT(self.specailInfoView, 0);
        }
    }
    else
    {
        [_specailInfoView removeFromSuperview];
        _specailInfoView = nil;
    }
}

#pragma mark 根据关键字模糊查询获取数据
- (void)loadData
{
    GetProductSalesR* getProdcctSalesR = [GetProductSalesR new];
    getProdcctSalesR.begin = self.startDate;
    getProdcctSalesR.end = self.endDate;
    getProdcctSalesR.token = QWGLOBALMANAGER.configure.userToken;
    getProdcctSalesR.upOrDown = self.upOrDown;
    getProdcctSalesR.keyWord = self.searchBar.text;
    __weak __typeof(self) weakSelf = self;
    [Store getProductSales:getProdcctSalesR success:^(ProductSalesListModel *productList) {
        if ([productList.apiStatus integerValue] == 0) {
            weakSelf.productArray = productList.list;
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:productList.apiMessage duration:DURATION_LONG];
        }
        [self showNoSearchInfoView:weakSelf.productArray.count <= 0];
        [weakSelf.tableView reloadData];
        
    } fail:^(HttpException *e) {
        [self showNoSearchInfoView:weakSelf.productArray.count <= 0];
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark 点击二维码按钮，跳到扫描二维码页面
- (void)scanBtnAction:(id)sender
{
    if (![QYPhotoAlbum checkCameraAuthorizationStatus]) {
        [QWGLOBALMANAGER getCramePrivate];
        return;
    }
    AllScanReaderViewController *vc = [[AllScanReaderViewController alloc]init];
    vc.scanType=Enum_Scan_Items_ProductSales;
    __weak __typeof(self) weakSelf = self;
    vc.scan = ^(NSString* scanCode)
    {
        weakSelf.searchBar.text = scanCode;
        [weakSelf searchBar:weakSelf.searchBar textDidChange:weakSelf.searchBar.text];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableView Delegate     start  ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.productArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductSearchTableVCell* cell = [tableView dequeueReusableCellWithIdentifier:kProductSalesCellIdentifier forIndexPath:indexPath];
    [self configure:cell indexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:kProductSalesCellIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
        [self configure:cell indexPath:indexPath];
    }];
}

- (void)configure:(id)cell indexPath:(NSIndexPath*)indexPath
{
    NSInteger row = indexPath.row;
    if (self.productArray.count > row) {
        [cell setCell:self.productArray[row]];
    }
}
#pragma mark - UITableView Delegate     end   ------

// 滑动的时候隐藏键盘
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - UISearchBarDelegate 模糊查询
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"searchText : %@", searchText);
//    if (!StrIsEmpty(searchText)) {
        [self loadData];
//    }
}

// 点击确认查询并隐藏键盘
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [searchBar resignFirstResponder];
        [self loadData];
    }
    return YES;
}

@end
