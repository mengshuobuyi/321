//
//  InternalProductSearchRootViewController.m
//  wenYao-store
//
//  本店商品搜索根页面
//  调用接口:
//  搜索商品列表: SearchInternalProductList       h5/bmmall/searchProduct
//
//  Created by PerryChen on 3/8/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "InternalProductSearchRootViewController.h"
#import "InternalProductModel.h"
#import "InternalProductSearchHistoryCell.h"
#import "InternalProductSearchResultViewController.h"
#import "AllScanReaderViewController.h"
#import "InternalProductDetailViewController.h"
#import "InternalProduct.h"

@interface InternalProductSearchRootViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *searchBarView;

@property (strong, nonatomic) NSMutableArray *arrSearchHistory;
@property (weak, nonatomic) IBOutlet UITextField *tfSearchContent;
@property (weak, nonatomic) IBOutlet UITableView *tbViewContent;
@property (strong, nonatomic) IBOutlet UIView *searchHistoryHeaderView;


- (IBAction)actionClearHistory:(UIButton *)sender;
- (IBAction)scanAction:(UIButton *)sender;

@end

@implementation InternalProductSearchRootViewController

static int maxSearchHis = 10;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fitSearchViewFrame];
    self.navigationItem.titleView = self.searchBarView;
    self.arrSearchHistory = [@[] mutableCopy];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getSearchHistory];
    self.tfSearchContent.text = @"";
    [self.tfSearchContent becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tfSearchContent resignFirstResponder];
}

/**
 *  调整头部搜索框frame大小
 */
- (void)fitSearchViewFrame
{
    CGRect rectHeader = CGRectMake(0, 0, APP_W - 60, self.searchBarView.frame.size.height);
    self.searchBarView.frame = rectHeader;
    self.searchBarView.layer.cornerRadius = 5.0f;
    //icon_search
    self.tfSearchContent.leftViewMode = UITextFieldViewModeUnlessEditing;
    UIView *viewSearchIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_search"]];
    imgView.frame = CGRectMake(5, 5, 15, 15);
    [viewSearchIcon addSubview:imgView];
    self.tfSearchContent.leftView = viewSearchIcon;
}

/**
 *  获取搜索历史
 */
- (void)getSearchHistory
{
    self.arrSearchHistory = (NSMutableArray *)[InternalProductHistoryModel getArrayFromDBWithWhere:nil WithorderBy:@"rowid desc"];
    if (self.arrSearchHistory.count > 0) {
        [self.tbViewContent reloadData];
        self.tbViewContent.hidden = NO;
        [self removeInfoView];
    } else {
        self.tbViewContent.hidden = YES;
        [self showInfoView:@"暂无搜索历史" image:nil];
    }
}

/**
 *  保存搜索历史
 */
- (void)saveSearchHistory:(NSString *)strItem
{
    //如果一个超过10个  那么删除最后面一个
    if (self.arrSearchHistory.count == maxSearchHis) {
        [self.arrSearchHistory removeObjectAtIndex:self.arrSearchHistory.count-1];
    }
    //加到最顶端
    InternalProductHistoryModel *modelSearch = [[InternalProductHistoryModel alloc] init];
    modelSearch.strSearchItem = strItem;
    [self.arrSearchHistory insertObject:modelSearch atIndex:0];
    [InternalProductHistoryModel deleteAllObjFromDB];
    [InternalProductHistoryModel saveObjToDBWithArray:self.arrSearchHistory];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self saveSearchHistory:textField.text];
    [self getSearchResult:textField.text];
//    InternalProductSearchResultViewController *vc = [[UIStoryboard storyboardWithName:@"InternalProduct" bundle:nil] instantiateViewControllerWithIdentifier:@"InternalProductSearchResultViewController"];
//    [self.navigationController pushViewController:vc
//                                         animated:YES];
    return YES;
}

#pragma mark - UITableView Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InternalProductSearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InternalProductSearchHistoryCell"];
    InternalProductHistoryModel *model = self.arrSearchHistory[indexPath.row];
    cell.contentLabel.text = model.strSearchItem;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrSearchHistory.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tfSearchContent resignFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.searchHistoryHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    InternalProductHistoryModel *model = self.arrSearchHistory[indexPath.row];
    [self.arrSearchHistory removeObjectAtIndex:indexPath.row];
    [self saveSearchHistory:model.strSearchItem];
    [self getSearchResult:model.strSearchItem];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/**
 *  清空搜索历史
 *
 *  @param sender
 */
- (IBAction)actionClearHistory:(UIButton *)sender {
    [InternalProductHistoryModel deleteAllObjFromDB];
    [self.arrSearchHistory removeAllObjects];
    [self.tbViewContent reloadData];
    self.tbViewContent.hidden = YES;
    [self showInfoView:@"暂无搜索历史" image:nil];
}

/**
 *  扫码
 *
 *  @param sender
 */
- (IBAction)scanAction:(UIButton *)sender {
    AllScanReaderViewController *vc = [[AllScanReaderViewController alloc]init];
    vc.scanType=Enum_Scan_Items_InterProduct;
    vc.scanProResult = ^(NSMutableArray *listArr) {
        if (listArr.count == 1) {
            InternalProductDetailViewController *vc = [[UIStoryboard storyboardWithName:@"InternalProduct" bundle:nil] instantiateViewControllerWithIdentifier:@"InternalProductDetailViewController"];
            __block InternalProductModel *model = listArr[0];
            vc.productModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            InternalProductSearchResultViewController *vc = [[UIStoryboard storyboardWithName:@"InternalProduct" bundle:nil] instantiateViewControllerWithIdentifier:@"InternalProductSearchResultViewController"];
            vc.arrProduct = listArr;
            vc.comeFromScan = YES;
            [self.navigationController pushViewController:vc
                                                 animated:YES];
            
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 接口请求
- (void)getSearchResult:(NSString *)result
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring12 image:@"img_network" flatY:40.0f];
        return;
    }
    InternalProductSearchModelR *modelR = [InternalProductSearchModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.keyWord = result;
    [InternalProduct queryInternalProductSearch:modelR success:^(InternalProductListModel *responseModel) {
        if (responseModel.list.count == 1) {
            InternalProductDetailViewController *vc = [[UIStoryboard storyboardWithName:@"InternalProduct" bundle:nil] instantiateViewControllerWithIdentifier:@"InternalProductDetailViewController"];
            __block InternalProductModel *model = responseModel.list[0];
            vc.productModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            InternalProductSearchResultViewController *vc = [[UIStoryboard storyboardWithName:@"InternalProduct" bundle:nil] instantiateViewControllerWithIdentifier:@"InternalProductSearchResultViewController"];
            vc.arrProduct = [responseModel.list mutableCopy];
            [self.navigationController pushViewController:vc
                                                 animated:YES];

        }
    } failure:^(HttpException *e) {
        [self showError:e.description];
    }];
}

@end
