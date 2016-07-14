//
//  MyRecommendMedicineViewController.m
//  wenYao-store
//  接口
//  查询推荐顾客预定商品  ：   h5/act/book/list
//  Created by Martin.Liu on 16/6/3.
//  Copyright © 2016年 carret. All rights reserved.
//
/*
 1、我的二维码——我的推荐页面，增加推荐顾客预订商品TAb，显示填写 店员/店长手机号的预定信息。具体是预订的是什么商品（取OP端配置的title,手机号（用户），姓名，提交预订时间）
 2、分页加载，每页10条
 */
#import "MyRecommendMedicineViewController.h"
#import "MyRecommendMedicineTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "Mbr.h"

static NSString *const kMyRecommendMedicineCellId = @"kMyRecommendMedicineCellId";

@interface MyRecommendMedicineViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;        // 表格视图
@property (nonatomic, strong) NSMutableArray* bookProductArray;     // 数据队列
@property (nonatomic, strong) BookProductR* bookProductR;           // 获取数据的参数
@property (nonatomic, assign) NSInteger pageNum;                    // 记录当前数据的页面索引
@end

@implementation MyRecommendMedicineViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"推荐预定商品";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBHex(qwColor11);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = RGBHex(qwColor11);
    [self.tableView registerNib:[UINib nibWithNibName:@"MyRecommendMedicineTableViewCell" bundle:nil] forCellReuseIdentifier:kMyRecommendMedicineCellId];
    __weak __typeof(self)weakSelf = self;
    [self enableSimpleRefresh:self.tableView block:^(SRRefreshView *sender) {
        weakSelf.pageNum = 0;
        [weakSelf loadData];
    }];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
    [self loadData];
    
}

// 队列 懒加载
- (NSMutableArray *)bookProductArray
{
    if (!_bookProductArray) {
        _bookProductArray = [NSMutableArray array];
    }
    return _bookProductArray;
}

// 获取数据的参数model 懒加载
- (BookProductR *)bookProductR
{
    if (!_bookProductR) {
        _bookProductR = [[BookProductR alloc] init];
        _bookProductR.token = QWGLOBALMANAGER.configure.userToken;
        _bookProductR.page = 0;
        _bookProductR.pageSize = 10;
    }
    return _bookProductR;
}

// 获取前十条数据
- (void)loadData
{
    self.bookProductR.page = self.pageNum + 1;
    __weak __typeof(self) weakSelf = self;
    [Mbr queryRecommendBookProduct:self.bookProductR success:^(BookProductListModel *bookProductList) {
        if (weakSelf.pageNum == 0) {
            [weakSelf.bookProductArray removeAllObjects];
        }
        weakSelf.pageNum += 1;
        if (bookProductList.list.count >= self.bookProductR.pageSize) {
            [weakSelf.tableView.footer setCanLoadMore:YES];
        }
        else
        {
            [weakSelf.tableView.footer setCanLoadMore:NO];
        }
        if (bookProductList.list.count > 0) {
            [weakSelf removeInfoView];
        }
        else
        {
            [weakSelf showInfoView:@"暂无推荐商品" image:@"img_employee_statistical"];
        }

        [weakSelf.bookProductArray addObjectsFromArray:bookProductList.list];
        [weakSelf.tableView reloadData];
        [weakSelf endHeaderRefresh];
        [weakSelf.tableView.footer endRefreshing];
    } failure:^(HttpException *e) {
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [weakSelf showInfoView:kWaring12 image:@"img_network"];
        }else
        {
            if(e.errorCode!=-999){
                if(e.errorCode == -1001){
                    [weakSelf showInfoView:kWarning215N54 image:@"ic_img_fail"];
                }else{
                    [weakSelf showInfoView:kWarning215N0 image:@"ic_img_fail"];
                }
            }
        }
        [weakSelf endHeaderRefresh];
        [weakSelf.tableView.footer endRefreshing];
    }];
}

// 点击获取前十条数据数据
- (void)viewInfoClickAction:(id)sender
{
    [self loadData];
}

// 加载更多数据
- (void)loadMoreData
{
    self.bookProductR.page = self.pageNum + 1;
    __weak __typeof(self) weakSelf = self;
    HttpClientMgr.progressEnabled = NO;
    [Mbr queryRecommendBookProduct:self.bookProductR success:^(BookProductListModel *bookProductList) {
        [weakSelf removeInfoView];
        weakSelf.pageNum += 1;
        if (bookProductList.list.count >= self.bookProductR.pageSize) {

        }
        else
        {
            [weakSelf.tableView.footer setCanLoadMore:NO];
        }
        [weakSelf.bookProductArray addObjectsFromArray:bookProductList.list];
        [weakSelf.tableView reloadData];
        [weakSelf endHeaderRefresh];
        [weakSelf.tableView.footer endRefreshing];
    } failure:^(HttpException *e) {
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [weakSelf showInfoView:kWaring12 image:@"img_network"];
        }else
        {
            if(e.errorCode!=-999){
                if(e.errorCode == -1001){
                    [weakSelf showInfoView:kWarning215N54 image:@"ic_img_fail"];
                }else{
                    [weakSelf showInfoView:kWarning215N0 image:@"ic_img_fail"];
                }
            }
        }
        [weakSelf endHeaderRefresh];
        [weakSelf.tableView.footer endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableview Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bookProductArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyRecommendMedicineTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kMyRecommendMedicineCellId forIndexPath:indexPath];
    [self configure:cell indexPath:indexPath];
    return cell;
}

- (void)configure:(id)cell indexPath:(NSIndexPath*)indexPath
{
    if (self.bookProductArray.count > indexPath.row) {
        [cell setCell:self.bookProductArray[indexPath.row]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak __typeof(self) weakSelf = self;
    return [tableView fd_heightForCellWithIdentifier:kMyRecommendMedicineCellId cacheByIndexPath:indexPath configuration:^(id cell) {
        [weakSelf configure:cell indexPath:indexPath];
    }];
}

// Group样式有个默认的高度，需要设置一个小的值
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

// UI需求
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
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
